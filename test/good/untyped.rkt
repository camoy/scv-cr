#lang racket/base

(require "typed.rkt")

(define (actually-ok x)
  (adder 0))

(actually-ok (random))
