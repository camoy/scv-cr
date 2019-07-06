#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide syntax-property-values
         module-typed?
         module-delete-zo
         syntax->pretty
         syntax->string
         syntax-overwrite
         syntax-fetch
         syntax-attach-scope
         syntax-fresh-scope
         syntax-scope-external
         syntax-dependencies
         syntax-preserve
         syntax-replace-srcloc!
         hash-ref-stx
         g-number
         generated-contract-number
         lifted-number
         lifted->l)

(require compiler/compilation-path
         lang-file/read-lang-file
         racket/require
         (multi-in racket (function list match path pretty set string syntax))
         (multi-in syntax (modcollapse modread parse strip-context)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Module-Path -> Boolean
;; whether target is a Typed Racket module
(define (module-typed? target)
  (unless (file-exists? target)
    (error 'module-typed? "file ~a doesn't exist" target))
  (string-prefix? (lang-file-lang target) "typed/racket"))

;; Module-Path -> Void
;; deletes zo associated with target if exists
(define (module-delete-zo target)
  (define zo-path (get-compilation-bytecode-file target))
  (when (file-exists? zo-path)
    (delete-file zo-path)))

;; Syntax -> String
;; converts syntax to nicer printable representation
(define syntax->pretty
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
    (thunk (displayln (syntax->pretty stx)))))

;; Module-Path -> Syntax
;; retrieves syntax object from module path
(define (syntax-fetch target)
  (define port (open-input-file target))
  (port-count-lines! port)
  (with-module-reading-parameterization
    (thunk
     (read-syntax (object-name port) port))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [List-of Path] Syntax -> Syntax
;; places a fresh scope on syntax that came from expansion
(define (syntax-scope-external targets stx)
  (let go ([e stx])
    (cond [(syntax? e)
           (let* ([id? (identifier? e)]
                  [binding (and id? (identifier-binding e))]
                  [mpi (and binding (third binding))]
                  [resolved (and mpi (module-path-index-resolve mpi))]
                  [name (and resolved (resolved-module-path-name resolved))]
                  [from-expansion? (equal? '|expanded module| name)]
                  [introducer (cond
                                [(not id?)
                                 (λ (x) (datum->syntax #f (syntax-e x) x x))]
                                [(or from-expansion? (not binding))
                                 strip-context]
                                [else
                                 (compose syntax-preserve syntax-attach-scope)])]
                  [e* (go (syntax-e e))])
             (introducer (datum->syntax e e* e e)))]
          [(pair? e)
           (cons (go (car e)) (go (cdr e)))]
          [else e])))

;; Syntax -> [List-of String]
;; returns relative paths to modules that identifiers in this syntax object
;; depends on
(define (syntax-dependencies e)
  (cond
    [(syntax? e)
     (if (and (identifier? e) (identifier-binding e))
         (let* ([binding (identifier-binding e)]
                [mpi     (third binding)]
                [dep     (module-path-index->relative-path mpi)])
           (if dep (list dep) '()))
         (syntax-dependencies (syntax-e e)))]
    [(pair? e)
     (append (syntax-dependencies (car e))
             (syntax-dependencies (cdr e)))]
    [else '()]))

;; Syntax -> Syntax
;; erases syntax object contexts that are not set to be preserved
(define (strip-context* e)
  (cond
    [(syntax? e)
     (if (syntax-property e 'preserve-context)
         e
         (datum->syntax #f (strip-context* (syntax-e e)) e e))]
    [(pair? e) (cons (strip-context* (car e))
                     (strip-context* (cdr e)))]
    [else e]))

;; Syntax -> Syntax
;; attaches scope for contract definitions
(define syntax-attach-scope
  (make-syntax-introducer))

;; Syntax -> Syntax
;; strips syntax of lexical context and attaches fresh scope
(define syntax-fresh-scope
  (compose syntax-attach-scope strip-context*))

;; Syntax -> Syntax
;; protects a syntax object's context from erasure by strip-context*
(define (syntax-preserve stx)
  (syntax-property stx 'preserve-context #t))

;; Syntax -> String
;; converts syntax to a string
(define (syntax->string stx)
  (format "~a" (syntax->datum stx)))

;; Module-Path-Index -> String
;; converts MPI to relative path string
(define (module-path-index->relative-path mpi)
  (define p (collapse-module-path-index mpi))
  (if (path? p)
      (path->string (find-relative-path (current-directory) p))
      p))


;; L/I-Hash Path Syntax -> Syntax
;; traverses the syntax object replacing each source location's source module
;; with target and updating the mapping between position
(define (syntax-replace-srcloc! l/i-hash target e)
  (define pos 1)
  (define parent-ctc (make-parameter #f))
  (let go ([e e])
    (cond
      [(syntax? e)
       (let* ([span    (string-length (syntax->string e))]
              [pos-old pos]
              [srcloc  (list target 1 pos pos span)]
              [within  (syntax-property e 'within-contract)]
              [e*      (if within
                           (parameterize ([parent-ctc within])
                             (go (syntax-e e)))
                           (go (syntax-e e)))])
         (set! pos (+ pos span))
         (datum->syntax e e* srcloc e))]
      [(pair? e) (cons (go (car e))
                       (go (cdr e)))]
      [else
       (when (parent-ctc)
         (hash-set! l/i-hash pos (parent-ctc)))
       e])))

;; [Hash Syntax Syntax] Syntax -> Syntax
;; looks syntax in a hash from by its content
(define (hash-ref-stx h k)
  (define p
   (assoc (syntax->datum k)
          (hash-map h (λ (k v) (cons (syntax->datum k) v)))))
  (and p (cdr p)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; String -> (Symbol -> Number)
;; makes a function that can extract number from a prefixed identifier
(define ((make-get-number t) x)
  (define x* (symbol->string x))
  (and (string-prefix? x* t)
       (string->number (substring x* (string-length t)))))

;; Symbol -> Number
;; extracts numbered suffix from an identifier
(define g-number (make-get-number "g"))
(define generated-contract-number (make-get-number "generated-contract"))
(define lifted-number (make-get-number "lifted/"))

;; Syntax -> Syntax
;; changed lifted identifier to non-lifted
(define (lifted->l stx)
  (define n (and (identifier? stx)
                 (lifted-number (syntax-e stx))))
  (if n (format-id #f "l/~a" n) stx))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
  (test-case
    "module-typed?"
    (check-true (module-typed? (benchmark-path "sieve" "typed" "main.rkt")))
    (check-false (module-typed? (benchmark-path "sieve" "untyped" "main.rkt")))
    (check-exn exn:fail? (thunk (module-typed? "unknown.rkt"))))

  (test-case
    "syntax-fetch"
    (check syntax=?
           (syntax-fetch (test-path "basic" "hello.rkt"))
           #'(module hello racket
               (#%module-begin "hello"))))

  )
