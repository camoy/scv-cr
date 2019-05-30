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

;; [Listof Syntax]
;; modules that provide bindings for contract definitions
(define ctc-dependencies
  '(racket/contract
    typed-racket/utils/struct-type-c))

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (as-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide contracts into the unexpanded syntax
(define (inject-provide forms data)
  (define forms* (transform-provide forms data))
  #`((require #,@ctc-dependencies)
     #,@(contract-data-provide-defns data)
     #,(contract-data-provide-out data)
     #,@forms*))

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject require contracts into the unexpanded syntax
(define (inject-require forms data)
  (define-values (forms* requires)
    (transform-require forms))
  #`((module require/contracts racket/base
       (require #,@ctc-dependencies)
       #,@requires
       #,@(contract-data-require-defns data)
       #,(contract-data-require-out data))
     (require 'require/contracts)
     #,@forms*))

;; Syntax Contract-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide and require contracts into the unexpanded syntax
(define (contract-inject stx data)
  (syntax-parse (syntax-fresh-scope stx)
    #:datum-literals (module)
    [(module name lang (mb forms ...))
     (define forms*
       (for/fold ([stx #'(forms ...)])
                 ([flag      (list (provide-off)
                                   (require-off))]
                  [injection (list inject-provide
                                   inject-require)])
         (if (not flag) (injection stx data) stx)))
     (define stx*
       #`(module name #,(as-no-check #'lang)
           (mb #,@forms*)))
     (syntax-scope-expanded stx*)]))

;; Syntax Contract-Data -> Syntax
;; removes provide forms
(define (transform-provide stx data)
  (define extract-struct-name
    (syntax-parser
      #:datum-literals (struct-out)
      [(struct-out y) (syntax-e #'y)]
      [_ #f]))
  (define (already-provided? id)
    (memf (λ (x) (or (equal? (syntax-e id) (syntax-e x))
                     (equal? (extract-struct-name id) (syntax-e x))))
          (contract-data-provide-ids data)))
  (define filter-provide
    (syntax-parser
      #:datum-literals (provide)
      [(provide x ...)
       #`(provide #,@(filter (negate already-provided?)
                             (syntax-e #'(x ...))))]
      [x #'x]))
  (syntax-parse stx
    [(x ...)
     (define provides*
       (map filter-provide (syntax-e #'(x ...))))
     (datum->syntax stx (map (λ (x) (transform-provide x data))
                             provides*))]
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
