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
(require require-typed-check "../base/typed-zo-structs.rkt")
(require "zo-shell.rkt")
(define TYPED-DATA '("../base/typed-zo-find_rkt.zo"))
(define UNTYPED-DATA
   '("../base/main_rkt.zo"
     "../base/zo-shell_rkt.zo"
     "../base/zo-string_rkt.zo"
     "../base/zo-transition_rkt.zo"))
(: parse-data (-> (Listof Path-String) (Listof zo)))
(define (parse-data ps*) (map zo-read ps*))
(: main (-> (Listof Path-String) Void))
(define (main ps*)
   (define zo* (parse-data ps*))
   (time (for ((zo (in-list zo*))) (init (vector zo "branch")))))
(main TYPED-DATA)
