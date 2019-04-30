#lang racket/base

(provide contract-opt)

(require scv-gt/private/configure)

;; Syntax -> Syntax
;; TODO: use SCV to optimize away contracts
(define (contract-opt stx)
  (if (verify-off)
      stx
      (values stx)))
