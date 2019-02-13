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
    (let* () (values))))
(require racket/contract)
(provide)
(module require-contracts racket/base
   (require racket/contract
            (prefix-in t: typed-racket/types/numeric-predicates)
            (submod typed-racket/private/type-contract predicates)
            typed-racket/utils/struct-type-c
            typed-racket/utils/vector-contract
            typed-racket/utils/hash-contract
            typed-racket/utils/opaque-object)
   (require "streams.rkt")
   (define g14 exact-nonnegative-integer?)
   (define g15 (or/c g14))
   (define g16 (lambda (x) (stream? x)))
   (define g17 (-> (values g16)))
   (define lifted/33 (-> g15 g17 (values g16)))
   (define lifted/35 (-> g16 (values g15)))
   (define g18 (-> g16))
   (define lifted/37 (-> g16 (values g18)))
   (define lifted/39 (-> g15 g17 (values g16)))
   (define lifted/41 (-> g16 (values g15 g16)))
   (define lifted/43 (-> g16 g15 (values g15)))
   (define g19 (listof g15))
   (define lifted/45 (-> g16 g15 (values g19)))
   (provide (contract-out (struct stream ((first g15) (rest g17))))
            (contract-out (make-stream (-> g15 g17 (values g16))))
            (contract-out (stream-unfold (-> g16 (values g15 g16))))
            (contract-out (stream-get (-> g16 g15 (values g15))))
            (contract-out (stream-take (-> g16 g15 (values g19))))))
(require 'require-contracts)
(require require-typed-check)
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
