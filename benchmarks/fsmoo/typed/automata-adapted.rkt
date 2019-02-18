#lang typed/racket/no-check
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
(provide Automaton oAutomaton Payoff make-random-automaton)
(require require-typed-check)
(require "automata.rkt")
(define-type Payoff Nonnegative-Real)
(define-type Transition* (Vectorof (Vectorof State)))
(define-type State Natural)
(define-type Input Natural)
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
