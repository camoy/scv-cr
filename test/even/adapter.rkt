#lang typed/racket/base

(require/typed "data.rkt"
  [even? (-> Integer Boolean)])

#;(: even? (-> Integer Boolean))
#;(define (even? n)
  (zero? (modulo n 2)))

(provide even?)

