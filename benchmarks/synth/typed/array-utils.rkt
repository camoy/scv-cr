#lang typed/racket/base/no-check
(define-values
  (g12
   g13
   g14
   g15
   generated-contract3
   g16
   g17
   generated-contract4
   g18
   generated-contract5
   g19
   generated-contract6
   g20
   generated-contract7
   generated-contract8
   g21
   g22
   g23
   generated-contract9
   generated-contract10
   generated-contract11)
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
    (letrec ((g12 exact-integer?)
             (g13 (or/c g12))
             (g14 (vectorof g13))
             (g15 (or/c g14))
             (generated-contract3 (-> g15 (values g13)))
             (g16 (or/c))
             (g17 (-> (values g16)))
             (generated-contract4 (-> g15 g17 (values g15)))
             (g18 symbol?)
             (generated-contract5 (-> g18 g15 (values g13)))
             (g19 (-> (values g15)))
             (generated-contract6 (-> g13 (values g19)))
             (g20 (lambda (x) (equal? x (void))))
             (generated-contract7 (-> g15 g13 g15 (values g20)))
             (generated-contract8 (-> g15 g15 (values g13)))
             (g21 any/c)
             (g22 (vectorof g21))
             (g23 (or/c g22))
             (generated-contract9 (-> g23 g13 g21 (values g23)))
             (generated-contract10 (-> g23 g13 (values g23)))
             (generated-contract11 (-> g23 (values g23))))
      (values
       g12
       g13
       g14
       g15
       generated-contract3
       g16
       g17
       generated-contract4
       g18
       generated-contract5
       g19
       generated-contract6
       g20
       generated-contract7
       generated-contract8
       g21
       g22
       g23
       generated-contract9
       generated-contract10
       generated-contract11))))
(require (only-in racket/contract contract-out))
(provide (contract-out (array-shape-size generated-contract3))
          (contract-out (check-array-shape generated-contract4))
          (contract-out (check-array-shape-size generated-contract5))
          (contract-out (make-thread-local-indexes generated-contract6))
          (contract-out (next-indexes! generated-contract7))
          (contract-out (unsafe-array-index->value-index generated-contract8))
          (contract-out (unsafe-vector-insert generated-contract9))
          (contract-out (unsafe-vector-remove generated-contract10))
          (contract-out (vector-copy-all generated-contract11)))
(require (only-in racket/performance-hint begin-encourage-inline)
          (for-syntax racket/base)
          (only-in racket/fixnum fx* fx+)
          "typed-data.rkt")
(provide)
(begin-encourage-inline
  (: vector->supertype-vector (All (A B) ((Vectorof A) -> (Vectorof (U A B)))))
  (define (vector->supertype-vector js)
    (define dims (vector-length js))
    (cond
     ((= dims 0) (vector))
     (else
      (define:
       new-js
       :
       (Vectorof (U A B))
       (make-vector dims (vector-ref js 0)))
      (let loop ((i 1))
        (cond
         ((< i dims) (vector-set! new-js i (vector-ref js i)) (loop (+ i 1)))
         (else new-js))))))
  (: vector-copy-all (All (A) ((Vectorof A) -> (Vectorof A))))
  (define (vector-copy-all js) ((inst vector->supertype-vector A A) js))
  (: array-shape-size (Indexes -> Integer))
  (define (array-shape-size ds)
    (define dims (vector-length ds))
    (let loop ((i 0) (n 1))
      (cond
       ((< i dims) (define d (vector-ref ds i)) (loop (+ i 1) (* n d)))
       (else n))))
  (: check-array-shape-size (Symbol Indexes -> Integer))
  (define (check-array-shape-size name ds)
    (define size (array-shape-size ds))
    (cond
     ((index? size) size)
     (else
      (error
       name
       "array size ~e (for shape ~e) is too large (is not an Index)"
       size
       ds))))
  (: check-array-shape ((Vectorof Integer) (-> Nothing) -> Indexes))
  (define (check-array-shape ds fail)
    (define dims (vector-length ds))
    (define: new-ds : Indexes (make-vector dims 0))
    (let loop ((i 0))
      (cond
       ((< i dims)
        (define di (vector-ref ds i))
        (cond
         ((index? di) (vector-set! new-ds i di) (loop (+ i 1)))
         (else (fail))))
       (else new-ds))))
  (: unsafe-array-index->value-index (Indexes Indexes -> Integer))
  (define (unsafe-array-index->value-index ds js)
    (define dims (vector-length ds))
    (let loop ((i 0) (j 0))
      (cond
       ((< i dims)
        (define di (vector-ref ds i))
        (define ji (vector-ref js i))
        (loop (+ i 1) (fx+ ji (fx* di j))))
       (else j)))))
(: raise-array-index-error (Symbol Indexes In-Indexes -> Nothing))
(define (raise-array-index-error name ds js)
   (error name "expected indexes for shape ~e; given ~e" (vector->list ds) js))
(: array-index->value-index (Symbol Indexes In-Indexes -> Integer))
(define (array-index->value-index name ds js)
   (define (raise-index-error) (raise-array-index-error name ds js))
   (define dims (vector-length ds))
   (unless (= dims (vector-length js)) (raise-index-error))
   (let loop ((i 0) (j 0))
     (cond
      ((< i dims)
       (define di (vector-ref ds i))
       (define ji (vector-ref js i))
       (cond
        ((and (exact-integer? ji) (<= 0 ji) (< ji di))
         (loop (+ i 1) (fx+ ji (fx* di j))))
        (else (raise-index-error))))
      (else j))))
(: check-array-indexes (Symbol Indexes In-Indexes -> Indexes))
(define (check-array-indexes name ds js)
   (define (raise-index-error) (raise-array-index-error name ds js))
   (define dims (vector-length ds))
   (unless (= dims (vector-length js)) (raise-index-error))
   (define: new-js : Indexes (make-vector dims 0))
   (let loop ((i 0))
     (cond
      ((< i dims)
       (define di (vector-ref ds i))
       (define ji (vector-ref js i))
       (cond
        ((and (exact-integer? ji) (<= 0 ji) (< ji di))
         (vector-set! new-js i ji)
         (loop (+ i 1)))
        (else (raise-index-error))))
      (else new-js))))
(: unsafe-vector-remove (All (I) ((Vectorof I) Integer -> (Vectorof I))))
(define (unsafe-vector-remove vec k)
   (define n (vector-length vec))
   (define n-1 (sub1 n))
   (cond
    ((not (index? n-1)) (error 'unsafe-vector-remove "internal error"))
    (else
     (define: new-vec : (Vectorof I) (make-vector n-1 (vector-ref vec 0)))
     (let loop ((i 0))
       (when (< i k)
         (vector-set! new-vec i (vector-ref vec i))
         (loop (+ i 1))))
     (let loop ((i k))
       (cond
        ((< i n-1)
         (vector-set! new-vec i (vector-ref vec (+ i 1)))
         (loop (+ i 1)))
        (else new-vec))))))
(: unsafe-vector-insert (All (I) ((Vectorof I) Integer I -> (Vectorof I))))
(define (unsafe-vector-insert vec k v)
   (define n (vector-length vec))
   (define: dst-vec : (Vectorof I) (make-vector (+ n 1) v))
   (let loop ((i 0))
     (when (< i k) (vector-set! dst-vec i (vector-ref vec i)) (loop (+ i 1))))
   (let loop ((i k))
     (when (< i n)
       (let ((i+1 (+ i 1)))
         (vector-set! dst-vec i+1 (vector-ref vec i))
         (loop i+1))))
   dst-vec)
(: make-thread-local-indexes (Integer -> (-> Indexes)))
(define (make-thread-local-indexes dims)
   (let:
    ((val : (Thread-Cellof (U #f Indexes)) (make-thread-cell #f)))
    (λ ()
      (or (thread-cell-ref val)
          (let:
           ((v : Indexes (make-vector dims 0)))
           (thread-cell-set! val v)
           v)))))
(: next-indexes! (Indexes Integer Indexes -> Void))
(define (next-indexes! ds dims js)
   (let loop ((k dims))
     (unless (zero? k)
       (let ((k (- k 1)))
         (define jk (vector-ref js k))
         (define dk (vector-ref ds k))
         (let ((jk (+ jk 1)))
           (cond
            ((>= jk dk) (vector-set! js k 0) (loop k))
            (else (vector-set! js k jk))))))))
