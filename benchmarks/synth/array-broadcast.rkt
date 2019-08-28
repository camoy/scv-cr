(module array-broadcast typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract/base.rkt")
             (lib "racket/base.rkt")
             (lib "racket/contract.rkt")
             (submod "data.rkt" #%type-decl ".."))
    (define g12 (lambda (x) (Array? x)))
    (define g13 exact-integer?)
    (define g14 (or/c g13))
    (define g15 (vectorof g14))
    (define g16 (or/c g15))
    (define g17 '#t)
    (define g18 '#f)
    (define g19 'permissive)
    (define g20 (or/c g17 g18 g19))
    (define g21 (box/c g20))
    (define g22 (listof g16))
    (define generated-contract9 (-> g12 g16 (values g12)))
    (define generated-contract10 g21)
    (define generated-contract11
      (case-> (-> g22 (values g16)) (-> g22 g20 (values g16))))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require (only-in racket/fixnum fx<= fxmax fxmodulo)
             (only-in racket/vector vector-append)
             (only-in racket/string string-join)
             (only-in racket/list empty? first rest)
             require-typed-check
             "typed-data.rkt")
    (require "array-struct.rkt")
    (require "array-utils.rkt")
    (void)
    (: array-broadcasting (Boxof (U #f #t 'permissive)))
    (define array-broadcasting (box #t))
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
        (if (or (array-strict? arr)
                (fx<= (array-size new-arr) (array-size arr)))
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
    (:
     shape-normal-broadcast
     (Indexes Indexes Integer (-> Nothing) -> Indexes))
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
                       ((< n 0)
                        (values ds1 (shape-insert-axes ds2 (- n)) dims1))
                       (else (values ds1 ds2 dims1)))))
          (if (eq? broadcasting 'permissive)
            (shape-permissive-broadcast ds1 ds2 dims fail)
            (shape-normal-broadcast ds1 ds2 dims fail))))))
    (:
     array-shape-broadcast
     (case->
      ((Listof Indexes) -> Indexes)
      ((Listof Indexes) (U #f #t 'permissive) -> Indexes)))
    (define (array-shape-broadcast
             dss
             (broadcasting (unbox array-broadcasting)))
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
    (provide)
    (provide (contract-out (array-shape-broadcast generated-contract11))
             (contract-out (array-broadcast generated-contract9))
             (contract-out (array-broadcasting generated-contract10)))))
