(module image-adapted typed/racket/base/no-check
   (#%module-begin
    (require racket/contract)
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check)
    (require "image.rkt")
    (define-type Image image)
    (void)
    (provide Image empty-scene place-image circle)
    (provide)))
