#lang racket

(require racket/cmdline
         racket/serialize
         (for-syntax racket/syntax))

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
(define stores
  (list require-mapping-store
        require-contracts-store
        provide-contracts-store))
(provide require-mapping-store
         require-contracts-store
         provide-contracts-store)

(define in-place (make-parameter #f))

(module+ main
  (define targets
    (command-parse (current-command-line-arguments)))

  (unless (andmap file-exists? targets)
    (define unknown-file
      (findf (negate file-exists?) targets))
    (raise-user-error 'explicit-contracts "could not find ~s" unknown-file))

  (for-each explicit-contracts targets))

(define (explicit-contracts target)
  (define (reset-contract-data)
    (for ([store stores])
      (send store reset-data)))

  (dynamic-wind
    reset-contract-data
    (λ ()
      (typed-module? target)
      (for ([store stores])
        (displayln (send store get-data))))
    reset-contract-data))

(define (command-parse argv)
  (command-line
   #:program "explicit-contracts"
   #:argv argv
   #:once-each
   [("-i" "--in-place") "edit files in place"
                        (in-place #t)]
   #:args targets
   targets))

(define (typed-module? module-path)
  (module-declared? `(submod ,module-path #%type-decl) #t))
