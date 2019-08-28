(module array-transform typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract/base.rkt")
             (lib "racket/base.rkt")
             (submod "data.rkt" #%type-decl "..")
             (lib "racket/contract.rkt"))
    (define g10 (lambda (x) (Array? x)))
    (define g11 (listof g10))
    (define generated-contract9 (-> g11 (values g10)))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require racket/vector
             (only-in racket/fixnum fx+)
             require-typed-check
             "typed-data.rkt")
    (require "array-struct.rkt")
    (require "array-broadcast.rkt")
    (require "array-utils.rkt")
    (void)
    (:
     array-broadcast-for-append
     (-> (Listof Array) Integer (values (Listof Array) (Listof Integer))))
    (define (array-broadcast-for-append arrs k)
      (: dss (Listof Indexes))
      (define dss
        (for/list: : (Listof Indexes) ((arr : Array arrs)) (array-shape arr)))
      (: dims Natural)
      (define dims
        (apply
         max
         (for/list:
          :
          (Listof Natural)
          ((ds : Indexes dss))
          (vector-length ds))))
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
                  (vector-append
                   ((inst make-vector Integer) (- dims dms) 1)
                   ds))
                 dss))
               (dks (map (λ: ((ds : Indexes)) (vector-ref ds k)) dss))
               (dss
                (map (λ: ((ds : Indexes)) (unsafe-vector-remove ds k)) dss))
               (ds (array-shape-broadcast dss))
               (dss
                (map
                 (λ: ((dk : Integer)) (unsafe-vector-insert ds k dk))
                 dks)))
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
          (error
           'array-append*
           "resulting axis is too large (not an Integer)"))
         (else
          (: dss (Listof Indexes))
          (define dss (map (λ: ((arr : Array)) (array-shape arr)) arrs))
          (: new-ds Indexes)
          (define new-ds (vector-copy-all (car dss)))
          (vector-set! new-ds k new-dk)
          (define old-procs
            (make-vector new-dk (unsafe-array-proc (car arrs))))
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
    (provide)
    (provide (contract-out (array-append* generated-contract9)))))
