#lang racket/base

(provide get-module-name-resolver
         expand/base+dir
         compile/dir
         in-dir)

;;
;; proxy module
;;

(module require-typed-check-proxy racket/base
  (provide time
           require/typed/check)
  (require (for-syntax racket/base syntax/parse)
           (only-in typed/racket require/typed))
  (define-syntax (time stx)
    (syntax/loc stx (void)))
  (define-syntax (require/typed/check stx)
    (syntax-parse stx
      [(_ x ...)
       (syntax/loc stx (require/typed x ...))])))

(module just-time-proxy racket/base
  (provide time
           (all-from-out (lib "require-typed-check")))
  (require (for-syntax racket/base)
           (lib "require-typed-check"))
  (define-syntax (time stx)
    (syntax/loc stx (void))))

;;
;; functions
;;

(require scv-gt/private/configure
         syntax/location
         racket/path)

;; evaluates with current directory from the parent of the target
(define-syntax-rule (in-dir target forms ...)
  (parameterize ([current-directory (path-only target)])
    forms ...))

;; Syntax Module-Path -> Syntax
;; expands module with base namespace in the directory of the given path
(define (expand/base+dir stx target)
  (in-dir target
    (parameterize ([current-namespace (make-base-namespace)]
                   [current-module-name-resolver
                    (get-module-name-resolver)])
      (expand stx))))

;; Syntax Module-Path -> Syntax
;; compiles module in the directory of the given path
(define (compile/dir stx target)
  (in-dir target
    (parameterize ([current-namespace (make-base-namespace)])
      (compile stx))))

;; Module-Name-Resolver
;; proxy module name resolver to intercept require-typed-check loads
(define (proxy-resolver ignore-check)
  (let ([mp (if ignore-check
                (quote-module-path require-typed-check-proxy)
                (quote-module-path just-time-proxy))])
    (case-lambda
      [(resolved-path ns)
       (old-resolver resolved-path ns)]
      [(module-path source-resolved-path stx load?)
       (if (equal? module-path 'require-typed-check)
           (old-resolver mp
                         source-resolved-path
                         stx
                         load?)
           (old-resolver module-path source-resolved-path stx load?))])))

;; Module-Name-Resolver
;; cache old resolver for proxying
(define old-resolver
  (current-module-name-resolver))

(define require-typed-check-resolver
  (proxy-resolver #t))

(define just-time-resolver
  (proxy-resolver #f))

;; -> Module-Name-Resolver
;; if the ignore-check parameter is set, returns a module name
;; resolver that disables require/typed/check
(define (get-module-name-resolver)
  (if (ignore-check)
      require-typed-check-resolver
      just-time-resolver))
