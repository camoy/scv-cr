#lang typed/racket/no-check
(define-values
  (g37
   g38
   g39
   g40
   generated-contract17
   g41
   generated-contract11
   g42
   g43
   g44
   g45
   g46
   g47
   g48
   generated-contract12
   generated-contract13
   generated-contract14
   generated-contract15
   g49
   generated-contract23
   generated-contract18
   generated-contract19
   generated-contract20
   generated-contract21
   generated-contract24
   generated-contract25
   generated-contract26
   g50
   g51
   generated-contract31
   generated-contract27
   generated-contract28
   generated-contract29
   g52
   generated-contract36
   generated-contract32
   generated-contract33
   generated-contract34)
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
    (letrec ((g37 real?)
             (g38 (or/c g37))
             (g39 symbol?)
             (g40 (lambda (x) (block? x)))
             (generated-contract17 (-> g38 g38 g39 (values g40)))
             (g41 (λ (_) #f))
             (generated-contract11 g41)
             (g42 (λ (_) #f))
             (g43 any/c)
             (g44 '#t)
             (g45 '#f)
             (g46 (or/c g44 g45))
             (g47 (-> g43 (values g46)))
             (g48 (or/c g42 g47))
             (generated-contract12 g48)
             (generated-contract13 (-> g40 (values g39)))
             (generated-contract14 (-> g40 (values g38)))
             (generated-contract15 (-> g40 (values g38)))
             (g49 (lambda (x) (posn? x)))
             (generated-contract23 (-> g38 g38 (values g49)))
             (generated-contract18 g41)
             (generated-contract19 g48)
             (generated-contract20 (-> g49 (values g38)))
             (generated-contract21 (-> g49 (values g38)))
             (generated-contract24 (-> g49 g49 (values g46)))
             (generated-contract25 g41)
             (generated-contract26 g41)
             (g50 (listof g40))
             (g51 (lambda (x) (tetra? x)))
             (generated-contract31 (-> g49 g50 (values g51)))
             (generated-contract27 g48)
             (generated-contract28 (-> g51 (values g50)))
             (generated-contract29 (-> g51 (values g49)))
             (g52 (lambda (x) (world? x)))
             (generated-contract36 (-> g51 g50 (values g52)))
             (generated-contract32 g48)
             (generated-contract33 (-> g52 (values g50)))
             (generated-contract34 (-> g52 (values g51))))
      (values
       g37
       g38
       g39
       g40
       generated-contract17
       g41
       generated-contract11
       g42
       g43
       g44
       g45
       g46
       g47
       g48
       generated-contract12
       generated-contract13
       generated-contract14
       generated-contract15
       g49
       generated-contract23
       generated-contract18
       generated-contract19
       generated-contract20
       generated-contract21
       generated-contract24
       generated-contract25
       generated-contract26
       g50
       g51
       generated-contract31
       generated-contract27
       generated-contract28
       generated-contract29
       g52
       generated-contract36
       generated-contract32
       generated-contract33
       generated-contract34))))
(require (only-in racket/contract contract-out))
(provide (contract-out (struct block ((x g38) (y g38) (color g39))))
          (contract-out (struct posn ((x g38) (y g38))))
          (contract-out (posn=? generated-contract24))
          (contract-out (struct tetra ((center g49) (blocks g50))))
          (contract-out (struct world ((tetra g51) (blocks g50)))))
(struct: posn ((x : Real) (y : Real)))
(struct: block ((x : Real) (y : Real) (color : Symbol)))
(struct: tetra ((center : posn) (blocks : (Listof block))))
(struct: world ((tetra : tetra) (blocks : (Listof block))))
(: posn=? (-> posn posn Boolean))
(define (posn=? p1 p2)
   (and (= (posn-x p1) (posn-x p2)) (= (posn-y p1) (posn-y p2))))
(provide)
