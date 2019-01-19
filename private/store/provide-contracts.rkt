#lang racket

(require tr-contract/private/store/generic
         syntax/parse)

(provide provide-contracts-store)

(define provide-contracts-singleton%
  (class store% (super-new [filename "_provide-contracts.dat"])
    (inherit get-data)
    (define/public (process)
      (map (compose begin-cases
                    (curry datum->syntax #'_))
           (get-data)))))

(define (begin-cases stx)
  (syntax-parse stx
    [((~datum begin) def ...)
     #`(beginzzzz def ...)]))

(define provide-contracts-store
  (new provide-contracts-singleton%))
