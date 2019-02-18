#lang typed/racket/base/no-check
(define-values
  (g10
   g11
   g12
   generated-contract3
   generated-contract4
   generated-contract5
   generated-contract6
   generated-contract7
   generated-contract8
   generated-contract9)
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
    (letrec ((g10 exact-integer?)
             (g11 (or/c g10))
             (g12 (listof g11))
             (generated-contract3 (-> g12 (values g12)))
             (generated-contract4 (-> g12 (values g12)))
             (generated-contract5 (-> (values g12)))
             (generated-contract6 (-> g12 (values g12)))
             (generated-contract7 (-> g12 (values g11 g12)))
             (generated-contract8 (-> g12 g11 (values g12)))
             (generated-contract9 (-> g12 (values g12))))
      (values
       g10
       g11
       g12
       generated-contract3
       generated-contract4
       generated-contract5
       generated-contract6
       generated-contract7
       generated-contract8
       generated-contract9))))
(require (only-in racket/contract contract-out))
(provide (contract-out (stack-drop generated-contract3))
          (contract-out (stack-dup generated-contract4))
          (contract-out (stack-init generated-contract5))
          (contract-out (stack-over generated-contract6))
          (contract-out (stack-pop generated-contract7))
          (contract-out (stack-push generated-contract8))
          (contract-out (stack-swap generated-contract9)))
(provide)
(define-type Stack (Listof Integer))
(: list->stack (-> (Listof Integer) Stack))
(define (list->stack xs)
   (for/fold
    ((S : Stack (stack-init)))
    ((x : Integer (in-list (reverse xs))))
    (stack-push S x)))
(: stack-drop (-> Stack Stack))
(define (stack-drop S) (let-values (((_v S+) (stack-pop S))) S+))
(: stack-dup (-> Stack Stack))
(define (stack-dup S)
   (let-values (((v S+) (stack-pop S))) (stack-push (stack-push S+ v) v)))
(: stack-init (-> Stack))
(define (stack-init) '())
(: stack-over (-> Stack Stack))
(define (stack-over S)
   (let*-values (((v1 S1) (stack-pop S)) ((v2 S2) (stack-pop S1)))
     (stack-push (stack-push (stack-push S2 v1) v2) v1)))
(: stack-pop (-> Stack (Values Integer Stack)))
(define (stack-pop S)
   (if (null? S) (raise-user-error "empty stack") (values (car S) (cdr S))))
(: stack-push (-> Stack Integer Stack))
(define (stack-push S v) (cons v S))
(: stack-swap (-> Stack Stack))
(define (stack-swap S)
   (let*-values (((v1 S1) (stack-pop S)) ((v2 S2) (stack-pop S1)))
     (stack-push (stack-push S2 v1) v2)))
