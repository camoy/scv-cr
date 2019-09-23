#lang racket/base

(provide benchmark-dir
         gtp-dir
         fake-bin
         benchmarks
         argv-setup)

(require basedir
         racket/runtime-path)

(define benchmark-dir "/home/camoy/wrk/gtp-benchmarks/benchmarks")
(define gtp-dir (writable-data-dir #:program "gtp-measure"))
(define-runtime-path fake-bin "fakebin")
(define benchmarks '("sieve"
                     "fsm"
                     #;"morsecode"
                     #;"zombie"
                     #;"lnm"
                     #;"suffixtree"
                     #;"kcfa"
                     #;"snake"
                     #;"tetris"))
(define argv-setup
  (vector "-c" "14"
          "-i" "10"
          "-S" "1"
          "-R" "6"
          "--bin" (path->string fake-bin)))
