#lang racket

(require tr-contract/private/store/struct-data
         tr-contract/private/utils
         syntax/parse
         racket/syntax)

(provide munge-contract
         prefix-predicates)

(define prefix-predicates
  (make-parameter #f))

(define ((munge-contract id) stx)
  (syntax-parse
      stx #:datum-literals (lambda equal? quote)
      [(lambda ((~literal x)) (equal? (~literal x) (quote y)))
       #:when (void? (syntax-e #'y))
       #'void?]
      [y #:when (void? (syntax-e #'y))
       #'void?]
      [(lambda ((~literal x)) (f (~literal x)))
       #:when (let ([function-desc (send struct-data struct-function? (syntax-e #'f))])
                (and (prefix-predicates)
                     function-desc
                     (equal? (car function-desc) 'predicate)))
       (prefix-unsafe #'f)]
      [(f args ...)
       #`(f #,@(map (munge-contract id)
                    (syntax->list #'(args ...))))]
      [other #'other]))
