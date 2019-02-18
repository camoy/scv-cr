#lang typed/racket/no-check
(define-values
  (g108
   g109
   g110
   g111
   g112
   g113
   g114
   generated-contract102
   g118
   g119
   g120
   g115
   g116
   g117
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
   g135
   g136
   g137
   g138
   g139
   g140
   g141
   g142
   g143
   g144
   g145
   g146
   g147
   g148
   g149
   g150
   g151
   generated-contract103
   generated-contract104
   generated-contract105
   generated-contract106
   generated-contract107)
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
    (letrec ((g108 (λ (_) #f))
             (g109 any/c)
             (g110 '#t)
             (g111 '#f)
             (g112 (or/c g110 g111))
             (g113 (-> g109 (values g112)))
             (g114 (or/c g108 g113))
             (generated-contract102 g114)
             (g118 (recursive-contract g137 #:impersonator))
             (g119 (recursive-contract g143 #:impersonator))
             (g120 (recursive-contract g148 #:impersonator))
             (g115 (recursive-contract g149 #:impersonator))
             (g116 (recursive-contract g150 #:impersonator))
             (g117 (recursive-contract g151 #:impersonator))
             (g121 nonnegative?)
             (g122 (or/c g121))
             (g123 g116)
             (g124 g117)
             (g125 (-> g109 (values g124)))
             (g126 (-> g109 g123 (values g112)))
             (g127 exact-nonnegative-integer?)
             (g128 (or/c g127))
             (g129 (lambda (x) (equal? x (void))))
             (g130 (-> g109 g128 g122 (values g129)))
             (g131 (-> g109 g123 g128 (values g124 g124)))
             (g132 (-> g109 (values g122)))
             (g133 (vectorof g128))
             (g134 (or/c g133))
             (g135 (vectorof g134))
             (g136 (or/c g135))
             (g137
              (object/c
               (clone g125)
               (equal g126)
               (jump g130)
               (match-pair g131)
               (pay g132)
               (reset g125)
               (field (current g128))
               (field (original g128))
               (field (payoff g122))
               (field (table g136))))
             (g138 (-> g109 (values g123)))
             (g139 (-> g109 g124 (values g112)))
             (g140 (-> g109 g128 g122 (values g129)))
             (g141 (-> g109 g124 g128 (values g123 g123)))
             (g142 (-> g109 (values g122)))
             (g143
              (object/c-opaque
               (clone g138)
               (equal g139)
               (jump g140)
               (match-pair g141)
               (pay g142)
               (reset g138)
               (field (current g128))
               (field (original g128))
               (field (payoff g122))
               (field (table g136))))
             (g144 g115)
             (g145 (-> g109 (values g144)))
             (g146 (-> g109 g144 (values g112)))
             (g147 (-> g109 g144 g128 (values g144 g144)))
             (g148
              (object/c-opaque
               (clone g145)
               (equal g146)
               (jump g140)
               (match-pair g147)
               (pay g142)
               (reset g145)
               (field (current g128))
               (field (original g128))
               (field (payoff g122))
               (field (table g136))))
             (g149 g120)
             (g150 g119)
             (g151 g118)
             (generated-contract103 (-> g122 (values g123)))
             (generated-contract104 (-> g122 (values g123)))
             (generated-contract105 (-> g122 (values g123)))
             (generated-contract106 (-> g128 (values g123)))
             (generated-contract107 (-> g122 (values g123))))
      (values
       g108
       g109
       g110
       g111
       g112
       g113
       g114
       generated-contract102
       g118
       g119
       g120
       g115
       g116
       g117
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
       g135
       g136
       g137
       g138
       g139
       g140
       g141
       g142
       g143
       g144
       g145
       g146
       g147
       g148
       g149
       g150
       g151
       generated-contract103
       generated-contract104
       generated-contract105
       generated-contract106
       generated-contract107))))
(require (only-in racket/contract contract-out))
(provide (contract-out (automaton? generated-contract102))
          (contract-out (cooperates generated-contract103))
          (contract-out (defects generated-contract104))
          (contract-out (grim-trigger generated-contract105))
          (contract-out (make-random-automaton generated-contract106))
          (contract-out (tit-for-tat generated-contract107)))
(define-type
  Automaton
  (Class
   (init-field
    (current State)
    (payoff Payoff)
    (table Transition*)
    (original State #:optional))
   (match-pair (-> oAutomaton Natural (values oAutomaton oAutomaton)))
   (jump (-> State Payoff Void))
   (pay (-> Payoff))
   (reset (-> oAutomaton))
   (clone (-> oAutomaton))
   (equal (-> oAutomaton Boolean))))
(define-type oAutomaton (Instance Automaton))
(define-type Payoff Nonnegative-Real)
(provide)
(: automaton? (-> Any Boolean))
(: defects (-> Payoff oAutomaton))
(: cooperates (-> Payoff oAutomaton))
(: tit-for-tat (-> Payoff oAutomaton))
(: grim-trigger (-> Payoff oAutomaton))
(: make-random-automaton (-> Natural oAutomaton))
(define (automaton? v) (is-a? v automaton%))
(define-type Transition* (Vectorof (Vectorof State)))
(define-type State Natural)
(define-type Input Natural)
(define (make-random-automaton n)
   (: trans (-> Any (Vectorof State)))
   (define (trans _i) (build-vector n (lambda (_) (random n))))
   (define seed (random n))
   (new automaton% (current seed) (payoff 0) (table (build-vector n trans))))
(: automaton% Automaton)
(define automaton%
   (let ()
     (: PAYOFF-TABLE (Vectorof (Vectorof (cons Payoff Payoff))))
     (define PAYOFF-TABLE
       (vector (vector (cons 3 3) (cons 0 4)) (vector (cons 4 0) (cons 1 1))))
     (class object%
       (init-field current payoff table (original current))
       (super-new)
       (define/public
        (match-pair other r)
        (: c1 (Boxof State))
        (: y1 (Boxof Payoff))
        (: c2 (Boxof State))
        (: y2 (Boxof Payoff))
        (define c1 (box (get-field current this)))
        (define y1 (box (get-field payoff this)))
        (define t1 (get-field table this))
        (define c2 (box (get-field current other)))
        (define y2 (box (get-field payoff other)))
        (define t2 (get-field table this))
        (for
         ((_i : Natural (in-range r)))
         (define input (unbox c2))
         (match-define
          (cons p1 p2)
          (vector-ref (vector-ref PAYOFF-TABLE (unbox c1)) input))
         (set-box! c1 (vector-ref (vector-ref t1 (unbox c1)) input))
         (set-box! y1 (+ (unbox y1) p1))
         (set-box! c2 (vector-ref (vector-ref t2 (unbox c2)) (unbox c1)))
         (set-box! y2 (+ (unbox y2) p2))
         (void))
        (set-field! current this (unbox c1))
        (set-field! payoff this (unbox y1))
        (set-field! current other (unbox c2))
        (set-field! payoff other (unbox y2))
        (values this other))
       (define/public
        (jump input delta)
        (set! current (vector-ref (vector-ref table current) input))
        (set! payoff (+ payoff delta)))
       (define/public (pay) payoff)
       (define/public
        (reset)
        (new automaton% (current original) (payoff 0) (table table)))
       (define/public
        (clone)
        (new automaton% (current original) (payoff 0) (table table)))
       (: compute-payoffs (-> State (cons Payoff Payoff)))
       (define/private
        (compute-payoffs other-current)
        (vector-ref (vector-ref PAYOFF-TABLE current) other-current))
       (define/public
        (equal other)
        (and (= current (get-field current other))
             (= original (get-field original other))
             (= payoff (get-field payoff other))
             (equal? table (get-field table other)))))))
(define COOPERATE 0)
(define DEFECT 1)
(define (defects p0)
   (new
    automaton%
    (current DEFECT)
    (payoff p0)
    (table
     (transitions
      #:i-cooperate/it-cooperates
      DEFECT
      #:i-cooperate/it-defects
      DEFECT
      #:i-defect/it-cooperates
      DEFECT
      #:i-defect/it-defects
      DEFECT))))
(define (cooperates p0)
   (new
    automaton%
    (current COOPERATE)
    (payoff p0)
    (table
     (transitions
      #:i-cooperate/it-cooperates
      COOPERATE
      #:i-cooperate/it-defects
      COOPERATE
      #:i-defect/it-cooperates
      COOPERATE
      #:i-defect/it-defects
      COOPERATE))))
(define (tit-for-tat p0)
   (new
    automaton%
    (current COOPERATE)
    (payoff p0)
    (table
     (transitions
      #:i-cooperate/it-cooperates
      COOPERATE
      #:i-cooperate/it-defects
      DEFECT
      #:i-defect/it-cooperates
      COOPERATE
      #:i-defect/it-defects
      DEFECT))))
(define (grim-trigger p0)
   (new
    automaton%
    (current COOPERATE)
    (payoff p0)
    (table
     (transitions
      #:i-cooperate/it-cooperates
      COOPERATE
      #:i-cooperate/it-defects
      DEFECT
      #:i-defect/it-cooperates
      DEFECT
      #:i-defect/it-defects
      DEFECT))))
(:
  transitions
  (->
   #:i-cooperate/it-cooperates
   State
   #:i-cooperate/it-defects
   State
   #:i-defect/it-cooperates
   State
   #:i-defect/it-defects
   State
   Transition*))
(define (transitions
          #:i-cooperate/it-cooperates
          cc
          #:i-cooperate/it-defects
          cd
          #:i-defect/it-cooperates
          dc
          #:i-defect/it-defects
          dd)
   (vector (vector cc cd) (vector dc dd)))
