#lang racket

(require tr-contract/private/store
         tr-contract/private/munge-contract)

(provide require-contract)

(define require-contract-singleton%
  (class store%
    (super-new [path "_require-contract.dat"])
    (field [imports (make-hash)])

    (define/override (process record)
      (map make-contract-out (reverse record)))

    (define/public (all-imports mod)
      (hash-ref imports mod '()))

    (define (make-contract-out required-lst)
      (match required-lst
        [(list contract-id id mod)
         (hash-set! imports mod
                    (if (hash-has-key? imports mod)
                        (cons id (hash-ref imports mod))
                        (list id)))
         #`(define/contract
             #,id
             #,((munge-contract #'_) contract-id)
             #,(prefix-unsafe id))]))
    ))

(define require-contract
  (new require-contract-singleton%))
