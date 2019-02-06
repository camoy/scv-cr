#lang racket

(require tr-contract/private/store
         tr-contract/private/store/struct-data
         tr-contract/private/munge-contract
         syntax/parse)

(provide provide-contract)

(define provide-contract-singleton%
  (class store%
    (super-new [path "_provide-contract.dat"])
    (define provided-hash
      (make-hash))

    (define/public (provided-record)
      (define return
        (hash-ref provided-hash (current-target) (make-hash)))
      (hash-set! provided-hash (current-target) return)
      return)

    (define/public (already-defined? id)
      (hash-ref (provided-record) id #f))

    (define/public (register-defined id)
      (hash-set! (provided-record) id #t))

    (define/override (process record)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (reverse record)))))

(define (begin-cases stx)
  (syntax-parse
      stx #:datum-literals (begin
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
  (syntax-parse
      stx #:datum-literals (define)
      [(define id contract)
       #`(define id #,((munge-contract #'id) #'contract))]))

(define (define-values-case stx)
  (syntax-parse
      stx #:datum-literals (define-values)
      [(define-values (id) contract)
       #`(define-values (id) #,((munge-contract #'id) #'contract))]))

(define (contract-case stx contract-def)
  (syntax-parse
      stx #:datum-literals (define-module-boundary-contract)
      [(define-module-boundary-contract x y contract _ ...)
       (define name
         (syntax->datum #'x))
       (define desc
         (send struct-data struct-function? name))
       (cond
         [(and desc (equal? (car desc) 'constructor))
          (make-struct-out (cdr desc) contract-def)]
         [desc #'(void)]
         [else
          (send provide-contract register-defined (syntax-e #'x))
          #'(begin
              (provide (contract-out [x contract]))
              (module+ unsafe
                (provide x)))])]))

(define (make-struct-out info contract-def)
  (syntax-parse
      contract-def #:datum-literals (->*)
      [((define-values (_) (-> fld-type ... (values _ ...))))
       (define struct-name
         (struct-desc-name info))
       (define fld-pairs
         (for/list ([fld-name (send struct-data struct-all-fields struct-name)]
                    [fld-type (syntax->datum #'(fld-type ...))])
           #`(#,fld-name #,fld-type)))
       (send provide-contract register-defined struct-name)
       #`(begin
           (provide (contract-out [struct #,(with-super info) #,fld-pairs]))
           (module+ unsafe (provide (struct-out #,struct-name))))]
      [_ (error 'make-struct-out "failed to match on contract definition")]))

(define (with-super info)
  (define struct-name
    (struct-desc-name info))
  (define sup-name
    (struct-desc-super-struct info))
  (if sup-name
      #`(#,struct-name #,sup-name)
      struct-name))

(define provide-contract
  (new provide-contract-singleton%))
