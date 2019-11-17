(module core-adapter typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract)
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check "../base/types.rkt")
    (begin (require "core-structs.rkt") (void))
    (provide (struct-out YMD) (struct-out HMSN) Month)
    (provide)))
