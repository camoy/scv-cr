#lang typed/racket/no-check
(define-values
  (g89
   g90
   g91
   g86
   g87
   g88
   g92
   g93
   g94
   g95
   g96
   g97
   g98
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
   g132
   g133
   g134
   generated-contract76)
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
    (letrec ((g89 (recursive-contract g108 #:impersonator))
             (g90 (recursive-contract g109 #:impersonator))
             (g91 (recursive-contract g104 #:impersonator))
             (g86 (recursive-contract g123 #:impersonator))
             (g87 (recursive-contract g129 #:impersonator))
             (g88 (recursive-contract g134 #:impersonator))
             (g92 exact-nonnegative-integer?)
             (g93 (or/c g92))
             (g94 any/c)
             (g95 nonnegative?)
             (g96 '#f)
             (g97 (or/c g95 g96))
             (g98 (lambda (x) (equal? x (void))))
             (g99 (->* (g94 g93) (#:random g97) (values g98)))
             (g100 (-> g94 g93 (values g98)))
             (g101 (or/c g95))
             (g102 (listof g101))
             (g103 (-> g94 (values g102)))
             (g104 g86)
             (g105 (vectorof g104))
             (g106 (or/c g105))
             (g107
              (object/c-opaque
               (death-birth g99)
               (match-up* g100)
               (payoffs g103)
               (field (a* g106))
               (field (b* g106))))
             (g108 g88)
             (g109 g87)
             (g110 g91)
             (g111 (-> g94 (values g110)))
             (g112 g90)
             (g113 '#t)
             (g114 (or/c g113 g96))
             (g115 (-> g94 g112 (values g114)))
             (g116 (-> g94 g93 g101 (values g98)))
             (g117 (-> g94 g112 g93 (values g110 g110)))
             (g118 (-> g94 (values g101)))
             (g119 (vectorof g93))
             (g120 (or/c g119))
             (g121 (vectorof g120))
             (g122 (or/c g121))
             (g123
              (object/c
               (clone g111)
               (equal g115)
               (jump g116)
               (match-pair g117)
               (pay g118)
               (reset g111)
               (field (current g93))
               (field (original g93))
               (field (payoff g101))
               (field (table g122))))
             (g124 (-> g94 (values g112)))
             (g125 (-> g94 g110 (values g114)))
             (g126 (-> g94 g93 g101 (values g98)))
             (g127 (-> g94 g110 g93 (values g112 g112)))
             (g128 (-> g94 (values g101)))
             (g129
              (object/c-opaque
               (clone g124)
               (equal g125)
               (jump g126)
               (match-pair g127)
               (pay g128)
               (reset g124)
               (field (current g93))
               (field (original g93))
               (field (payoff g101))
               (field (table g122))))
             (g130 g89)
             (g131 (-> g94 (values g130)))
             (g132 (-> g94 g130 (values g114)))
             (g133 (-> g94 g130 g93 (values g130 g130)))
             (g134
              (object/c-opaque
               (clone g131)
               (equal g132)
               (jump g126)
               (match-pair g133)
               (pay g128)
               (reset g131)
               (field (current g93))
               (field (original g93))
               (field (payoff g101))
               (field (table g122))))
             (generated-contract76 (-> g93 (values g107))))
      (values
       g89
       g90
       g91
       g86
       g87
       g88
       g92
       g93
       g94
       g95
       g96
       g97
       g98
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
       g132
       g133
       g134
       generated-contract76))))
(require (only-in racket/contract contract-out))
(provide (contract-out (build-random-population generated-contract76)))
(require "automata-adapted.rkt" require-typed-check)
(require "utilities.rkt")
(define-type Probability Nonnegative-Real)
(define-type
  Population
  (Class
   (init-field (a* Automaton*) (b* Automaton* #:optional))
   (payoffs (-> (Listof Payoff)))
   (match-up* (-> Natural Void))
   (death-birth (-> Natural (#:random (U False Payoff)) Void))))
(define-type
  oPopulation
  (Instance
   (Class
    (init-field (a* Automaton*) (b* Automaton* #:optional))
    (payoffs (-> (Listof Payoff)))
    (match-up* (-> Natural Void))
    (death-birth (-> Natural (#:random (U False Payoff)) Void)))))
(define-type Automaton* (Vectorof (Instance Automaton)))
(provide)
(: build-random-population (-> Natural oPopulation))
(define DEF-COO 2)
(define (build-random-population n)
   (define v (build-vector n (lambda (_) (make-random-automaton DEF-COO))))
   (new population% (a* v)))
(: population% Population)
(define population%
   (class object%
     (init-field a* (b* a*))
     (super-new)
     (define/public
      (payoffs)
      (for/list
       :
       (Listof Payoff)
       ((a : (Instance Automaton) (in-vector a*)))
       (send a pay)))
     (define/public
      (match-up* rounds-per-match)
      (reset)
      (for
       ((i (in-range 0 (- (vector-length a*) 1) 2)))
       (define p1 (vector-ref a* i))
       (define p2 (vector-ref a* (+ i 1)))
       (define-values (a1 a2) (send p1 match-pair p2 rounds-per-match))
       (vector-set! a* i a1)
       (vector-set! a* (+ i 1) a2))
      (void))
     (define/public
      (death-birth rate #:random (q #f))
      (define payoffs* (payoffs))
      (define substitutes (choose-randomly payoffs* rate #:random q))
      (for
       ((i (in-range rate)) (p (in-list substitutes)))
       (vector-set! a* i (send (vector-ref b* p) clone)))
      (shuffle-vector))
     (: reset (-> Void))
     (define/private
      (reset)
      (for
       ((x : (Instance Automaton) (in-vector a*)) (i : Natural (in-naturals)))
       (vector-set! a* i (send x reset))))
     (: shuffle-vector (-> Void))
     (define/private
      (shuffle-vector)
      (for
       ((x : (Instance Automaton) (in-vector a*)) (i : Natural (in-naturals)))
       (vector-set! b* i x))
      (for
       ((x (in-vector a*)) (i (in-naturals)))
       (define j (random (add1 i)))
       (unless (= j i) (vector-set! b* i (vector-ref b* j)))
       (vector-set! b* j x))
      (define tmp a*)
      (set! a* b*)
      (set! b* tmp)
      (void))))
