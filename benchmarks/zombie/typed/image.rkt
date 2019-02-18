#lang typed/racket/base/no-check
(define-values
  (g13
   g14
   g15
   g16
   generated-contract5
   generated-contract6
   g17
   generated-contract11
   g18
   generated-contract7
   g19
   g20
   g21
   g22
   g23
   g24
   generated-contract8
   g25
   generated-contract9
   generated-contract12)
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
    (letrec ((g13 real?)
             (g14 (or/c g13))
             (g15 string?)
             (g16 (lambda (x) (image? x)))
             (generated-contract5 (-> g14 g15 g15 (values g16)))
             (generated-contract6 (-> g14 g14 (values g16)))
             (g17 any/c)
             (generated-contract11 (-> g17 (values g16)))
             (g18 (λ (_) #f))
             (generated-contract7 g18)
             (g19 (λ (_) #f))
             (g20 '#t)
             (g21 '#f)
             (g22 (or/c g20 g21))
             (g23 (-> g17 (values g22)))
             (g24 (or/c g19 g23))
             (generated-contract8 g24)
             (g25 any/c)
             (generated-contract9 (-> g16 (values g25)))
             (generated-contract12 (-> g16 g14 g14 g16 (values g16))))
      (values
       g13
       g14
       g15
       g16
       generated-contract5
       generated-contract6
       g17
       generated-contract11
       g18
       generated-contract7
       g19
       g20
       g21
       g22
       g23
       g24
       generated-contract8
       g25
       generated-contract9
       generated-contract12))))
(require (only-in racket/contract contract-out))
(provide (contract-out (circle generated-contract5))
          (contract-out (empty-scene generated-contract6))
          (contract-out (struct image ((impl g17))))
          (contract-out (place-image generated-contract12)))
(provide)
(struct image ((impl : Any)))
(define-type Image image)
(: empty-scene (-> Real Real Image))
(define (empty-scene w h)
   (when (or (negative? w) (negative? h))
     (error 'image "Arguments must be non-negative real numbers"))
   (image (cons w h)))
(: place-image (-> Image Real Real Image Image))
(define (place-image i1 w h i2) (image (list i1 w h i2)))
(: circle (-> Real String String Image))
(define (circle radius style color) (image (list radius style color)))
