#lang typed/racket/no-check
(define-values
  (g6 g7 generated-contract3 generated-contract4 generated-contract5)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g6 exact-integer?)
             (g7 (or/c g6))
             (generated-contract3 g7)
             (generated-contract4 g7)
             (generated-contract5 g7))
      (values
       g6
       g7
       generated-contract3
       generated-contract4
       generated-contract5))))
(require (only-in racket/contract contract-out))
(provide (contract-out (block-size generated-contract3))
          (contract-out (board-height generated-contract4))
          (contract-out (board-width generated-contract5)))
(: block-size Integer)
(define block-size 20)
(: board-height Integer)
(define board-height 20)
(: board-width Integer)
(define board-width 10)
(provide)
