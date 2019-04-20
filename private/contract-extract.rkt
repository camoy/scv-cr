#lang racket/base

(require syntax/parse
         racket/list
         racket/match
         scv-gt/private/syntax-util
         scv-gt/private/provide-munge
         scv-gt/private/require-munge)

;;
;; contract definition functions
;;

(provide provide-ctc-defns
         require-ctc-defns)

;; Symbol (Syntax -> Syntax) -> Syntax -> Syntax
;; makes a munged definition function
(define ((make-ctc-defns key munger) stx)
  #`(begin
      #,@(map munger (reverse (syntax-property-values stx key)))))

;; Syntax -> Syntax
;; yields munged provide contract definitions
(define provide-ctc-defns
  (make-ctc-defns 'provide provide-munge))

;; Syntax -> Syntax
;; yields munged require contract definitions
(define require-ctc-defns
  (make-ctc-defns 'require require-munge))

;;
;; binding+ctc functions
;;

(provide provide-ctc-out
         require-ctc-out)

;; [List-of [Cons Syntax Syntax]] -> Syntax
;; constructs a provide form from a mapping between identifiers and contract definitions
(define (provide-wrapper p/c-items)
  #`(provide (contract-out #,@p/c-items)))

;; Symbol (Syntax -> [List-of Syntax]) -> (Syntax -> [List-of [List-of Syntax]])
;; takes a key for searching syntax properties and a syntax parser that yields
;; associations between bindings and contract definitions and constructs a
;; binding+ctc function
(define ((make-ctc-out key transform) stx)
  (provide-wrapper (map transform (syntax-property-values stx key))))

;; Syntax -> [List-of [List-of Syntax]]
;; takes syntax from Typed Racket and yields an immutable hash mapping from exported
;; identifiers to contract definitions
(define provide-ctc-out
  (make-ctc-out
   'provide
   (syntax-parser
     #:datum-literals (begin define define-values
                       define-module-boundary-contract)
     [(begin (define _ ...) ...
             (define-values _ ...)
             (define-module-boundary-contract
               _ k v _ ...))
      (list #'k #'v)])))

;; Syntax -> [List-of [List-of Syntax]]
;; takes syntax from Typed Racket and yields an immutable hash mapping from imported
;; identifiers to contract definitions
(define require-ctc-out
  (make-ctc-out
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

#|
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

|#


(require scv-gt/private/configure
         scv-gt/private/syntax-util
         scv-gt/private/test-util
         racket/set
         racket/pretty)
(ignore-check #t)
(define path (benchmark-path "sieve" "typed" "main.rkt"))
(require-ctc-defns (expand/base+dir (syntax-fetch path) path))
