#lang typed/racket/no-check
(require racket/contract)
(provide (contract-out))
(module require/contracts racket/base
   (require racket/contract
            "handlers.rkt"
            "const.rkt"
            (lib "racket/contract.rkt")
            (lib "racket/base.rkt")
            (lib "racket/contract/base.rkt")
            (submod "data.rkt" #%type-decl ".."))
   (define g34 (lambda (x) (world? x)))
   (define g35 (-> g34))
   (define g36 string?)
   (define g37 (-> any/c any/c g34))
   (define g38 '#t)
   (define g39 '#f)
   (define g40 (or/c g38 g39))
   (define l/1 g35)
   (define l/3 g37)
   (define l/5 (-> g34 (values g40)))
   (provide g36
            g37
            l/3
            g34
            g35
            l/1
            g38
            g39
            g40
            l/5
            (contract-out
             (game-over? any/c)
             (WORLD any/c)
             (handle-key any/c))))
(require (prefix-in
           -:
           (only-in 'require/contracts handle-key WORLD game-over?))
          (except-in 'require/contracts handle-key WORLD game-over?))
(define-values
  (handle-key WORLD game-over?)
  (values -:handle-key -:WORLD -:game-over?))
(require require-typed-check "data-adaptor.rkt")
(void)
(require "motion.rkt")
(void)
(: replay (-> World (Listof Any) Void))
(define (replay w0 hist)
   (reset!)
   (let loop ((w : World w0) (h : (Listof Any) hist))
     (if (empty? h)
       w
       (let ()
         (loop
          (match
           (car h)
           (`(on-key ,(? string? ke)) (handle-key w ke))
           (`(on-tick) (world->world w))
           (`(stop-when) (game-over? w) w))
          (cdr h)))))
   (void))
(define DATA (with-input-from-file "../base/snake-hist.rktd" read))
(define LOOPS 200)
(: main (-> Any Void))
(define (main hist)
   (define w0 (WORLD))
   (cond
    ((list? hist) (for ((i (in-range LOOPS))) (replay w0 hist)))
    (else (error "bad input"))))
(time (main DATA))
