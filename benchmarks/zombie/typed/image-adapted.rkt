#lang typed/racket/base

(require require-typed-check)

(require/typed/check "image.rkt"
  (#:struct image ())
  (empty-scene (-> Real Real image))
  (place-image (-> image Real Real image image))
  (circle (-> Real String String image)))

(provide
  (struct-out image)
  empty-scene
  place-image
  circle)
