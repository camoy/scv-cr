#lang racket

(require racket/cmdline
         tr-contract/private/stores
         (for-syntax racket/syntax))

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
    (for ([store all-stores])
      (send store reset-data)))

  (dynamic-wind
    reset-contract-data
    (λ ()
      (define is-tr (load-module target))
      (when is-tr
        (for ([store all-stores])
          (displayln (send store get-data)))))
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

(define (load-module module-path)
  (module-declared? `(submod ,module-path #%type-decl) #t))
