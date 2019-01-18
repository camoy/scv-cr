#lang racket

(require racket/cmdline)
(provide intercept-require-contracts
         intercept-provide-contracts)

(define require-contracts (make-parameter (box #f)))
(define provide-contracts (make-parameter (box #f)))
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
  (define require-hash (box '()))
  (define provide-hash (box '()))
  (parameterize ([require-contracts require-hash]
                 [provide-contracts provide-hash])
    target))

(define ((intercept-contracts parameter) stx)
  (displayln stx)
  (let* ([contracts-box (parameter)]
         [contracts-list (unbox contracts-box)])
    (when contracts-list
      (set-box! contracts-box
                (cons stx contracts-list)))))

(define-values
  (intercept-require-contracts intercept-provide-contracts)
  (values (intercept-contracts require-contracts)
          (intercept-contracts provide-contracts)))

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
