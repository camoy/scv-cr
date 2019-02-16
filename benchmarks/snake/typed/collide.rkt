#lang typed/racket/no-check
(define-values
  (g14 g15 g16 g17 generated-contract6 generated-contract7)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g14 (lambda (x) (snake? x)))
             (g15 '#t)
             (g16 '#f)
             (g17 (or/c g15 g16))
             (generated-contract6 (-> g14 (values g17)))
             (generated-contract7 (-> g14 (values g17))))
      (values g14 g15 g16 g17 generated-contract6 generated-contract7))))
(require (only-in racket/contract contract-out))
(provide (contract-out (snake-self-collide? generated-contract6))
          (contract-out (snake-wall-collide? generated-contract7)))
(require require-typed-check "data-adaptor.rkt")
(require "const.rkt")
(require "data.rkt")
(: snake-wall-collide? : (-> Snake Boolean))
(define (snake-wall-collide? snk) (head-collide? (car (snake-segs snk))))
(: head-collide? : (-> Posn Boolean))
(define (head-collide? p)
   (or (<= (posn-x p) 0)
       (>= (posn-x p) BOARD-WIDTH)
       (<= (posn-y p) 0)
       (>= (posn-y p) BOARD-HEIGHT)))
(: snake-self-collide? : (-> Snake Boolean))
(define (snake-self-collide? snk)
   (segs-self-collide? (car (snake-segs snk)) (cdr (snake-segs snk))))
(: segs-self-collide? : (-> Posn (Listof Posn) Boolean))
(define (segs-self-collide? h segs)
   (cond
    ((empty? segs) #f)
    (else (or (posn=? (car segs) h) (segs-self-collide? h (cdr segs))))))
(provide)
