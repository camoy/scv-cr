#lang typed/racket/base/no-check
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
(random-seed 5)
(require require-typed-check
          racket/list
          typed/racket/class
          "board-adapted.rkt"
          "state-adapted.rkt")
(require "admin.rkt")
(require "player.rkt")
(require "auxiliaries.rkt")
(: go (-> (Instance Player%) Void))
(define (go extra)
   (define p0 (ordered-players 10))
   (define p1 (random-players 10))
   (define p (cons extra (append p0 p1)))
   (define-values
    (two-status _score two-run)
    (let ((r (run p 10 #:show show #:choice randomly-pick)))
      (values (car r) (cadr r) (caddr r))))
   (void))
(:
  run
  (->*
   ((Listof (Instance Player%)) Natural)
   (#:show (-> Void) #:choice (-> (Listof Tile) Tile))
   RunResult))
(define (run
          players
          turns#
          #:show
          (show show)
          #:choice
          (choose-next-tile first))
   (define a (new administrator% (next-tile choose-next-tile)))
   (for ((p players)) (send p go a))
   (send a run turns# #:show show))
(: show (-> Void))
(define (show) (void))
(: main (-> Natural Void))
(define (main n) (for ((i (in-range n))) (go (inf-loop-player 99))))
(time (main 100))
