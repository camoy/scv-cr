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
(provide Face Bulls Name)
(define-type Name Natural)
(define-type Face Natural)
(define-type Bulls Natural)
