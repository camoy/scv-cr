#lang typed/racket/no-check
(define-values
  ()
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
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(require require-typed-check "data-adaptor.rkt")
(require "const.rkt")
(require "motion.rkt")
(require "handlers.rkt")
(: replay : (World (Listof Any) -> Void))
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
