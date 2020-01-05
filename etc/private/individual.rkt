#lang racket/base

(provide individual-functions
         save-pict*)

(require (for-syntax racket/base)
         racket/runtime-path
         racket/path
         racket/file
         racket/vector
         racket/draw
         racket/class
         pict
         math/statistics
         gtp-plot/configuration-info
         gtp-plot/typed-racket-info
         gtp-plot/sample-info
         gtp-plot/plot
         gtp-plot/util
         gtp-plot/performance-info
         "util.rkt"
         "data-lattice.rkt"
         "../config.rkt")


(*OVERHEAD-PLOT-HEIGHT* 250)
(*OVERHEAD-PLOT-WIDTH* 800)
(*OVERHEAD-SHOW-RATIO* #f)
(*OVERHEAD-MAX* 10)
(*OVERHEAD-SAMPLES* 100)
(*POINT-SIZE* 6)
(*POINT-ALPHA* 0.5)
(*AUTO-POINT-ALPHA?* #f)
(*FONT-SIZE* PLOT-LABEL-SIZE)
(*POINT-COLORS* COLOR-SCHEME)

(define-runtime-path figures-dir
  (build-path ".." "measurements" "figures"))

(make-directory* figures-dir)

(define (overhead benchmark samples baseline _ __)
  (define overhead-pict
    (overhead-plot (list baseline samples)
                   (string->symbol benchmark)))
  (define overhead-path
    (build-path figures-dir (format "~a-overhead" benchmark)))
  (save-pict* overhead-path overhead-pict)
  (define overhead0-pict
    (overhead-plot (list baseline)
                   (string->symbol benchmark)))
  (define overhead0-path
    (build-path figures-dir (format "~a-overhead-only-baseline" benchmark)))
  (save-pict* overhead0-path overhead0-pict))

(define (samples benchmark _ __ samples baseline)
  (define samples-pict
    (samples-plot samples))
  (define samples-path
    (build-path figures-dir (format "~a-samples" benchmark)))
  (save-pict* samples-path samples-pict))

(define (exact benchmark samples baseline _ __)
  (define exact-pict
    (exact-runtime-plot (list baseline samples)
                        (string->symbol benchmark)))
  (define exact-path
    (build-path figures-dir (format "~a-exact" benchmark)))
  (save-pict* exact-path exact-pict)
  (define exact0-pict
    (exact-runtime-plot (list baseline)
                        (string->symbol benchmark)))
  (define exact0-path
    (build-path figures-dir (format "~a-exact-only-baseline" benchmark)))
  (save-pict* exact0-path exact0-pict))

(define (scatterplot benchmark _ __ samples baseline)
  (define scatterplot-pict
    (parameterize ([*POINT-SIZE* 10])
      (relative-scatterplot baseline samples)))
  (define scatterplot-path
    (build-path figures-dir (format "~a-scatterplot" benchmark)))
  (save-pict* scatterplot-path scatterplot-pict))

(define (average-results samples)
  (for/vector ([config (in-configurations samples)])
    (define runtimes
      (configuration-info->runtime* config))
    (cons (mean runtimes)
          (stddev runtimes))))

(define ((make-lattice jo format-name) benchmark samples baseline _ __)
  (define height
    (performance-info->num-units (car (sample-info->performance-info* samples))))
  (when (<= height 6)
    ;; lattices
    (define lattice-pict
      (make-performance-lattice (average-results samples)
                                (average-results baseline)
                                #:just-one jo))
    (define lattice-path
      (build-path figures-dir (format format-name benchmark)))
    (save-pict* lattice-path lattice-pict)))

(define individual-functions
  (list overhead
        #;samples
        exact
        #;scatterplot
        (make-lattice 'scv "~a-scv-lattice")
        (make-lattice 'baseline "~a-baseline-lattice")
        (make-lattice #f "~a-lattice")))
