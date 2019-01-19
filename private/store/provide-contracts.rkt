#lang racket

(require tr-contract/private/store/generic
         syntax/parse)

(provide provide-contracts-store)

(define provide-contracts-singleton%
  (class store% (super-new [filename "_provide-contracts.dat"])
    (inherit get-data)
    (define/public (process)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (get-data)))))

(define (begin-cases stx)
  (syntax-parse stx #:datum-literals (begin
                                       define-values
                                       define-module-boundary-contract)
                [(begin (define a b) ...
                        (define-values (c) d) ...
                        (define-module-boundary-contract e ...))
                 #`(begin #,@(map define-case
                                  (syntax-e #'((define a b) ...)))
                          #,@(map define-values-case
                                  (syntax-e #'((define-values (c) d) ...)))
                          #,(contract-case
                             #'(define-module-boundary-contract e ...)))]))

(define define-case values)
(define define-values-case values)
(define (contract-case stx)
  (syntax-parse stx #:datum-literals (define-module-boundary-contract)
                [(define-module-boundary-contract x y contract _ ...)
                 #'(define-module-boundary-contract x y contract)]))

(define provide-contracts-store
  (new provide-contracts-singleton%))
