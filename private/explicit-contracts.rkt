#lang racket

(require racket/cmdline
         racket/serialize)

(provide intercept-require-contracts
         intercept-provide-contracts)

(define require-contracts-file "_require-contracts.dat")
(define provide-contracts-file "_provide-contracts.dat")
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
    (delete-if-exists require-contracts-file)
    (delete-if-exists provide-contracts-file))
  
  (define (delete-if-exists filename)
    (when (file-exists? filename)
      (delete-file filename)))

  (dynamic-wind
    reset-contract-data
    (λ ()
      (typed-module? target)
      (displayln (get-provide-contracts))
      (displayln (get-require-contracts)))
    reset-contract-data))

(define ((intercept-contracts getter setter) stx)
  (setter (cons (syntax->datum stx)
                (getter)))
  stx)

(define ((file->data filename))
  (if (file-exists? filename)
      (with-input-from-file filename
        (λ () (deserialize (read))))
      '()))

(define ((data->file filename) data)
  (with-output-to-file filename #:exists 'replace
    (λ () (write (serialize data)))))

(define-values
  (get-require-contracts get-provide-contracts)
  (values (file->data require-contracts-file)
          (file->data provide-contracts-file)))

(define-values
  (set-require-contracts set-provide-contracts)
  (values (data->file require-contracts-file)
          (data->file provide-contracts-file)))

(define-values
  (intercept-require-contracts intercept-provide-contracts)
  (values (intercept-contracts get-require-contracts set-require-contracts)
          (intercept-contracts get-provide-contracts set-provide-contracts)))

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
