#lang racket

(require tr-contract/private/store)

(provide provide-contract)

(define provide-contract-singleton%
  (class store%
    (super-new [path "_provide-contract.dat"])))

(define provide-contract
  (new provide-contract-singleton%))
