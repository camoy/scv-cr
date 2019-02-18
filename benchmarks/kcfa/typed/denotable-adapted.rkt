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
(require require-typed-check
          "structs-adapted.rkt"
          "benv-adapted.rkt"
          "time-adapted.rkt")
(require "denotable.rkt")
(provide Denotable
          Store
          (struct-out State)
          d-bot
          d-join
          empty-store
          store-lookup
          store-update
          store-update*
          store-join)
(define-type Denotable (Setof Value))
(define-type Store (HashTable Addr Denotable))
