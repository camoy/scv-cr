#lang typed/racket/no-check
(define-values
  ()
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
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(define-type Color Symbol)
(require require-typed-check)
(require "data.rkt")
(define-type Posn posn)
(define-type Block block)
(define-type Tetra tetra)
(define-type World world)
(define-type BSet (Listof Block))
(provide (struct-out posn)
          (struct-out block)
          (struct-out tetra)
          (struct-out world)
          Posn
          Block
          Tetra
          World
          Color
          BSet
          Color
          BSet)
