#lang racket/base

(provide contract-inject)

(require scv-gt/private/contract-syntax)

;; Syntax Contract-Syntax -> Syntax
;; injects provide and require contracts into a module's syntax
(define (contract-inject stx ctc-stx)
  stx)
