#lang racket/base

(require racket/require
         (multi-in racket (cmdline
                           function
                           list
                           pretty
                           path
                           string))
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

;; Module-Path -> Module-Path
;; Removes fake modules from the pipeline (but still compiles them)
(define (without-fakes targets [invert? #f])
  (filter (λ (target)
            ((if invert? values not)
             (string-prefix? (path->string (file-name-from-path target))
                             "fake-")))
          targets))

;; [List-of Module-Path] -> Void
;; optimizes target modules, see documentation for the purpose of
;; the flags
(define (optimize targets
                  #:show-contracts [s (show-contracts)]
                  #:keep-contracts [k (keep-contracts)]
                  #:show-optimized [p (show-optimized)]
                  #:show-blames [b (show-blames)]
                  #:ignore-check [i (ignore-check)]
                  #:overwrite [o (overwrite)]
                  #:compiler-off [c (compiler-off)]
                  #:verify-off [v (verify-off)]
                  #:analyze-fakes [f (analyze-fakes)])
  ;; set parameters
  (show-contracts s)
  (keep-contracts k)
  (show-optimized p)
  (show-blames b)
  (ignore-check i)
  (overwrite o)
  (compiler-off c)
  (verify-off v)
  (analyze-fakes f)

  ;; acquiring targets
  (define targets*
    (map (compose path->complete-path simplify-path) targets))
  (define targets** (without-fakes targets*))

  ;; clean old zo
  (for-each module-delete-zo targets**)

  ;; extract data
  (define ctc-data
    (time (map (pipeline targets**) targets**)))
  (define t/d-hash
    (make-hash (map cons targets** ctc-data)))

  ;; verify
  (define sorted-targets
    (sort-by-dependency targets**))
  (define sorted-data
    (map (λ (t) (hash-ref t/d-hash t)) sorted-targets))
  (define-values (stxs-unopt stxs-opt)
    (time (contract-opt sorted-targets sorted-data)))

  ;; flags
  (when (overwrite)
    (for-each syntax-overwrite
              (if (show-optimized) stxs-opt stxs-unopt)
              sorted-targets))

  (when (show-contracts)
    (for-each (λ (stx target)
                (displayln long-line)
                (displayln target)
                (displayln long-line)
                (displayln (syntax->pretty stx)))
              (if (show-optimized) stxs-opt stxs-unopt)
              sorted-targets))

  (unless (compiler-off)
    (syntax-compile-all sorted-targets stxs-opt)
    (let ([fakes (without-fakes targets* #t)])
      (syntax-compile-all fakes (map syntax-fetch fakes))))

  (void))

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
   [("-p" "--show-optimized") "print and overwrite optimized code"
                              (show-optimized #t)]
   [("-b" "--show-blames")    "dump blame information"
                              (show-blames #t)]
   [("-i" "--ignore-check")   "ignore require-typed/check"
                              (ignore-check #t)]
   [("-o" "--overwrite")      "overwrite source files"
                              (overwrite #t)]
   [("-c" "--compiler-off")   "don't compile zo files"
                              (compiler-off #t)]
   [("-v" "--verify-off")     "don't compile zo files"
                              (verify-off #t)]
   [("-f" "--analyze-fakes")  "analyze fake modules"
                              (analyze-fakes #t)]
   #:args targets
   targets))
