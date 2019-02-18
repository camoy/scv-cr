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
(random-seed 7480)
(require require-typed-check "automata-adapted.rkt")
(require "population.rkt")
(require "utilities.rkt")
(define (main)
   (simulation->lines (evolve (build-random-population 300) 500 100 20))
   (void))
(: simulation->lines (-> (Listof Payoff) (Listof (List Integer Real))))
(define (simulation->lines data)
   (for/list
    :
    (Listof (List Integer Real))
    ((d : Payoff (in-list data)) (n : Integer (in-naturals)))
    (list n d)))
(: evolve (-> Population Natural Natural Natural (Listof Payoff)))
(define (evolve p c s r)
   (cond
    ((zero? c) '())
    (else
     (define p2 (match-up* p r))
     (define pp (population-payoffs p2))
     (define p3 (death-birth p2 s))
     ((inst cons Payoff (Listof Payoff))
      (cast (relative-average pp r) Payoff)
      (evolve p3 (- c 1) s r)))))
(time (main))
