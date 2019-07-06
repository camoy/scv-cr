#lang racket/base

(provide table)
(define table
  (make-hash
   (list (cons #\a ""))))

#|
#lang typed/racket/base

(provide table)

(: table (HashTable Char String))
(define table
  (make-hash
   (list (cons #\a ""))))
|#
