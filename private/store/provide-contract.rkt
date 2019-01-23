#lang racket

(require tr-contract/private/store
         tr-contract/private/store/provide-struct
         syntax/parse)

(provide provide-contract)

(define provide-contract-singleton%
  (class store%
    (super-new [path "_provide-contract.dat"])
    (define/override (process record)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (reverse record)))))

(define (begin-cases stx)
  (syntax-parse stx #:datum-literals (begin
                                       define
                                       define-values
                                       define-module-boundary-contract)
                [(begin (define a b) ...
                        (define-values (c) d) ...
                        (define-module-boundary-contract e ...))
                 (define all-define
                   (map define-case (syntax-e #'((define a b) ...))))
                 (define all-define-values
                   (map define-values-case (syntax-e #'((define-values (c) d) ...))))
                 (define the-contract
                   (contract-case #'(define-module-boundary-contract e ...)
                                  all-define-values))
                 #`(begin #,@all-define
                          #,@all-define-values
                          #,the-contract)]))

(define (define-case stx)
  (syntax-parse stx #:datum-literals (define)
    [(define id contract)
     #`(define id #,((munge-contract #'id) #'contract))]))

(define (define-values-case stx)
  (syntax-parse stx #:datum-literals (define-values)
    [(define-values (id) contract)
     #`(define-values (id) #,((munge-contract #'id) #'contract))]))

(define (contract-case stx contract-def)
  (syntax-parse
      stx #:datum-literals (define-module-boundary-contract)
      [(define-module-boundary-contract x y contract _ ...)
       (define name
         (syntax->datum #'x))
       (define info
         (send provide-struct struct-function? name))
       (cond
         [(and info (equal? (car info) 'constructor))
          (make-struct-out (cdr info) contract-def)]
         [info #'(void)]
         [else #'(provide (contract-out [x contract]))])]))

(define (make-struct-out info contract-def)
  (syntax-parse
      contract-def #:datum-literals (->*)
      [((define-values (_) (->* (fld-type ...) () (values _ ...))))
       (define fld-pairs
         (for/list ([fld-name (struct-data-fields info)]
                    [fld-type (syntax->datum #'(fld-type ...))])
           #`(#,fld-name #,fld-type)))
       #`(provide (contract-out
                   [struct #,(struct-data-name info)
                     #,fld-pairs]))]))

(define ((munge-contract id) stx)
  (syntax-parse stx #:datum-literals (lambda equal? quote)
    [(lambda ((~literal x)) (equal? (~literal x) (quote y)))
     #:when (void? (syntax-e #'y))
     #'void?]
    [(f args ...)
     #`(f #,@(map (munge-contract id)
                  (syntax->list #'(args ...))))]
    [other #'other]))

(define provide-contract
  (new provide-contract-singleton%))
