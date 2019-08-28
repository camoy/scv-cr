#lang racket/base

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
(define (empty-scene w h) (image))
(define (place-image i₁ r c i₂) (image))
(define (circle r m c) (image))
