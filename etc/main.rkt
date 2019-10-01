#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(require (for-syntax racket/base)
         racket/runtime-path
         racket/vector
         racket/tcp
         racket/path
         racket/file
         basedir
         "config.rkt"
         "private/report.rkt")

(define benchmark-root-dir
  (vector-ref (current-command-line-arguments) 0))
(define blame-box (box '()))
(define default-bin-dir "/usr/bin")
(define gtp-dir
  (writable-data-dir #:program "gtp-measure"))
(define-runtime-path scv-bin-dir "bin")
(define-runtime-path scv-measurements-dir
  (build-path "measurements" "scv"))
(define-runtime-path baseline-measurements-dir
  (build-path "measurements" "baseline"))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; String Boolean -> Vector
;; Returns vector of correct command line arguments for gtp-measure
(define (gtp-setup-argv benchmark-dir scv?)
  (define base-argv
    (vector "-c" (number->string CUTOFF)
            "-i" (number->string ITERATIONS)
            "-S" (number->string SAMPLE-FACTOR)
            "-R" (number->string NUM-SAMPLES)
            "--setup" (path->string benchmark-dir)))
  (if scv?
      (vector-append (vector "--bin" (path->string scv-bin-dir)) base-argv)
      (vector-append (vector "--bin" default-bin-dir) base-argv)))

;; Vector ->
;; Run gtp-measure with argv as command line arguments
(define (gtp-measure argv)
  (parameterize ([current-command-line-arguments argv]
                 [current-namespace (make-base-empty-namespace)])
    (dynamic-require '(submod gtp-measure/private/raco main) #f)))

;; Listen for blame information and place in the blame box if you get something
;; Rinse and repeat
(define (listen-for-blames!)
  (define port 8182)
  (define listener (tcp-listen port))
  (define (loop)
    (thread (lambda ()
              (define-values (in out) (tcp-accept listener))
              (set-box! blame-box (cons (read in) (unbox blame-box)))
              (close-input-port in)
              (close-output-port out)
              (loop)))
    (void))
  (loop))

;; String -> Natural
;; Returns number of modules in the configuration of a given benchmark
(define (benchmark->modules benchmark-dir)
  (length (filter (λ (path)
                    (path-has-extension? path #".rkt"))
                  (directory-list (build-path benchmark-dir "typed")))))

;; String -> String
;; Returns bitstring of the fully typed configuration
(define (benchmark->typed-bitstring benchmark-dir)
  (make-string (benchmark->modules benchmark-dir) #\1))

;; String -> String
;; Returns bitstring of the fully untyped configuration
(define (benchmark->untyped-bitstring benchmark-dir)
  (make-string (benchmark->modules benchmark-dir) #\0))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(when (directory-exists? gtp-dir)
  (delete-directory/files gtp-dir))

(listen-for-blames!)
(for ([benchmark     (in-list BENCHMARKS)]
      [benchmark-idx (in-naturals 1)])
  (define benchmark-dir
    (build-path benchmark-root-dir benchmark))
  (define gtp-measure-benchmark-dir
    (build-path gtp-dir (number->string benchmark-idx)))
  (define config-rktd
    (build-path gtp-measure-benchmark-dir "config.rktd"))
  (define typed-in
    (build-path gtp-measure-benchmark-dir
                (format "0-~a-typed.in" benchmark)))
  (define untyped-in
    (build-path gtp-measure-benchmark-dir
                (format "0-~a-untyped.in" benchmark)))
  (define blame-report
    (build-path scv-measurements-dir
                (format "~a-blames.html" benchmark)))
  (define resume-argv
    (vector "--resume" (path->string gtp-measure-benchmark-dir)))

  ;; Setup
  (set-box! blame-box '())
  (gtp-measure (gtp-setup-argv benchmark-dir #t))

  ;; Run (SCV)
  (gtp-measure resume-argv)

  ;; Generate report
  (make-directory* scv-measurements-dir)
  (with-output-to-file blame-report
    #:exists 'replace
    (λ ()
      (benchmark->blame-report benchmark
                               benchmark-idx
                               gtp-measure-benchmark-dir
                               (reverse (unbox blame-box)))))

  ;; Add and run typed and untyped inputs (SCV)
  (with-output-to-file typed-in
    (λ () (displayln (benchmark->typed-bitstring benchmark-dir))))
  (with-output-to-file untyped-in
    (λ () (displayln (benchmark->untyped-bitstring benchmark-dir))))
  (gtp-measure resume-argv)

  ;; Collect measurements (SCV)
  (for ([path (in-directory gtp-measure-benchmark-dir)]
        #:when (path-has-extension? path #".out"))
    (copy-file path
               (build-path scv-measurements-dir
                           (file-name-from-path path))
               #t)
    (delete-file path))

  ;; Modify bin for baseline
  (define config-hash
    (read (open-input-file config-rktd)))
  (define baseline-argv
    (vector->list (gtp-setup-argv benchmark-dir #f)))
  (with-output-to-file config-rktd
    #:exists 'replace
    (λ () (write (hash-set config-hash 'argv baseline-argv))))

  ;; Run (baseline)
  (gtp-measure resume-argv)

  ;; Collect measurements (baseline)
  (make-directory* baseline-measurements-dir)
  (for ([path (in-directory gtp-measure-benchmark-dir)]
        #:when (path-has-extension? path #".out"))
    (copy-file path
               (build-path baseline-measurements-dir
                           (file-name-from-path path))
               #t)
    (delete-file path))
  )
