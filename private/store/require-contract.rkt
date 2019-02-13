#lang racket

(require tr-contract/private/store
         tr-contract/private/store/require-definition
         tr-contract/private/munge-contract)

(provide require-contract)

(define require-contract-singleton%
  (class store%
    (super-new [path "_require-contract.dat"])
    (field [required (make-hash)])

    (define/override (process record)
      (append-map make-contract-out (reverse record)))

    (define/public (all-requires)
      (hash-keys required))

    (define/public (already-required? mod)
      (hash-ref required mod #f))

    (define make-contract-out
      (match-lambda
        [(list ctc-id id mod)
         (define ctc
           (send require-definition lookup ctc-id))
         (define ctc*
           (if ctc
               (cadr ctc)
               ((munge-contract id) ctc-id)))
         (hash-set! required mod #t)
         (contract-case id ctc-id ctc*)]))
    ))

(define require-contract
  (new require-contract-singleton%))
