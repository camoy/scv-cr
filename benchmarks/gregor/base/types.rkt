(module types typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract)
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (define-type Month (U 1 2 3 4 5 6 7 8 9 10 11 12))
    (provide Month)
    (provide)))
