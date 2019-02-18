#lang typed/racket/no-check
(define-values
  (g106
   g107
   g108
   generated-contract97
   generated-contract98
   generated-contract99
   generated-contract100
   generated-contract101
   generated-contract102
   g109
   g110
   generated-contract103
   generated-contract104
   generated-contract105)
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
    (letrec ((g106 (lambda (x) (automaton? x)))
             (g107 nonnegative?)
             (g108 (or/c g107))
             (generated-contract97 (-> g106 (values g108)))
             (generated-contract98 (-> g106 (values g106)))
             (generated-contract99 (-> g106 (values g106)))
             (generated-contract100 (-> g108 (values g106)))
             (generated-contract101 (-> g108 (values g106)))
             (generated-contract102 (-> g108 (values g106)))
             (g109 exact-nonnegative-integer?)
             (g110 (or/c g109))
             (generated-contract103 (-> g110 (values g106)))
             (generated-contract104 (-> g106 g106 g110 (values g106 g106)))
             (generated-contract105 (-> g108 (values g106))))
      (values
       g106
       g107
       g108
       generated-contract97
       generated-contract98
       generated-contract99
       generated-contract100
       generated-contract101
       generated-contract102
       g109
       g110
       generated-contract103
       generated-contract104
       generated-contract105))))
(require (only-in racket/contract contract-out))
(provide (contract-out (automaton-reset generated-contract98))
          (contract-out (clone generated-contract99))
          (contract-out (cooperates generated-contract100))
          (contract-out (defects generated-contract101))
          (contract-out (grim-trigger generated-contract102))
          (contract-out (make-random-automaton generated-contract103))
          (contract-out (match-pair generated-contract104))
          (contract-out (tit-for-tat generated-contract105)))
(define-type Automaton automaton)
(define-type Payoff Nonnegative-Real)
(provide Automaton)
(: defects (-> Payoff Automaton))
(: cooperates (-> Payoff Automaton))
(: tit-for-tat (-> Payoff Automaton))
(: grim-trigger (-> Payoff Automaton))
(: make-random-automaton (-> Natural Automaton))
(: match-pair (-> Automaton Automaton Natural (values Automaton Automaton)))
(: automaton-reset (-> Automaton Automaton))
(: clone (-> Automaton Automaton))
(: COOPERATE State)
(define COOPERATE 0)
(: DEFECT State)
(define DEFECT 1)
(define-type State Natural)
(define-type Transition* (Vectorof Transition))
(define-type Transition (Vectorof State))
(struct
  automaton
  ((current : State)
   (original : State)
   (payoff : Payoff)
   (table : Transition*))
  #:transparent)
(define (make-random-automaton n)
   (: transitions (-> Any Transition))
   (define (transitions _i) (build-vector n (lambda (_) (random n))))
   (define original-current (random n))
   (automaton
    original-current
    original-current
    0
    (build-vector n transitions)))
(: make-automaton (-> State Transition* Automaton))
(define (make-automaton current table) (automaton current current 0 table))
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
(define defect-transitions
   (transitions
    #:i-cooperate/it-cooperates
    DEFECT
    #:i-cooperate/it-defects
    DEFECT
    #:i-defect/it-cooperates
    DEFECT
    #:i-defect/it-defects
    DEFECT))
(define (defects p0) (automaton DEFECT DEFECT p0 defect-transitions))
(define cooperates-transitions
   (transitions
    #:i-cooperate/it-cooperates
    COOPERATE
    #:i-cooperate/it-defects
    COOPERATE
    #:i-defect/it-cooperates
    COOPERATE
    #:i-defect/it-defects
    COOPERATE))
(define (cooperates p0)
   (automaton COOPERATE COOPERATE p0 cooperates-transitions))
(define tit-for-tat-transitions
   (transitions
    #:i-cooperate/it-cooperates
    COOPERATE
    #:i-cooperate/it-defects
    DEFECT
    #:i-defect/it-cooperates
    COOPERATE
    #:i-defect/it-defects
    DEFECT))
(define (tit-for-tat p0)
   (automaton COOPERATE COOPERATE p0 tit-for-tat-transitions))
(define grim-transitions
   (transitions
    #:i-cooperate/it-cooperates
    COOPERATE
    #:i-cooperate/it-defects
    DEFECT
    #:i-defect/it-cooperates
    DEFECT
    #:i-defect/it-defects
    DEFECT))
(: grim-trigger (-> Payoff Automaton))
(define (grim-trigger p0) (automaton COOPERATE COOPERATE p0 grim-transitions))
(define (automaton-reset a)
   (match-define (automaton current c0 payoff table) a)
   (automaton c0 c0 0 table))
(define (clone a)
   (match-define (automaton current c0 payoff table) a)
   (automaton c0 c0 0 table))
(define (match-pair auto1 auto2 rounds-per-match)
   (match-define (automaton current1 c1 payoff1 table1) auto1)
   (match-define (automaton current2 c2 payoff2 table2) auto2)
   (define-values
    (new1 p1 new2 p2)
    (for/fold
     ((current1 : State current1)
      (payoff1 : Payoff payoff1)
      (current2 : State current2)
      (payoff2 : Payoff payoff2))
     ((_ (in-range rounds-per-match)))
     (match-define (cons p1 p2) (payoff current1 current2))
     (define n1 (vector-ref (vector-ref table1 current1) current2))
     (define n2 (vector-ref (vector-ref table2 current2) current1))
     (values n1 (+ payoff1 p1) n2 (+ payoff2 p2))))
   (values (automaton new1 c1 p1 table1) (automaton new2 c2 p2 table2)))
(: PAYOFF-TABLE (Vectorof (Vectorof (cons Payoff Payoff))))
(define PAYOFF-TABLE
   (vector (vector (cons 3 3) (cons 0 4)) (vector (cons 4 0) (cons 1 1))))
(: payoff (-> State State (cons Payoff Payoff)))
(define (payoff current1 current2)
   (vector-ref (vector-ref PAYOFF-TABLE current1) current2))
