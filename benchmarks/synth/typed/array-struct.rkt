#lang typed/racket/base/no-check
(define-values
  (g21
   g22
   generated-contract6
   g23
   g24
   g25
   generated-contract7
   g26
   generated-contract8
   g27
   g28
   g29
   g30
   g31
   g32
   g33
   generated-contract9
   generated-contract10
   generated-contract11
   generated-contract12
   g34
   g35
   g36
   generated-contract13)
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
    (letrec ((g21 (lambda (x) (Array? x)))
             (g22 (lambda (x) (equal? x (void))))
             (generated-contract6 (-> g21 (values g22)))
             (g23 '#t)
             (g24 '#f)
             (g25 (or/c g23 g24))
             (generated-contract7 (-> g21 (values g25)))
             (g26 (parameter/c g25 g25))
             (generated-contract8 g26)
             (g27 exact-integer?)
             (g28 (or/c g27))
             (g29 (vectorof g28))
             (g30 (or/c g29))
             (g31 flonum?)
             (g32 (or/c g31))
             (g33 (-> g30 (values g32)))
             (generated-contract9 (-> g30 g33 (values g21)))
             (generated-contract10 (-> g30 g32 (values g21)))
             (generated-contract11 (-> g30 g33 (values g21)))
             (generated-contract12 (-> g30 g33 (values g21)))
             (g34 (vectorof g32))
             (g35 (or/c g34))
             (g36 (lambda (x) (Mutable-Array? x)))
             (generated-contract13 (-> g30 g35 (values g36))))
      (values
       g21
       g22
       generated-contract6
       g23
       g24
       g25
       generated-contract7
       g26
       generated-contract8
       g27
       g28
       g29
       g30
       g31
       g32
       g33
       generated-contract9
       generated-contract10
       generated-contract11
       generated-contract12
       g34
       g35
       g36
       generated-contract13))))
(require (only-in racket/contract contract-out))
(provide (contract-out (array-default-strict! generated-contract6))
          (contract-out (array-strict? generated-contract7))
          (contract-out (array-strictness generated-contract8))
          (contract-out (build-array generated-contract9))
          (contract-out (make-array generated-contract10))
          (contract-out (unsafe-build-array generated-contract11))
          (contract-out (unsafe-build-simple-array generated-contract12))
          (contract-out (unsafe-vector->array generated-contract13)))
(require (for-syntax racket/base syntax/parse)
          (only-in racket/fixnum fx+ fx*)
          require-typed-check
          "typed-data.rkt")
(require "array-utils.rkt")
(provide (rename-out (Array? array?))
          (rename-out (Array-shape array-shape))
          (rename-out (Array-size array-size))
          (rename-out (Array-unsafe-proc unsafe-array-proc))
          make-unsafe-array-proc
          make-unsafe-array-set-proc)
(define-syntax-rule
  (for-each-array+data-index ds-expr f-expr)
  (let*:
   ((ds : Indexes ds-expr) (dims : Integer (vector-length ds)))
   (define-syntax-rule (f js j) ((ann f-expr (Indexes Integer -> Void)) js j))
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
         (when (< j0 d0) (vector-set! js 0 j0) (f js j0) (j0-loop (+ j0 1)))))
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
            (cond ((< ji di) (ji-loop (+ ji 1) (i-loop (+ i 1) j))) (else j))))
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
(: array-strictness (Parameterof (U #f #t)))
(define array-strictness (make-parameter #t))
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
   (when (and (not (unbox strict?)) (array-strictness))
     ((Array-strict! arr))
     (set-box! strict? #t)))
(:
  unsafe-build-array
  ((Vectorof Integer) ((Vectorof Integer) -> Float) -> Array))
(define (unsafe-build-array ds f)
   (let ((f (box f)))
     (define size (check-array-shape-size 'unsafe-build-array ds))
     (define (strict!)
       (let* ((old-f : (-> (Vectorof Integer) Float) (unbox f))
              (vs
               :
               (Vectorof Float)
               (inline-build-array-data ds (lambda (js j) (old-f js)) Float)))
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
        (λ: ((js : (Vectorof Integer))) (proc (vector->immutable-vector js)))))
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
             (raise-argument-error 'make-array "(Vectorof Integer)" 0 ds v)))))
     (unsafe-build-simple-array ds (λ (js) v))))
(: unsafe-vector->array (Indexes (Vectorof Float) -> Mutable-Array))
(define (unsafe-vector->array ds vs)
   (define proc (make-unsafe-array-proc ds (λ (j) (vector-ref vs j))))
   (define set-proc
     (make-unsafe-array-set-proc Float ds (λ (j v) (vector-set! vs j v))))
   (Mutable-Array ds (vector-length vs) (box #t) void proc set-proc vs))
