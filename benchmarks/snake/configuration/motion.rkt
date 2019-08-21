(module motion racket
   (#%module-begin
    (require "data.rkt" "const.rkt" "motion-help.rkt")
    (provide reset!)
    (define (reset!) (random-seed 1324))
    (define (world->world w)
      (cond
       ((eating? w) (snake-eat w))
       (else (world (snake-slither (world-snake w)) (world-food w)))))
    (define (eating? w)
      (posn=? (world-food w) (car (snake-segs (world-snake w)))))
    (define (snake-change-direction snk dir) (snake dir (snake-segs snk)))
    (define (world-change-dir w dir)
      (world (snake-change-direction (world-snake w) dir) (world-food w)))
    (define (snake-eat w)
      (define i (add1 (random (sub1 BOARD-WIDTH))))
      (define j (add1 (random (sub1 BOARD-HEIGHT))))
      (world (snake-grow (world-snake w)) (posn i j)))
    (provide world-change-dir world->world)))
