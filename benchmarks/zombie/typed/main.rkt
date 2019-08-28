#lang typed/racket/base

(require
  require-typed-check
  "image-adapted.rkt")

(define-type World
  (case->
   ['on-mouse -> (Real Real String -> World)]
   ['on-tick -> (-> World)]
   ['to-draw -> (-> image)]
   ['stop-when -> (-> Boolean)]))

(require/typed/check "zombie.rkt"
  (w0 World))

;; =============================================================================

(: replay (-> World (Listof Any) Void))
(define (replay w0 hist)
 (let loop ((w : World w0)
            (h : (Listof Any) hist))
  (cond
   [(null? h)
    (void)]
   [(not (list? (car h)))
    (error "input error")]
   [else
    (define m (caar h))
    (define as (cdar h))
    (case m
     [(on-mouse)
      (define r (apply (w 'on-mouse) (cast as (List Real Real String))))
      (loop r (cdr h))]
     [(on-tick)
      (define r ((w 'on-tick)))
      (loop r (cdr h))])])))

(define TEST
  (with-input-from-file "../base/zombie-hist.rktd" read))

(: main (-> Any Void))
(define (main hist)
  (cond
   [(list? hist)
    (for ([i : Integer (in-range 100)])
      (replay w0 hist))]
   [else
    (error "bad input")]))

(time (main TEST))
