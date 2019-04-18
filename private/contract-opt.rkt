#lang racket/base

(provide contract-opt)

;; Syntax -> Syntax
;; uses SCV to optimize away contracts
(define (contract-opt stx)
  stx)
