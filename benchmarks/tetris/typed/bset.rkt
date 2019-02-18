#lang typed/racket/no-check
(define-values
  (g34
   g35
   g36
   generated-contract8
   g37
   g38
   g39
   generated-contract9
   g40
   g41
   generated-contract10
   generated-contract11
   g42
   g43
   generated-contract12
   generated-contract13
   generated-contract14
   generated-contract15
   generated-contract16
   g44
   generated-contract17
   generated-contract18
   generated-contract19
   generated-contract20
   generated-contract21
   generated-contract22
   generated-contract23)
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
    (letrec ((g34 (lambda (x) (block? x)))
             (g35 (listof g34))
             (g36 symbol?)
             (generated-contract8 (-> g35 g36 (values g35)))
             (g37 '#t)
             (g38 '#f)
             (g39 (or/c g37 g38))
             (generated-contract9 (-> g35 g34 (values g39)))
             (g40 exact-nonnegative-integer?)
             (g41 (or/c g40))
             (generated-contract10 (-> g35 (values g41)))
             (generated-contract11 (-> g35 g35 (values g35)))
             (g42 real?)
             (g43 (or/c g42))
             (generated-contract12 (-> g35 (values g43)))
             (generated-contract13 (-> g35 (values g43)))
             (generated-contract14 (-> g35 (values g43)))
             (generated-contract15 (-> g43 g43 g35 (values g35)))
             (generated-contract16 (-> g35 (values g39)))
             (g44 (lambda (x) (posn? x)))
             (generated-contract17 (-> g44 g35 (values g35)))
             (generated-contract18 (-> g44 g35 (values g35)))
             (generated-contract19 (-> g35 g43 (values g35)))
             (generated-contract20 (-> g35 g35 (values g39)))
             (generated-contract21 (-> g35 g35 (values g35)))
             (generated-contract22 (-> g35 g35 (values g39)))
             (generated-contract23 (-> g35 g41 (values g39))))
      (values
       g34
       g35
       g36
       generated-contract8
       g37
       g38
       g39
       generated-contract9
       g40
       g41
       generated-contract10
       generated-contract11
       g42
       g43
       generated-contract12
       generated-contract13
       generated-contract14
       generated-contract15
       generated-contract16
       g44
       generated-contract17
       generated-contract18
       generated-contract19
       generated-contract20
       generated-contract21
       generated-contract22
       generated-contract23))))
(require (only-in racket/contract contract-out))
(provide (contract-out (blocks-change-color generated-contract8))
          (contract-out (blocks-contains? generated-contract9))
          (contract-out (blocks-count generated-contract10))
          (contract-out (blocks-intersect generated-contract11))
          (contract-out (blocks-max-x generated-contract12))
          (contract-out (blocks-max-y generated-contract13))
          (contract-out (blocks-min-x generated-contract14))
          (contract-out (blocks-move generated-contract15))
          (contract-out (blocks-overflow? generated-contract16))
          (contract-out (blocks-rotate-ccw generated-contract17))
          (contract-out (blocks-rotate-cw generated-contract18))
          (contract-out (blocks-row generated-contract19))
          (contract-out (blocks-subset? generated-contract20))
          (contract-out (blocks-union generated-contract21))
          (contract-out (blocks=? generated-contract22))
          (contract-out (full-row? generated-contract23)))
(require "base-types.rkt")
(require require-typed-check)
(require "block.rkt")
(require "consts.rkt")
(: blocks-contains? (-> BSet Block Boolean))
(define (blocks-contains? bs b) (ormap (λ: ((c : Block)) (block=? b c)) bs))
(: blocks-subset? (-> BSet BSet Boolean))
(define (blocks-subset? bs1 bs2)
   (andmap (λ: ((b : Block)) (blocks-contains? bs2 b)) bs1))
(: blocks=? (-> BSet BSet Boolean))
(define (blocks=? bs1 bs2)
   (and (blocks-subset? bs1 bs2) (blocks-subset? bs2 bs1)))
(: blocks-intersect (-> BSet BSet BSet))
(define (blocks-intersect bs1 bs2)
   (filter (λ: ((b : Block)) (blocks-contains? bs2 b)) bs1))
(: blocks-count (-> BSet Natural))
(define (blocks-count bs) (length bs))
(: blocks-move (-> Real Real BSet BSet))
(define (blocks-move dx dy bs)
   (map (λ: ((b : Block)) (block-move dx dy b)) bs))
(: blocks-rotate-ccw (-> Posn BSet BSet))
(define (blocks-rotate-ccw c bs)
   (map (λ: ((b : Block)) (block-rotate-ccw c b)) bs))
(: blocks-rotate-cw (-> Posn BSet BSet))
(define (blocks-rotate-cw c bs)
   (map (λ: ((b : Block)) (block-rotate-cw c b)) bs))
(: blocks-change-color (-> BSet Color BSet))
(define (blocks-change-color bs c)
   (map (λ: ((b : Block)) (block (block-x b) (block-y b) c)) bs))
(: blocks-row (-> BSet Real BSet))
(define (blocks-row bs i) (filter (λ: ((b : Block)) (= i (block-y b))) bs))
(: full-row? (-> BSet Natural Boolean))
(define (full-row? bs i) (= board-width (blocks-count (blocks-row bs i))))
(: blocks-overflow? (-> BSet Boolean))
(define (blocks-overflow? bs)
   (ormap (λ: ((b : Block)) (<= (block-y b) 0)) bs))
(: blocks-union (-> BSet BSet BSet))
(define (blocks-union bs1 bs2)
   (foldr
    (λ:
     ((b : Block) (bs : BSet))
     (cond ((blocks-contains? bs b) bs) (else (cons b bs))))
    bs2
    bs1))
(: blocks-max-y (-> BSet Real))
(define (blocks-max-y bs)
   (foldr (λ: ((b : Block) (n : Real)) (max (block-y b) n)) 0 bs))
(: blocks-min-x (-> BSet Real))
(define (blocks-min-x bs)
   (foldr (λ: ((b : Block) (n : Real)) (min (block-x b) n)) board-width bs))
(: blocks-max-x (-> BSet Real))
(define (blocks-max-x bs)
   (foldr (λ: ((b : Block) (n : Real)) (max (block-x b) n)) 0 bs))
(provide)
