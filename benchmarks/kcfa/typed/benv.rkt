#lang typed/racket/base/no-check
(define-values
  (g23
   g24
   g25
   generated-contract12
   g26
   generated-contract7
   g27
   g28
   g29
   g30
   g31
   g32
   g33
   generated-contract8
   generated-contract9
   generated-contract10
   g34
   g35
   g36
   g37
   generated-contract18
   generated-contract13
   generated-contract14
   generated-contract15
   generated-contract16
   generated-contract19
   g38
   generated-contract20
   generated-contract21
   generated-contract22)
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
    (letrec ((g23 symbol?)
             (g24 (listof g23))
             (g25 (lambda (x) (Binding? x)))
             (generated-contract12 (-> g23 g24 (values g25)))
             (g26 (λ (_) #f))
             (generated-contract7 g26)
             (g27 (λ (_) #f))
             (g28 any/c)
             (g29 '#t)
             (g30 '#f)
             (g31 (or/c g29 g30))
             (g32 (-> g28 (values g31)))
             (g33 (or/c g27 g32))
             (generated-contract8 g33)
             (generated-contract9 (-> g25 (values g24)))
             (generated-contract10 (-> g25 (values g23)))
             (g34 (lambda (x) (Lam? x)))
             (g35 (typed-racket-hash/c g23 g25))
             (g36 (or/c g35))
             (g37 (lambda (x) (Closure? x)))
             (generated-contract18 (-> g34 g36 (values g37)))
             (generated-contract13 g26)
             (generated-contract14 g33)
             (generated-contract15 (-> g37 (values g36)))
             (generated-contract16 (-> g37 (values g34)))
             (generated-contract19 (-> g36 g23 g25 (values g36)))
             (g38 (listof g25))
             (generated-contract20 (-> g36 g24 g38 (values g36)))
             (generated-contract21 (-> g36 g23 (values g25)))
             (generated-contract22 g36))
      (values
       g23
       g24
       g25
       generated-contract12
       g26
       generated-contract7
       g27
       g28
       g29
       g30
       g31
       g32
       g33
       generated-contract8
       generated-contract9
       generated-contract10
       g34
       g35
       g36
       g37
       generated-contract18
       generated-contract13
       generated-contract14
       generated-contract15
       generated-contract16
       generated-contract19
       g38
       generated-contract20
       generated-contract21
       generated-contract22))))
(require (only-in racket/contract contract-out))
(provide (contract-out (struct Binding ((var g23) (time g24))))
          (contract-out (struct Closure ((lam g34) (benv g36))))
          (contract-out (benv-extend generated-contract19))
          (contract-out (benv-extend* generated-contract20))
          (contract-out (benv-lookup generated-contract21))
          (contract-out (empty-benv generated-contract22)))
(require "structs-adapted.rkt")
(provide)
(define-type BEnv (HashTable Var Addr))
(define-type Addr Binding)
(define-type Time (Listof Label))
(struct Closure ((lam : Lam) (benv : BEnv)))
(struct Binding ((var : Var) (time : Time)))
(: empty-benv BEnv)
(define empty-benv (make-immutable-hasheq '()))
(: benv-lookup (-> BEnv Var Addr))
(define benv-lookup hash-ref)
(: benv-extend (-> BEnv Var Addr BEnv))
(define benv-extend hash-set)
(: benv-extend* (-> BEnv (Listof Var) (Listof Addr) BEnv))
(define (benv-extend* benv vars addrs)
   (for/fold
    ((benv benv))
    ((v (in-list vars)) (a (in-list addrs)))
    (benv-extend benv v a)))
