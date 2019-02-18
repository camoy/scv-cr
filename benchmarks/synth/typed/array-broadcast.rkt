#lang typed/racket/base/no-check
(define-values
  (g34
   g35
   g36
   g37
   g38
   generated-contract16
   g39
   g40
   g41
   g42
   g43
   generated-contract17
   g44
   generated-contract18)
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
    (letrec ((g34 (lambda (x) (Array? x)))
             (g35 exact-integer?)
             (g36 (or/c g35))
             (g37 (vectorof g36))
             (g38 (or/c g37))
             (generated-contract16 (-> g34 g38 (values g34)))
             (g39 '#t)
             (g40 '#f)
             (g41 'permissive)
             (g42 (or/c g39 g40 g41))
             (g43 (parameter/c g42 g42))
             (generated-contract17 g43)
             (g44 (listof g38))
             (generated-contract18 (->* (g44) (g42) (values g38))))
      (values
       g34
       g35
       g36
       g37
       g38
       generated-contract16
       g39
       g40
       g41
       g42
       g43
       generated-contract17
       g44
       generated-contract18))))
(require (only-in racket/contract contract-out))
(provide (contract-out (array-broadcast generated-contract16))
          (contract-out (array-broadcasting generated-contract17))
          (contract-out (array-shape-broadcast generated-contract18)))
(require (only-in racket/fixnum fx<= fxmax fxmodulo)
          (only-in racket/vector vector-append)
          (only-in racket/string string-join)
          (only-in racket/list empty? first rest)
          require-typed-check
          "typed-data.rkt")
(require "array-struct.rkt")
(require "array-utils.rkt")
(provide)
(: array-broadcasting (Parameterof (U #f #t 'permissive)))
(define array-broadcasting (make-parameter #t))
(: shift-stretch-axes (-> Array Indexes Array))
(define (shift-stretch-axes arr new-ds)
   (define old-ds (array-shape arr))
   (define old-dims (vector-length old-ds))
   (define new-dims (vector-length new-ds))
   (define shift
     (let ((shift (- new-dims old-dims)))
       (cond
        ((index? shift) shift)
        (else
         (error
          'array-broadcast
          "cannot broadcast to a lower-dimensional shape; given ~e and ~e"
          arr
          new-ds)))))
   (define old-js (make-thread-local-indexes old-dims))
   (define old-f (unsafe-array-proc arr))
   (unsafe-build-array
    new-ds
    (λ:
     ((new-js : Indexes))
     (let ((old-js (old-js)))
       (let:
        loop
        :
        Float
        ((k : Integer 0))
        (cond
         ((< k old-dims)
          (define new-jk (vector-ref new-js (+ k shift)))
          (define old-dk (vector-ref old-ds k))
          (define old-jk (fxmodulo new-jk old-dk))
          (vector-set! old-js k old-jk)
          (loop (+ k 1)))
         (else (old-f old-js))))))))
(: array-broadcast (-> Array Indexes Array))
(define (array-broadcast arr ds)
   (cond
    ((equal? ds (array-shape arr)) arr)
    (else
     (define new-arr (shift-stretch-axes arr ds))
     (if (or (array-strict? arr) (fx<= (array-size new-arr) (array-size arr)))
       new-arr
       (begin (array-default-strict! new-arr) new-arr)))))
(: shape-insert-axes (Indexes Integer -> Indexes))
(define (shape-insert-axes ds n)
   (vector-append ((inst make-vector Integer) n 1) ds))
(:
  shape-permissive-broadcast
  (Indexes Indexes Integer (-> Nothing) -> Indexes))
(define (shape-permissive-broadcast ds1 ds2 dims fail)
   (define: new-ds : Indexes (make-vector dims 0))
   (let loop ((k 0))
     (cond
      ((< k dims)
       (define dk1 (vector-ref ds1 k))
       (define dk2 (vector-ref ds2 k))
       (vector-set!
        new-ds
        k
        (cond ((or (= dk1 0) (= dk2 0)) (fail)) (else (fxmax dk1 dk2))))
       (loop (+ k 1)))
      (else new-ds))))
(: shape-normal-broadcast (Indexes Indexes Integer (-> Nothing) -> Indexes))
(define (shape-normal-broadcast ds1 ds2 dims fail)
   (define: new-ds : Indexes (make-vector dims 0))
   (let loop ((k 0))
     (cond
      ((< k dims)
       (define dk1 (vector-ref ds1 k))
       (define dk2 (vector-ref ds2 k))
       (vector-set!
        new-ds
        k
        (cond
         ((= dk1 dk2) dk1)
         ((and (= dk1 1) (> dk2 0)) dk2)
         ((and (= dk2 1) (> dk1 0)) dk1)
         (else (fail))))
       (loop (+ k 1)))
      (else new-ds))))
(:
  shape-broadcast2
  (Indexes Indexes (-> Nothing) (U #f #t 'permissive) -> Indexes))
(define (shape-broadcast2 ds1 ds2 fail broadcasting)
   (cond
    ((equal? ds1 ds2) ds1)
    ((not broadcasting) (fail))
    (else
     (define dims1 (vector-length ds1))
     (define dims2 (vector-length ds2))
     (define n (- dims2 dims1))
     (let-values (((ds1 ds2 dims)
                   (cond
                    ((> n 0) (values (shape-insert-axes ds1 n) ds2 dims2))
                    ((< n 0) (values ds1 (shape-insert-axes ds2 (- n)) dims1))
                    (else (values ds1 ds2 dims1)))))
       (if (eq? broadcasting 'permissive)
         (shape-permissive-broadcast ds1 ds2 dims fail)
         (shape-normal-broadcast ds1 ds2 dims fail))))))
(:
  array-shape-broadcast
  (case->
   ((Listof Indexes) -> Indexes)
   ((Listof Indexes) (U #f #t 'permissive) -> Indexes)))
(define (array-shape-broadcast dss (broadcasting (array-broadcasting)))
   (define (fail)
     (error
      'array-shape-broadcast
      "incompatible array shapes (array-broadcasting ~v): ~a"
      broadcasting
      (string-join (map (λ (ds) (format "~e" ds)) dss) ", ")))
   (cond
    ((empty? dss) #())
    (else
     (for/fold
      ((new-ds (first dss)))
      ((ds (in-list (rest dss))))
      (shape-broadcast2 new-ds ds fail broadcasting)))))
