#lang racket/base

(provide contract-make)

;;
;; functions
;;

(require scv-gt/private/syntax-util
         scv-gt/private/contract-syntax)

;; Syntax -> Contract-Syntax
;; extracts contract information from syntax object properties and constructs
;; contracted provide and require forms
(define (contract-make stx)
  (contract-syntax #'_ #'_))
