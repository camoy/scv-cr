(module mixer typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (lib "racket/contract/base.rkt")
             (submod "data.rkt" #%type-decl ".."))
    (define g8 (lambda (x) (Array? x)))
    (define g9 real?)
    (define g10 (or/c g9))
    (define g11 '())
    (define g12 (cons/c g10 g11))
    (define g13 (cons/c g8 g12))
    (define g14 (listof g13))
    (define generated-contract7 (-> g14 (values g8)))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check
             "typed-data.rkt"
             (for-syntax racket/base)
             (only-in racket/list first second rest))
    (require "array-struct.rkt")
    (require "array-broadcast.rkt")
    (void)
    (define-syntax-rule
     (ensure-array name arr-expr)
     (let ((arr arr-expr))
       (if (array? arr) arr (raise-argument-error name "Array" arr))))
    (define-syntax (inline-array-map stx)
      (syntax-case stx ()
        ((_ f arr-expr)
         (syntax/loc
          stx
          (let ((arr (ensure-array 'array-map arr-expr)))
            (define ds (array-shape arr))
            (define proc (unsafe-array-proc arr))
            (define arr*
              (unsafe-build-array ds (λ: ((js : Indexes)) (f (proc js)))))
            (array-default-strict! arr*)
            arr*)))
        ((_ f arr-expr arr-exprs ...)
         (with-syntax
          (((arrs ...) (generate-temporaries #'(arr-exprs ...)))
           ((procs ...) (generate-temporaries #'(arr-exprs ...))))
          (syntax/loc
           stx
           (let ((arr (ensure-array 'array-map arr-expr))
                 (arrs (ensure-array 'array-map arr-exprs))
                 ...)
             (define ds
               (array-shape-broadcast
                (list (array-shape arr) (array-shape arrs) ...)))
             (let ((arr (array-broadcast arr ds))
                   (arrs (array-broadcast arrs ds))
                   ...)
               (define proc (unsafe-array-proc arr))
               (define procs (unsafe-array-proc arrs))
               ...
               (define arr*
                 (unsafe-build-array
                  ds
                  (λ: ((js : Indexes)) (f (proc js) (procs js) ...))))
               (array-default-strict! arr*)
               arr*)))))))
    (:
     array-map
     (case->
      (-> (-> Float Float Float) Array Array Array)
      (-> (-> Float Float) Array Array)))
    (define array-map
      (case-lambda:
       (((f : (Float -> Float)) (arr : Array)) (inline-array-map f arr))
       (((f : (Float Float -> Float)) (arr0 : Array) (arr1 : Array))
        (inline-array-map f arr0 arr1))))
    (: mix (-> (Listof Weighted-Signal) Array))
    (define (mix ss)
      (: signals (Listof Array))
      (define signals
        (for/list: : (Listof Array) ((s : Weighted-Signal ss)) (first s)))
      (: weights (Listof Float))
      (define weights
        (for/list:
         :
         (Listof Float)
         ((x : Weighted-Signal ss))
         (real->double-flonum (second x))))
      (: downscale-ratio Float)
      (define downscale-ratio (/ 1.0 (apply + weights)))
      (: scale-signal (Float -> (Float -> Float)))
      (define ((scale-signal w) x) (* x w downscale-ratio))
      (define old-array-broadcasting (unbox array-broadcasting))
      (set-box! array-broadcasting 'permissive)
      (define res
        (for/fold:
         ((res
           :
           Array
           (array-map (scale-signal (first weights)) (first signals))))
         ((s (in-list (rest signals))) (w (in-list (rest weights))))
         (define scale (scale-signal w))
         (array-map
          (lambda: ((acc : Float) (new : Float)) (+ acc (scale new)))
          res
          s)))
      (set-box! array-broadcasting old-array-broadcasting)
      res)
    (provide)
    (provide (contract-out (mix generated-contract7)))))
