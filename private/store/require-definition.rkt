#lang racket

(require tr-contract/private/store
         tr-contract/private/munge-contract
         syntax/parse)

(provide require-definition)

(define require-definition-singleton%
  (class store%
    (super-new [path "_require-definition.dat"])

    (define/override (process record)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (reverse record)))))

(define (begin-cases stx)
  (syntax-parse
      stx #:datum-literals (begin
                             define
                             define-values)
      [(begin (define a b) ...
              (define-values (c) d))
       (define all-define
         (map define-case (syntax-e #'((define a b) ...))))
       (define define-values-stx
         (define-values-case #'(define-values (c) d)))
       #`(begin #,@all-define
                #,define-values-stx)]))

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
       #`(define-values (id) #,((munge-contract #'id) #'contract))]))

(define require-definition
  (new require-definition-singleton%))
