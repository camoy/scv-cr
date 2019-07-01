#lang racket/base

(require racket/rerequire
         racket/function
         scv-gt
         scv-gt/private/syntax-util
         scv-gt/private/proxy-resolver)

(define (test-optimize main targets)
  (optimize targets)
  (define main* (path->complete-path main))
  (void)
  #;(in-dir main*
    (thunk (dynamic-rerequire main*)))
  #;(for-each module-delete-zo targets))

(test-optimize "untyped.rkt" '("typed.rkt" "untyped.rkt"))
