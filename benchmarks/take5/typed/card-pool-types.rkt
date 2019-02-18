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
(provide CardPool% CardPool Hand)
(require typed/racket/class "card-adapted.rkt" "basics-types.rkt")
(define-type
  CardPool%
  (Class
   (init-field
    (shuffle (-> (Listof Card) (Listof Card)) #:optional)
    (random-bulls (-> Bulls) #:optional))
   (draw-card (-> Card))
   (draw-hand (-> Hand))))
(define-type CardPool (Instance CardPool%))
(define-type Hand (Listof Card))
