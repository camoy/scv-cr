#lang racket

(require racket/cmdline
         racket/serialize
         (for-syntax racket/syntax))

(define require-mapping-file "_require-mappings.dat")
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
      (displayln (get-require-mapping))
      (displayln (get-require-contracts))
      (displayln (get-provide-contracts)))
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

(define-syntax (generate-data-handlers stx)
  (syntax-case stx ()
    [(_ handler filename)
     (with-syntax ([getter-id (format-id #'handler "get-~a" #'handler)]
                   [setter-id (format-id #'handler "set-~a" #'handler)]
                   [intercept-id (format-id #'handler "intercept-~a" #'handler)])
       #`(begin
           (define getter-id (file->data filename))
           (define setter-id (data->file filename))
           (define intercept-id (intercept-contracts getter-id setter-id))
           (provide intercept-id)))]))

(generate-data-handlers require-mapping require-mapping-file)
(generate-data-handlers require-contracts require-contracts-file)
(generate-data-handlers provide-contracts provide-contracts-file)

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
