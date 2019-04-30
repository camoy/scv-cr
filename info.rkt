#lang info
(define collection "scv-gt")
(define deps '("base"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/scv-gt.scrbl" ())))
(define pkg-desc "Typed Racket optimization with SCV")
(define version "0.0")
(define pkg-authors '(camoy))
(define raco-commands
  '(("scv-gt" (submod scv-gt/private/raco main)
              "Optimize Typed Racket program with SCV"
              #f)))
