#lang racket

(require syntax/modread
         syntax/parse
         racket/syntax
         tr-contract/private/store
         tr-contract/private/store/all)

(provide inject-contracts
         module->string
         module->file)

(define dependencies
  #'((require (except-in racket/contract ->)
              (prefix-in t: typed-racket/types/numeric-predicates)
              typed-racket/utils/struct-type-c
              typed-racket/utils/simple-result-arrow)))

;; This came from [1].
(define (file->module filename)
  (define port (open-input-file filename))
  (with-module-reading-parameterization
    (λ ()
      (syntax->datum (parameterize ([current-namespace (make-base-namespace)])
                       (read-syntax (object-name port) port))))))

(define (module->string stx)
  (syntax-parse stx #:datum-literals (module #%module-begin)
                [(module _ lang (#%module-begin forms ...))
                 (string-join
                  (cons (format "#lang ~a" (syntax->datum #'lang))
                        (map (λ (s) (substring (pretty-format s) 1))
                             (syntax->datum #'(forms ...))))
                  "\n")]))

(define (module->file stx filename)
  (with-output-to-file filename #:exists 'replace
    (λ () (displayln (module->string stx)))))

(define ((inject-syntax new-forms) stx)
  #`(#,@new-forms #,@stx))

(define (strip-provides stx)
  (define (provide-form? stx)
    (syntax-parse stx #:datum-literals (provide)
                  [(provide _ ...) #t]
                  [_ #f]))
  (datum->syntax stx (filter (negate provide-form?)
                             (syntax-e stx))))

(define (remove-require-typed stxs)
  (define (remove-or-keep stx)
    (syntax-parse stx #:datum-literals (require
                                        require-typed-check
                                        require/typed/check)
                  [(require require-typed-check) '()]
                  [(require/typed/check mod _ ...)
                   (list #'(require mod))]
                  [x (list #'x)]))
  (datum->syntax stxs (append-map remove-or-keep
                                  (syntax-e stxs))))

(define (make-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

(define (apply-transformers-to-module stx transformers)
  (define transformer (apply compose transformers))
  (syntax-parse stx #:datum-literals (module #%module-begin)
                [(module name lang (#%module-begin forms ...))
                 #`(module name #,(make-no-check #'lang)
                     (#%module-begin
                      #,@(transformer #'(forms ...))))]))

(define (inject-contracts target)
  (let* ([contracts (hash-ref (get-field data provide-contract)
                              (simplify-path (path->complete-path target))
                              '())]
         [transformers (list (inject-syntax dependencies)
                             (inject-syntax contracts)
                             remove-require-typed
                             strip-provides)]
         [stx (file->module target)])
    (apply-transformers-to-module stx transformers)))

;; References
;; [1] https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
