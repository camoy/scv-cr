#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide (all-defined-out))
(require racket/function)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define line-length 80)
(define long-line (build-string line-length (const #\━)))

(define-values (show-contracts
                keep-contracts
                show-optimized
                show-blames
                ignore-check
                blame-typed
                overwrite
                compiler-off
                verify-off
                ignore-fakes
                trust-zos)
  (values (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)))
