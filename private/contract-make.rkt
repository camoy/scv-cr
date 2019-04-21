#lang racket/base

(provide contract-make
         (struct-out contract-syntax))

;;
;; data
;;

(struct contract-syntax (provide-syntax require-syntax))

;;
;; functions
;;

(require scv-gt/private/syntax-util
         scv-gt/private/contract-syntax
         scv-gt/private/contract-extract)

;; Syntax -> Contract-Syntax
;; extracts contract information from syntax object properties and constructs
;; contracted provide and require forms
(define (contract-make stx)
  (define provide-stx
    #`(begin
        #,(provide-ctc-defns stx)
        (provide #,(provide-ctc-out stx))))
  (define require-stx
    #`(begin
        (module require/contracts racket/base
          #,(require-ctc-defns stx)
          (provide #,(provide-ctc-out stx)))
        (require 'require/contracts)))
  (contract-syntax provide-stx require-stx))

;; TODO: require/contracts must include the requires its proxies
