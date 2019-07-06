#lang typed/racket/base

(require require-typed-check)
(require/typed/check "server.rkt" [table (HashTable Char String)])
(provide t)

(: t (HashTable Char String))
(define t table)
