#lang info
(define collection "scv-cr")
(define deps '("base"
               "basedir"
               "mischief"
               "require-typed-check"
               "gtp-measure"
               "gtp-plot"
               "graph"
               "txexpr"
               "html-parsing"))
(define build-deps '("scribble-lib" "racket-doc" "rackunit-lib"))
(define scribblings '(("scribblings/scv-cr.scrbl" ())))
(define pkg-desc "Typed Racket optimization with SCV")
(define version "0.0")
(define pkg-authors '(camoy))
(define raco-commands
  '(("scv-cr" (submod scv-cr/main main)
              "Optimize Typed Racket program with SCV"
              #f)))
(define compile-omit-paths '("test" "benchmarks" "etc"))
