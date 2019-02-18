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
(provide Result Dealer% Dealer Internal% Internal)
(require typed/racket/class
          "basics-types.rkt"
          "card-adapted.rkt"
          "player-types.rkt")
(define-type Result (List (List Symbol Natural) (Listof (List Name Natural))))
(define-type
  Internal%
  (Class
   #:implements
   Player%
   (init-field (player Player))
   (field (my-bulls Natural))
   (bulls (-> Natural))
   (add-score (-> Natural Void))))
(define-type Internal (Instance Internal%))
(define-type
  Dealer%
  (Class
   (init-field (players (Listof Player)))
   (field (internal% Internal%) (internals (Listof Internal)))
   (present-results (-> Natural Result))
   (any-player-done? (-> Boolean))
   (play-round (-> (-> (Listof Card) (Listof Card)) (-> Bulls) Void))
   (play-game (->* () ((-> (Listof Card) (Listof Card)) (-> Bulls)) Result))))
(define-type Dealer (Instance Dealer%))
