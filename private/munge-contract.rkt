#lang racket

(require tr-contract/private/store/struct-data
         syntax/parse
         racket/syntax)

(provide munge-contract
         munge-all
         contract-case
         prefix-predicates
         prefix-unsafe)

(define prefix-predicates
  (make-parameter #f))

(define (contract-case id ctc-id ctc)
  (define desc
    (send struct-data lookup-function id))
  (cond
    [(and desc (equal? (car desc) 'constructor))
     (list (make-struct-out (cdr desc) ctc))]
    [desc '()]
    [else (list `(contract-out [,id ,ctc-id]))]))

(define (munge-all xs ys)
  (for/list ([x xs]
             [y ys])
    (list x ((munge-contract x) y))))

(define ((munge-contract id) stx)
  (syntax-parse
      stx #:datum-literals (lambda equal? quote ->*
                                   simple-result->
                                   any-wrap/c
                                   pred-cnt
                                   flat-named-contract
                                   flat-contract-predicate
                                   struct-predicate-procedure?/c                                                                     struct-predicate-procedure?
                                   struct-type/c
                                   letrec c-> c->*)
      ;; Convert any-wrap/c to any/c, cannot require (SCV)
      [any-wrap/c #'any/c]

      ;; Contract for predicate checking
      [pred-cnt #'(-> any/c boolean?)]

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

      ;; Warning if ->* is non-convertible
      [(->* x ...)
       (begin (log-warning "explicit-contracts: cannot convert ->* to ->")
              #'(->* x ...))]

      ;; Unwrap some contract forms (SCV)
      [(flat-named-contract _ contract) #'1
       ((munge-contract id) #'contract)]

      [(flat-contract-predicate v)
       ((munge-contract id) #'v)]

      ;; Replace literal voids with (void)
      [(quote y) #:when (void? (syntax-e #'y))
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
      [f #:when (let ([function-desc (send struct-data
                                           lookup-function
                                           (syntax-e #'f))])
                    (and (prefix-predicates)
                         function-desc
                         (equal? (car function-desc) 'predicate)))
       (prefix-unsafe #'f)]

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

(define (make-struct-out desc ctc)
  (syntax-parse ctc #:datum-literals (->)
    [(-> fld-types ... (values _ ...))
     (define struct-name
       (struct-desc-name desc))
     (define fld-pairs
       (for/list ([fld-name (send struct-data struct-all-fields struct-name)]
                  [fld-type (syntax-e #'(fld-types ...))])
         #`(#,fld-name #,fld-type)))
     #`(contract-out [struct #,(with-super desc) #,fld-pairs])]
    [_ (error 'make-struct-out "failed to match on contract definition")]))

(define (with-super desc)
  (define struct-name
    (struct-desc-name desc))
  (define sup-name
    (struct-desc-super-struct desc))
  (if sup-name
      `(,struct-name ,sup-name)
      struct-name))
