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
(require require-typed-check (only-in racket/file file->lines file->string))
(require "lcs.rkt")
(define LARGE_TEST "../base/prufock.txt")
(define SMALL_TEST "../base/hunt.txt")
(define KCFA_TYPED "../base/kcfa-typed.rkt")
(: main (-> String Void))
(define (main testfile)
   (define lines (file->lines testfile))
   (time (for* ((a lines) (b lines)) (longest-common-substring a b)))
   (void))
(main LARGE_TEST)
