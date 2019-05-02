#lang racket/base

(module+ test
  (require rackunit
           racket/function
           racket/list
           scv-gt)

  ;; Module-Path -> Void
  ;; checks to make sure running optimization on the modules does not yield
  ;; an issue; only runs the first target
  (define (test-optimize targets)
    (optimize targets #:ignore-check #t)
    (check-not-exn (thunk (dynamic-require (first targets) #f))))

  (test-case
    "basic programs"
    (test-optimize '("basic/abs.rkt")))

  (test-case
    "benchmark programs"
    (test-optimize '("benchmarks/sieve/typed/main.rkt"
                     "benchmarks/sieve/typed/streams.rkt")))
  )
