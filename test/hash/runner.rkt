#lang racket/base

(require racket/rerequire
         racket/function
         scv-cr
         scv-cr/private/syntax-util
         scv-cr/private/proxy-resolver)

(define (test-optimize main targets)
  (optimize targets
            #:ignore-check #f
            #:show-blames #t)
  (define main* (path->complete-path main))
  (void))

(test-optimize "client.rkt" '("client.rkt" "server.rkt"))
