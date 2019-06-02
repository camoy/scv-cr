#lang typed/racket/base

(require require-typed-check)

(require/typed/check "posn-untyped.rkt"
 [#:struct posn ([x : Real] [y : Real] [z : Real])])
