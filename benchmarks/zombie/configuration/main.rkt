(module main typed/racket/base/no-check
   (#%module-begin
    (require racket/contract)
    (module require/contracts racket/base
      (require racket/contract
               (lib "racket/base.rkt")
               (lib "racket/contract/base.rkt")
               (lib "racket/contract.rkt"))
      (define g5 real?)
      (define g6 (or/c g5))
      (define g7 string?)
      (define g8 '())
      (define g9 (cons/c g7 g8))
      (define g10 (cons/c g6 g9))
      (define g11 (cons/c g6 g10))
      (define g12 any/c)
      (define g13 (listof g12))
      (define l/10 g11)
      (define l/11 g13)
      (provide g8 g9 g10 g11 l/10 g12 g13 l/11 g5 g6 g7))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check "image-adapted.rkt")
    (require "zombie.rkt")
    (define-type
     World
     (->
      Symbol
      (U
       (Pairof 'on-mouse (-> Real Real String World))
       (Pairof 'on-tick (-> World))
       (Pairof 'to-draw (-> Image))
       (Pairof 'stop-when (-> Boolean)))))
    (: replay (-> World (Listof Any) Void))
    (define (replay w0 hist)
      (let loop ((w : World w0) (h : (Listof Any) hist))
        (cond
         ((null? h) (void))
         ((not (list? (car h))) (error "input error"))
         (else
          (define m (caar h))
          (define as (cdar h))
          (case m
            ((on-mouse)
             (define r
               (apply (world-on-mouse w) (cast as (List Real Real String))))
             (loop r (cdr h)))
            ((on-tick) (define r ((world-on-tick w))) (loop r (cdr h))))))))
    (define TEST (with-input-from-file "../base/zombie-hist.rktd" read))
    (: main (-> Any Void))
    (define (main hist)
      (cond
       ((list? hist) (for ((i : Integer (in-range 100))) (replay w0 hist)))
       (else (error "bad input"))))
    (time (main TEST))
    (provide)))
