#lang racket/base

(provide contract-opt)

(require soft-contract/main
         scv-gt/private/configure
         debug-scopes
         racket/pretty)

;; [List-of Path] [List-of Syntax] -> [List-of Syntax]
;; use SCV to optimize away contracts
(define (contract-opt targets stxs)
  (define targets* (map path->string targets))
  #;(pretty-print targets*)
  #;(pretty-print (map syntax->datum stxs))
  (displayln stxs)
  (for ([stx stxs])
    (displayln (+scopes stx)))
  #;(displayln (verify-modules targets* stxs))
  (if (verify-off)
      stxs
      stxs))
