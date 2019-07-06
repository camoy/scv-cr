#lang typed/racket

(require require-typed-check)
(require/typed/check "data.rkt" [#:struct foo ()])
(provide (struct-out foo))
