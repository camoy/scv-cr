#lang racket/base

(provide even?)

(define (even? n)
  (zero? (modulo n 2)))
