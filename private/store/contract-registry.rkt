#lang racket

(require tr-contract/private/store)

(provide contract-registry)

(define contract-registry-singleton%
  (class store%
    (super-new [path #f]
               [init-struct (make-hash)])
    (inherit current-record)

    (define/public (register id contract)
      (hash-set! (current-record) id contract))

    (define/public (lookup id)
      (define record
        (hash-ref (current-record) id))
      (values (car record) (cdr record)))

    ))

(define contract-registry
  (new contract-registry-singleton%))
