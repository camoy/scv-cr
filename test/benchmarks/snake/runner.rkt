#lang racket/base

(require racket/rerequire
         racket/function
         scv-gt
         scv-gt/private/syntax-util
         scv-gt/private/proxy-resolver)

(define (test-optimize main targets)
  (optimize targets
            #:compiler-off #t)
  (define main* (path->complete-path main))
  (void)
  #;(in-dir main*
    (thunk (dynamic-rerequire main*)))
  #;(for-each module-delete-zo targets))

(test-optimize "main.rkt" '("./collide.rkt"
                            "./handlers.rkt"
                            "./main.rkt"
                            "./motion-help.rkt"
                            "./motion.rkt"
                            "./cut-tail.rkt"
                            "./data.rkt"
                            "./runner.rkt"
                            "./data-adaptor.rkt"
                            "./const.rkt"))
