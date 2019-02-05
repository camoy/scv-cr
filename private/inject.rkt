#lang racket

(require syntax/modread
         syntax/parse
         racket/syntax
         tr-contract/private/utils
         tr-contract/private/store
         tr-contract/private/store/all)

(provide inject-contracts
         module->string
         module->file)

(define dependencies
  #'((require (except-in racket/contract ->)
              (prefix-in t: typed-racket/types/numeric-predicates)
              (prefix-in c: racket/class)
              (submod typed-racket/private/type-contract predicates)
              typed-racket/utils/struct-type-c
              typed-racket/utils/simple-result-arrow
              typed-racket/utils/any-wrap
              typed-racket/utils/vector-contract
              typed-racket/utils/hash-contract
              (prefix-in c: typed-racket/utils/opaque-object))))

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
  (define (if-undefined? id stx)
    (if (send provide-contract already-defined? id)
        '()
        (list stx)))
  (define (transform-id y)
    (syntax-parse
        y #:datum-literals (struct-out)
        [(struct-out id) (if-undefined? (syntax-e #'id) #'(struct-out id))]
        [id (if-undefined? (syntax-e #'id) #'id)]))
  (define (transform-form stx)
    (syntax-parse
        stx #:datum-literals (provide)
        [(provide x ...)
         #`(provide #,@(append-map transform-id (syntax-e #'(x ...))))]
        [x #'x]))
  (datum->syntax stx (map transform-form (syntax-e stx))))

(define (transform-requires stxs)
  (define (remove-or-keep stx)
    (syntax-parse
        stx #:datum-literals (require
                              require-typed-check
                              require/typed/check)
        [(require require-typed-check) '()]
        [(require/typed/check mod _ ...)
         ;; TODO: uncomment when checking provides contracts
         (list (if #t #;(load-module (syntax-e #'mod))
                   #'(require mod)
                   #'(require (prefix-in unsafe: mod))))]
        [x (list #'x)]))
  (datum->syntax stxs (append-map remove-or-keep
                                  (syntax-e stxs))))

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
    (let* ([provide-contracts (send provide-contract current-record)]
           [require-definitions (send require-definition current-record)]
           [require-contracts (send require-contract current-record)]
           [transformers (list (inject-syntax dependencies)
                               (inject-syntax provide-contracts)
                                ;; TODO: uncomment when doing provide contracts
                               #;(inject-syntax require-definitions)
                               #;(inject-syntax require-contracts)
                               transform-requires
                               transform-provides)]
           [stx (file->module target)])
      (apply-transformers-to-module stx transformers))))

;; References
;; [1] https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
