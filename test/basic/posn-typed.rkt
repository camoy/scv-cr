#lang typed/racket/base

(require require-typed-check)

(require/typed/check "posn-untyped.rkt"
  [#:struct posn-2d ([x : Real] [y : Real])]
  [#:struct posn-3d ([x : Real] [y : Real] [z : Real])])
