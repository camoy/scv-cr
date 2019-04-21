#lang racket/base

(provide contract-inject)

;;
;; functions
;;

(require scv-gt/private/contract-extract
         syntax/parse
         racket/syntax)

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (as-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

;; Syntax Syntax -> Syntax
;; takes original syntax and expanded syntax and uses contract information
;; from the expanded syntax to inject provide and require contracts into
;; the unexpanded syntax
(define (contract-inject stx stx-expanded)
  (syntax-parse stx
    #:datum-literals (module #%module-begin)
    [(module name lang (#%module-begin forms ...))
     (define provide-stx
       #`(begin
           #,(provide-ctc-defns stx-expanded)
           (provide #,(provide-ctc-out stx-expanded))))
     (define require-stx
       #`(begin
           (module require/contracts racket/base
             #,(require-ctc-defns stx-expanded)
             (provide #,(provide-ctc-out stx-expanded)))
           (require 'require/contracts)))
     #`(module name #,(as-no-check #'lang)
         (#%module-begin
          #,provide-stx
          #,require-stx
          forms ...))]))

;; TODO: forms must be transformed
