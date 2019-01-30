#lang racket

(provide (all-defined-out))

(define (load-module module-path)
  (module-declared? `(submod ,module-path #%type-decl) #t))
