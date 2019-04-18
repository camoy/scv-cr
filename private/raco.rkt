#lang racket/base

(require compiler/compilation-path
         racket/cmdline
         racket/file
         racket/function
         scv-gt/private/configure
         scv-gt/private/contract-make
         scv-gt/private/contract-inject
         scv-gt/private/contract-opt
         syntax/modread)

;;
;; main
;;

(module+ main
  (let* ([argv         (current-command-line-arguments)]
         [targets      (parse argv)]
         [targets/tr   (filter is-tr? targets)]
         [stxs         (map fetch-syntax targets/tr)]
         [stxs/expand  (map expand stxs)]
         [ctcs         (map contract-make stxs/expand)]
         [stxs/ctc     (map contract-inject stxs ctcs)]
         [stxs/opt     (map contract-opt stxs/ctc)])
    (map compile-syntax targets/tr stxs/opt)))

;;
;; parsing
;;

(define (parse argv)
  (command-line
   #:program "scv-gt"
   #:argv argv
   #:once-each
   [("-s" "--show-contract")  "show contracts"
                               (show-contract #t)]
   [("-p" "--provide-less")    "no provide contracts"
                               (provide-less #t)]
   [("-r" "--require-less")    "no require contracts"
                               (require-less #t)]
   #:args targets
   targets))

;;
;; function
;;

;; Module-Path -> Boolean
;; whether target is a Typed Racket module
(define (is-tr? target)
  (module-declared? `(submod ,target #%type-decl) #t))

;; Module-Path -> Syntax
;; retrieves syntax object from module path
(define (fetch-syntax target)
  (let ([port (open-input-file target)]
        [ns   (make-base-namespace)])
    (with-module-reading-parameterization
      (thunk
        (parameterize ([current-namespace ns])
          (read-syntax (object-name port) port))))))

;; Module-Path Syntax -> Void
;; compiles syntax and outputs to appropriate file
(define (compile-syntax target stx)
  (define zo-path (get-compilation-bytecode-file target))
  (make-parent-directory* zo-path)
  (with-output-to-file zo-path #:exists 'replace
    (thunk (write (compile stx)))))

;;
;; test
;;

(module+ test
  (require rackunit)

  (define (benchmark-path benchmark which name)
    (format "./test/benchmarks/~a/~a/~a" benchmark which name))

  (test-case
    "is-tr?"
    (check-true (is-tr? (benchmark-path 'sieve 'typed "main.rkt")))
    (check-false (is-tr? (benchmark-path 'sieve 'untyped "main.rkt"))))

  (test-case
    "fetch-syntax"
    (check-equal? (syntax->datum (fetch-syntax "./test/hello.rkt"))
                  (syntax->datum #'(module hello racket
                                     (#%module-begin "hello")))))

  (test-case
    "compile-syntax"
    (define zo-world
      "./test/compiled/world_rkt.zo")
    (when (file-exists? zo-world)
      (delete-file zo-world))
    (compile-syntax "./test/world.rkt"
                    #'(module world racket
                        (provide msg)
                        (define msg "world")))
    (check-equal? (dynamic-require zo-world 'msg (thunk #f))
                  "world")
    (when (file-exists? zo-world)
      (delete-file zo-world)))

  )
