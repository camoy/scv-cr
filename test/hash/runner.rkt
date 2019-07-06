#lang racket/base

(require racket/rerequire
         racket/function
         scv-gt
         scv-gt/private/syntax-util
         scv-gt/private/proxy-resolver)

(define (test-optimize main targets)
  (optimize targets
            #:ignore-check #f
            #:show-blames #t)
  (define main* (path->complete-path main))
  (void))

(test-optimize "client.rkt" '("client.rkt" "server.rkt"))
