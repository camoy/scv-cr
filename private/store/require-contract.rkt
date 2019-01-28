#lang racket

(require tr-contract/private/store
         tr-contract/private/store/require-mapping
         tr-contract/private/store/contract-registry
         tr-contract/private/munge-contract
         syntax/parse)

(provide require-contract)

(define require-contract-singleton%
  (class store%
    (super-new [path "_require-contract.dat"]
               [init-struct '()])

    (define/override (process record)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (reverse record)))))

(define (begin-cases stx)
  (syntax-parse stx #:datum-literals (begin
                                       define
                                       define-values)
                [(begin (define a b) ...
                        (define-values (c) d))
                 (define all-define
                   (map define-case (syntax-e #'((define a b) ...))))
                 (define all-define-values
                   (define-values-case  #'(define-values (c) d)))
                 #`(begin #,@all-define
                          #,@all-define-values)]))

(define (define-case stx)
  (parameterize ([prefix-predicates #t])
    (syntax-parse
        stx #:datum-literals (define)
        [(define id contract)
         #`(define id #,((munge-contract #'id) #'contract))])))

(define (define-values-case stx)
  (syntax-parse
      stx #:datum-literals (define-values)
      [(define-values (id) contract)
       (define required-id
         (send require-mapping lookup (syntax->datum #'id)))
       (send contract-registry register required-id #'id)
       #`((define-values (id) #,((munge-contract #'id) #'contract)))]))


(define require-contract
  (new require-contract-singleton%))
