#lang racket/base

(provide contract-inject)

;;
;; functions
;;

(require scv-gt/private/contract-extract
         scv-gt/private/configure
         scv-gt/private/syntax-util
         syntax/parse
         syntax/modresolve
         racket/syntax
         racket/function)

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (as-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

;; Syntax Contract-Quad -> Syntax
;; takes original syntax and contract quad and uses contract information
;; to inject provide contracts into the unexpanded syntax
(define (inject-provide stx quad)
  (define stx* (transform-provide stx))
  (syntax-parse stx*
    [(forms ...)
     (define provide-stx
       #`(begin
           #,(contract-quad-provide-defns quad)
           #,(contract-quad-provide-out quad)))
     #`(#,provide-stx forms ...)]))

;; Syntax Contract-Quad -> Syntax
;; takes original syntax and contract quad and uses contract information
;; to inject require contracts into the unexpanded syntax
(define (inject-require stx quad)
  (define-values (stx* requires)
    (transform-require stx))
  (syntax-parse stx*
    [(forms ...)
     (define require-stx
       #`(begin
           (module require/contracts racket/base
             #,@requires
             #,(contract-quad-require-defns quad)
             #,(contract-quad-require-out quad))
           (require 'require/contracts)))
     #`(#,require-stx forms ...)]))

;; Syntax Contract-Quad -> Syntax
;; takes original syntax and contract quad and uses contract information
;; to inject provide and require contracts into the unexpanded syntax
(define (contract-inject stx quad)
  (syntax-parse stx
    #:datum-literals (module)
    [(module name lang (mb forms ...))
     (define syntax-scope-expanded*
       (λ (stx _)
         (syntax-scope-expanded stx)))
     (define forms*
       (for/fold ([stx #'(forms ...)])
                 ([flag      (list (provide-less)
                                   (require-less)
                                   #f)]
                  [injection (list inject-provide
                                   inject-require
                                   syntax-scope-expanded*)])
         (if (not flag) (injection stx quad) stx)))
     #`(module name #,(as-no-check #'lang)
         (mb forms ...))]))

;; Syntax -> Syntax
;; removes provide forms
(define (transform-provide stx)
  (define provide?
    (syntax-parser
      #:datum-literals (provide)
      [(provide _ ...) #t]
      [_ #f]))
  (syntax-parse stx
    [(x ...)
     (define no-provides
       (filter (negate provide?) (syntax-e #'(x ...))))
     (datum->syntax stx (map transform-provide no-provides))]
    [x #'x]))

;; Syntax -> Syntax [List-of Syntax]
;; extracts and munges require forms
(define (transform-require stx)
  (syntax-parse stx
    #:datum-literals (require/typed require/typed/check)
    [(~or* (require/typed m _ ...)
           (require/typed/check m _ ...))
     (values #'(require m)
             (list #'(require m)))]
    [(x ...)
     (define-values (stxs* requires)
       (for/lists (stxs* requires)
                  ([stx (syntax-e #'(x ...))])
         (transform-require stx)))
     (values (datum->syntax stx stxs*)
             (apply append requires))]
    [x (values #'x '())]))
