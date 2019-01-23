#lang racket

(require racket/cmdline
         racket/hash
         tr-contract/private/inject
         tr-contract/private/store
         (for-syntax racket/syntax))

(define in-place (make-parameter #f))

(module+ main
  (define targets
    (command-parse (current-command-line-arguments)))

  (unless (andmap file-exists? targets)
    (define unknown-file
      (findf (negate file-exists?) targets))
    (raise-user-error 'explicit-contracts
                      "could not find ~s"
                      unknown-file))

  (define tr-modules
    (dynamic-wind
      (λ () (map persistent-init persistent-all))
      (λ () (filter extract-contracts targets))
      (λ () (map persistent-delete persistent-all))))

  (displayln store-all)
  )

#;(define (process-contracts target)
  (define provide-contracts
    (send provide-contracts-store process target))
  (define new-target
    (inject-contracts target provide-contracts))
  (if (in-place)
      (module->file new-target target)
      (displayln (module->string new-target))))

(define (extract-contracts target)
  (load-module target)
  (map store-load store-all))

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
