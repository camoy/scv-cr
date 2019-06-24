#lang racket/base

(module+ test
  (require
   racket/require
   rackunit
   (multi-in racket (function list path rerequire))
   scv-gt
   (multi-in scv-gt private (syntax-util proxy-resolver)))

  ;; Module-Path -> Void
  ;; checks to make sure running optimization on the modules does not yield
  ;; an issue; runs the main target
  (define (test-optimize main targets)
    (after
     (define main* (path->complete-path main))
     (in-dir main*
       (dynamic-rerequire main*))
     (optimize targets
               #:ignore-check #t)
     (in-dir main*
       (check-not-exn (thunk (dynamic-rerequire main*))))
     (for-each module-delete-zo targets)))

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

  (test-case
    "basic posn"
    (test-optimize "basic/posn-typed-client.rkt"
                   '("basic/posn-typed-client.rkt"
                     "basic/posn-untyped-server.rkt")))

  (test-case
    "bad adder"
    (test-optimize "bad/untyped.rkt"
                   '("bad/untyped.rkt"
                     "bad/typed.rkt")))

  ;; success
  (test-benchmark "sieve")
  (test-benchmark "snake")
  #;(test-benchmark "zombie")
  #;(test-benchmark "tetris")
  #;(test-benchmark "synth")

  ;; error
  #;(test-benchmark "morsecode")
  )
