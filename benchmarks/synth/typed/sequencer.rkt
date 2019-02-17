#lang typed/racket/base/no-check
(define-values
  (g26
   g27
   g28
   g29
   generated-contract7
   g30
   g31
   g32
   g33
   g34
   g35
   g36
   g37
   g38
   g39
   g40
   g41
   g42
   generated-contract8)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g26 symbol?)
             (g27 exact-nonnegative-integer?)
             (g28 (or/c g27))
             (g29 (cons/c g28 g28))
             (generated-contract7 (-> g26 g28 g28 (values g29)))
             (g30 '#f)
             (g31 (or/c g27 g30))
             (g32 (cons/c g31 g28))
             (g33 (listof g32))
             (g34 flonum?)
             (g35 (or/c g34))
             (g36 exact-integer?)
             (g37 (or/c g36))
             (g38 (vectorof g37))
             (g39 (or/c g38))
             (g40 (-> g39 (values g35)))
             (g41 (-> g35 (values g40)))
             (g42 (lambda (x) (Array? x)))
             (generated-contract8 (-> g28 g33 g28 g41 (values g42))))
      (values
       g26
       g27
       g28
       g29
       generated-contract7
       g30
       g31
       g32
       g33
       g34
       g35
       g36
       g37
       g38
       g39
       g40
       g41
       g42
       generated-contract8))))
(require (only-in racket/contract contract-out))
(provide (contract-out (note generated-contract7))
          (contract-out (sequence generated-contract8)))
(require require-typed-check "typed-data.rkt")
(require "array-struct.rkt")
(require "array-transform.rkt")
(require "synth.rkt")
(require "mixer.rkt")
(provide)
(: note-freq (-> Natural Float))
(define (note-freq note)
   (: res Real)
   (define res (* 440 (expt (expt 2 1/12) (- note 57))))
   (if (flonum? res) res (error "not real")))
(: name+octave->note (-> Symbol Natural Natural))
(define (name+octave->note name octave)
   (+
    (* 12 octave)
    (case name
      ((C) 0)
      ((C# Db) 1)
      ((D) 2)
      ((D# Eb) 3)
      ((E) 4)
      ((F) 5)
      ((F# Gb) 6)
      ((G) 7)
      ((G# Ab) 8)
      ((A) 9)
      ((A# Bb) 10)
      ((B) 11)
      (else 0))))
(: note (-> Symbol Natural Natural (Pairof Natural Natural)))
(define (note name octave duration)
   (cons (name+octave->note name octave) duration))
(:
  synthesize-note
  (-> (U #f Natural) Natural (-> Float (-> Indexes Float)) Array))
(define (synthesize-note note n-samples function)
   (build-array
    (vector n-samples)
    (if note (function (note-freq note)) (lambda (x) 0.0))))
(:
  sequence
  (->
   Natural
   (Listof (Pairof (U Natural #f) Natural))
   Natural
   (-> Float (-> Indexes Float))
   Array))
(define (sequence n pattern tempo function)
   (: samples-per-beat Natural)
   (define samples-per-beat (quotient (* fs 60) tempo))
   (array-append*
    (for*/list
     :
     (Listof Array)
     ((i (in-range n))
      (note : (Pairof (U Natural #f) Natural) (in-list pattern)))
     (: nsamples Natural)
     (define nsamples (* samples-per-beat (cdr note)))
     (synthesize-note (car note) nsamples function))))
