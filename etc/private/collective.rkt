#lang errortrace at-exp racket/base

(require (for-syntax racket/base)
         racket/format
         racket/string
         racket/runtime-path
         racket/function
         racket/path
         racket/file
         gtp-plot/performance-info
         gtp-plot/util
         plot)

(provide collective-functions)

(define-runtime-path figures-dir
  (build-path ".." "measurements" "figures"))

(make-directory* figures-dir)

(define (summary-statistics-template results)
  (define results*
    (string-join (map (λ (x) (string-join x " & ")) results)
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
  (define (convert x) (real->decimal-string x 1))
  (with-output-to-file summary-path
    #:exists 'replace
    (λ ()
      (displayln
       (summary-statistics-template
        (for/list ([benchmark benchmarks]
                   [sample samples]
                   [baseline baselines])
          (list benchmark
                (convert (max-overhead baseline))
                (convert (mean-overhead baseline))
                (convert (max-overhead sample))
                (convert (mean-overhead sample)))))))))

(define SLOWDOWN-X-MAX 6)
(define SLOWDOWN-GRANULARITY 0.1)
(line-width 3)

(define (slowdown-plot benchmarks samples baselines)
  (define slowdown-path
    (build-path figures-dir "slowdown.png"))
  (define slowdown-pict
    (plot-pict (list (parameterize ([line-color "blue"])
                       (lines (slowdown-points benchmarks samples)))
                     (lines (slowdown-points benchmarks baselines)))
               #:x-min 1
               #:x-max SLOWDOWN-X-MAX
               #:x-label ""
               #:y-label ""))
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
