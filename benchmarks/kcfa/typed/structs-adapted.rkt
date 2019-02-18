#lang typed/racket/base/no-check
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
(require require-typed-check)
(require "structs.rkt")
(provide (struct-out Stx)
          (struct-out exp)
          (struct-out Ref)
          (struct-out Lam)
          (struct-out Call)
          Exp
          Label
          Var)
(define-type Exp (U exp Ref Lam Call))
(define-type Label Symbol)
(define-type Var Symbol)
