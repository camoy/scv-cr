#lang racket

(require racket/cmdline)

(define tr-provide-contracts (make-parameter (void)))
(define tr-require-contracts (make-parameter (void)))
(define in-place (make-parameter #f))

(module+ main
  (define targets
    (command-parse (current-command-line-arguments)))

  (unless (andmap file-exists? targets)
    (define unknown-file
      (findf (negate file-exists?) targets))
    (raise-user-error 'explicit-contracts "could not find ~s" unknown-file))

  (define tr-targets
    (filter typed-module? targets))

  (for-each explicit-contracts tr-targets))

(define (explicit-contracts target)
  (define provide-hash (make-hash))
  (define require-hash (make-hash))
  (parameterize ([tr-provide-contracts provide-hash]
                 [tr-require-contracts require-hash])
    target))

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
