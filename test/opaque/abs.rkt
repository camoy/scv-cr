#lang racket/base

(require racket/contract)

(provide absz
         (contract-out [something-bad (parameter/c boolean?)]))

(define something-bad (make-parameter #f))

(define (absz x)
  (if (> x 0) x (- x)))
