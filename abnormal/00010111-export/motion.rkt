#lang typed/racket/no-check
(require racket/contract
          (lib "racket/contract.rkt")
          (lib "racket/base.rkt")
          (submod "data.rkt" #%type-decl "..")
          (lib "racket/contract/base.rkt"))
(define g10 (lambda (x) (equal? x (void))))
(define g11 (lambda (x) (world? x)))
(define g12 '"up")
(define g13 '"down")
(define g14 '"left")
(define g15 '"right")
(define g16 (or/c g12 g13 g14 g15))
(define generated-contract5 (-> (values g10)))
(define generated-contract6 (-> g11 (values g11)))
(define generated-contract7 (-> g11 g16 (values g11)))
(provide (contract-out
           (reset! any/c)
           (world->world any/c)
           (world-change-dir any/c)))
(module require/contracts racket/base
   (require racket/contract
            "const.rkt"
            (lib "racket/contract/base.rkt")
            (lib "racket/base.rkt"))
   (define g8 exact-integer?)
   (define g9 (or/c g8))
   (define l/1 g9)
   (define l/3 g9)
   (provide l/3
            g8
            g9
            l/1
            (contract-out (BOARD-WIDTH any/c) (BOARD-HEIGHT any/c))))
(require (prefix-in -: (only-in 'require/contracts BOARD-HEIGHT BOARD-WIDTH))
          (except-in 'require/contracts BOARD-HEIGHT BOARD-WIDTH))
(define-values
  (BOARD-HEIGHT BOARD-WIDTH)
  (values -:BOARD-HEIGHT -:BOARD-WIDTH))
(require require-typed-check "data-adaptor.rkt")
(void)
(require "data.rkt")
(require "motion-help.rkt")
(provide)
(define (reset!) (random-seed 1324))
(: world->world : (-> World World))
(define (world->world w)
   (cond
    ((eating? w) (snake-eat w))
    (else (world (snake-slither (world-snake w)) (world-food w)))))
(: eating? : (-> World Boolean))
(define (eating? w)
   (posn=? (world-food w) (car (snake-segs (world-snake w)))))
(: snake-change-direction : (-> Snake Dir Snake))
(define (snake-change-direction snk dir) (snake dir (snake-segs snk)))
(: world-change-dir : (-> World Dir World))
(define (world-change-dir w dir)
   (world (snake-change-direction (world-snake w) dir) (world-food w)))
(: snake-eat : (-> World World))
(define (snake-eat w)
   (define i (add1 (random (sub1 BOARD-WIDTH))))
   (define j (add1 (random (sub1 BOARD-HEIGHT))))
   (world (snake-grow (world-snake w)) (posn i j)))
(provide)
