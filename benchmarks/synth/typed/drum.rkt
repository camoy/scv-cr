#lang typed/racket/base/no-check
(define-values
  (g29 g30 g31 g32 g33 g34 g35 g36 generated-contract12)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g29 exact-nonnegative-integer?)
             (g30 (or/c g29))
             (g31 '#f)
             (g32 'O)
             (g33 'X)
             (g34 (or/c g31 g32 g33))
             (g35 (listof g34))
             (g36 (lambda (x) (Array? x)))
             (generated-contract12 (-> g30 g35 g30 (values g36))))
      (values g29 g30 g31 g32 g33 g34 g35 g36 generated-contract12))))
(require (only-in racket/contract contract-out))
(provide (contract-out (drum generated-contract12)))
(require require-typed-check "typed-data.rkt")
(require "array-struct.rkt")
(require "array-utils.rkt")
(require "array-transform.rkt")
(require "synth.rkt")
(provide)
(: random-sample (-> Float))
(define (random-sample) (- (* 2.0 (random)) 1.0))
(: bass-drum Array)
(define bass-drum
   (let ()
     (: n-samples Integer)
     (define n-samples (seconds->samples 0.05))
     (: n-different-samples Integer)
     (define n-different-samples (quotient n-samples 12))
     (: ds* In-Indexes)
     (define ds* (vector n-samples))
     (: ds Indexes)
     (define ds
       (check-array-shape
        ds*
        (λ () (raise-argument-error 'name "Indexes" ds))))
     (: vs (Vectorof Flonum))
     (define vs
       (for/vector
        :
        (Vectorof Flonum)
        #:length
        (array-shape-size ds)
        #:fill
        0.0
        ((i : Natural (in-range n-different-samples))
         (sample : Flonum (in-producer random-sample))
         #:when
         #t
         (j : Natural (in-range 12)))
        sample))
     (unsafe-vector->array ds vs)))
(: snare Array)
(define snare
   (let:
    ((indexes : In-Indexes (vector (seconds->samples 0.05)))
     (arr-gen : (-> Indexes Flonum) (lambda ((x : Indexes)) (random-sample))))
    (build-array indexes arr-gen)))
(: drum (-> Natural Pattern Natural Array))
(define (drum n pattern tempo)
   (: samples-per-beat Natural)
   (define samples-per-beat (quotient (* fs 60) tempo))
   (: make-drum (-> Array Natural Array))
   (define (make-drum drum-sample samples-per-beat)
     (array-append*
      (list
       drum-sample
       (make-array
        (vector (- samples-per-beat (array-size drum-sample)))
        0.0))))
   (: O Array)
   (define O (make-drum bass-drum samples-per-beat))
   (: X Array)
   (define X (make-drum snare samples-per-beat))
   (: pause Array)
   (define pause (make-array (vector samples-per-beat) 0.0))
   (array-append*
    (for*/list
     :
     (Listof Array)
     ((i : Integer (in-range n)) (beat : Drum-Symbol (in-list pattern)))
     (case beat ((X) X) ((O) O) ((#f) pause)))))
