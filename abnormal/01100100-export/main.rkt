#lang typed/racket/no-check
(require racket/contract)
(provide (contract-out))
(module require/contracts racket/base
   (require racket/contract
            "handlers.rkt"
            "motion.rkt"
            (lib "racket/contract.rkt")
            (lib "racket/base.rkt")
            (lib "racket/contract/base.rkt")
            (submod "data-adaptor.rkt" #%type-decl ".."))
   (define g35 (lambda (x) (equal? x (void))))
   (define g36 (-> g35))
   (define g37 (lambda (x) (world? x)))
   (define g38 (-> any/c g37))
   (define g39 string?)
   (define g40 (-> any/c any/c g37))
   (define g41 '#t)
   (define g42 '#f)
   (define g43 (or/c g41 g42))
   (define l/1 g36)
   (define l/3 g38)
   (define l/5 g40)
   (define l/7 (-> g37 (values g43)))
   (provide g39
            g40
            l/5
            g37
            g38
            l/3
            g35
            g36
            l/1
            g41
            g42
            g43
            l/7
            (contract-out
             (reset! any/c)
             (world->world any/c)
             (handle-key any/c)
             (game-over? any/c))))
(require (prefix-in
           -:
           (only-in
            'require/contracts
            game-over?
            handle-key
            world->world
            reset!))
          (except-in
           'require/contracts
           game-over?
           handle-key
           world->world
           reset!))
(define-values
  (game-over? handle-key world->world reset!)
  (values -:game-over? -:handle-key -:world->world -:reset!))
(require require-typed-check "data-adaptor.rkt")
(require "const.rkt")
(void)
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
