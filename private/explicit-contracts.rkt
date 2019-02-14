#lang racket

(require racket/cmdline
         racket/hash
         tr-contract/private/parameters
         tr-contract/private/utils
         tr-contract/private/inject
         tr-contract/private/store/all
         tr-contract/private/store
         (for-syntax racket/syntax))

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
      (λ ()
        (map (λ (store) (send store make))
             all-stores))
      (λ ()
        (filter extract-contracts targets))
      (λ ()
        (map (λ (store)
               (send store delete)
               (send store finalize))
             all-stores))))

  (for-each process-contracts tr-modules)
  )

(define (process-contracts target)
  (define new-target
    (inject-contracts target))
  (if (in-place)
      (module->file new-target target)
      (displayln (module->string new-target))))

(define (extract-contracts target)
  (define return (load-module target))
  (map (λ (store) (send store load)) all-stores)
  return)

(define (command-parse argv)
  (command-line
   #:program "explicit-contracts"
   #:argv argv
   #:once-each
   [("-i" "--in-place") "edit files in place"
                        (in-place #t)]
   [("-p" "--only-provides") "only provide contracts"
                             (only-provide #t)]
   #:args targets
   targets))
