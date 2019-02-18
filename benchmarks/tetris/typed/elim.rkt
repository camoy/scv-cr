#lang typed/racket/no-check
(define-values
  (g20 g21 generated-contract8)
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
    (letrec ((g20 (lambda (x) (block? x)))
             (g21 (listof g20))
             (generated-contract8 (-> g21 (values g21))))
      (values g20 g21 generated-contract8))))
(require (only-in racket/contract contract-out))
(provide (contract-out (eliminate-full-rows generated-contract8)))
(require "base-types.rkt")
(require require-typed-check)
(require "bset.rkt")
(require "consts.rkt")
(: eliminate-full-rows (-> BSet BSet))
(define (eliminate-full-rows bs) (elim-row bs board-height 0))
(: elim-row (-> BSet Integer Integer BSet))
(define (elim-row bs i offset)
   (cond
    ((< i 0) empty)
    ((full-row? bs i) (elim-row bs (sub1 i) (add1 offset)))
    (else
     (blocks-union
      (elim-row bs (sub1 i) offset)
      (blocks-move 0 offset (blocks-row bs i))))))
(provide)
