#lang typed/racket/base

(require scv-cr/opaque)

(require/typed/provide/opaque "abs.rkt"
  [absz (-> Real Number)]
  [#:struct my-box ([x : Real])])
