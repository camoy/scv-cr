#lang typed/racket/no-check
(define-values
  (g8
   g9
   generated-contract3
   g10
   g11
   generated-contract4
   generated-contract5
   generated-contract6
   g12
   generated-contract7)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g8 (and/c byte? positive?))
             (g9 (or/c g8))
             (generated-contract3 g9)
             (g10 (and/c fixnum? positive?))
             (g11 (or/c g10))
             (generated-contract4 (-> (values g11)))
             (generated-contract5 g9)
             (generated-contract6 g9)
             (g12 (lambda (x) (world? x)))
             (generated-contract7 (-> (values g12))))
      (values
       g8
       g9
       generated-contract3
       g10
       g11
       generated-contract4
       generated-contract5
       generated-contract6
       g12
       generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (BOARD-HEIGHT generated-contract3))
          (contract-out (BOARD-HEIGHT-PIXELS generated-contract4))
          (contract-out (BOARD-WIDTH generated-contract5))
          (contract-out (GRID-SIZE generated-contract6))
          (contract-out (WORLD generated-contract7)))
(require "data-adaptor.rkt")
(define GRID-SIZE 30)
(define BOARD-HEIGHT 20)
(define BOARD-WIDTH 30)
(define (BOARD-HEIGHT-PIXELS) (* GRID-SIZE BOARD-HEIGHT))
(define (BOARD-WIDTH-PIXELS) (* GRID-SIZE BOARD-WIDTH))
(define (SEGMENT-RADIUS) (/ GRID-SIZE 2))
(define (FOOD-RADIUS) (SEGMENT-RADIUS))
(define (WORLD) (world (snake "right" (cons (posn 5 3) empty)) (posn 8 12)))
(provide)
