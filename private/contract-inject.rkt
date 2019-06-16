#lang racket/base

(require
 racket/require
 (multi-in racket (syntax function))
 (multi-in syntax (parse modresolve))
 (multi-in scv-gt private (contract-extract
                           configure
                           syntax-util)))

;;
;; injection function
;;

(provide contract-inject)
(require syntax/strip-context)

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide and require contracts into the unexpanded syntax
(define (contract-inject stx data)
  (syntax-parse stx
    #:datum-literals (module)
    [(module name lang (mb forms ...))
     (define forms*
       (for/fold ([stx       #'(forms ...)])
                 ([injection (list inject-provide
                                   inject-require)])
         (injection stx data)))
     #`(module name #,(no-check #'lang)
         (mb #,@(strip-context forms*)))]))

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

;;
;; provide injection
;;

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide contracts into the unexpanded syntax
(define (inject-provide forms data)
  (define bundle (contract-data-provide data))
  (define forms* (munge-provides forms bundle))
  #`((require #,@(contract-bundle-deps bundle))
     #,@(contract-bundle-defns bundle)
     (provide (contract-out #,@(contract-bundle-outs bundle)))
     #,@forms*))

;; Syntax Contract-Data -> Syntax
;; removes already provided identifiers from provide forms
(define (munge-provides stx bundle)
  (define not-provided
    (syntax-parser
      #:datum-literals (provide)
      [(provide x ...)
       (define xs*
         (filter (λ (x) (not (contract-bundle-provided? bundle x)))
                 (syntax-e #'(x ...))))
       #`(provide #,@xs*)]
       [x #'x]))
  (syntax-parse stx
    [(x ...)
     (define provides*
       (map not-provided (syntax-e #'(x ...))))
     (define provides**
       (map (λ (x) (munge-provides x bundle)) provides*))
     (datum->syntax stx provides**)]
    [x #'x]))

;;
;; require injection
;;

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject require contracts into the unexpanded syntax
(define (inject-require forms data)
  (define bundle (contract-data-require data))
  (define forms* (munge-requires forms))
  #`((module require/contracts racket/base
       (require #,@(contract-bundle-deps bundle))
       #,@(contract-bundle-defns bundle)
       (provide (contract-out #,@(contract-bundle-outs bundle))))
     (require 'require/contracts)
     #,@forms*))

;; Syntax -> Syntax
;; extracts and munges require forms
(define (munge-requires stx)
  (syntax-parse stx
    #:datum-literals (require/typed require/typed/check)
    [(~or* (require/typed m _ ...)
           (require/typed/check m _ ...))
     #'(void)]
    [(x ...)
     (datum->syntax stx (map munge-requires
                             (syntax-e #'(x ...))))]
    [x #'x]))
