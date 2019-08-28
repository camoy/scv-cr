#lang typed/racket/base

;; Placeholder for images.
;; Pretends to render data.

(provide
 (struct-out image)
 empty-scene ;(number? number? . -> . image?)]
 place-image ;(image? number? number? image? . -> . image?)]
 circle      ;(number? string? string? . -> . image?)]
)

;; =============================================================================

(struct image ())
(define (empty-scene [w : Real] [h : Real]) (image))
(define (place-image [i₁ : image] [r : Real] [c : Real] [i₂ : image]) (image))
(define (circle [r : Real] [m : String] [c : String]) (image))
