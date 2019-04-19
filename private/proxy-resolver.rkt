#lang racket/base

(provide get-proxy-module-name-resolver)

;;
;; proxy module
;;

(module require-typed-check-proxy racket/base
  (provide require/typed/check)
  (require (for-syntax racket/base syntax/parse)
           (only-in typed/racket require/typed))
  (define-syntax (require/typed/check stx)
    (syntax-parse stx
      [(_ x ...)
       (syntax/loc stx (require/typed x ...))])))

;;
;; functions
;;

(require scv-gt/private/configure
         syntax/location)

;; -> Module Name Resolver
;; if the ignore-check parameter is set, returns a module name
;; resolver that disables require-typed/check
(define (get-proxy-module-name-resolver)
  (if (ignore-check)
      real-proxy-resolver
      old-resolver))

(define old-resolver
  (current-module-name-resolver))

(define real-proxy-resolver
  (case-lambda
    [(resolved-path ns)
     (old-resolver resolved-path ns)]
    [(module-path source-resolved-path stx load?)
     (if (equal? module-path 'require-typed-check)
         (old-resolver (quote-module-path require-typed-check-proxy)
                       source-resolved-path
                       stx
                       load?)
         (old-resolver module-path source-resolved-path stx load?))]))
