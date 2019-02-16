#lang typed/racket/base/no-check
(define-values
  ()
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(require require-typed-check)
(require "streams.rkt")
(: count-from (-> Natural stream))
(define (count-from n) (make-stream n (lambda () (count-from (add1 n)))))
(: sift (-> Natural stream stream))
(define (sift n st)
   (define-values (hd tl) (stream-unfold st))
   (cond
    ((= 0 (modulo hd n)) (sift n tl))
    (else (make-stream hd (lambda () (sift n tl))))))
(: sieve (-> stream stream))
(define (sieve st)
   (define-values (hd tl) (stream-unfold st))
   (make-stream hd (lambda () (sieve (sift hd tl)))))
(: primes stream)
(define primes (sieve (count-from 2)))
(: N-1 Natural)
(define N-1 6666)
(: main (-> Void))
(define (main) (void (stream-get primes N-1)))
(time (main))
