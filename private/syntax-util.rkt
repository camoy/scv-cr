#lang racket/base

(provide syntax-property-values
         module-typed?
         module-delete-zo
         syntax->string
         syntax-overwrite
         syntax-fetch
         syntax-compile
         syntax-fresh-scope
         syntax-scope-expanded)

;;
;; syntax properties
;;

(require racket/set
         racket/list
         racket/match
         racket/string
         racket/pretty
         syntax/parse)

;; Syntax Symbol -> [Set Any]
;; retrieves a set of all the values associated with the key within the given
;; syntax object
(define (syntax-property-values* stx key)
  ;; fixes key in syntax-property-values for use in map
  (define (syntax-property-values/key stx)
    (syntax-property-values* stx key))
  ;; syntax properties can return cons cells that must be flattened
  (define (flatten-value v)
    (match v
      [#f         (set)]
      [(cons x y) (set x y)]
      [z          (set z)]))
  (let* ([datum  (syntax-e stx)]
         [value  (syntax-property stx key)]
         [values (flatten-value value)])
    (cond [(empty? datum) values]
          [(list? datum)
           (apply set-union
                  (cons values
                        (map syntax-property-values/key datum)))]
          [else values])))

;; Syntax Symbol -> [List-of Any]
;; same as syntax-property-values* except returns as a list
(define syntax-property-values
  (compose set->list syntax-property-values*))

;;
;; syntax and modules
;;

(require compiler/compilation-path
         racket/file
         racket/function
         syntax/modread
         syntax/strip-context
         scv-gt/private/proxy-resolver)

;; Module-Path -> Boolean
;; whether target is a Typed Racket module
(define (module-typed? target)
  (module-declared? `(submod ,target #%type-decl) #t))

;; Module-Path -> Void
;; deletes zo associated with target if exists
(define (module-delete-zo target)
  (define zo-path (get-compilation-bytecode-file target))
  (when (file-exists? zo-path)
    (delete-file zo-path)))

;; Syntax -> String
;; converts syntax to nicer printable representation
(define syntax->string
  (syntax-parser
    #:datum-literals (module #%module-begin)
    [(module _ lang (#%module-begin forms ...))
     (string-join
      (cons (format "#lang ~a" (syntax->datum #'lang))
            (map (λ (s) (substring (pretty-format s) 1))
                 (syntax->datum #'(forms ...))))
      "\n")]))

;; Syntax Module-Path -> Void
;; replaces content of target with new syntax
(define (syntax-overwrite stx target)
  (with-output-to-file target
    #:exists 'replace
    (thunk (displayln (syntax->string stx)))))

;; Module-Path -> Syntax
;; retrieves syntax object from module path
(define (syntax-fetch target)
  (define port (open-input-file target))
  (with-module-reading-parameterization
    (thunk
     (read-syntax (object-name port) port))))

;; Module-Path Syntax -> Void
;; compiles syntax and outputs to appropriate file
(define (syntax-compile target stx)
  (define zo-path (get-compilation-bytecode-file target))
  (make-parent-directory* zo-path)
  (with-output-to-file zo-path
    #:exists 'replace
    (thunk (write (compile/dir stx target)))))

;; Syntax -> Syntax
;; strips syntax of lexical context and attaches fresh scope
(define syntax-fresh-scope
  (let ([introducer (make-syntax-introducer)])
    (compose introducer strip-context)))

;; Syntax -> Syntax
;; places a fresh scope on syntax that came from expansion
(define (syntax-scope-expanded stx)
  (let go ([e stx])
    (cond [(syntax? e)
           (let* ([binding (and (identifier? e) (identifier-binding e))]
                  [src (and binding (first binding))]
                  [resolved (and src (module-path-index-resolve src))]
                  [name (and resolved (resolved-module-path-name resolved))]
                  [from-expansion? (equal? '|expanded module| name)]
                  [introducer (if from-expansion? syntax-fresh-scope values)]
                  [e* (go (syntax-e e))])
             (introducer (datum->syntax e e* e e)))]
          [(pair? e)
           (cons (go (car e)) (go (cdr e)))]
          [else e])))

;;
;; syntax properties test
;;

(module+ test
  (require rackunit
           scv-gt/private/syntax-typed-racket
           scv-gt/private/test-util)

  (test-case
    "syntax-property-values*"
    (let* ([stx-a1      #'100]
           [stx-a2      #'200]
           [stx-b       #'300]
           [stx-a1/prop (syntax-property-self stx-a1 'a)]
           [stx-a2/prop (syntax-property-self stx-a2 'a)]
           [stx-b/prop  (syntax-property-self stx-b 'b)]
           [big-stx
            #`(+ (+ #,stx-a1/prop 2)
                 (* #,stx-a2/prop (+ 1 #,stx-a1/prop #,stx-b/prop)))])
      (check set=?
             (syntax-property-values* big-stx 'a)
             (set stx-a1 stx-a2))
      (check set=?
             (syntax-property-values* big-stx 'b)
             (set stx-b))))

  )

;;
;; syntax and modules test
;;

(module+ test
  (test-case
    "module-typed?"
    (check-true (module-typed? (benchmark-path "sieve" "typed" "main.rkt")))
    (check-false (module-typed? (benchmark-path "sieve" "untyped" "main.rkt"))))

  (test-case
    "syntax-fetch"
    (check syntax=?
           (syntax-fetch (test-path "basic" "hello.rkt"))
           #'(module hello racket
               (#%module-begin "hello"))))

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
