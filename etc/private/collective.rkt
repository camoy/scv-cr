#lang at-exp racket/base

(require (for-syntax racket/base)
         racket/format
         racket/string
         racket/runtime-path
         racket/function
         racket/path
         racket/file
         "data-lattice.rkt"
         gtp-plot/performance-info
         gtp-plot/util
         gtp-plot/plot
         plot
         "../config.rkt")

(provide collective-functions)

(define-runtime-path figures-dir
  (build-path ".." "measurements" "figures"))

(make-directory* figures-dir)

(define (color x)
  (if (number? x)
      (let ([x* (real->decimal-string x 1)])
        (cond
          [(<= x (*LATTICE-GREEN-THRESHOLD*))
           @~a{\cellcolor{rktpalegreen} @x*}]
          [(>= x (*LATTICE-RED-THRESHOLD*))
           @~a{\cellcolor{rktpink} @x*}]
          [else
           x*]))
      x))

(define (summary-statistics-template results)
  (define results*
    (string-join (map (λ (x)
                        (string-join (map color x) " & "))
                      results)
                 "\\\\"))
  @~a{\begin{tabular}{ | c | c c | c c | }
  \hline
  & \multicolumn{2}{|c|}{Racket}
  & \multicolumn{2}{|c|}{Racket with SCV} \\
  \hline
  Benchmark
  & Max Overhead & Mean Overhead
  & Max Overhead & Mean Overhead \\
  \hline
  @results* \\
  \hline
  \end{tabular}})

(define (summary-statistics benchmarks samples baselines)
  (define summary-path
    (build-path figures-dir "summary.tex"))
  (with-output-to-file summary-path
    #:exists 'replace
    (λ ()
      (displayln
       (summary-statistics-template
        (for/list ([benchmark benchmarks]
                   [sample samples]
                   [baseline baselines])
          (list benchmark
                (max-overhead baseline)
                (mean-overhead baseline)
                (max-overhead sample)
                (mean-overhead sample))))))))

(define SLOWDOWN-X-MAX 6)
(define SLOWDOWN-GRANULARITY 0.1)
(line-width 3)

(define (->x-axis pts)
  (map (λ (p) (list (car p) 0)) pts))

(define (make-lines pts label [offset 0])
  (lines-interval(->x-axis pts)
                 pts
                 #:label (symbol->string label)
                 #:x-min 1
                 #:x-max SLOWDOWN-X-MAX
                 #:y-min 0
                 #:y-max 100
                 #:alpha (*INTERVAL-ALPHA*)
                 #:color (+ (*OVERHEAD-LINE-COLOR*) offset)
                 #:line1-style 'transparent
                 #:line2-color (+ (*OVERHEAD-LINE-COLOR*) offset)
                 #:line2-width (*OVERHEAD-LINE-WIDTH*)
                 #:line2-style 'solid))

(define ((ticks-format/units units) ax-min ax-max pre-ticks)
  (for/list ([pt (in-list pre-ticks)])
    (define v (pre-tick-value pt))
    (if (= v ax-max)
      (format "~a~a" (rnd+ v) units)
      (rnd+ v))))

(define (rnd+ n)
  (if (exact-integer? n)
    (number->string n)
    (rnd n)))

(define (slowdown-plot benchmarks samples baselines)
  (define slowdown-path
    (build-path figures-dir "slowdown.png"))
  (define-values (sample-points baseline-points)
    (values (slowdown-points benchmarks samples)
            (slowdown-points benchmarks baselines)))
  (define slowdown-pict
    (parameterize ([plot-x-ticks (ticks (linear-ticks-layout)
                                        (ticks-format/units "x"))]
                   [plot-y-ticks (ticks (linear-ticks-layout)
                                        (ticks-format/units "%"))])
      (plot-pict
       (list (make-lines sample-points SCV-LABEL)
             (make-lines baseline-points BASELINE-LABEL 1))
       #:title "Slowdown over Entire Benchmark"
       #:legend-anchor 'bottom-right
       #:width 450
       #:height 450
       #:x-label "Deliverability"
       #:y-label "Percent of Benchmark Suite")))
  (save-pict slowdown-path slowdown-pict))

(define (slowdown-points benchmarks within)
  (for/list ([x (in-range 1
                          (+ SLOWDOWN-X-MAX SLOWDOWN-GRANULARITY)
                          SLOWDOWN-GRANULARITY)])
    (list x
          (* (/ 100 (length benchmarks))
             (for/sum ([sample within])
               (percent-k-deliverable x sample))))))

(define (percent-k-deliverable k sample)
  (/ ((deliverable k) sample)
     (count-configurations sample (const #t))))

(define collective-functions
  (list summary-statistics
        slowdown-plot))
