#lang racket/base

(provide absz)

(define (absz x)
  (if (> x 0) x (- x)))
