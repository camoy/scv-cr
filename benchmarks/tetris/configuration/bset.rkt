(module bset racket
   (#%module-begin
    (require "data.rkt" "block.rkt" "consts.rkt")
    (define (blocks-contains? bs b) (ormap (λ (c) (block=? b c)) bs))
    (define (blocks-subset? bs1 bs2)
      (andmap (λ (b) (blocks-contains? bs2 b)) bs1))
    (define (blocks=? bs1 bs2)
      (and (blocks-subset? bs1 bs2) (blocks-subset? bs2 bs1)))
    (define (blocks-intersect bs1 bs2)
      (filter (λ (b) (blocks-contains? bs2 b)) bs1))
    (define (blocks-count bs) (length bs))
    (define (blocks-move dx dy bs) (map (λ (b) (block-move dx dy b)) bs))
    (define (blocks-rotate-ccw c bs) (map (λ (b) (block-rotate-ccw c b)) bs))
    (define (blocks-rotate-cw c bs) (map (λ (b) (block-rotate-cw c b)) bs))
    (define (blocks-change-color bs c)
      (map (λ (b) (block (block-x b) (block-y b) c)) bs))
    (define (blocks-row bs i) (filter (λ (b) (= i (block-y b))) bs))
    (define (full-row? bs i) (= board-width (blocks-count (blocks-row bs i))))
    (define (blocks-overflow? bs) (ormap (λ (b) (<= (block-y b) 0)) bs))
    (define (blocks-union bs1 bs2)
      (foldr
       (λ (b bs) (cond ((blocks-contains? bs b) bs) (else (cons b bs))))
       bs2
       bs1))
    (define (blocks-max-y bs) (foldr (λ (b n) (max (block-y b) n)) 0 bs))
    (define (blocks-min-x bs)
      (foldr (λ (b n) (min (block-x b) n)) board-width bs))
    (define (blocks-max-x bs) (foldr (λ (b n) (max (block-x b) n)) 0 bs))
    (provide blocks-contains?
             blocks=?
             blocks-subset?
             blocks-intersect
             blocks-count
             blocks-overflow?
             blocks-move
             blocks-rotate-cw
             blocks-rotate-ccw
             blocks-change-color
             blocks-row
             full-row?
             blocks-union
             blocks-max-x
             blocks-min-x
             blocks-max-y)))
