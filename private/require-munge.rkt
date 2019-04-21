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

#|
'((begin (define g26 (simple-result-> g19 2)) (define-values (stream-get) g26))
  (begin
    (define g19 (flat-named-contract 'Natural exact-nonnegative-integer?))
    (define g20 (simple-result-> g19 1))
    (define-values (stream-first) g20))
  (begin (define-values (stream-unfold) (->* (g15) () (values g19 g16))))
  (begin
    (define g15 any/c)
    (define g16 (flat-named-contract 'stream? (lambda (x) (stream? x))))
    (define g17 (simple-result-> g16 2))
    (define-values (stream3) g17))
  (begin (define-values (make-stream) g17))
  (begin
    (define g28 (listof g19))
    (define-values (stream-take) (->* (g15 g15) () (values g28))))
  (begin
    (define g22 (simple-result-> g16 0))
    (define-values (stream-rest) (->* (g15) () (values g22)))))
|#
