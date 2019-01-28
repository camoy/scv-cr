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
      (hash-ref (current-record) id #f))


    ))

(define contract-registry
  (new contract-registry-singleton%))
