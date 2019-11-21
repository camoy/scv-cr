#lang racket/base

(define (sum-up n)
  (apply + (for/list ([k (in-range n)]) k)))

(time (sum-up 1000000))
