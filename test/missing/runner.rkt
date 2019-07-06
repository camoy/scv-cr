#lang racket/base

(require soft-contract/main)

(define-values (data-stx data-adaptor-stx const-stx)
  (values
   #'(module data typed/racket/no-check
       (#%module-begin
        (require racket/contract
                 (lib "racket/base.rkt")
                 (lib "racket/contract/base.rkt")
                 (lib "racket/contract.rkt"))
        (define g9 (lambda (x) (foo? x)))
        (define g10 #t)
        (define g11 #t)
        (define g12 any/c)
        (define g13 '#t)
        (define g14 '#f)
        (define g15 (or/c g13 g14))
        (define g16 (-> g12 (values g15)))
        (define g17 (or/c g11 g16))
        (define generated-contract5 g10)
        (define generated-contract6 g17)
        (define generated-contract8 (-> (values g9)))
        (provide (contract-out (struct foo ())))
        (module require/contracts racket/base
          (require racket/contract)
          (provide (contract-out)))
        (require (prefix-in -: (only-in 'require/contracts))
                 (except-in 'require/contracts))
        (define-values () (values))
        (struct: foo ())
        (provide)))
   #'(module data-adaptor typed/racket/no-check
       (#%module-begin
        (require racket/contract)
        (provide (contract-out))
        (module require/contracts racket/base
          (require racket/contract
                   "data.rkt"
                   (lib "racket/contract.rkt")
                   (lib "racket/base.rkt"))
          (define g8 (lambda (x) (foo? x)))
          (define g9 (-> g8))
          (define l/33 g9)
          (provide g8 g9 l/33 (contract-out (struct foo ()))))
        (require (prefix-in -: (only-in 'require/contracts foo?))
                 (except-in 'require/contracts foo?))
        (define-values (foo?) (values -:foo?))
        (require require-typed-check)
        (void)
        (provide (struct-out foo))))
   #'(module const typed/racket/no-check
       (#%module-begin
        (require racket/contract)
        (provide (contract-out))
        (module require/contracts racket/base
          (require racket/contract)
          (provide (contract-out)))
        (require (prefix-in -: (only-in 'require/contracts))
                 (except-in 'require/contracts))
        (define-values () (values))
        (require "data-adaptor.rkt")
        (define p (foo))))))

(verify-modules '("/home/camoy/wrk/scv-gt/test/benchmarks/snake/missing/data.rkt"
                  "/home/camoy/wrk/scv-gt/test/benchmarks/snake/missing/data-adaptor.rkt"
                  "/home/camoy/wrk/scv-gt/test/benchmarks/snake/missing/const.rkt")
                (list data-stx data-adaptor-stx const-stx))
