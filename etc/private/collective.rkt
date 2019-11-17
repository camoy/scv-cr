#lang at-exp racket/base

(require (for-syntax racket/base)
         racket/format
         racket/pretty
         racket/string
         racket/runtime-path
         racket/function
         racket/path
         racket/file
         racket/list
         "individual.rkt"
         "data-lattice.rkt"
         gtp-plot/performance-info
         gtp-plot/sample-info
         gtp-plot/util
         gtp-plot/plot
         plot
         pict
         ppict
         "../config.rkt")

(provide collective-functions)
(*OVERHEAD-PLOT-HEIGHT* 300)
(*OVERHEAD-PLOT-WIDTH* 800)
(*OVERHEAD-SHOW-RATIO* #f)
(*OVERHEAD-MAX* 10)
(*FONT-SIZE* PLOT-LABEL-SIZE)

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

(define (max-overhead* pi)
  (overhead pi (fold/mean-runtime pi max #:init #f)))

(define (mean-overhead* pi)
  (define 1/N
    (/ 1 (* (sample-info->sample-size pi)
            (sample-info->num-samples pi))))
  (define (avg acc v)
    (+ acc (* 1/N v)))
  (overhead pi (fold/mean-runtime pi avg #:init (λ (v) (* 1/N v)))))

(define (summary-statistics-template results)
  (define results*
    (string-join (map (λ (x)
                        (string-join (map color x) " & "))
                      results)
                 "\\\\"))
  @~a{\begin{tabular}{ | c | c c | c c | }
  \hline
  & \multicolumn{2}{|c|}{Racket Overhead}
  & \multicolumn{2}{|c|}{\tool Overhead} \\
  \hline
  Benchmark
  & \hspace{0.65em}Max\hspace{0.65em} & Mean
  & \hspace{0.65em}Max\hspace{0.65em} & Mean \\
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
          (list (format "\\textsc{~a}" benchmark)
                (max-overhead* baseline)
                (mean-overhead* baseline)
                (max-overhead* sample)
                (mean-overhead* sample))))))))

(define SLOWDOWN-X-MAX 10)
(define SLOWDOWN-GRANULARITY 0.1)
(line-width 3)

(define (->x-axis pts)
  (map (λ (p) (list (car p) 0)) pts))

(define (make-lines pts label color)
  (lines-interval (->x-axis pts)
                  pts
                  ;; #:label (symbol->string label)
                  #:x-min 1
                  #:x-max SLOWDOWN-X-MAX
                  #:y-min 0
                  #:y-max 100
                  #:alpha 0.5 #;(*INTERVAL-ALPHA*)
                  #:color color
                  #:line1-style 'transparent
                  #:line2-color color
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
    (build-path figures-dir "slowdown"))
  (define-values (sample-points baseline-points configs)
    (values (slowdown-points benchmarks samples)
            (slowdown-points benchmarks baselines)
            (all-configs samples)))
  (define slowdown-pict
    (parameterize ([*OVERHEAD-LABEL?* #t])
    (overhead-plot*
     (list (car baselines) (car samples))
     (list (make-lines sample-points SCV-LABEL (second COLOR-SCHEME))
           (make-lines baseline-points BASELINE-LABEL (first COLOR-SCHEME)))
     '||
     configs)))
     #|
    (parameterize ([plot-x-ticks (ticks (linear-ticks-layout)
                                        (ticks-format/units "x"))]
                   [plot-y-ticks (ticks (linear-ticks-layout)
                                        (ticks-format/units "%"))])
      (overhead-plot*
       (list (make-lines sample-points SCV-LABEL (second COLOR-SCHEME))
             (make-lines baseline-points BASELINE-LABEL (first COLOR-SCHEME)))
       "Slowdown over Entire Benchmark Suite")
      #;(plot-pict
       (list (make-lines sample-points SCV-LABEL (second COLOR-SCHEME))
             (make-lines baseline-points BASELINE-LABEL (first COLOR-SCHEME)))
       #:title "Slowdown over Entire Benchmark Suite"
       #:legend-anchor 'bottom-right
       #:width 450
       #:height 450
       #:x-label "Deliverability"
       #:y-label "Percent of Benchmark Suite")))
|#
  (save-pict* slowdown-path slowdown-pict))

(define (slowdown-points benchmarks within)
  (for/list ([x (in-range 1
                          (+ SLOWDOWN-X-MAX SLOWDOWN-GRANULARITY)
                          SLOWDOWN-GRANULARITY)])
    (list x
          (* (/ 100 (length benchmarks))
             (for/sum ([sample within])
               (percent-k-deliverable x sample))))))

(define (all-configs samples)
  (for/sum ([s samples])
    (count-configurations s (const #t))))

(define (percent-k-deliverable k sample)
  (/ ((deliverable k) sample)
     (count-configurations sample (const #t))))

(define (keys _1 _2 _3)
  (for ([c COLOR-SCHEME]
        [i (in-naturals)])
    (save-pict*
     (build-path figures-dir (format "key~a" i))
     (ppict-do
      (blank 20)
      #:go (coord 1/2 1/2 'cc)
      (filled-rounded-rectangle 15 15 #:color c #:draw-border? #f)))))

(define collective-functions
  (list summary-statistics
        slowdown-plot
        keys))
