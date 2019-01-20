#lang racket

(require racket/cmdline
         racket/hash
         tr-contract/private/store/require-mapping
         tr-contract/private/store/require-contracts
         tr-contract/private/store/provide-contracts
         tr-contract/private/inject
         (for-syntax racket/syntax))

(define in-place (make-parameter #f))
(define all-stores
  (list require-mapping-store
        require-contracts-store
        provide-contracts-store))
(define all-hashes
  (list (make-hash)
        (make-hash)
        (make-hash)))

(module+ main
  (define targets
    (command-parse (current-command-line-arguments)))

  (unless (andmap file-exists? targets)
    (define unknown-file
      (findf (negate file-exists?) targets))
    (raise-user-error 'explicit-contracts "could not find ~s" unknown-file))

  (define tr-modules
    (filter explicit-contracts targets))

  (for ([store-hash all-hashes]
        [store all-stores])
    (send store set-hash store-hash))

  (for ([target tr-modules])
    (process-contracts target))

  (for ([store all-stores])
    (send store reset-data)))

(define (process-contracts target)
  (define provide-contracts
    (send provide-contracts-store process target))
  (define new-target
    (inject-contracts target provide-contracts))
  (if (in-place)
      (module->file new-target target)
      (displayln (module->string new-target))))

(define (explicit-contracts target)
  (dynamic-wind
    (λ ()
      (for ([store all-stores])
        (send store init-data)))
    (λ ()
      (load-module target))
    (λ ()
      (for ([store-hash all-hashes]
            [store all-stores])
        (hash-union! store-hash (send store get-hash))
        (send store reset-data)))))

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
