#lang racket

(require racket/serialize)

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
      (with-output-to-file current-filename #:exists 'replace
        (λ () (write (serialize data)))))

    (define/public (reset-data)
      (when (file-exists? current-filename)
        (delete-file current-filename)))

    (define/public (intercept stx)
      (set-data (cons (syntax->datum stx)
                      (get-data)))
      stx)))

(define require-mapping-store
  (new store% [filename "_require-mappings.dat"]))
(define require-contracts-store
  (new store% [filename "_require-contracts.dat"]))
(define provide-contracts-store
  (new store% [filename "_provide-contracts.dat"]))
(define all-stores
  (list require-mapping-store
        require-contracts-store
        provide-contracts-store))

(provide require-mapping-store
         require-contracts-store
         provide-contracts-store
         all-stores)
