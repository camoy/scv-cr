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
(provide Player% Player)
(require "basics-types.rkt"
          "deck-types.rkt"
          "card-adapted.rkt"
          "stack-types.rkt"
          typed/racket/class)
(define-type
  Player%
  (Class
   (init-field (n Name) (order (-> (Listof Card) (Listof Card)) #:optional))
   (field (my-cards (Listof Card)))
   (name (-> Name))
   (start-round (-> (Listof Card) Void))
   (start-turn (-> Deck Card))
   (choose (-> Deck Stack))))
(define-type Player (Instance Player%))
