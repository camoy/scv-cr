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
  ;; an issue; runs the main target
  (define (test-optimize main targets)
    (optimize targets
              #:ignore-check #t
              #:verify-off #t)
    (define main* (path->complete-path main))
    (in-dir main*
      (check-not-exn (thunk (dynamic-require main* #f)))))

  ;; String -> Void
  ;; takes benchmark name and runs all files with test-optimize
  (define (test-benchmark benchmark)
    (let* ([benchmark-dir
            (build-path "benchmarks" benchmark "typed")]
           [benchmark-files
            (directory-list benchmark-dir #:build? benchmark-dir)]
           [benchmark-files*
            (filter (negate directory-exists?) benchmark-files)]
           [is-main?
            (λ (p) (string=? (path->string (file-name-from-path p))
                             "main.rkt"))]
           [main
            (findf is-main? benchmark-files*)])
      (test-case
        benchmark
        (test-optimize main benchmark-files*))))

  (test-case
    "basic programs"
    (test-optimize "basic/abs.rkt"
                   '("basic/abs.rkt")))
  (test-benchmark "sieve")
  (test-benchmark "snake")
  )
