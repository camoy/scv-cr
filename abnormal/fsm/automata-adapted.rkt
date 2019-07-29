#lang typed/racket/base/no-check
(require racket/contract)
(module require/contracts racket/base (require racket/contract) (provide))
(require (prefix-in -: (only-in 'require/contracts))
          (except-in 'require/contracts))
(define-values () (values))
(define-type Probability Nonnegative-Real)
(define-type Population (cons Automaton* Automaton*))
(define-type Automaton* (Vectorof Automaton))
(define-type Payoff Nonnegative-Real)
(define-type State Natural)
(define-type Transition* (Vectorof Transition))
(define-type Transition (Vectorof State))
(require "benchmark-util.rkt")
(require "automata.rkt")
(void)
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
(provide)
