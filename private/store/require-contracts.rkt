#lang racket

(require tr-contract/private/store/generic)

(provide require-contracts-store)

(define require-contracts-store
  (new store% [filename "_require-contracts.dat"]))
