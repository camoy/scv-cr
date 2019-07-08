#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-inject)

(require
 racket/require
 (multi-in racket (syntax function set path list))
 (multi-in syntax (parse modresolve))
 (multi-in scv-gt private (contract-extract
                           configure
                           syntax-util)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Path Syntax Ctc-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide and require contracts into the unexpanded syntax
(define (contract-inject target stx data)
  (syntax-parse stx
    #:datum-literals (module)
    [(module name lang (mb forms ...))
     (define forms*
       (for/fold ([stx       #'(forms ...)])
                 ([injection (list (inject-require target)
                                   inject-provide
                                   inject-predicates)])
         (injection stx data)))
     #`(module name #,(no-check #'lang)
         (#,(syntax-attach-scope #'mb)
          #,@(syntax-fresh-scope forms*)))]))

;; Syntax -> Syntax
;; changes Typed Racket #lang to the no-check variant
(define (no-check lang)
  (syntax-attach-scope (format-id lang "~a/no-check" (syntax-e lang))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax Ctc-Data -> Syntax
;; takes original syntax and contract data and uses contract information
;; to inject provide contracts into the unexpanded syntax
(define (inject-provide forms data)
  (define-values (p-bundle r-bundle)
    (values (ctc-data-provide data)
            (ctc-data-require data)))
  (define forms* (munge-provides forms p-bundle r-bundle))
  #`((require racket/contract
              #,@(ctc-bundle-deps p-bundle))
     #,@(ctc-bundle-defns p-bundle)
     (provide (contract-out #,@(ctc-bundle-outs p-bundle)))
     #,@forms*))

;; Syntax Ctc-Data -> Syntax
;; removes already provided identifiers from provide forms
(define (munge-provides stx p-bundle r-bundle)
  (define not-provided
    (syntax-parser
      #:datum-literals (provide)
      [(provide x ...)
       (define xs*
         (append-map (ctc-bundle-provides p-bundle r-bundle)
                     (syntax-e #'(x ...))))
       #`(provide #,@xs*)]
       [x #'x]))
  (syntax-parse stx
    [(x ...)
     (define provides*
       (map not-provided (syntax-e #'(x ...))))
     (define provides**
       (map (λ (x) (munge-provides x p-bundle r-bundle)) provides*))
     (datum->syntax stx provides** stx stx)]
    [x #'x]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Path -> (Syntax Ctc-Data -> Syntax)
;; takes original syntax and contract data and uses contract information
;; to inject require contracts into the unexpanded syntax
(define ((inject-require target) forms data)
  (define bundle (ctc-data-require data))
  (define required-set (mutable-set))
  (define forms* ((munge-requires target required-set) forms))
  (define-values (defs defs*) (make-definition bundle))
  #`((module require/contracts racket/base
       (require racket/contract
                #,@(set->list required-set)
                #,@(ctc-bundle-deps bundle))
       #,@(ctc-bundle-defns bundle)
       (provide #,@(hash-keys (ctc-bundle-i/c-hash bundle))
                (contract-out #,@(ctc-bundle-outs bundle))))
     (require (prefix-in -: (only-in 'require/contracts #,@defs))
              (except-in 'require/contracts #,@defs))
     (define-values (#,@defs) (values #,@defs*))
     #,@forms*))

;; Ctc-Bundle -> [List-of Symbol] [List-of Symbol]
;; identifiers that should be defined by the require form
(define (make-definition bundle)
  (define to-define
    (append (hash-keys (ctc-bundle-p/c-hash bundle))
            (map (λ (x) (format-symbol "~a?" x))
                 (hash-keys (ctc-bundle-s/o-hash bundle)))))
  (values to-define
          (map (λ (x) (format-symbol "-:~a" x)) to-define)))

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

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define (inject-predicates stx data)
  (define-values (d-pred m-pred)
    (values (ctc-data-d-pred data)
            (ctc-data-m-pred data)))
  (let go ([stx stx])
    (syntax-parse stx
      #:datum-literals (define-predicate make-predicate)
      [(define-predicate x _)
       #`(define x #,(hash-ref-stx d-pred stx))]
      [(make-predicate _)
       (hash-ref-stx m-pred stx)]
      [(x ...)
       (datum->syntax stx
                      (map go (syntax-e #'(x ...)))
                      stx
                      stx)]
      [x #'x])))
