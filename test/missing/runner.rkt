#lang racket

(require soft-contract/main
         racket/function)
(define posn-stx
  #'(module posn racket/base
      (#%module-begin (provide (struct-out posn)) (struct posn ()))))
(define main-stx
  #'(module main typed/racket/base/no-check
      (#%module-begin
       (require racket/contract)
       (provide (contract-out))
       (module require/contracts racket/base
         (require racket/contract
                  "posn.rkt"
                  (lib "racket/contract.rkt")
                  (lib "racket/base.rkt"))
         (define g8 (lambda (x) (posn? x)))
         (define g9 (-> g8))
         (define l/33 g9)
         (provide g8 g9 l/33 (contract-out (struct posn ()))))
       (require (prefix-in -: (only-in 'require/contracts posn?))
                (except-in 'require/contracts posn?))
       (define-values (posn?) (values -:posn?))
       (require require-typed-check)
       (void)
       (posn))))
(verify-modules (map (compose path->string path->complete-path) '("main.rkt" "posn.rkt"))
                (list main-stx posn-stx))