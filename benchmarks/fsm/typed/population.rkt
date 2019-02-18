#lang typed/racket/no-check
(define-values
  (g37
   g38
   g39
   g40
   g41
   g42
   generated-contract24
   g43
   g44
   g45
   generated-contract25
   generated-contract26
   g46
   g47
   g48
   generated-contract27)
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
    (letrec ((g37 exact-nonnegative-integer?)
             (g38 (or/c g37))
             (g39 (lambda (x) (automaton? x)))
             (g40 (vectorof g39))
             (g41 (or/c g40))
             (g42 (cons/c g41 g41))
             (generated-contract24 (-> g38 (values g42)))
             (g43 real?)
             (g44 '#f)
             (g45 (or/c g43 g44))
             (generated-contract25 (->* (g42 g38) (#:random g45) (values g42)))
             (generated-contract26 (-> g42 g38 (values g42)))
             (g46 nonnegative?)
             (g47 (or/c g46))
             (g48 (listof g47))
             (generated-contract27 (-> g42 (values g48))))
      (values
       g37
       g38
       g39
       g40
       g41
       g42
       generated-contract24
       g43
       g44
       g45
       generated-contract25
       generated-contract26
       g46
       g47
       g48
       generated-contract27))))
(require (only-in racket/contract contract-out))
(provide (contract-out (build-random-population generated-contract24))
          (contract-out (death-birth generated-contract25))
          (contract-out (match-up* generated-contract26))
          (contract-out (population-payoffs generated-contract27)))
(provide)
(: build-random-population (-> Natural Population))
(: population-payoffs (-> Population (Listof Payoff)))
(: match-up* (-> Population Natural Population))
(: death-birth (-> Population Natural (#:random (U False Real)) Population))
(require require-typed-check "automata-adapted.rkt")
(require "utilities.rkt")
(define DEF-COO 2)
(define (build-random-population n)
   (define v (build-vector n (lambda (_) (make-random-automaton DEF-COO))))
   (cons v v))
(define (population-payoffs population0)
   (define population (car population0))
   (for/list ((a population)) (automaton-payoff a)))
(define (match-up* population0 rounds-per-match)
   (define a* (car population0))
   (population-reset a*)
   (for
    ((i (in-range 0 (- (vector-length a*) 1) 2)))
    (define p1 (vector-ref a* i))
    (define p2 (vector-ref a* (+ i 1)))
    (define-values (a1 a2) (match-pair p1 p2 rounds-per-match))
    (vector-set! a* i a1)
    (vector-set! a* (+ i 1) a2))
   population0)
(: population-reset (-> Automaton* Void))
(define (population-reset a*)
   (for
    ((x (in-vector a*)) (i (in-naturals)))
    (vector-set! a* i (automaton-reset x))))
(define (death-birth population0 rate #:random (q #f))
   (match-define (cons a* b*) population0)
   (define payoffs
     (for/list
      :
      (Listof Payoff)
      ((x : Automaton (in-vector a*)))
      (automaton-payoff x)))
   (define substitutes (choose-randomly payoffs rate #:random q))
   (for
    ((i (in-range rate)) (p (in-list substitutes)))
    (vector-set! a* i (clone (vector-ref b* p))))
   (shuffle-vector a* b*))
(:
  shuffle-vector
  (All (X) (-> (Vectorof X) (Vectorof X) (cons (Vectorof X) (Vectorof X)))))
(define (shuffle-vector b a)
   (for ((x (in-vector b)) (i (in-naturals))) (vector-set! a i x))
   (for
    ((x (in-vector b)) (i (in-naturals)))
    (define j (random (add1 i)))
    (unless (= j i) (vector-set! a i (vector-ref a j)))
    (vector-set! a j x))
   (cons a b))
