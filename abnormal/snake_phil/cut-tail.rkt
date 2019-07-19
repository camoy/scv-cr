#lang racket
(require "data.rkt")
(define (cut-tail segs)
   (let ((r (cdr segs)))
     (cond ((empty? r) empty) (else (cons (car segs) (cut-tail r))))))
(provide cut-tail)
