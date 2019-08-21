(module handlers racket
   (#%module-begin
    (require "data.rkt" "motion.rkt" "collide.rkt")
    (define (handle-key w ke)
      (cond
       ((equal? ke "w") (world-change-dir w "up"))
       ((equal? ke "s") (world-change-dir w "down"))
       ((equal? ke "a") (world-change-dir w "left"))
       ((equal? ke "d") (world-change-dir w "right"))
       (else w)))
    (define (game-over? w)
      (or (snake-wall-collide? (world-snake w))
          (snake-self-collide? (world-snake w))))
    (provide handle-key game-over?)))
