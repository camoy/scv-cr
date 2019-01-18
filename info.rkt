#lang info
(define collection "tr-contract")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/tr-contract.scrbl" ())))
(define pkg-desc "Makes contracts in Typed Racket programs explicit.")
(define version "0.0")
(define pkg-authors '(camoy))
(define raco-commands
  '(("explicit-contracts"
     (submod tr-contract/private/explicit-contracts main)
     "make Typed Racket contracts explicit"
     #f)))
