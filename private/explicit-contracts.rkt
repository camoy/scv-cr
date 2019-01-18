#lang racket

(require racket/cmdline)
(define in-place (make-parameter #f))

(module+ main
  (define targets (command-parse (current-command-line-arguments)))
  (unless (files-exist? targets)
    (define unknown-file (findf (negate file-exists?) targets))
    (raise-user-error 'explicit-contracts "could not find ~s" unknown-file))
  targets)

(define (command-parse argv)
  (command-line
   #:program "explicit-contracts"
   #:argv argv
   #:once-each
   [("-i" "--in-place") "edit files in place"
                        (in-place #t)]
   #:args targets
   targets))

(define (files-exist? files)
  (andmap file-exists? files))

