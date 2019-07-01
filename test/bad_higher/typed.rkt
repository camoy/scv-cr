#lang typed/racket/base

(provide make-adder)

(: make-adder (-> Real (-> Real Real)))
(define (make-adder x)
  (lambda (y)
    (+ x y)))
