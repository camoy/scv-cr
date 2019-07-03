#lang racket

(define e? 'even?)
(define binding
  (syntax-binding-set-extend
   (syntax-binding-set)
   e?
   0
   (module-path-index-join "adapter.rkt" #f)))
(define stx (syntax-binding-set->syntax binding e?))
(define ns (make-base-namespace))

(parameterize ([current-namespace ns])
  (namespace-require "adapter.rkt")
  (eval stx))
