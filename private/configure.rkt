#lang racket/base

;;
;; provide
;;

(provide (all-defined-out))

;;
;; parameter
;;

(define-values (show-contract
                provide-less
                require-less
                ignore-check
                overwrite)
  (values (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)))
