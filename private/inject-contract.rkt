#lang racket/base

(provide inject-contract)

(require scv-gt/private/contract-syntax)

;; Syntax Contract-Syntax -> Syntax
;; injects provide and require contracts into a module's syntax
(define (inject-contract stx ctc-stx)
  stx)
