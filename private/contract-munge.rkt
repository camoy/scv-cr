#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-munge)

(require racket/function
         racket/contract
         syntax/parse)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax -> (Syntax -> Syntax)
;; given an id of a contract definition, munges that contract for use in
;; verification
(define (contract-munge id stx)
  (syntax-parse stx
    #:datum-literals (lambda
                       equal?
                       quote
                       ->*
                       simple-result->
                       any-wrap/c
                       pred-cnt
                       flat-named-contract
                       flat-contract-predicate
                       struct-predicate-procedure?/c
                       struct-predicate-procedure?
                       struct-type/c
                       letrec
                       c->
                       c->*
                       t:index?)
    ;; Convert any-wrap/c to any/c, cannot require (SCV)
    [any-wrap/c #'any/c]

    ;; Contract for predicate checking
    [pred-cnt #'(-> any/c boolean?)]

    ;; From numeric predicates
    [t:index? #'exact-nonnegative-integer?]

    ;; Inline simple-result->, cannot require (SCV)
    [(simple-result-> ran arity)
     #`(-> #,@(for/list ([_ (syntax->datum #'arity)]) #'any/c)
           #,(contract-munge id #'ran))]

    ;; Convert c-> and c->* to -> and ->* (SCV)
    [(c-> x ...) (contract-munge id #'(-> x ...))]
    [(c->* x ...) (contract-munge id #'(->* x ...))]

    ;; Convert ->* to -> if possible (SCV)
    [(->* (dom ...) () ran)
     (contract-munge id #'(-> dom ... ran))]

    ;; Replace contracts we cannot verify (SCV)
    [struct-predicate-procedure? #'(λ (_) #f)]
    [struct-predicate-procedure?/c #'(λ (_) #f)]
    [(struct-type/c _) #'#t]

    ;; Warning if ->* is non-convertible
    [(->* x ...)
     (begin (log-warning "explicit-contracts: cannot convert ->* to ->")
            #'(->* x ...))]

    ;; Unwrap some contract forms (SCV)
    [(flat-named-contract _ ctc)
     (contract-munge id #'ctc)]

    [(flat-contract-predicate v)
     (contract-munge id #'v)]

    ;; Replace literal voids with (void)
    [(quote y) #:when (void? (syntax-e #'y))
               #'(void)]

    ;; Remove non-recursive recursive-contract forms (SCV)
    [(letrec ([a (recursive-contract b args ...)] [c d]) body)
     (if (contains-id? #'d #'a)
         #`(letrec ([a (recursive-contract #,id args ...)]
                    [c #,(contract-munge id #'d)])
             body)
         #'(let ([a d])
             body))]

    ;; Distribute munge-contract to all list elements
    [(f args ...)
     #`(f #,@(map (curry contract-munge id)
                  (syntax->list #'(args ...))))]

    ;; Catch-all case
    [other #'other]))

;; Syntax Syntax -> Boolean
;; whether or not the syntax contains the given identifier
(define (contains-id? stx id)
  (syntax-parse stx
    [(f x ...) (ormap (curryr contains-id? id)
                      (syntax-e #'(x ...)))]
    [x #:when (equal? (syntax-e #'x) (syntax-e id)) #t]
    [_ #f]))
