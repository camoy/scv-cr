(module drum typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (submod "data.rkt" #%type-decl "..")
             (lib "racket/contract/base.rkt"))
    (define g4 exact-nonnegative-integer?)
    (define g5 (or/c g4))
    (define g6 '#f)
    (define g7 'O)
    (define g8 'X)
    (define g9 (or/c g6 g7 g8))
    (define g10 (listof g9))
    (define g11 (lambda (x) (Array? x)))
    (define generated-contract3 (-> g5 g10 g5 (values g11)))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check "typed-data.rkt")
    (require "array-struct.rkt")
    (require "array-utils.rkt")
    (require "array-transform.rkt")
    (require "synth.rkt")
    (void)
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
          (for/vector:
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
        (arr-gen
         :
         (-> Indexes Flonum)
         (lambda: ((x : Indexes)) (random-sample))))
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
       (for*/list:
        :
        (Listof Array)
        ((i : Integer (in-range n)) (beat : Drum-Symbol (in-list pattern)))
        (case beat ((X) X) ((O) O) ((#f) pause)))))
    (provide)
    (provide (contract-out (drum generated-contract3)))))
