#lang typed/racket/no-check
(require racket/contract
          (lib "racket/contract.rkt")
          (lib "racket/base.rkt")
          (submod "data.rkt" #%type-decl ".."))
(define g9 (lambda (x) (snake? x)))
(define generated-contract4 (-> g9 (values g9)))
(define generated-contract5 (-> g9 (values g9)))
(provide (contract-out
           (snake-grow generated-contract4)
           (snake-slither generated-contract5)))
(module require/contracts racket/base
   (require racket/contract
            "cut-tail.rkt"
            (lib "racket/contract.rkt")
            (lib "racket/base.rkt")
            (lib "racket/contract/base.rkt")
            (submod "data.rkt" #%type-decl ".."))
   (define g6 (lambda (x) (posn? x)))
   (define g7 (listof g6))
   (define g8 (cons/c g6 g7))
   (define l/1 (-> g8 (values g7)))
   (provide g6 g7 g8 l/1 (contract-out (cut-tail l/1))))
(require (prefix-in -: (only-in 'require/contracts cut-tail))
          (except-in 'require/contracts cut-tail))
(define-values (cut-tail) (values -:cut-tail))
(require require-typed-check "data-adaptor.rkt")
(void)
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
