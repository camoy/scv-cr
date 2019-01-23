#lang racket

(require tr-contract/private/store)

(provide require-mapping)

(define require-mapping-singleton%
  (class store%
    (super-new [path "_require-mapping.dat"])))

(define require-mapping
  (new require-mapping-singleton%))
