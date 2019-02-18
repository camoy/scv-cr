#lang typed/racket/base/no-check
(define-values
  (g20
   g21
   g22
   g23
   g24
   g25
   g26
   g27
   g28
   g29
   g30
   g31
   g32
   generated-contract12
   g33
   generated-contract5
   g34
   g35
   g36
   g37
   g38
   g39
   g40
   generated-contract6
   generated-contract7
   generated-contract8
   generated-contract9
   generated-contract10
   generated-contract13
   generated-contract14
   generated-contract15
   generated-contract16
   generated-contract17
   generated-contract18
   g41
   g42
   generated-contract19)
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
    (letrec ((g20 (lambda (x) (exp? x)))
             (g21 (lambda (x) (Call? x)))
             (g22 (or/c g20 g21))
             (g23 symbol?)
             (g24 (lambda (x) (Binding? x)))
             (g25 (typed-racket-hash/c g23 g24))
             (g26 (or/c g25))
             (g27 (lambda (x) (Closure? x)))
             (g28 (set/c g27))
             (g29 (typed-racket-hash/c g24 g28))
             (g30 (or/c g29))
             (g31 (listof g23))
             (g32 (lambda (x) (State? x)))
             (generated-contract12 (-> g22 g26 g30 g31 (values g32)))
             (g33 (λ (_) #f))
             (generated-contract5 g33)
             (g34 (λ (_) #f))
             (g35 any/c)
             (g36 '#t)
             (g37 '#f)
             (g38 (or/c g36 g37))
             (g39 (-> g35 (values g38)))
             (g40 (or/c g34 g39))
             (generated-contract6 g40)
             (generated-contract7 (-> g32 (values g31)))
             (generated-contract8 (-> g32 (values g30)))
             (generated-contract9 (-> g32 (values g26)))
             (generated-contract10 (-> g32 (values g22)))
             (generated-contract13 g28)
             (generated-contract14 (-> g28 g28 (values g28)))
             (generated-contract15 g30)
             (generated-contract16 (-> g30 g30 (values g30)))
             (generated-contract17 (-> g30 g24 (values g28)))
             (generated-contract18 (-> g30 g24 g28 (values g30)))
             (g41 (listof g24))
             (g42 (listof g28))
             (generated-contract19 (-> g30 g41 g42 (values g30))))
      (values
       g20
       g21
       g22
       g23
       g24
       g25
       g26
       g27
       g28
       g29
       g30
       g31
       g32
       generated-contract12
       g33
       generated-contract5
       g34
       g35
       g36
       g37
       g38
       g39
       g40
       generated-contract6
       generated-contract7
       generated-contract8
       generated-contract9
       generated-contract10
       generated-contract13
       generated-contract14
       generated-contract15
       generated-contract16
       generated-contract17
       generated-contract18
       g41
       g42
       generated-contract19))))
(require (only-in racket/contract contract-out))
(provide (contract-out
           (struct State ((call g22) (benv g26) (store g30) (time g31))))
          (contract-out (d-bot generated-contract13))
          (contract-out (d-join generated-contract14))
          (contract-out (empty-store generated-contract15))
          (contract-out (store-join generated-contract16))
          (contract-out (store-lookup generated-contract17))
          (contract-out (store-update generated-contract18))
          (contract-out (store-update* generated-contract19)))
(require require-typed-check
          racket/set
          "structs-adapted.rkt"
          "benv-adapted.rkt"
          "time-adapted.rkt")
(provide)
(define-type Denotable (Setof Value))
(define-type Store (HashTable Addr Denotable))
(struct State ((call : Exp) (benv : BEnv) (store : Store) (time : Time)))
(: d-bot Denotable)
(define d-bot (set))
(: d-join (-> Denotable Denotable Denotable))
(define d-join set-union)
(: empty-store Store)
(define empty-store (make-immutable-hasheq '()))
(: store-lookup (-> Store Addr Denotable))
(define (store-lookup s a) (hash-ref s a (lambda () d-bot)))
(: store-update (-> Store Addr Denotable Store))
(define (store-update store addr value)
   (: update-lam (-> Denotable Denotable))
   (define (update-lam d) (d-join d value))
   (hash-update store addr update-lam (lambda () d-bot)))
(: store-update* (-> Store (Listof Addr) (Listof Denotable) Store))
(define (store-update* s as vs)
   (for/fold
    ((store s))
    ((a (in-list as)) (v (in-list vs)))
    (store-update store a v)))
(: store-join (-> Store Store Store))
(define (store-join s1 s2)
   (for/fold
    ((new-store s1))
    (((k v) (in-hash s2)))
    (store-update new-store k v)))
