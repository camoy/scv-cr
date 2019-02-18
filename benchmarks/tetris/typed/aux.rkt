#lang typed/racket/no-check
(define-values
  (g11
   g12
   generated-contract4
   g13
   generated-contract5
   g14
   g15
   g16
   g17
   g18
   g19
   g20
   g21
   generated-contract6)
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
    (letrec ((g11 (lambda (x) (tetra? x)))
             (g12 (listof g11))
             (generated-contract4 (-> g12 (values g11)))
             (g13 (and/c fixnum? negative?))
             (generated-contract5 g13)
             (g14 '())
             (g15 (cons/c g11 g14))
             (g16 (cons/c g11 g15))
             (g17 (cons/c g11 g16))
             (g18 (cons/c g11 g17))
             (g19 (cons/c g11 g18))
             (g20 (cons/c g11 g19))
             (g21 (cons/c g11 g20))
             (generated-contract6 g21))
      (values
       g11
       g12
       generated-contract4
       g13
       generated-contract5
       g14
       g15
       g16
       g17
       g18
       g19
       g20
       g21
       generated-contract6))))
(require (only-in racket/contract contract-out))
(provide (contract-out (list-pick-random generated-contract4))
          (contract-out (neg-1 generated-contract5))
          (contract-out (tetras generated-contract6)))
(require "base-types.rkt")
(require require-typed-check)
(require "tetras.rkt")
(provide)
(define r (make-pseudo-random-generator))
(parameterize ((current-pseudo-random-generator r)) (random-seed 43453))
(: list-pick-random (-> (Listof Tetra) Tetra))
(define (list-pick-random ls) (list-ref ls (random (length ls) r)))
(define neg-1 -1)
(define tetras
   (list
    (build-tetra-blocks 'green 1/2 -3/2 0 -1 0 -2 1 -1 1 -2)
    (build-tetra-blocks 'blue 1 -1 0 -1 1 -1 2 -1 3 -1)
    (build-tetra-blocks 'purple 1 -1 0 -1 1 -1 2 -1 2 -2)
    (build-tetra-blocks 'cyan 1 -1 0 -1 1 -1 2 -1 0 -2)
    (build-tetra-blocks 'orange 1 -1 0 -1 1 -1 2 -1 1 -2)
    (build-tetra-blocks 'red 1 -1 0 -1 1 -1 1 -2 2 -2)
    (build-tetra-blocks 'pink 1 -1 0 -2 1 -2 1 -1 2 -1)))
