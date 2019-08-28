(module array-struct typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (submod "data.rkt" #%type-decl "..")
             (lib "racket/contract/base.rkt"))
    (define g15 (lambda (x) (Array? x)))
    (define g16 (lambda (x) (equal? x (void))))
    (define g17 exact-integer?)
    (define g18 (or/c g17))
    (define g19 (vectorof g18))
    (define g20 (or/c g19))
    (define g21 '#t)
    (define g22 '#f)
    (define g23 (or/c g21 g22))
    (define g24 (box/c g23))
    (define g25 (λ (_) #f))
    (define g26 any/c)
    (define g27 (-> g26 (values g23)))
    (define g28 (or/c g25 g27))
    (define g29 flonum?)
    (define g30 (or/c g29))
    (define g31 (-> g20 (values g30)))
    (define g32 (-> g20 (values g30)))
    (define g33 (vectorof g30))
    (define g34 (or/c g33))
    (define g35 (lambda (x) (Mutable-Array? x)))
    (define generated-contract3 (-> g15 (values g16)))
    (define generated-contract4 (-> g15 (values g20)))
    (define generated-contract5 (-> g15 (values g18)))
    (define generated-contract6 (-> g15 (values g23)))
    (define generated-contract7 g24)
    (define generated-contract8 g28)
    (define generated-contract9 (-> g20 g31 (values g15)))
    (define generated-contract10 (-> g20 g30 (values g15)))
    (define generated-contract11 (-> g15 (values g32)))
    (define generated-contract12 (-> g20 g31 (values g15)))
    (define generated-contract13 (-> g20 g31 (values g15)))
    (define generated-contract14 (-> g20 g34 (values g35)))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require (for-syntax racket/base syntax/parse)
             (only-in racket/fixnum fx+ fx*)
             require-typed-check
             "typed-data.rkt")
    (require "array-utils.rkt")
    (define-values
     (array? array-shape array-size unsafe-array-proc)
     (values Array? Array-shape Array-size Array-unsafe-proc))
    (void)
    (define-syntax-rule
     (for-each-array+data-index ds-expr f-expr)
     (let*:
      ((ds : Indexes ds-expr) (dims : Integer (vector-length ds)))
      (define-syntax-rule
       (f js j)
       ((ann f-expr (Indexes Integer -> Void)) js j))
      (cond
       ((= dims 0) (f ds 0))
       (else
        (define: js : Indexes (make-vector dims 0))
        (case dims
          ((1)
           (define: d0 : Integer (vector-ref ds 0))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0))
            (when (< j0 d0)
              (vector-set! js 0 j0)
              (f js j0)
              (j0-loop (+ j0 1)))))
          ((2)
           (define: d0 : Integer (vector-ref ds 0))
           (define: d1 : Integer (vector-ref ds 1))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0) (j : Integer 0))
            (when (< j0 d0)
              (vector-set! js 0 j0)
              (let:
               j1-loop
               :
               Void
               ((j1 : Integer 0) (j : Integer j))
               (cond
                ((< j1 d1)
                 (vector-set! js 1 j1)
                 (f js j)
                 (j1-loop (+ j1 1) (fx+ j 1)))
                (else (j0-loop (+ j0 1) j)))))))
          (else
           (let:
            i-loop
            :
            Integer
            ((i : Integer 0) (j : Integer 0))
            (cond
             ((< i dims)
              (define: di : Integer (vector-ref ds i))
              (let:
               ji-loop
               :
               Integer
               ((ji : Integer 0) (j : Integer j))
               (cond
                ((< ji di)
                 (vector-set! js i ji)
                 (ji-loop (+ ji 1) (i-loop (+ i 1) j)))
                (else j))))
             (else (f js j) (fx+ j 1))))
           (void)))))))
    (define-syntax-rule
     (for-each-array-index ds-expr f-expr)
     (let*:
      ((ds : Indexes ds-expr) (dims : Integer (vector-length ds)))
      (define-syntax-rule (f js) ((ann f-expr (Indexes -> Void)) js))
      (cond
       ((= dims 0) (f ds))
       (else
        (define: js : Indexes (make-vector dims 0))
        (case dims
          ((1)
           (define: d0 : Integer (vector-ref ds 0))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0))
            (when (< j0 d0) (vector-set! js 0 j0) (f js) (j0-loop (+ j0 1)))))
          ((2)
           (define: d0 : Integer (vector-ref ds 0))
           (define: d1 : Integer (vector-ref ds 1))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0))
            (when (< j0 d0)
              (vector-set! js 0 j0)
              (let:
               j1-loop
               :
               Void
               ((j1 : Integer 0))
               (cond
                ((< j1 d1) (vector-set! js 1 j1) (f js) (j1-loop (+ j1 1)))
                (else (j0-loop (+ j0 1))))))))
          (else
           (let:
            i-loop
            :
            Void
            ((i : Integer 0))
            (cond
             ((< i dims)
              (define: di : Integer (vector-ref ds i))
              (let:
               ji-loop
               :
               Void
               ((ji : Integer 0))
               (when (< ji di)
                 (vector-set! js i ji)
                 (i-loop (+ i 1))
                 (ji-loop (+ ji 1)))))
             (else (f js))))))))))
    (define-syntax-rule
     (for-each-data-index ds-expr f-expr)
     (let*:
      ((ds : Indexes ds-expr) (dims : Integer (vector-length ds)))
      (define-syntax-rule (f j) ((ann f-expr (Integer -> Void)) j))
      (cond
       ((= dims 0) (f 0))
       (else
        (case dims
          ((1)
           (define: d0 : Integer (vector-ref ds 0))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0))
            (when (< j0 d0) (f j0) (j0-loop (+ j0 1)))))
          ((2)
           (define: d0 : Integer (vector-ref ds 0))
           (define: d1 : Integer (vector-ref ds 1))
           (let:
            j0-loop
            :
            Void
            ((j0 : Integer 0) (j : Integer 0))
            (when (< j0 d0)
              (let:
               j1-loop
               :
               Void
               ((j1 : Integer 0) (j : Integer j))
               (cond
                ((< j1 d1) (f j) (j1-loop (+ j1 1) (fx+ j 1)))
                (else (j0-loop (+ j0 1) j)))))))
          (else
           (let:
            i-loop
            :
            Integer
            ((i : Integer 0) (j : Integer 0))
            (cond
             ((< i dims)
              (define: di : Integer (vector-ref ds i))
              (let:
               ji-loop
               :
               Integer
               ((ji : Integer 0) (j : Integer j))
               (cond
                ((< ji di) (ji-loop (+ ji 1) (i-loop (+ i 1) j)))
                (else j))))
             (else (f j) (fx+ j 1))))
           (void)))))))
    (define-syntax-rule
     (inline-build-array-data ds-expr g-expr A)
     (let*:
      ((ds : Indexes ds-expr) (dims : Integer (vector-length ds)))
      (define-syntax-rule (g js j) ((ann g-expr (Indexes Integer -> A)) js j))
      (define:
       size
       :
       Integer
       (let:
        loop
        :
        Integer
        ((k : Integer 0) (size : Integer 1))
        (cond
         ((< k dims) (loop (+ k 1) (fx* size (vector-ref ds k))))
         (else size))))
      (cond
       ((= size 0) (ann (vector) (Vectorof A)))
       (else
        (define: js0 : Indexes (make-vector dims 0))
        (define: vs : (Vectorof A) (make-vector size (g js0 0)))
        (for-each-array+data-index ds (λ (js j) (vector-set! vs j (g js j))))
        vs))))
    (: array-strictness (Boxof (U #f #t)))
    (define array-strictness (box #t))
    (define-syntax-rule
     (make-unsafe-array-proc ds ref)
     (λ: ((js : Indexes)) (ref (unsafe-array-index->value-index ds js))))
    (: array-strict? (Array -> Boolean))
    (define (array-strict? arr) (unbox (Array-strict? arr)))
    (: array-strict! (Array -> Void))
    (define (array-strict! arr)
      (define strict? (Array-strict? arr))
      (unless (unbox strict?) ((Array-strict! arr)) (set-box! strict? #t)))
    (: array-default-strict! (Array -> Void))
    (define (array-default-strict! arr)
      (define strict? (Array-strict? arr))
      (when (and (not (unbox strict?)) (unbox array-strictness))
        ((Array-strict! arr))
        (set-box! strict? #t)))
    (:
     unsafe-build-array
     ((Vectorof Integer) ((Vectorof Integer) -> Float) -> Array))
    (define (unsafe-build-array ds f)
      (let ((f (box f)))
        (define size (check-array-shape-size 'unsafe-build-array ds))
        (define (strict!)
          (let*: ((old-f : (-> (Vectorof Integer) Float) (unbox f))
                 (vs
                  :
                  (Vectorof Float)
                  (inline-build-array-data
                   ds
                   (lambda (js j) (old-f js))
                   Float)))
            (set-box!
             f
             (λ:
              ((js : Indexes))
              (vector-ref vs (unsafe-array-index->value-index ds js))))))
        (define unsafe-proc (λ: ((js : Indexes)) ((unbox f) js)))
        (Array ds size ((inst box Boolean) #f) strict! unsafe-proc)))
    (: unsafe-build-simple-array (Indexes (Indexes -> Float) -> Array))
    (define (unsafe-build-simple-array ds f)
      (define size (check-array-shape-size 'unsafe-build-simple-array ds))
      (Array ds size (box #t) void f))
    (: build-array ((Vectorof Integer) ((Vectorof Integer) -> Float) -> Array))
    (define (build-array ds proc)
      (let ((ds
             (check-array-shape
              ds
              (lambda ()
                (raise-argument-error
                 'build-array
                 "(Vectorof Integer)"
                 0
                 ds
                 proc)))))
        (define arr
          (unsafe-build-array
           ds
           (λ:
            ((js : (Vectorof Integer)))
            (proc (vector->immutable-vector js)))))
        (array-default-strict! arr)
        arr))
    (: build-simple-array ((Vectorof Integer) (Indexes -> Float) -> Array))
    (define (build-simple-array ds proc)
      (let ((ds
             (check-array-shape
              ds
              (lambda ()
                (raise-argument-error
                 'build-simple-array
                 "(Vectorof Index)"
                 0
                 ds
                 proc)))))
        (unsafe-build-simple-array
         ds
         (λ: ((js : Indexes)) (proc (vector->immutable-vector js))))))
    (define settable-array? Settable-Array?)
    (define unsafe-settable-array-set-proc Settable-Array-set-proc)
    (define-syntax-rule
     (make-unsafe-array-set-proc A ds set!)
     (λ:
      ((js : Indexes) (v : A))
      (set! (unsafe-array-index->value-index ds js) v)))
    (: make-array ((Vectorof Integer) Float -> Array))
    (define (make-array ds v)
      (let ((ds
             (check-array-shape
              ds
              (λ ()
                (raise-argument-error
                 'make-array
                 "(Vectorof Integer)"
                 0
                 ds
                 v)))))
        (unsafe-build-simple-array ds (λ (js) v))))
    (: unsafe-vector->array (Indexes (Vectorof Float) -> Mutable-Array))
    (define (unsafe-vector->array ds vs)
      (define proc (make-unsafe-array-proc ds (λ (j) (vector-ref vs j))))
      (define set-proc
        (make-unsafe-array-set-proc Float ds (λ (j v) (vector-set! vs j v))))
      (Mutable-Array ds (vector-length vs) (box #t) void proc set-proc vs))
    (provide make-unsafe-array-proc make-unsafe-array-set-proc)
    (provide (contract-out (array? generated-contract8))
             (contract-out (unsafe-vector->array generated-contract14))
             (contract-out (unsafe-build-simple-array generated-contract13))
             (contract-out (unsafe-build-array generated-contract12))
             (contract-out (make-array generated-contract10))
             (contract-out (build-array generated-contract9))
             (contract-out (array-strictness generated-contract7))
             (contract-out (array-strict? generated-contract6))
             (contract-out (array-default-strict! generated-contract3))
             (contract-out (unsafe-array-proc generated-contract11))
             (contract-out (array-size generated-contract5))
             (contract-out (array-shape generated-contract4)))))
