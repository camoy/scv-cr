#lang racket

(require tr-contract/private/store)

(provide require-mapping)

(define require-mapping-singleton%
  (class store%
    (super-new [path "_require-mapping.dat"]
               [init-struct (make-hash)])
    (inherit current-record)
    (define/override (process record)
      (define lifted->id (make-hash))
      (for ([lst record])
        (match lst
          [(list lifted id lib) (hash-set! lifted->id lifted id)]))
      lifted->id)

    (define/public (lookup lifted)
      (hash-ref (current-record) lifted))

    ))

(define require-mapping
  (new require-mapping-singleton%))
