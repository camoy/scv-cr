#lang racket/base

(provide contract-make)

(require racket/set
         racket/function
         scv-gt/private/contract-syntax)

;; Syntax -> Contract-Syntax
;; extracts contract information from syntax object properties and constructs
;; contracted provide and require forms
(define (contract-make stx)
  (contract-syntax #'_ #'_))

;;
;; syntax object properties
;;

;; Syntax Symbol -> Syntax
;; associates the syntax itself with the given key
(define (syntax-property-self stx key)
  (syntax-property stx key stx))

;; Syntax Symbol -> [Set Any]
;; retrieves a set of all the values associated with the key within the given
;; syntax object
(define (syntax-property-values stx key)
  (define (syntax-property-values/key stx)
    (syntax-property-values stx key))
  (let* ([datum   (syntax-e stx)]
         [value   (syntax-property stx key)]
         [values  (if (list? datum)
                      (apply set-union
                             (map syntax-property-values/key datum))
                      (set))])
    (if value (set-add values value) values)))

;;
;; test
;;

(module+ test
  (require rackunit)

  (test-case
    "syntax-property-self"
    (let* ([stx #'hello]
           [stx/prop (syntax-property-self stx 'a)])
      (check-equal? (syntax-property stx/prop 'a) stx)))

  (test-case
    "syntax-property-values"
    (let* ([stx-a1      #'100]
           [stx-a2      #'200]
           [stx-b       #'300]
           [stx-a1/prop (syntax-property-self stx-a1 'a)]
           [stx-a2/prop (syntax-property-self stx-a2 'a)]
           [stx-b/prop  (syntax-property-self stx-b 'b)]
           [big-stx
            #`(+ (+ #,stx-a1/prop 2)
                 (* #,stx-a2/prop (+ 1 #,stx-a1/prop #,stx-b/prop)))])
      (check set=?
             (syntax-property-values big-stx 'a)
             (set stx-a1 stx-a2))
      (check set=?
             (syntax-property-values big-stx 'b)
             (set stx-b))))

  )
