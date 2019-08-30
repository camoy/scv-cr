#lang racket/base

(provide absz (struct-out my-box))

(struct my-box (x))

(define (absz x)
  (if (> x 0) x (- x)))
