#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require (for-syntax racket/base)
         mischief/for
         gtp-plot/typed-racket-info
         gtp-plot/plot
         gtp-plot/util
         racket/runtime-path
         racket/function
         racket/path
         racket/list
         racket/match
         racket/vector
         basedir
         "config.rkt"
         "private/individual.rkt"
         "private/collective.rkt")

(define time-regexp
  #px"cpu time: (\\d+) real time: (\\d+) gc time: (\\d+)")
(define-runtime-path baseline-dir (build-path "measurements" "baseline"))
(define-runtime-path scv-dir (build-path "measurements" "scv"))
(define is-out?
  (curryr path-has-extension? #".out"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (runtime->number runtime)
  (define regexp-result
    (regexp-match time-regexp runtime))
  (if regexp-result
      (string->number (second (cdr regexp-result)))
      (error (format "bad runtime ~a" runtime))))

(define (out->sample-list out-path)
  (with-input-from-file out-path
    (λ ()
      (let go ()
        (define datum (read))
        (if (eof-object? datum)
            '()
            (cons datum (go)))))))

(define (config-data->config-info config-data)
  (match config-data
    [(list config runtimes)
     (make-typed-racket-configuration-info
      config
      (map runtime->number runtimes))]))

(define (benchmark->configurations benchmark out-dir)
  (define out-paths
    (filter (λ (path)
              (regexp-match (pregexp (format "0-~a\\d*\\.out" benchmark))
                            (file-name-from-path path)))
            (directory-list out-dir #:build? #t)))
  (for/list ([out-path (in-list out-paths)])
    (define sample (out->sample-list out-path))
    (for/list ([config-data (in-list sample)])
      (config-data->config-info config-data))))

(define (benchmark->samples benchmark baseline?)
  (define out-dir
    (if baseline? baseline-dir scv-dir))
  (define configs
    (benchmark->configurations benchmark out-dir))
  (define typed-path
    (build-path out-dir (format "0-~a-typed.out" benchmark)))
  (define typed-config
    (config-data->config-info (first (out->sample-list typed-path))))
  (define untyped-path
    (build-path out-dir (format "0-~a-untyped.out" benchmark)))
  (define untyped-config
    (config-data->config-info (first (out->sample-list untyped-path))))
  (values
   (make-typed-racket-sample-info
    configs
    #:name (if baseline? BASELINE-LABEL SCV-LABEL)
    #:typed-configuration typed-config
    #:untyped-configuration untyped-config)
   (make-typed-racket-sample-info
    configs
    #:name (string->symbol benchmark)
    #:typed-configuration typed-config
    #:untyped-configuration untyped-config)))

(define-values (samples baselines)
  (for/lists (samples baselines)
             ([benchmark (in-list BENCHMARKS)])
    (define-values (samples samples*)
      (benchmark->samples benchmark #f))
    (define-values (baseline baseline*)
      (benchmark->samples benchmark #t))
    (for ([fun (in-list individual-functions)])
      (fun benchmark samples baseline samples* baseline*))
    (values samples baseline)))

(for ([fun (in-list collective-functions)])
  (fun BENCHMARKS samples baselines))
