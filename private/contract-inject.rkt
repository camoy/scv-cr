#lang racket/base

(require
 racket/require
 (multi-in racket (syntax function set path))
 (multi-in syntax (parse modresolve))
 (multi-in scv-gt private (contract-extract
                           configure
                           syntax-util)))

;;
;; injection function
;;

(provide contract-inject)
(require syntax/strip-context)

;; Path Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide and require contracts into the unexpanded syntax
(define (contract-inject target stx data)
  (syntax-parse stx
    #:datum-literals (module)
    [(module name lang (mb forms ...))
     (define forms*
       (for/fold ([stx       #'(forms ...)])
                 ([injection (list (inject-require target)
                                   inject-provide)])
         (injection stx data)))
     #`(module name #,(no-check #'lang)
         (#,(syntax-attach-scope #'mb)
          #,@(syntax-fresh-scope forms*)))]))

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (no-check lang)
  (syntax-attach-scope (format-id lang "~a/no-check" (syntax-e lang))))

;;
;; provide injection
;;

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide contracts into the unexpanded syntax
(define (inject-provide forms data)
  (define bundle (contract-data-provide data))
  (define forms* (munge-provides forms bundle))
  #`((require racket/contract
              #,@(contract-bundle-deps bundle))
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
     (datum->syntax stx provides** stx stx)]
    [x #'x]))

;;
;; require injection
;;

;; Path -> Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject require contracts into the unexpanded syntax
(define ((inject-require target) forms data)
  (define bundle (contract-data-require data))
  (define required-set (mutable-set))
  (define forms* ((munge-requires target required-set) forms))
  #`((module require/contracts racket/base
       (require racket/contract
                #,@(set->list required-set)
                #,@(contract-bundle-deps bundle))
       #,@(contract-bundle-defns bundle)
       (provide (contract-out #,@(contract-bundle-outs bundle))))
     (require 'require/contracts)
     #,@forms*))

;; Path Set -> Syntax -> Syntax
;; extracts and munges require forms
(define ((munge-requires target required-set) stx)
  (syntax-parse stx
    #:datum-literals (require/typed require/typed/check)
    [(~or* (require/typed m _ ...)
           (require/typed/check m _ ...))
     (define m-typed?
       (parameterize ([current-directory (path-only target)])
         (module-typed? (path->complete-path (syntax-e #'m)))))
     (cond
       [(and m-typed? (not (ignore-check)))
        #'(require m)]
       [else
        (set-add! required-set #'m)
        #'(void)])]
    [(x ...)
     (datum->syntax stx
                    (map (munge-requires target required-set)
                         (syntax-e #'(x ...)))
                    stx
                    stx)]
    [x #'x]))
