#lang racket

(require syntax/modread
         syntax/parse)

;; See https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
(define (file->syntax filename)
  (define port (open-input-file filename))
  (with-module-reading-parameterization
    (λ ()
      (syntax->datum (parameterize ([current-namespace (make-base-namespace)])
                       (read-syntax (object-name port) port))))))

(define (syntax-module->string stx)
  (syntax-parse stx #:datum-literals (module #%module-begin)
                [(module _ lang (#%module-begin forms ...))
                 (string-join
                  (cons (format "#lang ~a" (syntax->datum #'lang))
                        (map (λ (s) (pretty-format s #:mode 'display))
                             (syntax->datum #'(forms ...))))
                  "\n")]))

#;(define (inject-contracts filename)
  ...)
