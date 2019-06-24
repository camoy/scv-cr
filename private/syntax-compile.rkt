#lang racket/base

(provide syntax-compile-all)

(require mischief/dict
         mischief/sort
         syntax/modcode
         syntax/modresolve
         compiler/compilation-path
         racket/list
         racket/file
         racket/function
         scv-gt/private/proxy-resolver)

;; Path -> Symbol
;; converts a path to a symbol
(define path->symbol
  (compose string->symbol path->string))

;; Symbol -> Path
;; converts a symbol to a path
(define symbol->path
  (compose string->path symbol->string))

;; Module-Path Syntax -> Void
;; compiles syntax and outputs to appropriate file
(define (syntax-compile target stx)
  (define zo-path (get-compilation-bytecode-file target))
  (make-parent-directory* zo-path)
  (with-output-to-file zo-path
    #:exists 'replace
    (thunk (write (compile/dir stx target))))
  (file-or-directory-modify-seconds target (current-seconds)))

(require syntax/modcollapse)

 ;; Module-Path -> [List-of Module-Path]
 ;; gets a module's dependencies
(define (get-dependencies target)
  (define mpis
    (cdr (assoc 0 (module-compiled-imports (get-module-code target)))))
  (map (λ (x) (collapse-module-path-index x target)) mpis))

(provide sort-by-dependency)
(define (sort-by-dependency targets)
  (define (clean-deps dependencies)
    (filter-map (λ (x) (and (member x targets)
                            (path->symbol x)))
                dependencies))
  (define target->deps
    (for/list ([target targets])
      (cons (path->symbol target)
            (clean-deps (get-dependencies target)))))
  (map symbol->path
       (topological-sort (map path->symbol targets)
                         (dict->procedure #:failure (const empty)
                                          target->deps))))

;; [List-of Module-Path] [List-of Syntax] -> Void
;; compiles targets in the correct order
(define (syntax-compile-all targets stxs)
  (for ([target targets]
        [stx    stxs])
    (syntax-compile target stx)))

;;
;; test
;;

(module+ test
  (require rackunit
           scv-gt/private/syntax-util
           scv-gt/private/test-util)

  (test-case
    "syntax-compile"
    (define path (test-path "world.rkt"))
    (define world-zo
      (test-path "compiled" "world_rkt.zo"))
    (module-delete-zo path)
    (syntax-compile path
                    #'(module world racket
                        (provide msg)
                        (define msg "world")))
    (check-equal? (dynamic-require world-zo 'msg (thunk #f)) "world")
    (module-delete-zo path))
  )
