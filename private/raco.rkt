#lang racket/base

(require racket/cmdline
         racket/function
         racket/pretty
         scv-gt/private/proxy-resolver
         scv-gt/private/configure
         scv-gt/private/contract-extract
         scv-gt/private/contract-inject
         scv-gt/private/contract-opt
         scv-gt/private/syntax-util)

;;
;; main
;;

(module+ main
  (let* ([argv         (current-command-line-arguments)]
         [targets      (parse argv)]
         [targets-tr   (filter typed? targets)]
         [stxs         (map syntax-fetch targets-tr)]
         [stxs-expand  (map expand/base+dir stxs targets-tr)]
         [ctc-quads    (map contract-extract stxs-expand)]
         [stxs-ctc     (map contract-inject stxs ctc-quads)]
         [stxs-opt     (map contract-opt stxs-ctc)])
    (when (overwrite)
      (for-each syntax-overwrite stxs-opt targets-tr))
    (when (show-contract)
      (for-each (λ (stx target)
                  (displayln (format "#### ~a ####" target))
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

;;
;; TODO: remove
;;



(require scv-gt/private/configure
         scv-gt/private/test-util
         racket/set
         racket/pretty
         syntax/parse)

#;(define path (benchmark-path "sieve" "typed" "streams.rkt"))
(define path (test-path "abs.rkt"))
(define stx (syntax-fetch path))
(define stx*
  (parameterize ([ignore-check #t])
    (contract-inject
     stx
     (contract-extract (expand/base+dir stx path)))))
stx*
(pretty-print (syntax->datum stx*))
(expand/base+dir stx* path)
