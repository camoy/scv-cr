#lang typed/racket/base/no-check
(define-values
  (g11
   g12
   generated-contract3
   generated-contract4
   generated-contract5
   generated-contract6
   generated-contract7
   generated-contract8
   generated-contract9
   g13
   g14
   g15
   g16
   g17
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
    (letrec ((g11 exact-nonnegative-integer?)
             (g12 (or/c g11))
             (generated-contract3 g12)
             (generated-contract4 g12)
             (generated-contract5 g12)
             (generated-contract6 g12)
             (generated-contract7 g12)
             (generated-contract8 g12)
             (generated-contract9 g12)
             (g13 symbol?)
             (g14 '())
             (g15 (cons/c g12 g14))
             (g16 (cons/c g13 g15))
             (g17 (listof g16))
             (generated-contract10 (-> (values g17))))
      (values
       g11
       g12
       generated-contract3
       generated-contract4
       generated-contract5
       generated-contract6
       generated-contract7
       generated-contract8
       generated-contract9
       g13
       g14
       g15
       g16
       g17
       generated-contract10))))
(require (only-in racket/contract contract-out))
(provide (contract-out (FACE generated-contract3))
          (contract-out (FIVE generated-contract4))
          (contract-out (HAND generated-contract5))
          (contract-out (MAX-BULL generated-contract6))
          (contract-out (MIN-BULL generated-contract7))
          (contract-out (SIXTYSIX generated-contract8))
          (contract-out (STACKS generated-contract9))
          (contract-out (configuration generated-contract10)))
(provide)
(require "basics-types.rkt")
(define FACE : Natural 104)
(define HAND : Natural 10)
(define SIXTYSIX : Natural 66)
(define STACKS : Natural 4)
(define FIVE : Natural 5)
(define MAX-BULL : Bulls 7)
(define MIN-BULL : Bulls 2)
(: configuration (-> (Listof (List Symbol Natural))))
(define (configuration)
   `((FACE ,FACE)
     (HAND ,HAND)
     (SIXTSIX ,SIXTYSIX)
     (STACKS ,STACKS)
     (FIVE ,FIVE)
     (MAX_BULL ,MAX-BULL)
     (MIN_BULL ,MIN-BULL)))
