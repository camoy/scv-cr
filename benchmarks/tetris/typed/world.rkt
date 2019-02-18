#lang typed/racket/no-check
(define-values
  (g36
   g37
   g38
   generated-contract18
   generated-contract19
   g39
   generated-contract20)
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
    (letrec ((g36 (lambda (x) (world? x)))
             (g37 (lambda (x) (block? x)))
             (g38 (listof g37))
             (generated-contract18 (-> g36 (values g38)))
             (generated-contract19 (-> g36 (values g36)))
             (g39 string?)
             (generated-contract20 (-> g36 g39 (values g36))))
      (values
       g36
       g37
       g38
       generated-contract18
       generated-contract19
       g39
       generated-contract20))))
(require (only-in racket/contract contract-out))
(provide (contract-out (ghost-blocks generated-contract18))
          (contract-out (next-world generated-contract19))
          (contract-out (world-key-move generated-contract20)))
(require "base-types.rkt")
(require require-typed-check)
(require "bset.rkt")
(require "tetras.rkt")
(require "aux.rkt")
(require "elim.rkt")
(require "consts.rkt")
(provide)
(: touchdown (-> World World))
(define (touchdown w)
   (world
    (list-pick-random tetras)
    (eliminate-full-rows
     (blocks-union (tetra-blocks (world-tetra w)) (world-blocks w)))))
(: world-jump-down (-> World World))
(define (world-jump-down w)
   (cond
    ((landed? w) w)
    (else
     (world-jump-down
      (world (tetra-move 0 1 (world-tetra w)) (world-blocks w))))))
(: landed-on-blocks? (-> World Boolean))
(define (landed-on-blocks? w)
   (tetra-overlaps-blocks? (tetra-move 0 1 (world-tetra w)) (world-blocks w)))
(: landed-on-floor? (-> World Boolean))
(define (landed-on-floor? w)
   (= (blocks-max-y (tetra-blocks (world-tetra w))) (sub1 board-height)))
(: landed? (-> World Boolean))
(define (landed? w) (or (landed-on-blocks? w) (landed-on-floor? w)))
(: next-world (-> World World))
(define (next-world w)
   (cond
    ((landed? w) (touchdown w))
    (else (world (tetra-move 0 1 (world-tetra w)) (world-blocks w)))))
(: try-new-tetra (-> World Tetra World))
(define (try-new-tetra w new-tetra)
   (cond
    ((or (< (blocks-min-x (tetra-blocks new-tetra)) 0)
         (>= (blocks-max-x (tetra-blocks new-tetra)) board-width)
         (tetra-overlaps-blocks? new-tetra (world-blocks w)))
     w)
    (else (world new-tetra (world-blocks w)))))
(: world-move (-> Real Real World World))
(define (world-move dx dy w)
   (try-new-tetra w (tetra-move dx dy (world-tetra w))))
(: world-rotate-ccw (-> World World))
(define (world-rotate-ccw w)
   (try-new-tetra w (tetra-rotate-ccw (world-tetra w))))
(: world-rotate-cw (-> World World))
(define (world-rotate-cw w)
   (try-new-tetra w (tetra-rotate-cw (world-tetra w))))
(: ghost-blocks (-> World BSet))
(define (ghost-blocks w)
   (tetra-blocks (tetra-change-color (world-tetra (world-jump-down w)) 'gray)))
(: world-key-move (-> World String World))
(define (world-key-move w k)
   (cond
    ((equal? k "left") (world-move neg-1 0 w))
    ((equal? k "right") (world-move 1 0 w))
    ((equal? k "down") (world-jump-down w))
    ((equal? k "a") (world-rotate-ccw w))
    ((equal? k "s") (world-rotate-cw w))
    (else w)))
