#lang racket

(require syntax/modread
         syntax/parse
         racket/syntax)

(provide inject-contracts module->string)

;; See https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
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
                        (map (λ (s) (pretty-format s #:mode 'display))
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

(define (make-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

(define (apply-transformers-to-module stx transformers)
  (define transformer (apply compose transformers))
  (syntax-parse stx #:datum-literals (module #%module-begin)
                [(module name lang (#%module-begin forms ...))
                 #`(module name #,(make-no-check #'lang)
                     (#%module-begin
                      #,@(transformer #'(forms ...))))]))

(define (inject-contracts filename contracts [in-place #f])
  (define transformers
    (list (inject-syntax contracts)
          strip-provides))
  (define stx (file->module filename))
  (define transformed-stx
    (apply-transformers-to-module stx transformers))
  (when in-place
    (module->file transformed-stx filename))
  transformed-stx)
