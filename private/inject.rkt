#lang racket

(require syntax/modread
         syntax/parse
         racket/syntax
         tr-contract/private/munge-contract
         tr-contract/private/utils
         tr-contract/private/store
         tr-contract/private/store/all)

(provide inject-contracts
         module->string
         module->file)

(define dependencies
  '(racket/contract
    (prefix-in t: typed-racket/types/numeric-predicates)
    (submod typed-racket/private/type-contract predicates)
    typed-racket/utils/struct-type-c
    typed-racket/utils/vector-contract
    typed-racket/utils/hash-contract
    typed-racket/utils/opaque-object))

;; This came from [1].
(define (file->module filename)
  (define port (open-input-file filename))
  (with-module-reading-parameterization
    (λ ()
      (syntax->datum (parameterize ([current-namespace (make-base-namespace)])
                       (read-syntax (object-name port) port))))))

(define (module->string stx)
  (syntax-parse
      stx #:datum-literals (module #%module-begin)
      [(module _ lang (#%module-begin forms ...))
       (string-join
        (cons (format "#lang ~a" (syntax->datum #'lang))
              (map (λ (s) (substring (pretty-format s) 1))
                   (syntax->datum #'(forms ...))))
        "\n")]))

(define (module->file stx filename)
  (with-output-to-file filename #:exists 'replace
    (λ () (displayln (module->string stx)))))

(define ((inject-syntax new-forms) stx)
  #`(#,@new-forms #,@stx))

(define (transform-provides stx)
  (define (undefined? id)
    (not (send provide-contract already-provided? id)))
  (define (transform-spec spec)
    (syntax-parse
        spec #:datum-literals (struct-out)
        [(~or* (struct-out x) x)
         (if (undefined? (syntax-e #'x))
             (list spec)
             '())]))
  (define (transform-form stx)
    (syntax-parse
        stx #:datum-literals (provide)
        [(provide x ...)
         #`(provide #,@(append-map transform-spec
                                   (syntax-e #'(x ...))))]
        [x #'x]))
  (datum->syntax stx (map transform-form (syntax-e stx))))

(define (transform-requires stxs)
  (define (remove-or-keep stx)
    (syntax-parse
        stx #:datum-literals (require/typed
                              require/typed/check)
        [(~or* (require/typed _ ...)
               (require/typed/check _ ...))
         '()]
        [x (list #'x)]))
  (datum->syntax stxs (append-map remove-or-keep
                                  (syntax-e stxs))))

(define (prefix-imported mod)
  (map (λ (x) #`(#,x #,(prefix-unsafe x)))
       (send require-contract all-imports mod)))

(define (make-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

(define (apply-transformers-to-module stx transformers)
  (define transformer (apply compose transformers))
  (syntax-parse
      stx #:datum-literals (module #%module-begin)
      [(module name lang (#%module-begin forms ...))
       #`(module name #,(make-no-check #'lang)
           (#%module-begin
            #,@(transformer #'(forms ...))))]))

(define (inject-contracts target)
  (define path
    (simplify-path (path->complete-path target)))
  (parameterize ([current-target path])
    (let ([transformers (list (inject-syntax (provide-all))
                              (inject-syntax (require-all))
                              transform-requires
                              transform-provides)]
          [stx (file->module target)])
      (apply-transformers-to-module stx transformers))))

(define (require-all)
  (let* ([defns (send require-definition current-record)]
         [requires (send require-contract all-requires)]
         [ctcs (send require-contract current-record)]
         [defns-stx (defns->syntax defns)])
    (list #`(module require-contracts racket/base
              (require #,@dependencies)
              (require #,@requires)
              #,@defns-stx
              (provide #,@ctcs))
          #`(require 'require-contracts))))

(define (provide-all)
  (let* ([defns (send provide-definition current-record)]
         [ctcs (send provide-contract current-record)]
         [to-define (map first defns)]
         [all-defns (map second defns)])
    (list #`(define-values (#,@to-define)
              (let ()
                (local-require #,@dependencies)
                (let* (#,@defns) (values #,@to-define))))
          #`(require racket/contract)
          #`(provide #,@ctcs))))

(define (defns->syntax defns)
  (map
   (match-lambda
     [(list id ctc)
      #`(define #,id #,ctc)])
   defns))

;; References
;; [1] https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
