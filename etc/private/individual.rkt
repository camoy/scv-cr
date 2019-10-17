#lang racket/base

(provide individual-functions)

(require (for-syntax racket/base)
         racket/runtime-path
         racket/path
         racket/file
         racket/vector
         math/statistics
         gtp-plot/configuration-info
         gtp-plot/typed-racket-info
         gtp-plot/plot
         gtp-plot/util
         gtp-plot/performance-info
         "data-lattice.rkt")

(*OVERHEAD-PLOT-HEIGHT* 400)
(*OVERHEAD-PLOT-WIDTH* 800)
(*OVERHEAD-SHOW-RATIO* #f)
(*OVERHEAD-MAX* 10)
(*OVERHEAD-SAMPLES* 100)
(*POINT-SIZE* 18)
(*FONT-SIZE* 24)
(*POINT-COLOR* 3)

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

(define (samples benchmark _ __ samples baseline)
  (define samples-pict
    (samples-plot samples))
  (define samples-path
    (build-path figures-dir (format "~a-samples.png" benchmark)))
  (save-pict samples-path samples-pict))

(define (exact benchmark samples baseline _ __)
  (define exact-pict
    (exact-runtime-plot (list baseline samples)
                        (string->symbol benchmark)))
  (define exact-path
    (build-path figures-dir (format "~a-exact.png" benchmark)))
  (save-pict exact-path exact-pict))

(define (scatterplot benchmark _ __ samples baseline)
  (define scatterplot-pict
    (relative-scatterplot baseline samples))
  (define scatterplot-path
    (build-path figures-dir (format "~a-scatterplot.png" benchmark)))
  (save-pict scatterplot-path scatterplot-pict))

(define (average-results samples)
  (for/vector ([config (in-configurations samples)])
    (define runtimes
      (configuration-info->runtime* config))
    (cons (mean runtimes)
          (stddev runtimes))))

(define ((make-lattice jo format-name) benchmark samples baseline _ __)
  ;; lattices
  (define lattice-pict
    (make-performance-lattice (average-results samples)
                              (average-results baseline)
                              #:just-one jo))
  (define lattice-path
    (build-path figures-dir (format format-name benchmark)))
  (save-pict lattice-path lattice-pict))

(define individual-functions
  (list overhead
        #;samples
        exact
        scatterplot
        (make-lattice 'scv "~a-scv-lattice.png")
        (make-lattice 'baseline "~a-baseline-lattice.png")
        (make-lattice #f "~a-lattice.png")))
