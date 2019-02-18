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
(define-type Probability Nonnegative-Real)
(define-type Population (cons Automaton* Automaton*))
(define-type Automaton* (Vectorof Automaton))
(define-type Payoff Nonnegative-Real)
(define-type State Natural)
(define-type Transition* (Vectorof Transition))
(define-type Transition (Vectorof State))
(require "benchmark-util.rkt")
(require "automata.rkt")
(provide defects
          cooperates
          tit-for-tat
          grim-trigger
          match-pair
          automaton-reset
          clone
          make-random-automaton
          automaton-payoff
          Automaton
          Probability
          Population
          Automaton*
          Payoff)
