#lang racket/base

(require scv-cr/opaque)
(require/opaque "abs.rkt"
  absz
  [#:struct my-box (x)])
(define boxed-x (my-box -3))
(displayln (absz (my-box-x boxed-x)))
