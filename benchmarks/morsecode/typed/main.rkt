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
(require require-typed-check (only-in racket/file file->value))
(require "morse-code-strings.rkt")
(require "levenshtein.rkt")
(define word-frequency-list "./../base/frequency.rktd")
(define word-frequency-list-small "./../base/frequency-small.rktd")
(define-predicate freq-list? (Listof (List String Integer)))
(: file->words (-> String (Listof String)))
(define (file->words filename)
   (define words+freqs (file->value (string->path filename)))
   (unless (freq-list? words+freqs) (error "expected a frequency list"))
   (for/list
    :
    (Listof String)
    ((word+freq : (List String Integer) words+freqs))
    (car word+freq)))
(: allwords (Listof String))
(define allwords (file->words word-frequency-list))
(: words-small (Listof String))
(define words-small (file->words word-frequency-list-small))
(: main (-> (Listof String) Void))
(define (main words)
   (for*
    ((w1 (in-list words)) (w2 (in-list words)))
    (string->morse w1)
    (string->morse w2)
    (string-levenshtein w1 w2)
    (string-levenshtein w2 w1)
    (void)))
(time (main words-small))
