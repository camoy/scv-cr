(module image-adapted typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract)
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check)
    (begin (require "image.rkt") (void))
    (define-type Image image)
    (void)
    (provide Image empty-scene place-image circle)
    (provide)))
