#lang racket

(require tr-contract/private/store/struct-data
         syntax/parse
         racket/syntax)

(provide munge-contract
         prefix-predicates
         prefix-unsafe)

(define prefix-predicates
  (make-parameter #f))

(define ((munge-contract id) stx)
  (syntax-parse
      stx #:datum-literals (lambda equal? quote class/c)
      [(lambda ((~literal x)) (equal? (~literal x) (quote y)))
       #:when (void? (syntax-e #'y))
       #'void?]
      [y #:when (void? (syntax-e #'y))
       #'void?]
      [(lambda ((~literal x)) (f (~literal x)))
       #:when (let ([function-desc (send struct-data struct-function? (syntax-e #'f))])
                (and (prefix-predicates)
                     function-desc
                     (equal? (car function-desc) 'predicate)))
       (prefix-unsafe #'f)]
      [(f x ...)
       #:when (member (syntax-e #'f) '(class/c object/c object/c-opaque))
       #`(#,(prefix-with-c #'f)
          #,@(map prefix-specs
                  (syntax->list #'(x ...))))]
      [(f args ...)
       #`(f #,@(map (munge-contract id)
                    (syntax->list #'(args ...))))]
      [other #'other]))

(define (prefix-unsafe id)
  (format-id #'_ "unsafe:~a" id))

(define (prefix-specs stx)
  (syntax-parse
      stx
    [(k v ...)
     #:when (member (syntax-e #'k) '(field init init-field
                                           inherit inherit-field
                                           super inner
                                           override augment
                                           augride absent))
     #`(#,(prefix-with-c #'k) v ...)]
    [x #'x]))

(define (prefix-with-c id)
  (format-id #'_ "c:~a" id))
