#lang typed/racket/base/no-check
(define-values
  (g39
   g40
   g41
   g42
   g43
   generated-contract23
   g44
   generated-contract13
   g45
   g46
   g47
   g48
   g49
   g50
   g51
   generated-contract14
   g52
   generated-contract19
   generated-contract15
   generated-contract16
   generated-contract17
   generated-contract20
   generated-contract21
   g53
   g54
   generated-contract33
   generated-contract24
   generated-contract25
   generated-contract29
   generated-contract26
   generated-contract27
   generated-contract30
   generated-contract31
   g55
   generated-contract38
   generated-contract34
   generated-contract35
   generated-contract36)
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
    (letrec ((g39 symbol?)
             (g40 (lambda (x) (Call? x)))
             (g41 (lambda (x) (exp? x)))
             (g42 (or/c g40 g41))
             (g43 (listof g42))
             (generated-contract23 (-> g39 g42 g43 (values g40)))
             (g44 (λ (_) #f))
             (generated-contract13 g44)
             (g45 (λ (_) #f))
             (g46 any/c)
             (g47 '#t)
             (g48 '#f)
             (g49 (or/c g47 g48))
             (g50 (-> g46 (values g49)))
             (g51 (or/c g45 g50))
             (generated-contract14 g51)
             (g52 (lambda (x) (Stx? x)))
             (generated-contract19 (-> g39 (values g52)))
             (generated-contract15 g44)
             (generated-contract16 g51)
             (generated-contract17 (-> g52 (values g39)))
             (generated-contract20 (-> g40 (values g43)))
             (generated-contract21 (-> g40 (values g42)))
             (g53 (listof g39))
             (g54 (lambda (x) (Lam? x)))
             (generated-contract33 (-> g39 g53 g42 (values g54)))
             (generated-contract24 g44)
             (generated-contract25 g51)
             (generated-contract29 (-> g39 (values g41)))
             (generated-contract26 g44)
             (generated-contract27 g51)
             (generated-contract30 (-> g54 (values g42)))
             (generated-contract31 (-> g54 (values g53)))
             (g55 (lambda (x) (Ref? x)))
             (generated-contract38 (-> g39 g39 (values g55)))
             (generated-contract34 g44)
             (generated-contract35 g51)
             (generated-contract36 (-> g55 (values g39))))
      (values
       g39
       g40
       g41
       g42
       g43
       generated-contract23
       g44
       generated-contract13
       g45
       g46
       g47
       g48
       g49
       g50
       g51
       generated-contract14
       g52
       generated-contract19
       generated-contract15
       generated-contract16
       generated-contract17
       generated-contract20
       generated-contract21
       g53
       g54
       generated-contract33
       generated-contract24
       generated-contract25
       generated-contract29
       generated-contract26
       generated-contract27
       generated-contract30
       generated-contract31
       g55
       generated-contract38
       generated-contract34
       generated-contract35
       generated-contract36))))
(require (only-in racket/contract contract-out))
(provide (contract-out (struct (Call Stx) ((label g39) (fun g42) (args g43))))
          (contract-out (struct Stx ((label g39))))
          (contract-out
           (struct (Lam exp) ((label g39) (formals g53) (call g42))))
          (contract-out (struct (exp Stx) ((label g39))))
          (contract-out (struct (Ref exp) ((label g39) (var g39)))))
(provide)
(struct Stx ((label : Symbol)))
(struct exp Stx ())
(struct Ref exp ((var : Symbol)))
(struct Lam exp ((formals : (Listof Symbol)) (call : (U exp Ref Lam Call))))
(struct
  Call
  Stx
  ((fun : (U exp Ref Lam Call)) (args : (Listof (U exp Ref Lam Call)))))
