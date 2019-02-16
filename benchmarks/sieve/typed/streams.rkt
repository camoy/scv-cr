#lang typed/racket/base/no-check
(define-values
  (g15
   g16
   g17
   g18
   generated-contract5
   generated-contract11
   g19
   generated-contract6
   g20
   g21
   g22
   g23
   g24
   g25
   g26
   generated-contract7
   g27
   generated-contract8
   generated-contract9
   generated-contract12
   g28
   generated-contract13
   generated-contract14)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g15 exact-nonnegative-integer?)
             (g16 (or/c g15))
             (g17 (lambda (x) (stream? x)))
             (g18 (-> g17))
             (generated-contract5 (-> g16 g18 (values g17)))
             (generated-contract11 (-> g16 g18 (values g17)))
             (g19 (λ (_) #f))
             (generated-contract6 g19)
             (g20 (λ (_) #f))
             (g21 any/c)
             (g22 '#t)
             (g23 '#f)
             (g24 (or/c g22 g23))
             (g25 (-> g21 (values g24)))
             (g26 (or/c g20 g25))
             (generated-contract7 g26)
             (g27 (-> (values g17)))
             (generated-contract8 (-> g17 (values g27)))
             (generated-contract9 (-> g17 (values g16)))
             (generated-contract12 (-> g17 g16 (values g16)))
             (g28 (listof g16))
             (generated-contract13 (-> g17 g16 (values g28)))
             (generated-contract14 (-> g17 (values g16 g17))))
      (values
       g15
       g16
       g17
       g18
       generated-contract5
       generated-contract11
       g19
       generated-contract6
       g20
       g21
       g22
       g23
       g24
       g25
       g26
       generated-contract7
       g27
       generated-contract8
       generated-contract9
       generated-contract12
       g28
       generated-contract13
       generated-contract14))))
(require (only-in racket/contract contract-out))
(provide (contract-out (make-stream generated-contract5))
          (contract-out (struct stream ((first g16) (rest g18))))
          (contract-out (stream-get generated-contract12))
          (contract-out (stream-take generated-contract13))
          (contract-out (stream-unfold generated-contract14)))
(provide)
(struct: stream ((first : Natural) (rest : (-> stream))))
(: make-stream (-> Natural (-> stream) stream))
(define (make-stream hd thunk) (stream hd thunk))
(: stream-unfold (-> stream (values Natural stream)))
(define (stream-unfold st) (values (stream-first st) ((stream-rest st))))
(: stream-get (-> stream Natural Natural))
(define (stream-get st i)
   (define-values (hd tl) (stream-unfold st))
   (cond ((= i 0) hd) (else (stream-get tl (sub1 i)))))
(: stream-take (-> stream Natural (Listof Natural)))
(define (stream-take st n)
   (cond
    ((= n 0) '())
    (else
     (define-values (hd tl) (stream-unfold st))
     (cons hd (stream-take tl (sub1 n))))))
