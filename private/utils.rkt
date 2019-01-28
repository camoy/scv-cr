#lang racket

(require racket/syntax)
(provide (all-defined-out))

(define (load-module module-path)
  (module-declared? `(submod ,module-path #%type-decl) #t))

(define (prefix-unsafe id)
  (format-id #'_ "unsafe:~a" id))
