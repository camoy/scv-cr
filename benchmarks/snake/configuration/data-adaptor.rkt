(module data-adaptor typed/racket/no-check
   (#%module-begin
    (require racket/contract)
    (module require/contracts racket/base
      (require racket/contract
               "data.rkt"
               (lib "racket/contract.rkt")
               (lib "racket/base.rkt")
               (lib "racket/contract/base.rkt"))
      (define g24 real?)
      (define g25 (or/c g24))
      (define g26 (lambda (x) (posn? x)))
      (define g27 '"right")
      (define g28 '"left")
      (define g29 '"down")
      (define g30 '"up")
      (define g31 (or/c g27 g28 g29 g30))
      (define g32 (listof g26))
      (define g33 (cons/c g26 g32))
      (define g34 (lambda (x) (snake? x)))
      (define g35 (lambda (x) (world? x)))
      (define g36 (-> any/c any/c g35))
      (define g37 (-> any/c g34))
      (define g38 (-> any/c g26))
      (define l/109 g36)
      (define l/111 g37)
      (define l/113 g38)
      (define l/33 (-> g25 g25 (values g26)))
      (define l/35 (-> g26 (values g25)))
      (define l/37 (-> g26 (values g25)))
      (define l/71 (-> g31 g33 (values g34)))
      (define l/73 (-> g34 (values g31)))
      (define l/75 (-> g34 (values g33)))
      (provide l/35
               g24
               g25
               g26
               l/33
               l/75
               g38
               l/113
               l/73
               g37
               l/111
               g27
               g28
               g29
               g30
               g31
               g32
               g33
               g34
               l/71
               g35
               g36
               l/109
               l/37
               (contract-out (struct world ((snake any/c) (food any/c))))
               (contract-out (struct posn ((x g25) (y g25))))
               (contract-out (struct snake ((dir g31) (segs g33))))))
    (require (prefix-in -: (only-in 'require/contracts snake? posn? world?))
             (except-in 'require/contracts snake? posn? world?))
    (define-values (snake? posn? world?) (values -:snake? -:posn? -:world?))
    (require require-typed-check)
    (void)
    (define-type (NEListof A) (Pairof A (Listof A)))
    (define-type Dir (U "up" "down" "left" "right"))
    (define-type Snake snake)
    (define-type World world)
    (define-type Posn posn)
    (void)
    (provide (struct-out posn)
             posn?
             (struct-out snake)
             snake?
             (struct-out world)
             world?
             Dir
             Snake
             World
             Posn
             NEListof)
    (provide)))
