#lang typed/racket/base/no-check
(define-values
  (g33
   g34
   g35
   g36
   g37
   g38
   g39
   generated-contract12
   generated-contract13
   g40
   generated-contract14
   g41
   g42
   g43
   g44
   g45
   generated-contract15
   g46
   generated-contract16
   g47
   g48
   generated-contract17)
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
    (letrec ((g33 (lambda (x) (Call? x)))
             (g34 (lambda (x) (exp? x)))
             (g35 (or/c g33 g34))
             (g36 symbol?)
             (g37 (set/c g35))
             (g38 (typed-racket-hash/c g36 g37))
             (g39 (or/c g38))
             (generated-contract12 (-> g35 (values g39)))
             (generated-contract13 g39)
             (g40 string?)
             (generated-contract14 (-> g39 (values g40)))
             (g41 (lambda (x) (Binding? x)))
             (g42 (lambda (x) (Closure? x)))
             (g43 (set/c g42))
             (g44 (typed-racket-hash/c g41 g43))
             (g45 (or/c g44))
             (generated-contract15 (-> g45 (values g39)))
             (g46 (lambda (x) (Lam? x)))
             (generated-contract16 (-> g42 (values g46)))
             (g47 (lambda (x) (State? x)))
             (g48 (set/c g47))
             (generated-contract17 (-> g48 (values g45))))
      (values
       g33
       g34
       g35
       g36
       g37
       g38
       g39
       generated-contract12
       generated-contract13
       g40
       generated-contract14
       g41
       g42
       g43
       g44
       g45
       generated-contract15
       g46
       generated-contract16
       g47
       g48
       generated-contract17))))
(require (only-in racket/contract contract-out))
(provide (contract-out (analyze generated-contract12))
          (contract-out (empty-mono-store generated-contract13))
          (contract-out (format-mono-store generated-contract14))
          (contract-out (monovariant-store generated-contract15))
          (contract-out (monovariant-value generated-contract16))
          (contract-out (summarize generated-contract17)))
(require require-typed-check
          racket/set
          "structs-adapted.rkt"
          "benv-adapted.rkt"
          "denotable-adapted.rkt"
          "time-adapted.rkt"
          (only-in racket/string string-join))
(require "ai.rkt")
(provide)
(define-type MonoStore (HashTable Var (Setof Exp)))
(: summarize (-> (Setof State) Store))
(define (summarize states)
   (for/fold
    ((store empty-store))
    ((state (in-set states)))
    (store-join (State-store state) store)))
(: empty-mono-store MonoStore)
(define empty-mono-store (make-immutable-hasheq '()))
(: monovariant-value (-> Value Lam))
(define (monovariant-value v) (Closure-lam v))
(: monovariant-store (-> Store MonoStore))
(define (monovariant-store store)
   (: update-lam (-> (Setof Value) (-> (Setof Exp) (Setof Exp))))
   (define ((update-lam vs) b-vs)
     (: v-vs (Setof Lam))
     (define v-vs (list->set (set-map vs monovariant-value)))
     (set-union b-vs v-vs))
   (: default-lam (-> (Setof Exp)))
   (define (default-lam) (set))
   (for/fold
    ((mono-store empty-mono-store))
    (((b vs) (in-hash store)))
    (hash-update mono-store (Binding-var b) (update-lam vs) default-lam)))
(: analyze (-> Exp MonoStore))
(define (analyze exp)
   (define init-state (State exp empty-benv empty-store time-zero))
   (define states (explore (set) (list init-state)))
   (define summary (summarize states))
   (define mono-store (monovariant-store summary))
   mono-store)
(: format-mono-store (-> MonoStore String))
(define (format-mono-store ms)
   (: res (Listof String))
   (define res
     (for/list
      (((i vs) (in-hash ms)))
      (format
       "~a:\n~a"
       i
       (string-join
        (for/list : (Listof String) ((v (in-set vs))) (format "\t~S" v))
        "\n"))))
   (string-join res "\n"))
