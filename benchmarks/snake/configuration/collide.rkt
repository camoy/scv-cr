(module collide racket
   (#%module-begin
    (require "data.rkt" "const.rkt")
    (define (snake-wall-collide? snk) (head-collide? (car (snake-segs snk))))
    (define (head-collide? p)
      (or (<= (posn-x p) 0)
          (>= (posn-x p) BOARD-WIDTH)
          (<= (posn-y p) 0)
          (>= (posn-y p) BOARD-HEIGHT)))
    (define (snake-self-collide? snk)
      (segs-self-collide? (car (snake-segs snk)) (cdr (snake-segs snk))))
    (define (segs-self-collide? h segs)
      (cond
       ((empty? segs) #f)
       (else (or (posn=? (car segs) h) (segs-self-collide? h (cdr segs))))))
    (provide snake-wall-collide? snake-self-collide?)))
