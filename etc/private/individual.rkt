#lang racket/base

(provide individual-functions)

(require (for-syntax racket/base)
         racket/runtime-path
         racket/path
         racket/file
         gtp-plot/typed-racket-info
         gtp-plot/plot
         gtp-plot/util
         gtp-plot/performance-info)

(*OVERHEAD-PLOT-HEIGHT* 400)
(*OVERHEAD-PLOT-WIDTH* 800)
(*OVERHEAD-SHOW-RATIO* #f)
(*OVERHEAD-MAX* 10)
(*POINT-SIZE* 18)
(*FONT-SIZE* 24)

(define-runtime-path figures-dir
  (build-path ".." "measurements" "figures"))

(make-directory* figures-dir)

(define (overhead benchmark samples baseline _ __)
  (define overhead-pict
    (overhead-plot (list baseline samples)
                   (string->symbol benchmark)))
  (define overhead-path
    (build-path figures-dir (format "~a-overhead.png" benchmark)))
  (save-pict overhead-path overhead-pict))

(define (samples benchmark samples baseline _ __)
  (define samples-pict
    (samples-plot samples))
  (define samples-path
    (build-path figures-dir (format "~a-samples.png" benchmark)))
  (save-pict samples-path samples-pict))

(define (exact benchmark samples baseline _ __)
  (define exact-pict
    (exact-runtime-plot samples))
  (define exact-path
    (build-path figures-dir (format "~a-exact.png" benchmark)))
  (save-pict exact-path exact-pict))

(define (scatterplot benchmark _ __ samples baseline)
  (define scatterplot-pict
    (relative-scatterplot samples baseline))
  (define scatterplot-path
    (build-path figures-dir (format "~a-scatterplot.png" benchmark)))
  (save-pict scatterplot-path scatterplot-pict))

(define individual-functions
  (list overhead
        samples
        exact
        scatterplot))
