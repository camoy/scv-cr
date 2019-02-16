#lang typed/racket/no-check
(define-values
  (g18 g19 g20 g21 generated-contract6 g22 generated-contract7)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g18 (lambda (x) (world? x)))
             (g19 '#t)
             (g20 '#f)
             (g21 (or/c g19 g20))
             (generated-contract6 (-> g18 (values g21)))
             (g22 string?)
             (generated-contract7 (-> g18 g22 (values g18))))
      (values g18 g19 g20 g21 generated-contract6 g22 generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (game-over? generated-contract6))
          (contract-out (handle-key generated-contract7)))
(require require-typed-check "data-adaptor.rkt")
(require "collide.rkt")
(require "motion.rkt")
(: handle-key : (-> World String World))
(define (handle-key w ke)
   (cond
    ((equal? ke "w") (world-change-dir w "up"))
    ((equal? ke "s") (world-change-dir w "down"))
    ((equal? ke "a") (world-change-dir w "left"))
    ((equal? ke "d") (world-change-dir w "right"))
    (else w)))
(: game-over? : (-> World Boolean))
(define (game-over? w)
   (or (snake-wall-collide? (world-snake w))
       (snake-self-collide? (world-snake w))))
(provide)
