#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-opt)

(require racket/require
         racket/contract
         (multi-in scv-gt/private (configure
                                   contract-extract
                                   contract-inject
                                   syntax-compile
                                   syntax-util))
         syntax/parse
         soft-contract/main)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [List-of Path] [List-of Syntax] -> [List-of Syntax]
;; use SCV to optimize away contracts
(define (contract-opt targets data)
  (define targets*
    (map path->string targets))
  (define raw-stxs
    (map syntax-fetch targets))
  (define stxs
    (for/list ([target  targets]
               [raw-stx raw-stxs]
               [datum   data])
      (define stx
        (if datum
            (syntax-replace-srcloc target
                                   (contract-inject target raw-stx datum))
            raw-stx))
      (syntax-compile target stx)
      stx))
  (if (verify-off)
      stxs
      (let ([blames (verify-modules targets* stxs)])
        (displayln blames)
        (for/list ([target  targets]
                   [raw-stx raw-stxs]
                   [datum   data])
          (if datum
              (begin
                #;(erase-contracts! target datum blames)
                (contract-inject target raw-stx datum))
              raw-stx)))))

;; Path Contract-Data [List-of Blame] -> Void
;; erase contract by changing them to any/c
(define (erase-contracts! target datum blames)
  (define-values (require-bundle provide-bundle)
    (values (ctc-data-require datum)
            (ctc-data-provide datum)))
  (set-ctc-bundle-outs! require-bundle
                        (map make-any
                             (ctc-bundle-outs require-bundle)))
  (set-ctc-bundle-outs! provide-bundle
                        (map make-any
                             (ctc-bundle-outs provide-bundle))))

;; Syntax -> Syntax
;; given an element in a contract-out specification will change all contracts
;; to any/c
(define make-any
  (syntax-parser
    #:datum-literals (struct)
    [(struct s (p ...))
     #`(struct s #,(map make-any (syntax-e #'(p ...))))]
    [(k v) #'(k any/c)]))
