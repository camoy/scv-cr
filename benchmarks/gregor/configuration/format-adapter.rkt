(module format-adapter typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract)
    (module require/contracts racket/base
      (require soft-contract/fake-contract
               (lib "racket/contract.rkt")
               (lib "racket/base.rkt")
               (lib "racket/contract/base.rkt")
               (lib "typed-racket/types/numeric-predicates.rkt"))
      (define g6 t:exact-rational?)
      (define g7 (or/c g6))
      (define g8 exact-nonnegative-integer?)
      (define g9 (or/c g8))
      (define g10 string?)
      (define l/1 (-> g7 g9 g10 (values g10)))
      (define l/3 (-> g7 g9 (values g10)))
      (define l/5 (-> g7 g9 g10 (values g10)))
      (begin (define ~r #:opaque) (define ~r* #:opaque) (define ~r** #:opaque))
      (provide g6
               g7
               g8
               g9
               g10
               l/1
               l/5
               l/3
               (contract-out (~r** l/5))
               (contract-out (~r l/1))
               (contract-out (~r* l/3))))
    (require (prefix-in -: (only-in 'require/contracts ~r* ~r ~r**))
             (except-in 'require/contracts ~r* ~r ~r**))
    (define-values (~r* ~r ~r**) (values -:~r* -:~r -:~r**))
    (require scv-gt/opaque)
    (begin (void) (provide ~r ~r* ~r**))
    (provide)))
