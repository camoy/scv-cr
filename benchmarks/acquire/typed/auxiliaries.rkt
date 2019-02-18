#lang typed/racket/base/no-check
(define-values
  (g10
   g11
   g12
   g13
   g14
   generated-contract7
   g15
   g16
   g17
   g18
   g19
   generated-contract8
   generated-contract9)
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
    (letrec ((g10 any/c)
             (g11 (listof g10))
             (g12 '#t)
             (g13 '#f)
             (g14 (or/c g12 g13))
             (generated-contract7 (-> g11 (values g14)))
             (g15 real?)
             (g16 (or/c g15))
             (g17 (-> g10 (values g16)))
             (g18 (-> any/c g10))
             (g19 (listof g11))
             (generated-contract8 (-> g11 g17 g18 (values g19)))
             (generated-contract9 (-> g11 (values g10))))
      (values
       g10
       g11
       g12
       g13
       g14
       generated-contract7
       g15
       g16
       g17
       g18
       g19
       generated-contract8
       generated-contract9))))
(require (only-in racket/contract contract-out))
(provide (contract-out (distinct generated-contract7))
          (contract-out (ext:aux:partition generated-contract8))
          (contract-out (randomly-pick generated-contract9)))
(provide (rename-out (ext:aux:partition aux:partition)))
(require (only-in racket/list first second rest range cons?))
(: randomly-pick (All (A) (-> (Listof A) A)))
(define (randomly-pick l) (list-ref l (random (length l))))
(:
  ext:aux:partition
  (All (A B) (-> (Listof A) (-> A Real) (-> A B) (Listof (Listof B)))))
(define (ext:aux:partition lo-h-size selector info)
   (define s* (map selector lo-h-size))
   (define s1 (sort s* <=))
   (define s2 (sort s* <=))
   (unless (or (equal? s* s1) (equal? s* s2))
     (error 'aux:partition "Precondition: expected a sorted list"))
   ((inst aux:partition A B) lo-h-size selector info))
(:
  aux:partition
  (All (A B) (-> (Listof A) (-> A Real) (-> A B) (Listof (Listof B)))))
(define (aux:partition lo-h-size selector info)
   (define one (first lo-h-size))
   (let loop :
     (Listof (Listof B))
     ((pred : Real (selector one))
      (l : (Listof A) (rest lo-h-size))
      (pt : (Listof B) (list (info one))))
     (cond
      ((null? l) (list (reverse pt)))
      (else
       (define two (first l))
       (if (not (= (selector two) pred))
         (cons (reverse pt) (loop (selector two) (rest l) (list (info two))))
         (loop pred (rest l) (cons (info two) pt)))))))
(: distinct (-> (Listof Any) Boolean))
(define (distinct s)
   (cond
    ((null? s) #t)
    (else (and (not (member (first s) (rest s))) (distinct (rest s))))))
