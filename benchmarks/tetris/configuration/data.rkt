(module data racket
   (#%module-begin
    (struct posn (x y))
    (struct block (x y color))
    (struct tetra (center blocks))
    (struct world (tetra blocks))
    (define (posn=? p1 p2)
      (and (= (posn-x p1) (posn-x p2)) (= (posn-y p1) (posn-y p2))))
    (provide (struct-out block)
             (struct-out posn)
             (struct-out tetra)
             (struct-out world)
             posn=?)))
