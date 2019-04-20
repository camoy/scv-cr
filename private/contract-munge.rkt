#lang racket/base

(require syntax/parse
         racket/list)

;; Syntax -> Syntax
;; yields require contract definitions
(define (require-contract stx)
  (define rename-mapping
    (require-rename-mapping
     (syntax-property-values stx 'require-rename)))
  (require-transform/mapping
   rename-mapping
   (syntax-property-values stx 'require)))

;; [Hash Symbol Syntax] [List-of Syntax] -> [List-of Syntax]
;; transforms require definitions by mapping lifted identifiers to the
;; corresponding real identifier as defined by rename-mapping
(define (require-transform/mapping rename-mapping stxs)
  (define helper
    (syntax-parser
      #:datum-literals (begin define define-values)
      [(begin (define x ...) ...
              (define-values (y) z ...))
       (define y* (hash-ref rename-mapping (syntax-e #'y)))
       #`(begin (define x ...) ...
                (define-values (#,y*) z ...))]))
  (map helper stxs))

;; [List-of Syntax] -> [Hash Symbol Syntax]
;; maps raw syntaxes from Typed Racket to an immutable hash mapping
;; lifted identifiers (as symbols) to exported identifiers
(define (require-rename-mapping stxs)
  (define helper
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract k v _ ...)))
      (list (syntax-e #'k) #'v)]))
  (apply hash (append-map helper stxs)))

;;
;; test
;;

(module+ test
  (require rackunit
           scv-gt/private/configure
           scv-gt/private/syntax-util
           scv-gt/private/test-util)

  (ignore-check #t)

  (test-case
    "require-rename-mapping"
    (define path (benchmark-path "sieve" "typed" "main.rkt"))
    (define renames
      (syntax-property-values
       (expand/base+dir (syntax-fetch path) path)
       'require-rename))
    (check set=?
           (map syntax-e (hash-values (require-rename-mapping renames)))
           '(stream-first stream-unfold stream3 make-stream stream?
             stream-take stream-get stream-rest))))

#|
(require scv-gt/private/configure
         scv-gt/private/syntax-util
         scv-gt/private/test-util
         racket/set
         racket/pretty)
(ignore-check #t)
(define path (benchmark-path "sieve" "typed" "main.rkt"))
(require-contract
   (expand/base+dir (syntax-fetch path) path))
|#
