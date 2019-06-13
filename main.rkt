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
                    syntax-util
                    syntax-compile)))

;;
;; const
;;

(define line-length 80)
(define long-line (build-string line-length (const #\━)))

;;
;; main
;;

(module+ main
  (let* ([argv    (current-command-line-arguments)]
         [targets (parse argv)])
    (optimize targets)))


;;
;; runner
;;

(provide optimize)

;; Module-Path -> Syntax
;; takes a target and returns syntax object with full contracts
(define (pipeline target)
  (define stx (syntax-fetch target))
  (if (module-typed? target)
      (let* ([stx-expand (expand/base+dir stx target)]
             [ctc-quads  (contract-extract stx stx-expand)]
             [stx-ctc    (contract-inject stx ctc-quads)])
        stx-ctc)
      stx))

;; [List-of Module-Path] -> Void
;; optimizes target modules, see documentation for the purpose of
;; the flags
(define (optimize targets
                  #:show-contract [s (show-contract)]
                  #:provide-off [p (provide-off)]
                  #:require-off [r (require-off)]
                  #:ignore-check [i (ignore-check)]
                  #:overwrite [o (overwrite)]
                  #:compiler-off [c (compiler-off)]
                  #:verify-off [v (verify-off)])
  ;; set parameters
  (show-contract s)
  (provide-off p)
  (require-off r)
  (ignore-check i)
  (overwrite o)
  (compiler-off c)
  (verify-off v)

  ;; optimize
  (define targets*
    (map path->complete-path targets))
  (for-each module-delete-zo targets*)
  (define stxs-opt
    (contract-opt targets* (map pipeline targets*)))

  ;; flags
  (when (overwrite)
    (for-each syntax-overwrite stxs-opt targets*))

  (when (show-contract)
    (for-each (λ (stx target)
                (displayln long-line)
                (displayln target)
                (displayln long-line)
                (displayln (syntax->string stx)))
              stxs-opt
              targets*))

  (unless (compiler-off)
    (syntax-compile-all targets* stxs-opt))

  )

;;
;; parsing
;;

(define (parse argv)
  (command-line
   #:program "scv-gt"
   #:argv argv
   #:once-each
   [("-s" "--show-contract")  "dump modules with contracts"
                              (show-contract #t)]
   [("-p" "--provide-off")    "don't attach contracts to provided bindings"
                              (provide-off #t)]
   [("-r" "--require-off")    "don't attach contracts to required bindings"
                              (require-off #t)]
   [("-i" "--ignore-check")   "ignore require-typed/check (for debugging)"
                              (ignore-check #t)]
   [("-o" "--overwrite")      "overwrite source files (for debugging)"
                              (overwrite #t)]
   [("-c" "--compiler-off")   "don't compile zo files"
                              (compiler-off #t)]
   [("-v" "--verify-off")     "don't compile zo files"
                              (verify-off #t)]
   #:args targets
   targets))
