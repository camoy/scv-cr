#lang racket/base

(require (only-in "zombie.rkt" w0))

;; =============================================================================

(define (replay w0 hist)
 (let loop ((w  w0)
            (h  hist))
  (cond
   [(null? h)
    (void)]
   [(not (list? (car h)))
    (error "input error")]
   [else
    (define m (caar h))
    (define as (cdar h))
    (case m
     ;; no rendering
     [(to-draw stop-when)
       (loop w (cdr h))]
     [(on-mouse)
      (define r (apply (w 'on-mouse) (if (and (list? as) (real? (car as)) (real? (cadr as)) (string? (caddr as)) (null? (cdddr as)))
                                              as (error "cast error"))))
      (loop r (cdr h))]
     [(on-tick)
      (define r ((w 'on-tick)))
      (loop r (cdr h))])])))

(define DATA
  (with-input-from-file "../base/zombie-hist.rktd" read))

(define (main hist)
  (cond
   [(list? hist)
    (for ((i (in-range 100)))
      (replay w0 hist))]
   [else
    (error "bad input")]))

(time (main DATA))
