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
(provide BaseDeck%
          BaseDeck
          PlayerDeck%
          PlayerDeck
          DealerDeck%
          DealerDeck
          Deck%
          Deck)
(require typed/racket/class
          "basics-types.rkt"
          "card-adapted.rkt"
          "stack-types.rkt")
(define-type
  BaseDeck%
  (Class
   (init-field (cards0 (Listof Card)))
   (field (my-stacks (Listof Stack)))))
(define-type
  PlayerDeck%
  (Class #:implements/inits BaseDeck% (fewest-bulls (-> Stack))))
(define-type
  DealerDeck%
  (Class
   #:implements/inits
   BaseDeck%
   (fit (-> Card Stack))
   (push (-> Card Void))
   (replace (-> Stack Card Natural))
   (replace-stack (-> Card (U Card (Listof Card)) Natural))
   (larger-than-some-top-of-stacks? (-> Card Boolean))))
(define-type
  Deck%
  (Class
   #:implements/inits
   BaseDeck%
   (fewest-bulls (-> Stack))
   (fit (-> Card Stack))
   (push (-> Card Void))
   (replace (-> Stack Card Natural))
   (replace-stack (-> Card (U Card (Listof Card)) Natural))
   (larger-than-some-top-of-stacks? (-> Card Boolean))))
(define-type BaseDeck (Instance BaseDeck%))
(define-type PlayerDeck (Instance PlayerDeck%))
(define-type DealerDeck (Instance DealerDeck%))
(define-type Deck (Instance Deck%))
