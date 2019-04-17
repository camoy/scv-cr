#lang racket/base

(require racket/cmdline
         scv-gt/private/configure
         scv-gt/private/contract-syntax
         scv-gt/private/is-tr
         scv-gt/private/fetch-syntax
         scv-gt/private/make-contract
         scv-gt/private/inject-contract
         scv-gt/private/opt-contract
         scv-gt/private/compile-syntax)

;;
;; parsing
;;

(define (raco-parse argv)
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

;;
;; main
;;

(module+ main
  (let* ([argv         (current-command-line-arguments)]
         [targets      (raco-parse argv)]
         [targets/tr   (filter is-tr? targets)]
         [stxs         (map fetch-syntax targets/tr)]
         [stxs/expand  (map expand stxs)]
         [ctcs         (map make-contract stxs/expand)]
         [stxs/ctc     (map inject-contract stxs ctcs)]
         [stxs/opt     (map opt-contract stxs/ctc)])
    (map compile-syntax targets/tr stxs/opt)))
