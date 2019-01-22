#lang racket

(require racket/serialize
         racket/syntax)

(provide store%)

(define store%
  (class object%
    (init filename)
    (define current-filename filename)
    (super-new)

    (define/public (get-data target)
      (define normalized-path
        (simplify-path (path->complete-path target)))
      (hash-ref (get-hash)
                normalized-path
                '()))

    (define/public (get-hash)
      (deserialize (with-input-from-file current-filename read)))

    (define/public (set-hash current-hash)
      (with-output-to-file current-filename #:exists 'replace
        (λ () (write (serialize current-hash)))))

    (define/public (init-data)
      (with-output-to-file current-filename
        (λ () (write (serialize (make-hash))))))

    (define/public (reset-data)
      (when (file-exists? current-filename)
        (delete-file current-filename)))

    (define/public (show target)
      (pretty-format (get-data target)))

    (define/public (intercept target-path stx)
      (when (file-exists? current-filename)
        (define target
          (resolved-module-path-name target-path))
        (define current-hash (get-hash))
        (define file-record
          (hash-ref current-hash target '()))
        (hash-set! current-hash
                   target
                   (cons (syntax->datum stx)
                         file-record))
        (set-hash current-hash))
      stx)

    ))
