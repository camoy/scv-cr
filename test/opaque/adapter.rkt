#lang typed/racket/base

(require scv-gt/opaque)

(require/typed/provide/opaque "abs.rkt"
  [absz (-> Real Number)]
  [#:struct my-box ([x : Real])])
