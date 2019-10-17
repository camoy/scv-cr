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

(define blame-box (box '()))
(define gtp-dir
  (writable-data-dir #:program "gtp-measure"))
(define-runtime-path scv-bin-dir "bin_scv")
(define-runtime-path baseline-bin-dir "bin_baseline")
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
      (vector-append (vector "--bin" DEFAULT-BIN-DIR) base-argv)))

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
    (build-path BENCHMARK-ROOT-DIR benchmark))
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
  (with-output-to-file config-rktd
    #:exists 'replace
    (λ () (write (hash-set config-hash 'bin (path->string baseline-bin-dir)))))

  ;; Move original Typed Racket directory into place and back
  (define-values (tmp-dir mod-dir orig-dir)
    (values
     (simplify-path (build-path MODIFIED-TR-DIR ".." "hopefully_fresh_name"))
     (string->path MODIFIED-TR-DIR)
     (string->path ORIGINAL-TR-DIR)))

  (dynamic-wind
    ;; Place regular TR
    (λ ()
      (rename-file-or-directory mod-dir tmp-dir)
      (rename-file-or-directory orig-dir mod-dir))

    ;; Run (baseline)
    (λ ()
      (gtp-measure resume-argv))

    ;; Place modified TR
    (λ ()
      (rename-file-or-directory mod-dir orig-dir)
      (rename-file-or-directory tmp-dir mod-dir)
      ))

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
