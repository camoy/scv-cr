#lang typed/racket/base/no-check
(define-values
  (g34 g35 g36 g37 g38 g39 g40 generated-contract15)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g34 (lambda (x) (Array? x)))
             (g35 real?)
             (g36 (or/c g35))
             (g37 '())
             (g38 (cons/c g36 g37))
             (g39 (cons/c g34 g38))
             (g40 (listof g39))
             (generated-contract15 (-> g40 (values g34))))
      (values g34 g35 g36 g37 g38 g39 g40 generated-contract15))))
(require (only-in racket/contract contract-out))
(provide (contract-out (mix generated-contract15)))
(require require-typed-check
          "typed-data.rkt"
          (for-syntax racket/base)
          (only-in racket/list first second rest))
(require "array-struct.rkt")
(require "array-broadcast.rkt")
(provide)
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
           (unsafe-build-array ds (λ ((js : Indexes)) (f (proc js)))))
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
               (λ ((js : Indexes)) (f (proc js) (procs js) ...))))
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
     (for/list : (Listof Array) ((s : Weighted-Signal ss)) (first s)))
   (: weights (Listof Float))
   (define weights
     (for/list
      :
      (Listof Float)
      ((x : Weighted-Signal ss))
      (real->double-flonum (second x))))
   (: downscale-ratio Float)
   (define downscale-ratio (/ 1.0 (apply + weights)))
   (: scale-signal (Float -> (Float -> Float)))
   (define ((scale-signal w) x) (* x w downscale-ratio))
   (parameterize
    ((array-broadcasting 'permissive))
    (for/fold
     ((res : Array (array-map (scale-signal (first weights)) (first signals))))
     ((s (in-list (rest signals))) (w (in-list (rest weights))))
     (define scale (scale-signal w))
     (array-map
      (lambda ((acc : Float) (new : Float)) (+ acc (scale new)))
      res
      s))))
