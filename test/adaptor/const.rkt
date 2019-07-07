#lang typed/racket/no-check
(require racket/contract)
(provide (contract-out))
(module require/contracts racket/base
   (require racket/contract)
   (provide (contract-out)))
(require (prefix-in -: (only-in 'require/contracts))
          (except-in 'require/contracts))
(define-values () (values))
(require "data-adaptor.rkt")
(define p (foo))
