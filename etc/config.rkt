#lang racket/base

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

(define DEFAULT-BIN-DIR "/usr/bin")
(define BENCHMARK-ROOT-DIR "/home/camoy/wrk/gtp-benchmarks/benchmarks")
(define MODIFIED-TR-DIR "/home/camoy/wrk/typed-racket")
(define ORIGINAL-TR-DIR "/home/camoy/wrk/original-typed-racket")

(define CUTOFF 10)
(define ITERATIONS 10)
(define NUM-SAMPLES 10)
(define SAMPLE-FACTOR 10)
(define BASELINE-LABEL
  (string->symbol (format "~a" (version))))
(define SCV-LABEL
  (string->symbol (format "~a + SCV" (version))))
