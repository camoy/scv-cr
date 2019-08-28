#lang typed/racket/base

(provide
 min  ;(number? number? . -> . number?)]
 max  ;(number? number? . -> . number?)]
 abs  ;(number? . -> . number?)]
)

;; =============================================================================

(define (min [x : Real] [y : Real]) (if (<= x y) x y))
(define (max [x : Real] [y : Real]) (if (>= x y) x y))
(define (abs [x : Real]) (if (>= x 0) x (- 0 x)))
