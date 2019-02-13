#lang racket

(require tr-contract/private/store
         tr-contract/private/store/struct-data
         tr-contract/private/munge-contract
         syntax/parse)

(provide provide-contract)

(define provide-contract-singleton%
  (class store%
    (super-new [path "_provide-contract.dat"])
    (field [provided (make-hash)])

    (define/override (process record)
      (append-map begin-cases (reverse record)))

    (define/public (already-provided? id)
      (hash-ref provided id #f))

    (define begin-cases
      (match-lambda
        [`(begin (define ,_ ,_) ...
                 (define-values (,_) ,ctc)
                 (define-module-boundary-contract ,id ,_ ,ctc-id ,_ ...))
         (hash-set! provided id #t)
         (contract-case id ctc-id ((munge-contract id) ctc))]))
    ))

(define provide-contract
  (new provide-contract-singleton%))
