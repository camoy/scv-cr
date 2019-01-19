#lang racket

(require tr-contract/private/store/generic)

(provide require-mapping-store)

(define require-mapping-store
  (new store% [filename "_require-mappings.dat"]))
