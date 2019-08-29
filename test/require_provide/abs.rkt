#lang racket/base

(provide abs)

(define (abs x)
  (if (> x 0) x (- x)))
