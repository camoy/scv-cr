#lang typed/racket/base

(require require-typed-check)
(require/typed/check "server.rkt"
  [#:struct posn ([x : Real] [y : Real])]
  [set-posn-x! (-> posn Real Void)])
(define p (posn 1 2))
(set-posn-x! p 0)
