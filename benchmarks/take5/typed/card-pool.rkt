#lang typed/racket/base/no-check
(define-values
  (g45 g46 g47 g48 g49 g50 g51 g52 g53 g54 g55 g56 generated-contract42)
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
    (letrec ((g45 (lambda (x) (card? x)))
             (g46 (listof g45))
             (g47 (-> g46 (values g46)))
             (g48 exact-nonnegative-integer?)
             (g49 (or/c g48))
             (g50 (-> (values g49)))
             (g51 any/c)
             (g52 (-> g51 (values g45)))
             (g53 (-> g51 (values g46)))
             (g54 (-> (values g49)))
             (g55 (-> g46 (values g46)))
             (g56
              (object/c-opaque
               (draw-card g52)
               (draw-hand g53)
               (field (random-bulls g54))
               (field (shuffle g55))))
             (generated-contract42 (->* () (g47 g50) (values g56))))
      (values
       g45
       g46
       g47
       g48
       g49
       g50
       g51
       g52
       g53
       g54
       g55
       g56
       generated-contract42))))
(require (only-in racket/contract contract-out))
(provide (contract-out (create-card-pool generated-contract42)))
(provide)
(require "card-adapted.rkt"
          "basics-types.rkt"
          "card-pool-types.rkt"
          typed/racket/class
          require-typed-check
          (only-in racket/list shuffle first rest))
(require "basics.rkt")
(:
  create-card-pool
  (->* () ((-> (Listof Card) (Listof Card)) (-> Bulls)) CardPool))
(define (create-card-pool (shuffle shuffle) (random-bulls random-bulls))
   (new card-pool% (shuffle shuffle) (random-bulls random-bulls)))
(define rng (vector->pseudo-random-generator '#(12 34 56 78 90 1)))
(: random-bulls (-> Bulls))
(define (random-bulls) (random MIN-BULL (+ MAX-BULL 1) rng))
(: card-pool% CardPool%)
(define card-pool%
   (class object%
     (init-field (shuffle shuffle) (random-bulls random-bulls))
     (super-new)
     (define
      my-cards
      :
      (Listof Card)
      (shuffle
       (build-list
        FACE
        (lambda ((i : Natural)) (card (+ i 1) (random-bulls))))))
     (define/public
      (draw-card)
      (begin0 (first my-cards) (set! my-cards (rest my-cards))))
     (define/public (draw-hand) (build-list HAND (lambda (_) (draw-card))))))
