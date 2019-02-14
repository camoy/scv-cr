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

    (define/public (provided-record)
      (define return
        (hash-ref provided (current-target) (make-hash)))
      (hash-set! provided (current-target) return)
      return)

    (define/public (register-provided id)
      (hash-set! (provided-record) id #t))

    (define/public (already-provided? id)
      (hash-ref (provided-record) id #f))

    (define begin-cases
      (match-lambda
        [`(begin (define ,_ ,_) ...
                 (define-values (,_) ,ctc)
                 (define-module-boundary-contract ,id ,_ ,ctc-id ,_ ...))
         (send provide-contract register-provided id)
         (contract-case id ctc-id ((munge-contract id) ctc))]))
    ))

(define provide-contract
  (new provide-contract-singleton%))
