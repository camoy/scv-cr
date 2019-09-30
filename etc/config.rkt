#lang racket/base

(provide (all-defined-out))

(define BENCHMARKS
  '("sieve"
    #;"fsm"
    "morsecode"
    #;"zombie"
    #;"lnm"
    #;"suffixtree"
    #;"kcfa"
    #;"snake"
    #;"tetris"))

(define CUTOFF 10)
(define ITERATIONS 2)
(define NUM-SAMPLES 2)
(define SAMPLE-FACTOR 1)
