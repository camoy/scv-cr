#lang typed/racket/base/no-check
(define-values
  (g27
   generated-contract6
   g28
   g29
   g30
   g31
   g32
   g33
   g34
   generated-contract7
   g35
   g36
   g37
   generated-contract8
   generated-contract9
   g38
   g39
   g40
   g41
   g42
   generated-contract10
   generated-contract11
   generated-contract12
   g43
   g44
   generated-contract13
   g45
   generated-contract14
   generated-contract15
   generated-contract16
   g46
   generated-contract17
   generated-contract18
   generated-contract19
   generated-contract20
   generated-contract21
   generated-contract22
   generated-contract23
   generated-contract24
   generated-contract25
   g47
   generated-contract26)
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
    (letrec ((g27 (λ (_) #f))
             (generated-contract6 g27)
             (g28 (λ (_) #f))
             (g29 any/c)
             (g30 '#t)
             (g31 '#f)
             (g32 (or/c g30 g31))
             (g33 (-> g29 (values g32)))
             (g34 (or/c g28 g33))
             (generated-contract7 g34)
             (g35 (lambda (x) (label? x)))
             (g36 exact-nonnegative-integer?)
             (g37 (or/c g36))
             (generated-contract8 (-> g35 (values g37)))
             (generated-contract9 (-> g35 (values g37)))
             (g38 symbol?)
             (g39 char?)
             (g40 (or/c g38 g39))
             (g41 (vectorof g40))
             (g42 (or/c g41))
             (generated-contract10 (-> g35 (values g42)))
             (generated-contract11 g27)
             (generated-contract12 g34)
             (g43 (lambda (x) (node? x)))
             (g44 (or/c g31 g43))
             (generated-contract13 (-> g43 (values g44)))
             (g45 (listof g43))
             (generated-contract14 (-> g43 (values g45)))
             (generated-contract15 (-> g43 (values g44)))
             (generated-contract16 (-> g43 (values g35)))
             (g46 (lambda (x) (equal? x (void))))
             (generated-contract17 (-> g35 g42 (values g46)))
             (generated-contract18 (-> g35 g37 (values g46)))
             (generated-contract19 (-> g35 g37 (values g46)))
             (generated-contract20 (-> g43 g45 (values g46)))
             (generated-contract21 (-> g43 g44 (values g46)))
             (generated-contract22 (-> g43 g44 (values g46)))
             (generated-contract23 (-> g43 g35 (values g46)))
             (generated-contract24 g27)
             (generated-contract25 g34)
             (g47 (lambda (x) (suffix-tree? x)))
             (generated-contract26 (-> g47 (values g43))))
      (values
       g27
       generated-contract6
       g28
       g29
       g30
       g31
       g32
       g33
       g34
       generated-contract7
       g35
       g36
       g37
       generated-contract8
       generated-contract9
       g38
       g39
       g40
       g41
       g42
       generated-contract10
       generated-contract11
       generated-contract12
       g43
       g44
       generated-contract13
       g45
       generated-contract14
       generated-contract15
       generated-contract16
       g46
       generated-contract17
       generated-contract18
       generated-contract19
       generated-contract20
       generated-contract21
       generated-contract22
       generated-contract23
       generated-contract24
       generated-contract25
       g47
       generated-contract26))))
(require (only-in racket/contract contract-out))
(provide)
(provide (struct-out label) (struct-out suffix-tree) (struct-out node))
(define-struct
  label
  ((datum : (Vectorof (U Char Symbol))) (i : Natural) (j : Natural))
  #:mutable)
(define-struct suffix-tree ((root : node)))
(define-struct
  node
  ((up-label : label)
   (parent : (U #f node))
   (children : (Listof node))
   (suffix-link : (U #f node)))
  #:mutable)
