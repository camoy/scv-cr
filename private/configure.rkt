#lang racket/base

;;
;; provide
;;

(provide (all-defined-out))

;;
;; parameter
;;

(define-values (show-contracts
                ignore-check
                overwrite
                compiler-off
                verify-off)
  (values (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)))
