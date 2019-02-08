#lang racket

(require tr-contract/private/store/struct-data
         syntax/parse
         racket/syntax)

(provide munge-contract
         prefix-predicates
         prefix-unsafe)

(define prefix-predicates
  (make-parameter #f))

(define ((munge-contract id) stx)
  (syntax-parse
      stx #:datum-literals (lambda equal? quote ->*
                                   simple-result->
                                   any-wrap/c
                                   flat-named-contract
                                   flat-contract-predicate
                                   struct-predicate-procedure?/c                                                                     struct-predicate-procedure?
                                   struct-type/c
                                   letrec c-> c->*)
      ;; Convert any-wrap/c to any/c, cannot require (SCV)
      [any-wrap/c #'any/c]

      ;; Inline simple-result->, cannot require (SCV)
      [(simple-result-> ran arity)
       #`(-> #,@(for/list ([_ (syntax->datum #'arity)]) #'any/c)
             #,((munge-contract #'id) #'ran))]

      ;; Convert c-> and c->* to -> and ->* (SCV)
      [(c-> x ...) ((munge-contract id) #'(-> x ...))]
      [(c->* x ...) ((munge-contract id) #'(->* x ...))]

      ;; Convert ->* to -> if possible (SCV)
      [(->* (dom ...) () ran)
       ((munge-contract id) #'(-> dom ... ran))]

      ;; Replace contracts we cannot verify (SCV)
      [struct-predicate-procedure? #'(λ (_) #f)]
      [struct-predicate-procedure?/c #'(λ (_) #f)]
      [(struct-type/c _) #'(λ (_) #f)]

      ;; Error if ->* is non-convertible
      [(->* _ ...)
       (error 'munge-contract "cannot convert ->* to ->")]

      ;; Unwrap some contract forms (SCV)
      [(flat-named-contract _ contract) #'1
       ((munge-contract id) #'contract)]

      [(flat-contract-predicate v)
       ((munge-contract id) #'v)]

      ;; Replace literal voids with (void)
      [y #:when (void? (syntax-e #'y))
       #'(void)]

      ;; Remove non-recursive recursive-contract forms (SCV)
      [(letrec ([a (recursive-contract b args ...)] [c d]) body)
       (if (contains-id #'d #'a)
           #`(letrec ([a (recursive-contract #,id args ...)]
                      [c #,((munge-contract id) #'d)])
               body)
           #'(let ([a d])
               body))]

      ;; Struct predicates within contracts should be unprotected
      [(lambda ((~literal x)) (f (~literal x)))
       #:when (let ([function-desc (send struct-data
                                         struct-function?
                                         (syntax-e #'f))])
                (and (prefix-predicates)
                     function-desc
                     (equal? (car function-desc) 'predicate)))
       (prefix-unsafe #'f)]

      ;; Prefix OO contracts to prevent collision with typed-racket/class
      [(f x ...)
       #:when (member (syntax-e #'f) '(class/c object/c object/c-opaque))
       #`(#,(prefix-with-c #'f)
          #,@(map prefix-specs
                  (syntax->list #'(x ...))))]

      ;; Distribute munge-contract to all list elements
      [(f args ...)
       #`(f #,@(map (munge-contract id)
                    (syntax->list #'(args ...))))]

      ;; Catch-all case
      [other #'other]))

(define (contains-id stx id)
  (syntax-parse stx
    [(f x ...) (ormap (λ (x) (contains-id x id)) (syntax-e #'(x ...)))]
    [a #:when (equal? (syntax-e #'a) (syntax-e id)) #t]
    [_ #f]))

(define (prefix-unsafe id)
  (format-id #'_ "unsafe:~a" id))

(define (prefix-specs stx)
  (syntax-parse
      stx
    [(k v ...)
     #:when (member (syntax-e #'k) '(field init init-field
                                           inherit inherit-field
                                           super inner
                                           override augment
                                           augride absent))
     #`(#,(prefix-with-c #'k) v ...)]
    [x #'x]))

(define (prefix-with-c id)
  (format-id #'_ "c:~a" id))
