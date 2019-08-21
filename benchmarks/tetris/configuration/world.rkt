(module world racket
   (#%module-begin
    (require "data.rkt"
             "bset.rkt"
             "tetras.rkt"
             "aux.rkt"
             "elim.rkt"
             "consts.rkt")
    (provide world-key-move next-world ghost-blocks)
    (define (touchdown w)
      (world
       (list-pick-random tetras)
       (eliminate-full-rows
        (blocks-union (tetra-blocks (world-tetra w)) (world-blocks w)))))
    (define (world-jump-down w)
      (cond
       ((landed? w) w)
       (else
        (world-jump-down
         (world (tetra-move 0 1 (world-tetra w)) (world-blocks w))))))
    (define (landed-on-blocks? w)
      (tetra-overlaps-blocks?
       (tetra-move 0 1 (world-tetra w))
       (world-blocks w)))
    (define (landed-on-floor? w)
      (= (blocks-max-y (tetra-blocks (world-tetra w))) (sub1 board-height)))
    (define (landed? w) (or (landed-on-blocks? w) (landed-on-floor? w)))
    (define (next-world w)
      (cond
       ((landed? w) (touchdown w))
       (else (world (tetra-move 0 1 (world-tetra w)) (world-blocks w)))))
    (define (try-new-tetra w new-tetra)
      (cond
       ((or (< (blocks-min-x (tetra-blocks new-tetra)) 0)
            (>= (blocks-max-x (tetra-blocks new-tetra)) board-width)
            (tetra-overlaps-blocks? new-tetra (world-blocks w)))
        w)
       (else (world new-tetra (world-blocks w)))))
    (define (world-move dx dy w)
      (try-new-tetra w (tetra-move dx dy (world-tetra w))))
    (define (world-rotate-ccw w)
      (try-new-tetra w (tetra-rotate-ccw (world-tetra w))))
    (define (world-rotate-cw w)
      (try-new-tetra w (tetra-rotate-cw (world-tetra w))))
    (define (ghost-blocks w)
      (tetra-blocks
       (tetra-change-color (world-tetra (world-jump-down w)) 'gray)))
    (define (world-key-move w k)
      (cond
       ((equal? k "left") (world-move neg-1 0 w))
       ((equal? k "right") (world-move 1 0 w))
       ((equal? k "down") (world-jump-down w))
       ((equal? k "a") (world-rotate-ccw w))
       ((equal? k "s") (world-rotate-cw w))
       (else w)))))
