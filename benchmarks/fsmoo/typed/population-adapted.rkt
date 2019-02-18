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
(provide oPopulation build-random-population)
(require "automata-adapted.rkt" require-typed-check)
(require "population.rkt")
(define-type Automaton* (Vectorof oAutomaton))
(define-type oPopulation (Instance Population))
(define-type
  Population
  (Class
   (init-field (a* Automaton*) (b* Automaton* #:optional))
   (payoffs (-> (Listof Payoff)))
   (match-up* (-> Natural Void))
   (death-birth (-> Natural (#:random (U False Payoff)) Void))))
