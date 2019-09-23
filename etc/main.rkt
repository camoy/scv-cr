#lang racket/base

(require racket/vector
         racket/file
         racket/list
         racket/string
         racket/path
         racket/function
         racket/port
         racket/tcp
         "config.rkt"
         (prefix-in report: "report.rkt")
         (prefix-in plot: "plot.rkt"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (gtp-measure argv)
  (parameterize ([current-command-line-arguments argv]
                 [current-namespace (make-base-empty-namespace)])
    (dynamic-require '(submod gtp-measure/private/raco main) #f)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define port 8182)
(define listener (tcp-listen port))
(define blames (box '()))
(define (loop)
  (thread (lambda ()
            (define-values (in out) (tcp-accept listener))
            (set-box! blames (cons (read in) (unbox blames)))
            (close-input-port in)
            (close-output-port out)
            (loop)))
  (void))
(loop)

(define is-out? (curryr path-has-extension? #".out"))

(define (get-data benchmark k dir)
  (define outs (filter is-out? (directory-list dir)))
  (define path->number
    (let ([prefix-length
           (string-length (string-append (number->string k) "-" benchmark))])
      (λ (p)
        (define n (substring (path->string (path-replace-extension p #""))
                             prefix-length))
        (if (non-empty-string? n) (string->number n) 0))))
  (define (<* x y)
    (< (path->number x) (path->number y)))
  (append-map
   (λ (x)
     (define f (open-input-file (build-path dir x)))
     (let go ([xs '()]
              [x  (read f)])
       (if (eof-object? x) (reverse xs) (go (cons x xs) (read f)))))
   (sort outs <*)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define dats
  (for/list ([benchmark (in-list benchmarks)]
             [k         (in-naturals 1)])
    (set-box! blames '())
    (displayln (format "Starting: ~a" benchmark))
    (define benchmark-arg
      (vector "--setup"
              (path->string (build-path benchmark-dir benchmark))))
    (define argv-setup* (vector-append argv-setup benchmark-arg))
    (define gtp-dir* (build-path gtp-dir (number->string k)))
    (define argv-resume (vector "--resume" (path->string gtp-dir*)))
    (unless (directory-exists? gtp-dir*)
      (gtp-measure argv-setup*))
    (define outs (filter is-out? (directory-list gtp-dir*)))
    (for ([out (in-list outs)])
      (delete-file (build-path gtp-dir* out)))
    (gtp-measure argv-resume)
    (define benchmark-assoc
      (for/list ([data  (get-data benchmark k gtp-dir*)]
                 [blame (reverse (unbox blames))])
        (define-values (conf perf)
          (values (first data)
                  (second data)))
        (list conf perf blame)))
    (define dat-file (build-path "results" (string-append benchmark ".dat")))
    (with-output-to-file dat-file
      #:exists 'replace
      (λ () (write benchmark-assoc)))
    dat-file))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(report:main dats)
(plot:main)
