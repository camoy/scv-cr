#lang typed/racket/base/no-check
(define-values
  (g8
   g9
   g10
   g11
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
    (letrec ((g8 (lambda (x) (card? x)))
             (g9 (listof g8))
             (g10 exact-nonnegative-integer?)
             (g11 (or/c g10))
             (generated-contract3 (-> g9 (values g11)))
             (generated-contract4 (-> g8 (values g9)))
             (generated-contract5 (-> g9 (values g11)))
             (generated-contract6 (-> g8 g9 (values g9)))
             (generated-contract7 (-> g9 (values g8))))
      (values
       g8
       g9
       g10
       g11
       generated-contract3
       generated-contract4
       generated-contract5
       generated-contract6
       generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (bulls generated-contract3))
          (contract-out (create-stack generated-contract4))
          (contract-out (length generated-contract5))
          (contract-out (push generated-contract6))
          (contract-out (top generated-contract7)))
(provide)
(require "card-adapted.rkt" "stack-types.rkt")
(require (prefix-in list: (only-in racket/base length)))
(require (only-in racket/list first))
(: create-stack (-> Card Stack))
(define (create-stack c) (list c))
(: top (-> Stack Card))
(define top first)
(: push (-> Card Stack Stack))
(define (push c s) ((inst cons Card Card) c s))
(: length (-> Stack Natural))
(define length list:length)
(: bulls (-> Stack Natural))
(define (bulls s) (foldr + 0 (map card-bulls s)))
