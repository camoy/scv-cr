#lang typed/racket/no-check
(require racket/contract)
(provide (contract-out))
(module require/contracts racket/base
   (require racket/contract)
   (provide (contract-out)))
(require (prefix-in -: (only-in 'require/contracts))
          (except-in 'require/contracts))
(define-values () (values))
(require require-typed-check)
(require "data.rkt")
(define-type (NEListof A) (Pairof A (Listof A)))
(define-type Dir (U "up" "down" "left" "right"))
(define-type Snake snake)
(define-type World world)
(define-type Posn posn)
(provide (struct-out posn)
          (struct-out snake)
          (struct-out world)
          Dir
          Snake
          World
          Posn
          NEListof)
