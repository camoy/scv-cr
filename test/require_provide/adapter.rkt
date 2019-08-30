#lang typed/racket/base

(require/typed/provide "abs.rkt"
  [absz (-> Real Number)]
  [#:struct my-box ([x : Real])])
