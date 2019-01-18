#lang racket

(require racket/cmdline)

(define in-place (make-parameter #f))

(define (command-parse argv)
  (command-line
   #:program "explicit-contracts"
   #:argv argv
   #:once-each
   [("-i" "--in-place") "edit files in place"
                        (in-place #t)]
   #:args targets
   targets))

(module+ main
  (command-parse (current-command-line-arguments)))
