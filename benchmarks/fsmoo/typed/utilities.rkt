#lang typed/racket/no-check
(define-values
  (g12
   g13
   g14
   g15
   g16
   g17
   g18
   g19
   g20
   generated-contract9
   g21
   g22
   generated-contract10
   generated-contract11)
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
    (letrec ((g12 nonnegative?)
             (g13 (or/c g12))
             (g14 (listof g13))
             (g15 exact-nonnegative-integer?)
             (g16 (or/c g15))
             (g17 real?)
             (g18 '#f)
             (g19 (or/c g17 g18))
             (g20 (listof g16))
             (generated-contract9 (->* (g14 g16) (#:random g19) (values g20)))
             (g21 (or/c g17))
             (g22 (listof g21))
             (generated-contract10 (-> g22 g21 (values g21)))
             (generated-contract11 (-> g22 (values g21))))
      (values
       g12
       g13
       g14
       g15
       g16
       g17
       g18
       g19
       g20
       generated-contract9
       g21
       g22
       generated-contract10
       generated-contract11))))
(require (only-in racket/contract contract-out))
(provide (contract-out (choose-randomly generated-contract9))
          (contract-out (relative-average generated-contract10))
          (contract-out (sum generated-contract11)))
(define-type Probability Nonnegative-Real)
(provide)
(: sum (-> (Listof Real) Real))
(: relative-average (-> (Listof Real) Real Real))
(:
  choose-randomly
  (-> (Listof Probability) Natural (#:random (U False Real)) (Listof Natural)))
(define (sum l) (apply + l))
(define (relative-average l w) (exact->inexact (/ (sum l) w (length l))))
(define (choose-randomly probabilities speed #:random (q #f))
   (define %s (accumulated-%s probabilities))
   (for/list
    ((n (in-range speed)))
    (define r (or q (random)))
    (let loop :
      Natural
      ((%s : (Listof Real) %s))
      (cond ((< r (first %s)) 0) (else (add1 (loop (rest %s))))))))
(: accumulated-%s (-> (Listof Probability) (Listof Real)))
(define (accumulated-%s probabilities)
   (define total (sum probabilities))
   (let relative->absolute :
     (Listof Real)
     ((payoffs : (Listof Real) probabilities) (so-far : Real 0.0))
     (cond
      ((empty? payoffs) '())
      (else
       (define nxt (+ so-far (first payoffs)))
       ((inst cons Real Real)
        (/ nxt total)
        (relative->absolute (rest payoffs) nxt))))))
