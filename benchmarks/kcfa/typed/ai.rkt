#lang typed/racket/base/no-check
(define-values
  (g55
   g56
   g57
   g58
   g59
   g60
   g61
   g62
   g63
   g64
   g65
   g66
   generated-contract52
   g67
   g68
   g69
   generated-contract53
   generated-contract54)
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
    (letrec ((g55 symbol?)
             (g56 (lambda (x) (Binding? x)))
             (g57 (typed-racket-hash/c g55 g56))
             (g58 (or/c g57))
             (g59 (lambda (x) (Closure? x)))
             (g60 (set/c g59))
             (g61 (typed-racket-hash/c g56 g60))
             (g62 (or/c g61))
             (g63 (lambda (x) (exp? x)))
             (g64 (lambda (x) (Call? x)))
             (g65 (or/c g63 g64))
             (g66 (-> g65 (values g60)))
             (generated-contract52 (-> g58 g62 (values g66)))
             (g67 (lambda (x) (State? x)))
             (g68 (set/c g67))
             (g69 (listof g67))
             (generated-contract53 (-> g68 g69 (values g68)))
             (generated-contract54 (-> g67 (values g68))))
      (values
       g55
       g56
       g57
       g58
       g59
       g60
       g61
       g62
       g63
       g64
       g65
       g66
       generated-contract52
       g67
       g68
       g69
       generated-contract53
       generated-contract54))))
(require (only-in racket/contract contract-out))
(provide (contract-out (atom-eval generated-contract52))
          (contract-out (explore generated-contract53))
          (contract-out (next generated-contract54)))
(require "structs-adapted.rkt"
          "benv-adapted.rkt"
          "time-adapted.rkt"
          "denotable-adapted.rkt"
          racket/set
          (only-in racket/match match-define))
(provide)
(: atom-eval (-> BEnv Store (-> Exp Denotable)))
(define ((atom-eval benv store) id)
   (cond
    ((Ref? id) (store-lookup store (benv-lookup benv (Ref-var id))))
    ((Lam? id) (set (Closure id benv)))
    (else (error "atom-eval got a plain Exp"))))
(: next (-> State (Setof State)))
(define (next st)
   (match-define (State c benv store time) st)
   (cond
    ((Call? c)
     (define time* (tick c time))
     (match-define (Call _ f args) c)
     (: procs Denotable)
     (define procs ((atom-eval benv store) f))
     (: params (Listof Denotable))
     (define params (map (atom-eval benv store) args))
     (: new-states (Listof State))
     (define new-states
       (for/list
        ((proc : Value (in-set procs)))
        (match-define (Closure lam benv*) proc)
        (match-define (Lam _ formals call*) lam)
        (define bindings (map (alloc time*) formals))
        (define benv** (benv-extend* benv* formals bindings))
        (define store* (store-update* store bindings params))
        (State call* benv** store* time*)))
     (list->set new-states))
    (else (set))))
(: explore (-> (Setof State) (Listof State) (Setof State)))
(define (explore seen todo)
   (cond
    ((eq? '() todo) seen)
    ((set-member? seen (car todo)) (explore seen (cdr todo)))
    (else
     (define st0 (car todo))
     (: succs (Setof State))
     (define succs (next st0))
     (explore (set-add seen st0) (append (set->list succs) (cdr todo))))))
