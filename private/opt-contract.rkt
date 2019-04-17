#lang racket/base

(provide opt-contract)

;; Syntax -> Syntax
;; uses SCV to optimize away contracts
(define (opt-contract stx)
  stx)
