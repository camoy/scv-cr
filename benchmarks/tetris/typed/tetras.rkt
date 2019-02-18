#lang typed/racket/no-check
(define-values
  (g20
   g21
   g22
   g23
   generated-contract8
   generated-contract9
   generated-contract10
   g24
   g25
   g26
   g27
   g28
   generated-contract11
   generated-contract12
   generated-contract13)
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
    (letrec ((g20 symbol?)
             (g21 real?)
             (g22 (or/c g21))
             (g23 (lambda (x) (tetra? x)))
             (generated-contract8
              (-> g20 g22 g22 g22 g22 g22 g22 g22 g22 g22 g22 (values g23)))
             (generated-contract9 (-> g23 g20 (values g23)))
             (generated-contract10 (-> g22 g22 g23 (values g23)))
             (g24 (lambda (x) (block? x)))
             (g25 (listof g24))
             (g26 '#t)
             (g27 '#f)
             (g28 (or/c g26 g27))
             (generated-contract11 (-> g23 g25 (values g28)))
             (generated-contract12 (-> g23 (values g23)))
             (generated-contract13 (-> g23 (values g23))))
      (values
       g20
       g21
       g22
       g23
       generated-contract8
       generated-contract9
       generated-contract10
       g24
       g25
       g26
       g27
       g28
       generated-contract11
       generated-contract12
       generated-contract13))))
(require (only-in racket/contract contract-out))
(provide (contract-out (build-tetra-blocks generated-contract8))
          (contract-out (tetra-change-color generated-contract9))
          (contract-out (tetra-move generated-contract10))
          (contract-out (tetra-overlaps-blocks? generated-contract11))
          (contract-out (tetra-rotate-ccw generated-contract12))
          (contract-out (tetra-rotate-cw generated-contract13)))
(require "base-types.rkt")
(require require-typed-check)
(require "bset.rkt")
(: tetra-move (-> Real Real Tetra Tetra))
(define (tetra-move dx dy t)
   (tetra
    (posn (+ dx (posn-x (tetra-center t))) (+ dy (posn-y (tetra-center t))))
    (blocks-move dx dy (tetra-blocks t))))
(: tetra-rotate-ccw (-> Tetra Tetra))
(define (tetra-rotate-ccw t)
   (tetra
    (tetra-center t)
    (blocks-rotate-ccw (tetra-center t) (tetra-blocks t))))
(: tetra-rotate-cw (-> Tetra Tetra))
(define (tetra-rotate-cw t)
   (tetra
    (tetra-center t)
    (blocks-rotate-cw (tetra-center t) (tetra-blocks t))))
(: tetra-overlaps-blocks? (-> Tetra BSet Boolean))
(define (tetra-overlaps-blocks? t bs)
   (not (empty? (blocks-intersect (tetra-blocks t) bs))))
(: tetra-change-color (-> Tetra Color Tetra))
(define (tetra-change-color t c)
   (tetra (tetra-center t) (blocks-change-color (tetra-blocks t) c)))
(:
  build-tetra-blocks
  (-> Color Real Real Real Real Real Real Real Real Real Real Tetra))
(define (build-tetra-blocks color xc yc x1 y1 x2 y2 x3 y3 x4 y4)
   (tetra-move
    3
    0
    (tetra
     (posn xc yc)
     (list
      (block x1 y1 color)
      (block x2 y2 color)
      (block x3 y3 color)
      (block x4 y4 color)))))
(provide)
