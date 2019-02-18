#lang typed/racket/base/no-check
(define-values
  (g17
   g18
   g19
   generated-contract5
   g20
   g21
   g22
   generated-contract6
   generated-contract12
   g23
   generated-contract7
   g24
   g25
   g26
   g27
   generated-contract8
   generated-contract9
   generated-contract10)
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
    (letrec ((g17 (lambda (x) (card? x)))
             (g18 exact-nonnegative-integer?)
             (g19 (or/c g18))
             (generated-contract5 (-> g17 g17 (values g19)))
             (g20 '#t)
             (g21 '#f)
             (g22 (or/c g20 g21))
             (generated-contract6 (-> g17 g17 (values g22)))
             (generated-contract12 (-> g19 g19 (values g17)))
             (g23 (λ (_) #f))
             (generated-contract7 g23)
             (g24 (λ (_) #f))
             (g25 any/c)
             (g26 (-> g25 (values g22)))
             (g27 (or/c g24 g26))
             (generated-contract8 g27)
             (generated-contract9 (-> g17 (values g19)))
             (generated-contract10 (-> g17 (values g19))))
      (values
       g17
       g18
       g19
       generated-contract5
       g20
       g21
       g22
       generated-contract6
       generated-contract12
       g23
       generated-contract7
       g24
       g25
       g26
       g27
       generated-contract8
       generated-contract9
       generated-contract10))))
(require (only-in racket/contract contract-out))
(provide (contract-out (--face generated-contract5))
          (contract-out (>-face generated-contract6))
          (contract-out (struct card ((face g19) (bulls g19)))))
(provide)
(require "basics-types.rkt")
(struct card ((face : Face) (bulls : Bulls)) #:transparent)
(define-type Card card)
(: >-face (-> Card Card Boolean))
(define (>-face c d) (> (card-face c) (card-face d)))
(: --face (-> Card Card Face))
(define (--face c d) (cast (- (card-face c) (card-face d)) Face))
