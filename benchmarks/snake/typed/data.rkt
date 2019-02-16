#lang typed/racket/no-check
(define-values
  (g28
   g29
   g30
   generated-contract14
   g31
   generated-contract9
   g32
   g33
   g34
   g35
   g36
   g37
   g38
   generated-contract10
   generated-contract11
   generated-contract12
   generated-contract15
   g39
   g40
   g41
   g42
   g43
   g44
   g45
   g46
   generated-contract21
   generated-contract16
   generated-contract17
   generated-contract18
   generated-contract19
   generated-contract22
   g47
   generated-contract27
   generated-contract23
   generated-contract24
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
    (letrec ((g28 real?)
             (g29 (or/c g28))
             (g30 (lambda (x) (posn? x)))
             (generated-contract14 (-> g29 g29 (values g30)))
             (g31 (λ (_) #f))
             (generated-contract9 g31)
             (g32 (λ (_) #f))
             (g33 any/c)
             (g34 '#t)
             (g35 '#f)
             (g36 (or/c g34 g35))
             (g37 (-> g33 (values g36)))
             (g38 (or/c g32 g37))
             (generated-contract10 g38)
             (generated-contract11 (-> g30 (values g29)))
             (generated-contract12 (-> g30 (values g29)))
             (generated-contract15 (-> g30 g30 (values g36)))
             (g39 '"right")
             (g40 '"left")
             (g41 '"down")
             (g42 '"up")
             (g43 (or/c g39 g40 g41 g42))
             (g44 (listof g30))
             (g45 (cons/c g30 g44))
             (g46 (lambda (x) (snake? x)))
             (generated-contract21 (-> g43 g45 (values g46)))
             (generated-contract16 g31)
             (generated-contract17 g38)
             (generated-contract18 (-> g46 (values g45)))
             (generated-contract19 (-> g46 (values g43)))
             (generated-contract22 g31)
             (g47 (lambda (x) (world? x)))
             (generated-contract27 (-> g46 g30 (values g47)))
             (generated-contract23 g38)
             (generated-contract24 (-> g47 (values g30)))
             (generated-contract25 (-> g47 (values g46))))
      (values
       g28
       g29
       g30
       generated-contract14
       g31
       generated-contract9
       g32
       g33
       g34
       g35
       g36
       g37
       g38
       generated-contract10
       generated-contract11
       generated-contract12
       generated-contract15
       g39
       g40
       g41
       g42
       g43
       g44
       g45
       g46
       generated-contract21
       generated-contract16
       generated-contract17
       generated-contract18
       generated-contract19
       generated-contract22
       g47
       generated-contract27
       generated-contract23
       generated-contract24
       generated-contract25))))
(require (only-in racket/contract contract-out))
(provide (contract-out (struct posn ((x g29) (y g29))))
          (contract-out (posn=? generated-contract15))
          (contract-out (struct snake ((dir g43) (segs g45))))
          (contract-out (struct world ((snake g46) (food g30)))))
(struct: snake ((dir : Dir) (segs : (NEListof Posn))))
(struct: world ((snake : Snake) (food : Posn)))
(struct: posn ((x : Real) (y : Real)))
(define-type Posn posn)
(define-type (NEListof A) (Pairof A (Listof A)))
(define-type Snake snake)
(define-type Dir (U "up" "down" "left" "right"))
(: posn=? (-> posn posn Boolean))
(define (posn=? p1 p2)
   (and (= (posn-x p1) (posn-x p2)) (= (posn-y p1) (posn-y p2))))
(provide)
