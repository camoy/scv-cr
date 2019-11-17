(module gregor-adapter typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract)
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check "core-adapter.rkt")
    (begin (require "gregor-structs.rkt") (void))
    (void)
    (provide (struct-out Date)
             (struct-out Time)
             (struct-out DateTime)
             (struct-out Moment))
    (provide)))
