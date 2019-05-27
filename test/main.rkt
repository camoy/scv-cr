#lang racket/base

(module+ test
  (require rackunit
           racket/function
           racket/list
           racket/path
           scv-gt
           scv-gt/private/proxy-resolver)

  ;; Module-Path -> Void
  ;; checks to make sure running optimization on the modules does not yield
  ;; an issue; only runs the first target
  (define (test-optimize targets)
    (optimize targets
              #:ignore-check #t
              #:verify-off #t)
    (define main (path->complete-path (first targets)))
    (in-dir main
      (check-not-exn (thunk (dynamic-require main #f)))))

  (test-case
    "basic programs"
    (test-optimize '("basic/abs.rkt")))

  (test-case
    "sieve"
    (test-optimize '("benchmarks/sieve/typed/main.rkt"
                     "benchmarks/sieve/typed/streams.rkt")))

  (test-case
    "snake"
    (test-optimize '("benchmarks/snake/typed/main.rkt"
                     "benchmarks/snake/typed/collide.rkt"
                     "benchmarks/snake/typed/handlers.rkt"
                     "benchmarks/snake/typed/motion-help.rkt"
                     "benchmarks/snake/typed/motion.rkt"
                     "benchmarks/snake/typed/cut-tail.rkt"
                     "benchmarks/snake/typed/data.rkt"
                     "benchmarks/snake/typed/data-adaptor.rkt"
                     "benchmarks/snake/typed/const.rkt")))

  )
