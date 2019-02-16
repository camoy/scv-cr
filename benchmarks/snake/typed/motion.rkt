#lang typed/racket/no-check
(define-values
  (g19
   generated-contract8
   g20
   generated-contract9
   g21
   g22
   g23
   g24
   g25
   generated-contract10)
  (let ()
    (local-require
     racket/contract
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g19 (lambda (x) (equal? x (void))))
             (generated-contract8 (-> (values g19)))
             (g20 (lambda (x) (world? x)))
             (generated-contract9 (-> g20 (values g20)))
             (g21 '"up")
             (g22 '"down")
             (g23 '"left")
             (g24 '"right")
             (g25 (or/c g21 g22 g23 g24))
             (generated-contract10 (-> g20 g25 (values g20))))
      (values
       g19
       generated-contract8
       g20
       generated-contract9
       g21
       g22
       g23
       g24
       g25
       generated-contract10))))
(require (only-in racket/contract contract-out))
(provide (contract-out (reset! generated-contract8))
          (contract-out (world->world generated-contract9))
          (contract-out (world-change-dir generated-contract10)))
(require require-typed-check "data-adaptor.rkt")
(require "const.rkt")
(require "data.rkt")
(require "motion-help.rkt")
(provide)
(define r (make-pseudo-random-generator))
(define (reset!) (void))
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
   (define i (add1 (random (sub1 BOARD-WIDTH) r)))
   (define j (add1 (random (sub1 BOARD-HEIGHT) r)))
   (world (snake-grow (world-snake w)) (posn i j)))
(provide)
