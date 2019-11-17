#lang racket/base

(require racket/class
         racket/draw)

(provide (all-defined-out))

(define BENCHMARKS
  '("sieve"
    "fsm"
    "morsecode"
    "zombie"
    "zordoz"
    "lnm"
    "suffixtree"
    "kcfa"
    "snake"
    "tetris"
    "synth"
    "gregor"))

(define BENCHMARK-ROOT-DIR "/home/camoy/wrk/gtp-benchmarks/benchmarks")
(define MODIFIED-TR-DIR "/home/camoy/wrk/typed-racket")
(define ORIGINAL-TR-DIR "/home/camoy/wrk/original-typed-racket")

(define CUTOFF 10)
(define ITERATIONS 10)
(define NUM-SAMPLES 10)
(define SAMPLE-FACTOR 10)
(define BASELINE-LABEL
  (string->symbol "Typed Racket"))
(define SCV-LABEL
  (string->symbol "Typed Racket + SCV-CR"))
(define PLOT-LABEL-SIZE 22)

(define COLOR-SCHEME
  (list (make-object color% 94 60 153)
        (make-object color% 230 97 1)))

#;(define COLOR-SCHEME '(3 4))
#;(define COLOR-SCHEME '(Indigo Goldenrod))
