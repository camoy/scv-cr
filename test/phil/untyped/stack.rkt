#lang racket/base
(provide stack-drop
          stack-dup
          stack-init
          stack-over
          stack-pop
          stack-push
          stack-swap)
(define (list->stack xs)
   (for/fold ((S (stack-init))) ((x (in-list (reverse xs)))) (stack-push S x)))
(define (stack-drop S) (let-values (((_v S+) (stack-pop S))) S+))
(define (stack-dup S)
   (let-values (((v S+) (stack-pop S))) (stack-push (stack-push S+ v) v)))
(define (stack-init) '())
(define (stack-over S)
   (let*-values (((v1 S1) (stack-pop S)) ((v2 S2) (stack-pop S1)))
     (stack-push (stack-push (stack-push S2 v1) v2) v1)))
(define (stack-pop S)
   (if (null? S) (raise-user-error "empty stack") (values (car S) (cdr S))))
(define (stack-push S v) (cons v S))
(define (stack-swap S)
   (let*-values (((v1 S1) (stack-pop S)) ((v2 S2) (stack-pop S1)))
     (stack-push (stack-push S2 v1) v2)))
