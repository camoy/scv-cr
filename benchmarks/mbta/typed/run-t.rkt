#lang typed/racket/no-check
(define-values
  (g65
   g66
   g67
   generated-contract20
   g68
   generated-contract21
   generated-contract22
   generated-contract23
   generated-contract24
   generated-contract25)
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
    (letrec ((g65 pregexp?)
             (g66 (and/c regexp? (not/c pregexp?)))
             (g67 (or/c g65 g66))
             (generated-contract20 g67)
             (g68 string?)
             (generated-contract21 g68)
             (generated-contract22 g67)
             (generated-contract23 g68)
             (generated-contract24 g67)
             (generated-contract25 (-> g68 (values g68))))
      (values
       g65
       g66
       g67
       generated-contract20
       g68
       generated-contract21
       generated-contract22
       generated-contract23
       generated-contract24
       generated-contract25))))
(require (only-in racket/contract contract-out))
(provide (contract-out (DISABLE generated-contract20))
          (contract-out (DONE generated-contract21))
          (contract-out (ENABLE generated-contract22))
          (contract-out (EOM generated-contract23))
          (contract-out (PATH generated-contract24))
          (contract-out (run-t generated-contract25)))
(provide)
(require require-typed-check)
(require "t-view.rkt")
(require "../base/t-view-types.rkt")
(define PATH #rx"from (.*) to (.*)$")
(define DISABLE #rx"disable (.*)$")
(define ENABLE #rx"enable (.*)$")
(define DONE "done")
(define EOM "eom")
(: manage (Instance Manage))
(define manage (new manage%))
(: run-t (-> String String))
(define (run-t next)
   (cond
    ((regexp-match PATH next)
     =>
     (lambda ((x : (Listof (U #f String))))
       (define x2 (second x))
       (define x3 (third x))
       (unless (and x2 x3) (error 'run-t "invariat error"))
       (send manage find x2 x3)))
    ((regexp-match DISABLE next)
     =>
     (lambda ((x : (Listof (U #f String))))
       (define x2 (second x))
       (unless x2 (error 'run-t "invariants"))
       (status-check add-to-disabled x2)))
    ((regexp-match ENABLE next)
     =>
     (lambda ((x : (Listof (U #f String))))
       (define x2 (second x))
       (unless x2 (error 'run-t "invariants"))
       (status-check remove-from-disabled x2)))
    (else "message not understood")))
(define-syntax-rule
  (status-check remove-from-disabled enabled)
  (let ((status (send manage remove-from-disabled enabled)))
    (if (boolean? status) DONE status)))
