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
     (optimize targets #:ignore-check #t)
     (in-dir main*
       (check-not-exn
         (thunk
          (parameterize ([current-namespace (make-base-namespace)])
            (dynamic-require main* #f)))))
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

  (test-case
    "unexported identifier"
    (test-optimize "unexported/main.rkt"
                   '("unexported/main.rkt"
                     "unexported/server.rkt"
                     "unexported/client.rkt")))

  (test-case
    "hash"
    (test-optimize "hash/client.rkt"
                   '("hash/client.rkt"
                     "hash/server.rkt")))

  (test-case
    "super structs simple"
    (test-optimize "super/both.rkt"
                   '("super/both.rkt")))

  (test-case
    "super structs"
    (test-optimize "super/main.rkt"
                   '("super/main.rkt"
                     "super/parent.rkt"
                     "super/child.rkt")))

  (test-case
    "mutable"
    (test-optimize "mutable/client.rkt"
                   '("mutable/client.rkt"
                     "mutable/server.rkt")))

  (test-case
    "predicate"
    (test-optimize "predicate/main.rkt"
                   '("predicate/main.rkt"
                     "predicate/typed.rkt")))

  (test-case
    "adaptor"
    (test-optimize "adaptor/const.rkt"
                   '("adaptor/const.rkt"
                     "adaptor/data-adaptor.rkt"
                     "adaptor/data.rkt")))

  (test-benchmark "sieve")
  (test-benchmark "morsecode")
  #;(test-benchmark "snake")
  #;(test-benchmark "zombie")
  #;(test-benchmark "tetris")
  #;(test-benchmark "synth"))
