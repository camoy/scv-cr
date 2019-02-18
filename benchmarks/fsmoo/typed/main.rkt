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
(require "automata-adapted.rkt" "population-adapted.rkt" require-typed-check)
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
(: evolve (-> oPopulation Natural Natural Natural (Listof Payoff)))
(define (evolve p c s r)
   (let evolve ((c : Natural c) (s : Natural s) (r : Natural r))
     (cond
      ((zero? c) '())
      (else
       (send p match-up* r)
       (define pp (send p payoffs))
       (send p death-birth s)
       ((inst cons Payoff (Listof Payoff))
        (cast (relative-average pp r) Payoff)
        (evolve (- c 1) s r))))))
(time (main))
