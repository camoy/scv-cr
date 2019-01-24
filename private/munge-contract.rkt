#lang racket

(require syntax/parse)

(provide munge-contract)

(define ((munge-contract id) stx)
  (syntax-parse stx #:datum-literals (lambda equal? quote)
    [(lambda ((~literal x)) (equal? (~literal x) (quote y)))
     #:when (void? (syntax-e #'y))
     #'void?]
    [(f args ...)
     #`(f #,@(map (munge-contract id)
                  (syntax->list #'(args ...))))]
    [other #'other]))
