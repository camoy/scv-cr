#lang racket

(provide (all-defined-out))

(define in-place
  (make-parameter #f))
(define only-provide
  (make-parameter #f))
(define only-require
  (make-parameter #f))
