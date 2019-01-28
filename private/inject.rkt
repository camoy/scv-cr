#lang racket

(require syntax/modread
         syntax/parse
         racket/syntax
         tr-contract/private/utils
         tr-contract/private/store
         tr-contract/private/store/contract-registry
         tr-contract/private/store/all)

(provide inject-contracts
         module->string
         module->file)

(define dependencies
  #'((require (except-in racket/contract ->)
              (prefix-in t: typed-racket/types/numeric-predicates)
              typed-racket/utils/struct-type-c
              typed-racket/utils/simple-result-arrow)))

;; This came from [1].
(define (file->module filename)
  (define port (open-input-file filename))
  (with-module-reading-parameterization
    (λ ()
      (syntax->datum
       (parameterize ([current-namespace (make-base-namespace)])
         (read-syntax (object-name port) port))))))

(define (module->string stx)
  (syntax-parse stx #:datum-literals (module #%module-begin)
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
  (define (transform-id y)
    (syntax-parse
        y #:datum-literals (struct-out)
        [(struct-out id)
         (define fld-pairs (registry-lookup #'id))
         (list #`(provide (contract-out [struct id #,fld-pairs])))]
        [id
         (define contract (registry-lookup #'id))
         (list #`(provide (contract-out [id #,contract]))
               #`(module+ unsafe (provide id)))]))
  (define (transform-form stx)
    (syntax-parse
        stx #:datum-literals (provide)
        [(provide x ...)
         #`(begin #,@(append-map transform-id (syntax-e #'(x ...))))]
        [x #'x]))
  (datum->syntax stx (map transform-form (syntax-e stx))))

;; TODO: transform required-typed from registry instead of just removing
(define (transform-require-typed stxs)
  (define (transform-clause stx)
    (syntax-parse
        stx
        [((~datum #:struct) id flds) #'(void)] ; TODO!!!
        [(id type)
         (define contract (registry-lookup #'id))
         #`(define/contract id #,contract #,(prefix-unsafe #'id))]))
  (define (transform-or-keep stx)
    (syntax-parse
        stx #:datum-literals (require
                              require-typed-check
                              require/typed/check)
        [(require require-typed-check) '()]
        [(require/typed/check mod clause ...)
         (if (load-module (syntax-e #'mod))
             (list #'(require (submod mod unsafe)))
             (cons #'(require (prefix-in unsafe: mod))
                   (map transform-clause (syntax-e #'(clause ...)))))]
        [x (list #'x)]))
  (datum->syntax stxs (append-map transform-or-keep
                                  (syntax-e stxs))))

(define (make-no-check lang)
  (format-id lang "~a/no-check" (syntax-e lang)))

(define (apply-transformers-to-module stx transformers)
  (define transformer (apply compose transformers))
  (syntax-parse stx #:datum-literals (module #%module-begin)
                [(module name lang (#%module-begin forms ...))
                 #`(module name #,(make-no-check #'lang)
                     (#%module-begin
                      #,@(transformer #'(forms ...))))]))

(define (inject-contracts target)
  (define path
    (simplify-path (path->complete-path target)))
  (parameterize ([current-target path])
    (let* ([provide-contracts (send provide-contract current-record)]
           [require-contracts (send require-contract current-record)]
           [transformers (list (inject-syntax dependencies)
                               (inject-syntax provide-contracts)
                               (inject-syntax require-contracts)
                               transform-require-typed
                               transform-provides)]
           [stx (file->module target)])
      (apply-transformers-to-module stx transformers))))

(define (registry-lookup id)
  (send contract-registry lookup (syntax-e id)))

;; References
;; [1] https://groups.google.com/d/msg/racket-users/obchB2GIm4c/PGp1hWTeiqUJ
