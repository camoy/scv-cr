#lang racket/base

(provide require-munge)

;;
;; functions
;;

(require syntax/parse
         scv-gt/private/contract-munge)

;; Syntax -> Syntax
;; takes provide syntax from Typed Racket and extracts out only the contract definitions
;; and munges them
(define (require-munge stx)
  (syntax-parse stx
    #:datum-literals (begin define define-values)
    [(begin (define xs x-def) ...
            (define-values (y) y-def))
     (with-syntax ([(x-def* ...)
                    (map contract-munge
                         (syntax-e #'(xs ...))
                         (syntax-e #'(x-def ...)))]
                   [y-def*
                    (contract-munge #'y #'y-def)])
       #`(begin (define xs x-def*) ...
                (define-values (y) y-def*)))]))
