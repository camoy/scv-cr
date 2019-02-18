#lang typed/racket/no-check
(define-values
  (g4 g5 g6 generated-contract3)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g4 (lambda (x) (posn? x)))
             (g5 (listof g4))
             (g6 (cons/c g4 g5))
             (generated-contract3 (-> g6 (values g5))))
      (values g4 g5 g6 generated-contract3))))
(require (only-in racket/contract contract-out))
(provide (contract-out (cut-tail generated-contract3)))
(require "data-adaptor.rkt")
(: cut-tail : (-> (NEListof Posn) (Listof Posn)))
(define (cut-tail segs)
   (let ((r (cdr segs)))
     (cond ((empty? r) empty) (else (cons (car segs) (cut-tail r))))))
(provide)
