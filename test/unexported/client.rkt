#lang typed/racket

(require "server.rkt")

(: my-example* MyNumber)
(define my-example*
  my-example)

(: print-add1 (-> MyNumber Void))
(define (print-add1 x)
  (displayln (my-number-add1 x)))

(provide
  my-example*
  print-add1)
