#lang racket

(require tr-contract/private/store
         tr-contract/private/munge-contract
         syntax/parse)

(provide provide-definition)

(define provide-definition-singleton%
  (class store%
    (super-new [path "_provide-definition.dat"])

    (define/override (process record)
      (append-map begin-cases (reverse record)))))

(define begin-cases
  (match-lambda
    [`(begin (define ,as ,bs) ...
             (define-values (,cs) ,ds) ...
             ,_)
     (append (munge-all as bs)
             (munge-all cs ds))]))

(define provide-definition
  (new provide-definition-singleton%))
