#lang typed/racket/no-check
(require racket/contract)
(provide (contract-out))
(module require/contracts racket/base
   (require racket/contract
            "data.rkt"
            (lib "racket/contract.rkt")
            (lib "racket/base.rkt"))
   (define g8 (lambda (x) (foo? x)))
   (define g9 (-> g8))
   (define l/33 g9)
   (provide g8 g9 l/33 (contract-out (struct foo ()))))
(require (prefix-in -: (only-in 'require/contracts foo?))
          (except-in 'require/contracts foo?))
(define-values (foo?) (values -:foo?))
(require require-typed-check)
(void)
(provide (struct-out foo))
