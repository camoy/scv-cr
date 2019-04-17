#lang racket/base

;; Syntax -> Contract-Syntax
;; extracts contract information from syntax object properties and constructs
;; contracted provide and require forms
(define (make-contract stx)
  (contract-syntax #'_ #'_))
