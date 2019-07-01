#lang racket/base

(require "typed.rkt")

(define (definitely-not-ok x)
  (if (< x 0.001)
      ((make-adder 1) "bad1")
      ((make-adder "bad2") 1)))

(definitely-not-ok (random))
