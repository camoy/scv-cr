#lang racket/base

(provide make-contract)

(require scv-gt/private/contract-syntax)

;; Syntax -> Contract-Syntax
;; extracts contract information from syntax object properties and constructs
;; contracted provide and require forms
(define (make-contract stx)
  (contract-syntax #'_ #'_))
