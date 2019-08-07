#lang racket/base

(require racket/match
         racket/list
         racket/function
         racket/path
         basedir)

(define r #px"cpu time: (\\d+) real time: (\\d+) gc time: (\\d+)")
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
(define gtp-dir (writable-data-dir #:program "gtp-measure"))
(define is-out? (curryr path-has-extension? #".out"))

(for ([f (directory-list gtp-dir)])
  (for ([f* (directory-list (build-path gtp-dir f))])
    (define f** (build-path gtp-dir f f*))
    (when (is-out? f**)
      ;; second means use real time not CPU time
      (define benchmark-name (second (regexp-match #px"\\d-(.+)\\.out" f**)))
      (define out-name (format "~a-v~a-~a.rktd" benchmark-name (version) "scv-gt"))
      (with-output-to-file (build-path gtp-dir f out-name)
        (λ ()
          (display (out->data f**)))))))
