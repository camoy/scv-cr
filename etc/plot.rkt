#lang racket/base

(provide main)

(require gtp-plot/typed-racket-info
         gtp-plot/plot
         gtp-plot/util
         racket/path
         racket/match
         racket/list
         racket/function
         "data-lattice.rkt"
         "config.rkt"
         basedir)

(define r #px"cpu time: (\\d+) real time: (\\d+) gc time: (\\d+)")
(define gtp-dir (writable-data-dir #:program "gtp-measure"))
(define is-out? (curryr path-has-extension? #".out"))

(*OVERHEAD-PLOT-HEIGHT* 400)
(*OVERHEAD-PLOT-WIDTH* 800)
(*OVERHEAD-SHOW-RATIO* #f)
(*FONT-SIZE* 24)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (out->data out-file)
  (define outs
    (with-input-from-file out-file
      (λ ()
        (let go ()
          (define datum (read))
          (if (eof-object? datum)
              '()
              (cons datum (go)))))))
  (for/vector ([out outs])
    (match out
      [(list config runtimes)
       (for/list ([runtime (in-list runtimes)])
         (string->number (second (cdr (regexp-match r runtime)))))])))

(define (out->rktd)
  (for ([f (directory-list gtp-dir)])
    (for ([f* (directory-list (build-path gtp-dir f))])
      (define f** (build-path gtp-dir f f*))
      (when (is-out? f**)
        ;; second means use real time not CPU time
        (define benchmark-name (second (regexp-match #px"\\d-(.+)\\.out" f**)))
        (define out-name
          (build-path "results" (format "~a-v~a-~a.rktd"
                                        benchmark-name
                                        (version)
                                        "scv-gt")))
        (with-output-to-file out-name
          #:exists 'replace
          (λ ()
            (display (out->data f**))))))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (main)
  (out->rktd)
  (define infos
    (for/list ([benchmark (in-list benchmarks)])
      ;; overhead plots
      (define data (build-path "results" (format "~a-v~a-scv-gt.rktd"
                                                 benchmark
                                                 (version))))
      (define info (make-typed-racket-info data))
      (define overhead-pict (overhead-plot info))
      (save-pict (build-path (path-only data) (format "~a-plot.png" benchmark))
                 overhead-pict)

      ;; lattices
      (define lattice-pict (file->performance-lattice data))
      (save-pict (build-path "results" (format "~a-lattice.png" benchmark))
                 lattice-pict)

      ;; return info
      info))

  ;; overhead grid
  (define overheads-pict (grid-plot overhead-plot infos))
  (save-pict (build-path "results" "all-plots.png")
             overheads-pict))
