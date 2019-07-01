#lang racket/base

(require "typed.rkt")

(define (probably-ok x)
  (if (< x 0.001)
      (adder "bad")
      (adder 0)))

(probably-ok (random))
