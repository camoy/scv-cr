#lang racket/base

(provide provide-munge)

;;
;; functions
;;

(require syntax/parse
         scv-gt/private/contract-munge)

;; Syntax -> Syntax
;; takes provide syntax from Typed Racket and extracts out only the contract definitions
;; and munges them
(define (provide-munge stx)
  (syntax-parse stx
    #:datum-literals (begin define define-values define-module-boundary-contract)
    [(begin (define xs x-def) ...
            (define-values (y) y-def)
            (define-module-boundary-contract
              _ ...))
     (with-syntax ([(x-def* ...)
                    (map contract-munge
                         (syntax-e #'(x-def ...)))]
                   [y-def*
                    (contract-munge #'y-def)])
       #`(begin (define xs x-def*) ...
                (define-values (y) y-def*)))]))
