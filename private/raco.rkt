#lang racket/base

(require racket/cmdline
         racket/function
         scv-gt/private/configure
         scv-gt/private/contract-inject
         scv-gt/private/contract-make
         scv-gt/private/contract-opt
         scv-gt/private/syntax-util)

;;
;; main
;;

(module+ main
  (let* ([argv         (current-command-line-arguments)]
         [targets      (parse argv)]
         [targets/tr   (filter is-tr? targets)]
         [stxs         (map syntax-fetch targets/tr)]
         [stxs/expand  (map expand/base+dir stxs targets/tr)]
         [ctcs         (map contract-make stxs/expand)]
         [stxs/ctc     (map contract-inject stxs ctcs)]
         [stxs/opt     (map contract-opt stxs/ctc)])
    (map syntax-compile targets/tr stxs/opt)))

;;
;; parsing
;;

(define (parse argv)
  (command-line
   #:program "scv-gt"
   #:argv argv
   #:once-each
   [("-s" "--show-contract")  "show contracts"
                               (show-contract #t)]
   [("-p" "--provide-less")    "no provide contracts"
                               (provide-less #t)]
   [("-r" "--require-less")    "no require contracts"
                               (require-less #t)]
   #:args targets
   targets))
