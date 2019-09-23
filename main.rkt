#lang racket/base

(require racket/require
         syntax/modread
         compiler/compile-file
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
  (define (fake-prefixed? target)
    (string-prefix? (path->string (file-name-from-path target)) "fake-"))
  (filter (λ (target)
            ((if invert? values not)
             (fake-prefixed? target)))
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
                  #:ignore-fakes [f (ignore-fakes)]
                  #:trust-zos [t (trust-zos)])
  ;; set parameters
  (show-contracts s)
  (keep-contracts k)
  (show-optimized p)
  (show-blames b)
  (ignore-check i)
  (overwrite o)
  (compiler-off c)
  (verify-off v)
  (ignore-fakes f)
  (trust-zos t)

  ;; acquiring targets
  (define targets*
    (map (compose path->complete-path simplify-path) targets))
  (define targets**
    ((if (ignore-fakes) without-fakes values) targets*))

  ;; remove old zo and rebuild unless trusted
  (unless (trust-zos)
    (for-each module-delete-zo targets*)
    (parameterize ([current-namespace (make-base-namespace)])
      (with-module-reading-parameterization
        (λ ()
          (for ([target (in-list targets*)])
            (compile-file target))))))

  ;; extract data
  (define ctc-data
    (map (pipeline targets**) targets**))
  (define t/d-hash
    (make-hash (map cons targets** ctc-data)))

  ;; verify
  (define sorted-targets
    (sort-by-dependency targets**))
  (define sorted-data
    (map (λ (t) (hash-ref t/d-hash t)) sorted-targets))
  (define-values (stxs-unopt stxs-opt)
    (contract-opt sorted-targets sorted-data))

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
    (when (ignore-fakes)
      (let ([fakes (without-fakes targets* #t)])
        (syntax-compile-all fakes (map syntax-fetch fakes)))))

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
   [("-f" "--ignore-fakes")   "ignore fake modules"
                              (ignore-fakes #t)]
   [("-t" "--trust-zos")      "trust existing compiled zo's"
                              (trust-zos #t)]
   #:args targets
   targets))
