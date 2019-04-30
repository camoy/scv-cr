#lang racket/base

(require racket/require
         (multi-in racket (cmdline
                          function
                          pretty))
         (multi-in scv-gt
                   private
                   (proxy-resolver
                    configure
                    contract-extract
                    contract-inject
                    contract-opt
                    syntax-util)))

;;
;; const
;;

(define line-length 80)

;;
;; main
;;

(module+ main
  (let* ([argv         (current-command-line-arguments)]
         [targets      (parse argv)]
         [_            (for-each module-delete-zo targets)]
         [targets-tr   (filter module-typed? targets)]
         [stxs         (map syntax-fetch targets-tr)]
         [stxs-expand  (map expand/base+dir stxs targets-tr)]
         [ctc-quads    (map contract-extract stxs-expand)]
         [stxs-ctc     (map contract-inject stxs ctc-quads)]
         [stxs-opt     (map contract-opt stxs-ctc)])
    (when (overwrite)
      (for-each syntax-overwrite stxs-opt targets-tr))

    (when (show-contract)
      (for-each (λ (stx target)
                  (displayln target)
                  (displayln (build-string line-length (const #\━)))
                  (displayln (syntax->string stx)))
                stxs-opt
                targets-tr))

    (unless (compiler-off)
      (for-each syntax-compile targets-tr stxs-opt))))

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
   [("-p" "--provide-less")   "no provide contracts"
                              (provide-less #t)]
   [("-r" "--require-less")   "no require contracts"
                              (require-less #t)]
   [("-i" "--ignore-check")   "ignore require-typed/check (for benchmarks)"
                              (ignore-check #t)]
   [("-o" "--overwrite")      "overwrite source files"
                              (overwrite #t)]
   [("-c" "--compiler-off")   "do not compile zo files"
                              (compiler-off #t)]
   #:args targets
   targets))
