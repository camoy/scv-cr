#lang racket

(require tr-contract/private/store)

(provide require-contract)

(define require-contract-singleton%
  (class store%
    (super-new [path "_require-contract.dat"])))

(define require-contract
  (new require-contract-singleton%))
