(module synth typed/racket/base/no-check
   (#%module-begin
    (require racket/contract
             (lib "racket/contract/base.rkt")
             (lib "racket/base.rkt")
             (lib "racket/contract.rkt")
             (submod "data.rkt" #%type-decl ".."))
    (define g14 (lambda (x) (Array? x)))
    (define g15 exact-integer?)
    (define g16 (or/c g15))
    (define g17 (vectorof g16))
    (define g18 (or/c g17))
    (define g19 exact-nonnegative-integer?)
    (define g20 (or/c g19))
    (define g21 flonum?)
    (define g22 (or/c g21))
    (define g23 (-> g18 (values g22)))
    (define generated-contract10 (-> g14 (values g18)))
    (define generated-contract11 g20)
    (define generated-contract12 (-> g22 (values g23)))
    (define generated-contract13 (-> g22 (values g16)))
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check
             "typed-data.rkt"
             (only-in racket/unsafe/ops unsafe-fx+ unsafe-fx<)
             (only-in racket/math exact-floor))
    (require "array-utils.rkt")
    (require "array-struct.rkt")
    (require (for-syntax racket/base syntax/parse))
    (define-sequence-syntax
     in-array
     (λ () #'in-array)
     (λ (stx)
       (syntax-case stx ()
         (((x) (_ arr-expr))
          (syntax/loc
           stx
           ((x)
            (:do-in
             (((ds size dims js proc)
               (let:
                ((arr : Array arr-expr))
                (cond
                 ((array? arr)
                  (define ds (array-shape arr))
                  (define dims (vector-length ds))
                  (define size (array-size arr))
                  (define proc (unsafe-array-proc arr))
                  (define: js : Indexes (make-vector dims 0))
                  (values ds size dims js proc))
                 (else (raise-argument-error 'in-array "Array" arr))))))
             (void)
             ((j 0))
             (unsafe-fx< j size)
             (((x) (proc js)))
             #t
             #t
             ((begin (next-indexes! ds dims js) (unsafe-fx+ j 1)))))))
         ((_ clause)
          (raise-syntax-error
           'in-array
           "expected (in-array <Array>)"
           #'clause
           #'clause)))))
    (set-box! array-strictness #f)
    (: fs Natural)
    (define fs 44100)
    (: bits-per-sample Natural)
    (define bits-per-sample 16)
    (: freq->sample-period (-> Float Integer))
    (define (freq->sample-period freq)
      (: res Exact-Rational)
      (define res (inexact->exact (round (/ fs freq))))
      (if (index? res) res (error "not index")))
    (: seconds->samples (-> Float Integer))
    (define (seconds->samples s)
      (: res Exact-Rational)
      (define res (inexact->exact (round (* s fs))))
      (if (index? res) res (error "not index")))
    (define-syntax-rule
     (array-lambda (i) body ...)
     (lambda: ((i* : (Vectorof Integer)))
       (let: ((i : Integer (vector-ref i* 0))) body ...)))
    (: make-sawtooth-wave (-> Float (-> Float (-> Indexes Float))))
    (define ((make-sawtooth-wave coeff) freq)
      (: sample-period Integer)
      (define sample-period (freq->sample-period freq))
      (: sample-period/2 Integer)
      (define sample-period/2 (quotient sample-period 2))
      (array-lambda
       (x)
       (: x* Float)
       (define x* (exact->inexact (modulo x sample-period)))
       (* coeff (- (/ x* sample-period/2) 1.0))))
    (: sawtooth-wave (-> Float (-> Indexes Float)))
    (define sawtooth-wave (make-sawtooth-wave 1.0))
    (: signal->integer-sequence (-> Array (#:gain Float) (Vectorof Integer)))
    (define (signal->integer-sequence signal #:gain (gain 1))
      (for/vector:
       :
       (Vectorof Integer)
       #:length
       (array-size signal)
       ((sample : Float (in-array signal)))
       (max
        0
        (min
         (sub1 (expt 2 bits-per-sample))
         (exact-floor
          (* gain (* (+ sample 1.0) (expt 2 (sub1 bits-per-sample)))))))))
    (: emit (-> Array (Vectorof Integer)))
    (define (emit signal) (signal->integer-sequence signal #:gain 0.3))
    (provide)
    (provide (contract-out (emit generated-contract10))
             (contract-out (seconds->samples generated-contract13))
             (contract-out (sawtooth-wave generated-contract12))
             (contract-out (fs generated-contract11)))))
