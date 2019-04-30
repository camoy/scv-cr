#lang racket/base

;;
;; provide
;;

(provide (all-defined-out))

;;
;; parameter
;;

(define-values (show-contract
                provide-off
                require-off
                ignore-check
                overwrite
                compiler-off)
  (values (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)))
