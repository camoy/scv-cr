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

(define CUTOFF 10)
(define ITERATIONS 10)
(define NUM-SAMPLES 10)
(define SAMPLE-FACTOR 10)
(define BASELINE-LABEL
  (string->symbol (format "~a" (version))))
(define SCV-LABEL
  (string->symbol (format "~a + SCV" (version))))
