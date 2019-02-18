#lang typed/racket/base/no-check
(define-values
  (g7
   g8
   g9
   g10
   generated-contract3
   g11
   g12
   g13
   generated-contract4
   g14
   generated-contract5
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
    (letrec ((g7 symbol?)
             (g8 (listof g7))
             (g9 (lambda (x) (Binding? x)))
             (g10 (-> g7 (values g9)))
             (generated-contract3 (-> g8 (values g10)))
             (g11 exact-nonnegative-integer?)
             (g12 (or/c g11))
             (g13 (parameter/c g12 g12))
             (generated-contract4 g13)
             (g14 (lambda (x) (Stx? x)))
             (generated-contract5 (-> g14 g8 (values g8)))
             (generated-contract6 g8))
      (values
       g7
       g8
       g9
       g10
       generated-contract3
       g11
       g12
       g13
       generated-contract4
       g14
       generated-contract5
       generated-contract6))))
(require (only-in racket/contract contract-out))
(provide (contract-out (alloc generated-contract3))
          (contract-out (k generated-contract4))
          (contract-out (tick generated-contract5))
          (contract-out (time-zero generated-contract6)))
(require "structs-adapted.rkt" "benv-adapted.rkt")
(provide)
(define-type Value Closure)
(: take* (All (A) (-> (Listof A) Natural (Listof A))))
(define (take* l n) (for/list ((e (in-list l)) (i (in-range n))) e))
(: time-zero Time)
(define time-zero '())
(: k (Parameterof Natural))
(define k (make-parameter 1))
(: tick (-> Stx Time Time))
(define (tick call time)
   (define label (Stx-label call))
   (take* (cons label time) (k)))
(: alloc (-> Time (-> Var Addr)))
(define ((alloc time) var) (Binding var time))
