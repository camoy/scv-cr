#lang racket/base

;;
;; provide
;;

(provide (all-defined-out))

;;
;; parameter
;;

(define-values (show-contracts
                provide-less
                require-less)
  (values (make-parameter #f)
          (make-parameter #f)
          (make-parameter #f)))
