#lang racket/base

(require racket/runtime-path
         racket/vector
         racket/file
         racket/list
         racket/string
         racket/path
         racket/function
         racket/port
         racket/tcp
         basedir)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define benchmark-dir "/home/camoy/wrk/gtp-benchmarks/benchmarks")
(define gtp-dir (writable-data-dir #:program "gtp-measure"))
(define-runtime-path fake-bin "fakebin")
(define benchmarks '("sieve"
                     "morsecode"
                     "fsm"
                     "snake"
                     "suffixtree"
                     "tetris"))
(define argv-setup
  (vector "-c" "4"
          "-i" "8"
          "-S" "1"
          "-R" "6"
          "--bin" (path->string fake-bin)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (dynamic-require* mod)
  (parameterize ([current-namespace (make-base-empty-namespace)])
    (dynamic-require mod #f)))

(define (gtp-measure argv)
  (define-values (out err)
    (values (open-output-string)
            (open-output-string)))
  (parameterize ([current-command-line-arguments argv]
                 [current-output-port out]
                 [current-error-port err])
    (dynamic-require* '(submod gtp-measure/private/raco main)))
  (values (get-output-string out)
          (get-output-string err)))

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

(define (get-data benchmark k dir)
  (define is-out? (curryr path-has-extension? #".out"))
  (define outs (filter is-out? (directory-list dir)))
  (define path->number
    (let ([prefix-length (string-length (string-append (number->string k) "-" benchmark))])
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

(delete-directory/files gtp-dir #:must-exist? #f)

(for ([benchmark (in-list benchmarks)]
      [k         (in-naturals 1)])
  (displayln (format "Starting: ~a" benchmark))
  (define benchmark-arg
    (vector "--setup"
            (path->string (build-path benchmark-dir benchmark))))
  (define argv-setup* (vector-append argv-setup benchmark-arg))
  (define gtp-dir* (build-path gtp-dir (number->string k)))
  (define argv-resume (vector "--resume" (path->string gtp-dir*)))
  (gtp-measure argv-setup*)
  (gtp-measure argv-resume)
  (define benchmark-assoc
    (for/list ([data  (get-data benchmark k gtp-dir*)]
               [blame (reverse (unbox blames))])
      (define-values (conf perf)
        (values (first data)
                (second data)))
      (list conf perf blame)))
  (with-output-to-file (string-append benchmark ".dat") #:exists 'replace
    (λ () (write benchmark-assoc))))
