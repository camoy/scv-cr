#lang typed/racket/no-check
(define-values
  (g9 generated-contract4 generated-contract5)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g9 (lambda (x) (snake? x)))
             (generated-contract4 (-> g9 (values g9)))
             (generated-contract5 (-> g9 (values g9))))
      (values g9 generated-contract4 generated-contract5))))
(require (only-in racket/contract contract-out))
(provide (contract-out (snake-grow generated-contract4))
          (contract-out (snake-slither generated-contract5)))
(require require-typed-check "data-adaptor.rkt")
(require "cut-tail.rkt")
(: next-head : (-> Posn Dir Posn))
(define (next-head seg dir)
   (cond
    ((equal? "right" dir) (posn (add1 (posn-x seg)) (posn-y seg)))
    ((equal? "left" dir) (posn (sub1 (posn-x seg)) (posn-y seg)))
    ((equal? "down" dir) (posn (posn-x seg) (sub1 (posn-y seg))))
    (else (posn (posn-x seg) (add1 (posn-y seg))))))
(: snake-slither : (-> Snake Snake))
(define (snake-slither snk)
   (let ((d (snake-dir snk)))
     (snake
      d
      (cons
       (next-head (car (snake-segs snk)) d)
       (cut-tail (snake-segs snk))))))
(: snake-grow : (-> Snake Snake))
(define (snake-grow snk)
   (let ((d (snake-dir snk)))
     (snake d (cons (next-head (car (snake-segs snk)) d) (snake-segs snk)))))
(provide)
