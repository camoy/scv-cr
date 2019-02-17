#lang typed/racket/base/no-check
(define-values
  ()
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(provide Indexes
          In-Indexes
          Weighted-Signal
          Drum-Symbol
          Pattern
          (struct-out Array)
          (struct-out Settable-Array)
          (struct-out Mutable-Array))
(require require-typed-check)
(require "data.rkt")
(define-type Indexes (Vectorof Integer))
(define-type In-Indexes Indexes)
(define-type Weighted-Signal (List Array Real))
(define-type Drum-Symbol (U 'O 'X #f))
(define-type Pattern (Listof Drum-Symbol))
