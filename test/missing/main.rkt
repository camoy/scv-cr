#lang typed/racket/base

(require require-typed-check)
(require/typed/check "posn.rkt"
  [#:struct posn ()])
(posn)
