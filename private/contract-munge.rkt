#lang racket/base

(require syntax/parse
         racket/list)

;; [List-of Syntax] -> [Hash Syntax Syntax]
;; maps raw syntaxes from Typed Racket to an immutable hash mapping
;; lifted identifiers to exported identifiers
(define (require-rename-mapping stxs)
  (define rename-helper
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract k v _ ...)))
      (list #'k #'v)]))
  (apply hash (append-map rename-helper stxs)))

;;
;; test
;;

(module+ test
  (require racket/set
           rackunit
           scv-gt/private/configure
           scv-gt/private/syntax-util
           scv-gt/private/test-util)

  (ignore-check #t)

  (test-case
    "require-rename-mapping"
    (define path (benchmark-path "sieve" "typed" "main.rkt"))
    (define renames
      (set->list
       (syntax-property-values
        (expand/base+dir (syntax-fetch path) path)
        'require-rename)))
    (check set=?
           (map syntax-e (hash-values (require-rename-mapping renames)))
           '(stream-first stream-unfold stream3 make-stream stream?
             stream-take stream-get stream-rest))))
