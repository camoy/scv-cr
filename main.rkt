#lang racket/base

(require racket/require
         (multi-in racket (cmdline
                           function
                           list
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

;; Module-Path -> Contract-Data
;; takes a target and returns contract data
(define ((pipeline targets) target)
  (if (module-typed? target)
      (let* ([stx        (syntax-fetch target)]
             [stx-expand (expand/base+dir stx target)]
             [ctc-data   (contract-extract targets stx-expand stx)])
        ctc-data)
      #f))

;; [List-of Module-Path] -> Void
;; optimizes target modules, see documentation for the purpose of
;; the flags
(define (optimize targets
                  #:show-contracts [s (show-contracts)]
                  #:keep-contracts [k (keep-contracts)]
                  #:show-blames [b (show-blames)]
                  #:ignore-check [i (ignore-check)]
                  #:overwrite [o (overwrite)]
                  #:compiler-off [c (compiler-off)]
                  #:verify-off [v (verify-off)])
  ;; set parameters
  (show-contracts s)
  (keep-contracts k)
  (show-blames b)
  (ignore-check i)
  (overwrite o)
  (compiler-off c)
  (verify-off v)

  ;; acquiring targets
  (define targets*
    (map (compose path->complete-path simplify-path)
         targets))

  ;; clean old zo
  (for-each module-delete-zo targets*)

  ;; extract data
  (define ctc-data
    (map (pipeline targets*) targets*))
  (define t/d-hash
    (make-hash (map cons targets* ctc-data)))

  ;; verify
  (define sorted-targets
    (sort-by-dependency targets*))
  (define sorted-data
    (map (λ (t) (hash-ref t/d-hash t)) sorted-targets))
  (define stxs-opt
    (contract-opt sorted-targets sorted-data))

  ;; flags
  (when (overwrite)
    (for-each syntax-overwrite stxs-opt sorted-targets))

  (when (show-contracts)
    (for-each (λ (stx target)
                (displayln long-line)
                (displayln target)
                (displayln long-line)
                (displayln (syntax->pretty stx)))
              stxs-opt
              sorted-targets))

  (unless (compiler-off)
    (syntax-compile-all sorted-targets stxs-opt))

  )

;;
;; parsing
;;

(define (parse argv)
  (command-line
   #:program "scv-gt"
   #:argv argv
   #:once-each
   [("-s" "--show-contracts") "dump modules with contracts"
                              (show-contracts #t)]
   [("-k" "--keep-contracts") "keep all contracts even if verified"
                              (keep-contracts #t)]
   [("-b" "--show-blames")    "dump blame information"
                              (show-blames #t)]
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
