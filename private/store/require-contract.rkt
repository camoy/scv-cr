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
      (hash-ref required (current-target) '()))

    (define/public (already-required? mod)
      (member mod (all-requires)))

    (define make-contract-out
      (match-lambda
        [(list ctc-id id mod)
         (define ctc
           (let go ([x ctc-id])
             (define ctc*
               (send require-definition lookup x))
             (if ctc*
                 (go (syntax-e (cadr ctc*)))
                 ((munge-contract id) x))))
         (unless (already-required? mod)
           (hash-set! required
                      (current-target)
                      (cons mod (all-requires))))
         (contract-case id ctc-id ctc)]))
    ))

(define require-contract
  (new require-contract-singleton%))
