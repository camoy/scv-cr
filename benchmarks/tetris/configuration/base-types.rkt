(module base-types typed/racket/no-check
   (#%module-begin
    (require racket/contract)
    (module require/contracts racket/base
      (require racket/contract
               "data.rkt"
               (lib "racket/contract.rkt")
               (lib "racket/base.rkt")
               (lib "racket/contract/base.rkt"))
      (define g32 real?)
      (define g33 (or/c g32))
      (define g34 (lambda (x) (posn? x)))
      (define g35 symbol?)
      (define g36 (lambda (x) (block? x)))
      (define g37 (-> any/c g35))
      (define g38 (listof g36))
      (define g39 (lambda (x) (tetra? x)))
      (define g40 (-> any/c g34))
      (define g41 (lambda (x) (world? x)))
      (define g42 (-> any/c g39))
      (define l/111 (-> g34 g38 (values g39)))
      (define l/113 g40)
      (define l/115 (-> g39 (values g38)))
      (define l/149 (-> g39 g38 (values g41)))
      (define l/151 g42)
      (define l/153 (-> g41 (values g38)))
      (define l/33 (-> g33 g33 (values g34)))
      (define l/35 (-> g34 (values g33)))
      (define l/37 (-> g34 (values g33)))
      (define l/71 (-> g33 g33 g35 (values g36)))
      (define l/73 (-> g36 (values g33)))
      (define l/75 (-> g36 (values g33)))
      (define l/77 g37)
      (provide g41
               l/149
               l/115
               l/153
               g40
               l/113
               g42
               l/151
               g38
               g39
               l/111
               g37
               l/77
               l/37
               l/75
               l/35
               l/73
               g32
               g33
               g34
               l/33
               g35
               g36
               l/71
               (contract-out (struct world ((tetra g39) (blocks g38))))
               (contract-out (struct posn ((x g33) (y g33))))
               (contract-out (struct block ((x g33) (y g33) (color g35))))
               (contract-out (struct tetra ((center g34) (blocks g38))))))
    (require (prefix-in
              -:
              (only-in 'require/contracts tetra? block? posn? world?))
             (except-in 'require/contracts tetra? block? posn? world?))
    (define-values
     (tetra? block? posn? world?)
     (values -:tetra? -:block? -:posn? -:world?))
    (define-type Color Symbol)
    (require require-typed-check)
    (void)
    (define-type Posn posn)
    (define-type Block block)
    (define-type Tetra tetra)
    (define-type World world)
    (define-type BSet (Listof Block))
    (void)
    (provide (struct-out posn)
             posn?
             (struct-out block)
             block?
             (struct-out tetra)
             tetra?
             (struct-out world)
             world?
             Posn
             Block
             Tetra
             World
             Color
             BSet
             Color
             BSet)
    (provide)))
