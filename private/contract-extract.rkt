#lang racket/base

(require syntax/parse
         racket/list
         scv-gt/private/syntax-util
         scv-gt/private/provide-munge
         scv-gt/private/require-munge)

;; Symbol (Syntax -> Syntax) -> Syntax -> Syntax
;; makes a munged definition function
(define ((make-ctc+def key munger) stx)
  (datum->syntax stx (map munger
                          (syntax-property-values stx key))))

;; Syntax -> Syntax
;; yields munged provide contract definitions
(define provide-ctc+def
  (make-ctc+def 'provide provide-munge))

;; Syntax -> Syntax
;; yields munged require contract definitions
(define (require-ctc+def stx)
  (make-ctc+def 'require require-munge))

;; Symbol (Syntax -> [List-of Syntax]) -> (Syntax -> [Hash Syntax Syntax])
;; takes a key for searching syntax properties and a syntax parser that yields
;; associations between bindings and contract definitions and constructs a
;; binding+ctc function
(define ((make-binding+ctc key transform) stx)
  (apply hash (append-map transform (syntax-property-values stx key))))

;; [List-of Syntax] -> [Hash Syntax Syntax]
;; takes syntax from Typed Racket and yields an immutable hash mapping from exported
;; identifiers to contract definitions
(define provide-binding+ctc
  (make-binding+ctc
   'provide
   (syntax-parser
     #:datum-literals (begin define define-values
                       define-module-boundary-contract)
     [(begin (define _ ...) ...
             (define-values _ ...)
             (define-module-boundary-contract
               _ k v _ ...))
      (list #'k #'v)])))

;; Syntax -> [Hash Syntax Syntax]
;; takes syntax from Typed Racket and yields an immutable hash mapping from imported
;; identifiers to contract definitions
(define require-binding+ctc
  (make-binding+ctc
   'require-rename
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract v k _ ...)))
      (list #'k #'v)])))

;;
;; test
;;

(module+ test
  (require rackunit
           racket/set
           scv-gt/private/configure
           scv-gt/private/syntax-util
           scv-gt/private/test-util)

  (ignore-check #t)

  (test-case
    "require-binding+ctc"
    (define path (benchmark-path "sieve" "typed" "main.rkt"))
    (define stx
      (expand/base+dir (syntax-fetch path) path))
    (check set=?
           (map syntax-e (hash-keys (require-binding+ctc stx)))
           '(stream-first stream-unfold stream3 make-stream stream?
                          stream-take stream-get stream-rest)))

  (test-case
    "provide-binding+ctc"
    (define path (benchmark-path "sieve" "typed" "streams.rkt"))
    (define stx
      (expand/base+dir (syntax-fetch path) path))
    (check set=?
           (map syntax-e (hash-keys (provide-binding+ctc stx)))
           '(stream stream-rest make-stream stream-unfold stream-get
             stream? stream-take struct:stream stream-first)))
  )

#|

(require scv-gt/private/configure
         scv-gt/private/syntax-util
         scv-gt/private/test-util
         racket/set
         racket/pretty)
(ignore-check #t)
(define path (benchmark-path "sieve" "typed" "streams.rkt"))
(provide-ctc+def (expand/base+dir (syntax-fetch path) path))

|#
