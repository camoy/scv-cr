#lang typed/racket/base

(require require-typed-check)
(require/typed/check "parent.rkt"
                     [#:struct parent ([x : Real] [y : Real])])
(require/typed/check "child.rkt"
                     [#:struct (child parent) ([a : Real] [b : Real])])

(define c (child 0 1 2 3))
(and (= (parent-x c) 0)
     (= (parent-y c) 1)
     (= (child-a c) 2)
     (= (child-b c) 3))
