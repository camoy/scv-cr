(module block racket
   (#%module-begin
    (require "data.rkt")
    (define (block=? b1 b2)
      (and (= (block-x b1) (block-x b2)) (= (block-y b1) (block-y b2))))
    (define (block-move dx dy b)
      (block (+ dx (block-x b)) (+ dy (block-y b)) (block-color b)))
    (define (block-rotate-ccw c b)
      (block
       (+ (posn-x c) (- (posn-y c) (block-y b)))
       (+ (posn-y c) (- (block-x b) (posn-x c)))
       (block-color b)))
    (define (block-rotate-cw c b)
      (block-rotate-ccw c (block-rotate-ccw c (block-rotate-ccw c b))))
    (provide block-rotate-ccw block-rotate-cw block=? block-move)))
