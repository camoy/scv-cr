#lang typed/racket/base/no-check
(define-values
  (g8
   g9
   generated-contract3
   generated-contract4
   generated-contract5
   generated-contract6
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
    (letrec ((g8 real?)
             (g9 (or/c g8))
             (generated-contract3 (-> g9 (values g9)))
             (generated-contract4 (-> g9 g9 (values g9)))
             (generated-contract5 (-> g9 g9 (values g9)))
             (generated-contract6 (-> g9 (values g9)))
             (generated-contract7 (-> g9 (values g9))))
      (values
       g8
       g9
       generated-contract3
       generated-contract4
       generated-contract5
       generated-contract6
       generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (abs generated-contract3))
          (contract-out (max generated-contract4))
          (contract-out (min generated-contract5))
          (contract-out (msqrt generated-contract6))
          (contract-out (sqr generated-contract7)))
(provide sqrt)
(: min (-> Real Real Real))
(define (min x y) (if (<= x y) x y))
(: max (-> Real Real Real))
(define (max x y) (if (>= x y) x y))
(: abs (-> Real Real))
(define (abs x) (if (>= x 0) x (- 0 x)))
(: sqr (-> Real Real))
(define (sqr x) (* x x))
(: msqrt (-> Real Real))
(define (msqrt x) (assert (sqrt x) real?))
