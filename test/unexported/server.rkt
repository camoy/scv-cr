#lang typed/racket/base

(struct my-number ([x : Real]))
(define-type MyNumber my-number)

(: my-example MyNumber)
(define my-example
  (my-number 0))

(: my-number-add1 (-> MyNumber Real))
(define (my-number-add1 num)
  (add1 (my-number-x num)))

(provide my-example MyNumber my-number-add1)
