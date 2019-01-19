#lang racket

(require racket/serialize
         racket/syntax)

(provide store%)

(define store%
  (class object%
    (init filename)
    (define current-filename filename)
    (super-new)

    (define/public (get-data)
      (if (file-exists? current-filename)
          (with-input-from-file current-filename
            (λ () (deserialize (read))))
          '()))

    (define/public (set-data data)
      (when (file-exists? current-filename)
        (with-output-to-file current-filename #:exists 'replace
          (λ () (write (serialize data))))))

    (define/public (init-data)
      (with-output-to-file current-filename
        (λ () (write (serialize '())))))

    (define/public (reset-data)
      (when (file-exists? current-filename)
        (delete-file current-filename)))

    (define/public (show)
      (pretty-format (get-data)))

    (define/public (intercept stx)
      (set-data (cons (syntax->datum stx)
                      (get-data)))
      stx)))
