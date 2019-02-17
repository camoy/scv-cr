#lang typed/racket/base/no-check
(define-values
  (g31 g32 generated-contract18)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g31 (lambda (x) (Array? x)))
             (g32 (listof g31))
             (generated-contract18 (-> g32 (values g31))))
      (values g31 g32 generated-contract18))))
(require (only-in racket/contract contract-out))
(provide (contract-out (array-append* generated-contract18)))
(require racket/vector
          (only-in racket/fixnum fx+)
          require-typed-check
          "typed-data.rkt")
(require "array-struct.rkt")
(require "array-broadcast.rkt")
(require "array-utils.rkt")
(provide)
(:
  array-broadcast-for-append
  (-> (Listof Array) Integer (values (Listof Array) (Listof Integer))))
(define (array-broadcast-for-append arrs k)
   (: dss (Listof Indexes))
   (define dss
     (for/list : (Listof Indexes) ((arr : Array arrs)) (array-shape arr)))
   (: dims Natural)
   (define dims
     (apply
      max
      (for/list : (Listof Natural) ((ds : Indexes dss)) (vector-length ds))))
   (cond
    ((not (index? dims)) (error 'array-broadcast-for-append "can't happen"))
    ((or (< k 0) (>= k dims))
     (raise-argument-error 'array-append* (format "Integer < ~a" dims) k))
    (else
     (let* ((dss
             (map
              (λ:
               ((ds : Indexes))
               (define dms (vector-length ds))
               (vector-append ((inst make-vector Integer) (- dims dms) 1) ds))
              dss))
            (dks (map (λ: ((ds : Indexes)) (vector-ref ds k)) dss))
            (dss (map (λ: ((ds : Indexes)) (unsafe-vector-remove ds k)) dss))
            (ds (array-shape-broadcast dss))
            (dss
             (map (λ: ((dk : Integer)) (unsafe-vector-insert ds k dk)) dks)))
       (define new-arrs
         (map
          (λ: ((arr : Array) (ds : Indexes)) (array-broadcast arr ds))
          arrs
          dss))
       (values new-arrs dks)))))
(: array-append* (-> (Listof Array) Array))
(define (array-append* arrs (k 0))
   (when (null? arrs)
     (raise-argument-error 'array-append* "nonempty (Listof Array)" arrs))
   (let-values (((arrs dks) (array-broadcast-for-append arrs k)))
     (define new-dk (apply + dks))
     (cond
      ((not (index? new-dk))
       (error 'array-append* "resulting axis is too large (not an Integer)"))
      (else
       (: dss (Listof Indexes))
       (define dss (map (λ: ((arr : Array)) (array-shape arr)) arrs))
       (: new-ds Indexes)
       (define new-ds (vector-copy-all (car dss)))
       (vector-set! new-ds k new-dk)
       (define old-procs (make-vector new-dk (unsafe-array-proc (car arrs))))
       (define: old-jks : Indexes (make-vector new-dk 0))
       (let arrs-loop ((arrs arrs) (dks dks) (jk 0))
         (unless (null? arrs)
           (define arr (car arrs))
           (define proc (unsafe-array-proc arr))
           (define dk (car dks))
           (let i-loop ((i 0) (jk jk))
             (cond
              ((< i dk)
               (vector-set! old-procs jk proc)
               (vector-set! old-jks jk i)
               (i-loop (+ i 1) (fx+ jk 1)))
              (else (arrs-loop (cdr arrs) (cdr dks) jk))))))
       (: arr* Array)
       (define arr*
         (unsafe-build-array
          new-ds
          (λ:
           ((js : Indexes))
           (define jk (vector-ref js k))
           (vector-set! js k (vector-ref old-jks jk))
           (define v ((vector-ref old-procs jk) js))
           (vector-set! js k jk)
           v)))
       (array-default-strict! arr*)
       arr*))))
