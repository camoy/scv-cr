#lang typed/racket/base/no-check
(define-values
  (g10 generated-contract5)
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
    (letrec ((g10 string?) (generated-contract5 (-> g10 (values g10))))
      (values g10 generated-contract5))))
(require (only-in racket/contract contract-out))
(provide (contract-out (string->morse generated-contract5)))
(provide)
(require require-typed-check)
(require "morse-code-table.rkt")
(: char->dit-dah-string (-> Char String))
(define (char->dit-dah-string letter)
   (define res (hash-ref char-table (char-downcase letter) #f))
   (if (eq? #f res)
     (raise-argument-error 'letter-map "character in map" 0 letter)
     res))
(: string->morse (-> String String))
(define (string->morse str)
   (define morse-list
     (for/list : (Listof String) ((c : Char str)) (char->dit-dah-string c)))
   (apply string-append morse-list))
