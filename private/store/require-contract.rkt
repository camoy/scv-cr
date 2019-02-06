#lang racket

(require tr-contract/private/store
         tr-contract/private/munge-contract)

(provide require-contract)

(define require-contract-singleton%
  (class store%
    (super-new [path "_require-contract.dat"])
    (inherit current-record)

    (define/override (process record)
      (map make-contract-out (reverse record)))
    ))

(define (make-contract-out required-lst)
  (match required-lst
    [(list contract-id id lib)
     #`(define/contract
         #,id
         #,((munge-contract #'_) contract-id)
         #,(prefix-unsafe id))]))

(define require-contract
  (new require-contract-singleton%))
