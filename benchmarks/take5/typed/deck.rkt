#lang typed/racket/base/no-check
(define-values
  (g99
   g100
   g101
   g102
   g103
   g104
   g105
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
   g118
   g119
   g120
   g121
   g122
   g123
   g124
   g125
   g126
   g127
   g128
   g129
   g130
   g131
   generated-contract94)
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
    (letrec ((g99 (recursive-contract g124 #:impersonator))
             (g100 (recursive-contract g131 #:impersonator))
             (g101 (recursive-contract g131 #:impersonator))
             (g102 any/c)
             (g103 (lambda (x) (card? x)))
             (g104 (-> any/c g103))
             (g105 (listof g103))
             (g106 (-> g102 (values g105)))
             (g107 exact-nonnegative-integer?)
             (g108 (or/c g107))
             (g109 (-> (values g108)))
             (g110 (-> g105 (values g105)))
             (g111
              (object/c
               (draw-card g104)
               (draw-hand g106)
               (field (random-bulls g109))
               (field (shuffle g110))))
             (g112 g100)
             (g113 (-> g102 g103 (values g105)))
             (g114 '#t)
             (g115 '#f)
             (g116 (or/c g114 g115))
             (g117 (-> g102 g103 (values g116)))
             (g118 (lambda (x) (equal? x (void))))
             (g119 (-> any/c any/c g118))
             (g120 (-> g102 g105 g103 (values g108)))
             (g121 (or/c g103 g105))
             (g122 (-> g102 g103 g121 (values g108)))
             (g123 (listof g105))
             (g124
              (object/c
               (fewest-bulls g106)
               (fit g113)
               (larger-than-some-top-of-stacks? g117)
               (push g119)
               (replace g120)
               (replace-stack g122)
               (field (cards0 g105))
               (field (my-stacks g123))))
             (g125 (-> g102 (values g105)))
             (g126 (-> g102 g103 (values g105)))
             (g127 (-> g102 g103 (values g116)))
             (g128 (-> g102 g103 (values g118)))
             (g129 (-> g102 g105 g103 (values g108)))
             (g130 (-> g102 g103 g121 (values g108)))
             (g131
              (object/c-opaque
               (fewest-bulls g125)
               (fit g126)
               (larger-than-some-top-of-stacks? g127)
               (push g128)
               (replace g129)
               (replace-stack g130)
               (field (cards0 g105))
               (field (my-stacks g123))))
             (generated-contract94 (-> g111 (values g112))))
      (values
       g99
       g100
       g101
       g102
       g103
       g104
       g105
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
       g118
       g119
       g120
       g121
       g122
       g123
       g124
       g125
       g126
       g127
       g128
       g129
       g130
       g131
       generated-contract94))))
(require (only-in racket/contract contract-out))
(provide (contract-out (create-deck generated-contract94)))
(provide)
(require typed/racket/class
          "basics-types.rkt"
          "card-adapted.rkt"
          "card-pool-types.rkt"
          "deck-types.rkt"
          "stack-types.rkt"
          racket/list
          require-typed-check)
(require "basics.rkt")
(require "stack.rkt")
(: create-deck (-> CardPool Deck))
(define (create-deck card-pool)
   (define deck% (for-player (for-dealer base-deck%)))
   (define cards (build-list STACKS (lambda (_) (send card-pool draw-card))))
   (new deck% (cards0 cards)))
(: for-player (-> DealerDeck% Deck%))
(define (for-player deck%)
   (class deck%
     (inherit-field my-stacks)
     (super-new)
     (define/public
      (fewest-bulls)
      (define stacks-with-bulls
        :
        (Listof (List Stack Natural))
        (for/list
         :
         (Listof (List Stack Natural))
         ((s my-stacks))
         (list s (bulls s))))
      (first
       (argmin
        (lambda ((l : (List Stack Natural))) (second l))
        stacks-with-bulls)))))
(: for-dealer (-> BaseDeck% DealerDeck%))
(define (for-dealer deck%)
   (class deck%
     (inherit-field cards0)
     (inherit-field my-stacks)
     (super-new)
     (set-field! my-stacks this (map (lambda ((c : Card)) (list c)) cards0))
     (define/public
      (fit c)
      (: distance (-> (Listof Card) Real))
      (define (distance stack)
        (define d (first stack))
        (if (>-face c d) (--face c d) (+ FACE 1)))
      (argmin distance my-stacks))
     (define/public
      (push c)
      (define s0 (fit c))
      (void (replace-stack (first s0) c)))
     (define/public (replace s c) (replace-stack (first s) (list c)))
     (define/public
      (replace-stack top0 c)
      (define result : Natural 0)
      (set! my-stacks
        (for/list
         :
         (Listof Stack)
         ((s : Stack my-stacks))
         (cond
          ((equal? (first s) top0)
           (set! result (bulls s))
           (if (cons? c) c (if (null? c) (error 'invalid-input) (cons c s))))
          (else s))))
      result)
     (define/public
      (larger-than-some-top-of-stacks? c)
      (for/or ((s my-stacks)) (>-face c (first s))))))
(: base-deck% BaseDeck%)
(define base-deck%
   (class object% (init-field cards0) (field (my-stacks '())) (super-new)))
