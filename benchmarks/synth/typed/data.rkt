#lang typed/racket/base/no-check
(define-values
  (g28
   g29
   g30
   g31
   g32
   g33
   g34
   g35
   g36
   g37
   g38
   g39
   g40
   g41
   generated-contract17
   g42
   generated-contract9
   g43
   g44
   g45
   g46
   generated-contract10
   g47
   generated-contract11
   g48
   generated-contract12
   generated-contract13
   generated-contract14
   generated-contract15
   g49
   g50
   g51
   g52
   generated-contract27
   generated-contract18
   generated-contract19
   g53
   generated-contract24
   generated-contract20
   generated-contract21
   g54
   generated-contract22
   generated-contract25)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g28 exact-integer?)
             (g29 (or/c g28))
             (g30 (vectorof g29))
             (g31 (or/c g30))
             (g32 '#t)
             (g33 '#f)
             (g34 (or/c g32 g33))
             (g35 (box/c g34))
             (g36 (lambda (x) (equal? x (void))))
             (g37 (-> g36))
             (g38 flonum?)
             (g39 (or/c g38))
             (g40 (-> g31 (values g39)))
             (g41 (lambda (x) (Array? x)))
             (generated-contract17 (-> g31 g29 g35 g37 g40 (values g41)))
             (g42 (λ (_) #f))
             (generated-contract9 g42)
             (g43 (λ (_) #f))
             (g44 any/c)
             (g45 (-> g44 (values g34)))
             (g46 (or/c g43 g45))
             (generated-contract10 g46)
             (g47 (-> g31 (values g39)))
             (generated-contract11 (-> g41 (values g47)))
             (g48 (-> (values g36)))
             (generated-contract12 (-> g41 (values g48)))
             (generated-contract13 (-> g41 (values g35)))
             (generated-contract14 (-> g41 (values g29)))
             (generated-contract15 (-> g41 (values g31)))
             (g49 (-> g31 g39 (values g36)))
             (g50 (vectorof g39))
             (g51 (or/c g50))
             (g52 (lambda (x) (Mutable-Array? x)))
             (generated-contract27
              (-> g31 g29 g35 g37 g40 g49 g51 (values g52)))
             (generated-contract18 g42)
             (generated-contract19 g46)
             (g53 (lambda (x) (Settable-Array? x)))
             (generated-contract24 (-> g31 g29 g35 g37 g40 g49 (values g53)))
             (generated-contract20 g42)
             (generated-contract21 g46)
             (g54 (-> g31 g39 (values g36)))
             (generated-contract22 (-> g53 (values g54)))
             (generated-contract25 (-> g52 (values g51))))
      (values
       g28
       g29
       g30
       g31
       g32
       g33
       g34
       g35
       g36
       g37
       g38
       g39
       g40
       g41
       generated-contract17
       g42
       generated-contract9
       g43
       g44
       g45
       g46
       generated-contract10
       g47
       generated-contract11
       g48
       generated-contract12
       generated-contract13
       generated-contract14
       generated-contract15
       g49
       g50
       g51
       g52
       generated-contract27
       generated-contract18
       generated-contract19
       g53
       generated-contract24
       generated-contract20
       generated-contract21
       g54
       generated-contract22
       generated-contract25))))
(require (only-in racket/contract contract-out))
(provide (contract-out
           (struct
            Array
            ((shape g31)
             (size g29)
             (strict? g35)
             (strict! g37)
             (unsafe-proc g40))))
          (contract-out
           (struct
            (Mutable-Array Settable-Array)
            ((shape g31)
             (size g29)
             (strict? g35)
             (strict! g37)
             (unsafe-proc g40)
             (set-proc g49)
             (data g51))))
          (contract-out
           (struct
            (Settable-Array Array)
            ((shape g31)
             (size g29)
             (strict? g35)
             (strict! g37)
             (unsafe-proc g40)
             (set-proc g49)))))
(provide)
(struct
  Array
  ((shape : (Vectorof Integer))
   (size : Integer)
   (strict? : (Boxof Boolean))
   (strict! : (-> Void))
   (unsafe-proc : (-> (Vectorof Integer) Float))))
(struct
  Settable-Array
  Array
  ((set-proc : ((Vectorof Integer) Float -> Void))))
(struct Mutable-Array Settable-Array ((data : (Vectorof Float))))
