#lang typed/racket/base

(provide absz (struct-out my-box))

(struct my-box ([x : Real]))

(: bad-for-scv (Parameterof Boolean))
(define bad-for-scv (make-parameter #f))

(: absz (-> Real Real))
(define (absz x)
  (if (> x 0) x (- x)))
