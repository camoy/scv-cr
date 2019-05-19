#lang racket/base

(provide contract-opt)

(require soft-contract/main
         scv-gt/private/configure
         racket/pretty)

;; [List-of Syntax] [List-of Path] -> [List-of Syntax]
;; use SCV to optimize away contracts
(define (contract-opt stxs targets)
  (pretty-print (syntax->datum (car stxs)))
  (displayln (verify-modules targets stxs))
  (if (verify-off)
      stxs
      stxs))
