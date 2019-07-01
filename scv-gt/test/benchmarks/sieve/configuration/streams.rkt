#lang racket/base
(provide (struct-out stream) make-stream stream-unfold stream-get stream-take)
(struct stream (first rest))
(define (make-stream hd thunk) (stream hd thunk))
(define (stream-unfold st) (values (stream-first st) ((stream-rest st))))
(define (stream-get st i)
   (define-values (hd tl) (stream-unfold st))
   (cond ((= i 0) hd) (else (stream-get tl (sub1 i)))))
(define (stream-take st n)
   (cond
    ((= n 0) '())
    (else
     (define-values (hd tl) (stream-unfold st))
     (cons hd (stream-take tl (sub1 n))))))
