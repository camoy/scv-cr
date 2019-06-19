#lang racket/base

(provide contract-opt)

(require soft-contract/main
         scv-gt/private/configure
         scv-gt/private/contract-inject
         scv-gt/private/contract-extract
         scv-gt/private/syntax-util
         debug-scopes
         racket/contract
         syntax/parse
         racket/pretty)

(define (make-any stx)
  (syntax-parse stx
    #:datum-literals (struct)
    [(struct s (p ...))
     #`(struct s #,(map make-any (syntax-e #'(p ...))))]
    [(k v) #'(k any/c)]))

;; TODO actually use blames
;; Path Contract-Data [List-of Blame] -> Void
(define (erase-contracts! target datum blames)
  (define-values (require-bundle provide-bundle)
    (values (contract-data-require datum)
            (contract-data-provide datum)))
  (set-contract-bundle-outs! require-bundle
                             (map make-any
                                  (contract-bundle-outs require-bundle)))
  (set-contract-bundle-outs! provide-bundle
                             (map make-any
                                  (contract-bundle-outs provide-bundle))))

;; [List-of Path] [List-of Syntax] -> [List-of Syntax]
;; use SCV to optimize away contracts
(define (contract-opt targets data)
  (define targets*
    (map path->string targets))
  (define stxs
    (for/list ([target targets]
               [datum  data])
      (contract-inject (syntax-fetch target)
                       datum)))
  #;(pretty-print (map syntax->datum stxs))
  #;(for ([stx stxs]) (displayln (+scopes stx)))
  #;(displayln stxs)
  (if (verify-off)
      stxs
      (let ([blames (verify-modules targets* stxs)])
        (displayln blames)
        (for/list ([target targets]
                   [datum  data])
          (erase-contracts! target datum blames)
          (contract-inject (syntax-fetch target)
                           datum)))))
