#lang typed/racket/no-check
(define-values
  (g12
   g13
   g14
   generated-contract4
   g15
   generated-contract5
   generated-contract6
   g16
   g17
   g18
   generated-contract7)
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
    (letrec ((g12 real?)
             (g13 (or/c g12))
             (g14 (lambda (x) (block? x)))
             (generated-contract4 (-> g13 g13 g14 (values g14)))
             (g15 (lambda (x) (posn? x)))
             (generated-contract5 (-> g15 g14 (values g14)))
             (generated-contract6 (-> g15 g14 (values g14)))
             (g16 '#t)
             (g17 '#f)
             (g18 (or/c g16 g17))
             (generated-contract7 (-> g14 g14 (values g18))))
      (values
       g12
       g13
       g14
       generated-contract4
       g15
       generated-contract5
       generated-contract6
       g16
       g17
       g18
       generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (block-move generated-contract4))
          (contract-out (block-rotate-ccw generated-contract5))
          (contract-out (block-rotate-cw generated-contract6))
          (contract-out (block=? generated-contract7)))
(require "base-types.rkt")
(require require-typed-check)
(require "data.rkt")
(: block=? (-> Block Block Boolean))
(define (block=? b1 b2)
   (and (= (block-x b1) (block-x b2)) (= (block-y b1) (block-y b2))))
(: block-move (-> Real Real Block Block))
(define (block-move dx dy b)
   (block (+ dx (block-x b)) (+ dy (block-y b)) (block-color b)))
(: block-rotate-ccw (-> Posn Block Block))
(define (block-rotate-ccw c b)
   (block
    (+ (posn-x c) (- (posn-y c) (block-y b)))
    (+ (posn-y c) (- (block-x b) (posn-x c)))
    (block-color b)))
(: block-rotate-cw (-> Posn Block Block))
(define (block-rotate-cw c b)
   (block-rotate-ccw c (block-rotate-ccw c (block-rotate-ccw c b))))
(provide)
