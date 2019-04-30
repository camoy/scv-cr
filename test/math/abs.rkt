#lang typed/racket/base

(provide my-abs)

(: my-abs (-> Real Nonnegative-Real))
(define (my-abs x)
  (if (x . > . 0) x (- x)))
