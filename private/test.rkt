#lang racket/base

(provide test-path
         benchmark-path
         syntax=?)

;;
;; constants
;;

(define TEST-DIR
  (build-path (current-directory) 'up "test"))
(define BENCHMARK-DIR
  (build-path TEST-DIR "benchmarks"))

;;
;; functions
;;

(require racket/string
         racket/function)

;; Syntax Syntax -> Boolean
;; returns whether the two syntaxes have the same datum
;; ignoring lexical context
(define (syntax=? stx1 stx2)
  (equal? (syntax->datum stx1) (syntax->datum stx2)))

;;
;; path builders
;;

(define test-path
  (curry build-path TEST-DIR))

(define benchmark-path
  (curry build-path BENCHMARK-DIR))
