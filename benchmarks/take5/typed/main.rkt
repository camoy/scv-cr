#lang typed/racket/base/no-check
(define-values
  (g106
   g107
   g108
   g109
   g110
   g111
   g112
   g113
   g114
   g115
   g116
   g117
   generated-contract9)
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
    (letrec ((g106 exact-nonnegative-integer?)
             (g107 string?)
             (g108 (or/c g106 g107))
             (g109 symbol?)
             (g110 (or/c g106))
             (g111 '())
             (g112 (cons/c g110 g111))
             (g113 (cons/c g109 g112))
             (g114 (cons/c g110 g112))
             (g115 (listof g114))
             (g116 (cons/c g115 g111))
             (g117 (cons/c g113 g116))
             (generated-contract9 (-> g108 (values g117))))
      (values
       g106
       g107
       g108
       g109
       g110
       g111
       g112
       g113
       g114
       g115
       g116
       g117
       generated-contract9))))
(require (only-in racket/contract contract-out))
(provide (contract-out (main generated-contract9)))
(provide)
(require require-typed-check
          typed/racket/class
          "player-types.rkt"
          "dealer-types.rkt")
(require "player.rkt")
(require "dealer.rkt")
(: main (-> (U String Natural) Result))
(define (main n)
   (define k
     (cond
      ((and (string? n) (string->number n)) => (lambda (x) (assert n index?)))
      ((index? n) n)
      (else (error 'main "input must be a natural number; given ~e" n))))
   (define players (build-list k create-player))
   (define dealer (create-dealer players))
   (send dealer play-game))
(define PLAYERS 10)
(define LOOPS 1000)
(module+
  test
  (unless (equal?
           (main PLAYERS)
           '((after-round 2)
             ((1 0)
              (2 0)
              (3 0)
              (6 0)
              (7 0)
              (8 0)
              (0 56)
              (4 80)
              (9 80)
              (5 120))))
    (raise-user-error 'take5 "TEST FAILURE")))
(module+ main (time (for ((n (in-range LOOPS))) (main PLAYERS))))
