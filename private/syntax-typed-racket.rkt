#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide syntax-property-self*
         syntax-property-self)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax -> Syntax
;; helper for calling syntax-property-self from Typed Racket source
(define-syntax-rule (syntax-property-self* key e ...)
  (syntax-property-self (let () e ...) key))

;; Syntax Symbol -> Syntax
;; associates the syntax itself with the given key
(define (syntax-property-self stx key)
  (syntax-property stx key stx))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(module+ test
  (require rackunit
           scv-gt/private/test-util)

  (test-case
    "syntax-property-self*"
    (let* ([stx #'hello]
           [stx/prop (syntax-property-self*
                      'a
                      (define foo 'bar)
                      stx)])
      (check-equal? (syntax-property stx/prop 'a) stx)))

  (test-case
    "syntax-property-self"
    (let* ([stx #'hello]
           [stx/prop (syntax-property-self stx 'a)])
      (check-equal? (syntax-property stx/prop 'a) stx)))
  )
