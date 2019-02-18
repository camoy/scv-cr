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
(require "base-types.rkt")
(require require-typed-check)
(require "aux.rkt")
(require "bset.rkt")
(require "world.rkt")
(define (world0) (world (list-pick-random tetras) empty))
(: game-over? (-> World Boolean))
(define (game-over? w) (blocks-overflow? (world-blocks w)))
(: replay : World (Listof Any) -> Void)
(define (replay w0 hist)
   (for/fold
    ((w : World w0))
    ((e hist))
    (match
     e
     (`(on-key ,(? string? ke)) (world-key-move w ke))
     (`(on-tick) (next-world w))
     (`(stop-when) (game-over? w) w)))
   (void))
(define DATA (with-input-from-file "../base/tetris-hist.rktd" read))
(define LOOPS 2)
(: main (-> Any Void))
(define (main raw)
   (define w0 (world0))
   (if (list? raw)
     (for ((_i (in-range LOOPS))) (replay w0 raw))
     (error "bad input")))
(time (main DATA))
