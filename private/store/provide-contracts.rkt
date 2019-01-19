#lang racket

(require tr-contract/private/store/generic)

(provide provide-contracts-store)

(define provide-contracts-store
  (new store% [filename "_provide-contracts.dat"]))
