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

(define stat-blames (box #f))
(define stat-times (make-hash))

(define-syntax-rule (stat-time ?key ?x ...)
  (let ([body (λ () ?x ...)])
    (define-values (r _ t __)
      (time-apply body '()))
    (define old (hash-ref! stat-times ?key (λ () 0)))
    (hash-set! stat-times ?key (+ old t))
    (apply values r)))
