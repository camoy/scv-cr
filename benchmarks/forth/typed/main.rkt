#lang typed/racket/base/no-check
(define-values
  ()
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
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(require require-typed-check "../base/command-types.rkt")
(require "eval.rkt")
(require (only-in racket/file file->lines))
(define LOOPS 10)
(: main (-> (Listof String) Void))
(define (main lines)
   (for
    ((i (in-range LOOPS)))
    (define-values (_e _s) (forth-eval* lines))
    (void)))
(define lines (file->lines "../base/history-100.txt"))
(time (main lines))
