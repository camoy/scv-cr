#lang racket/base

(require syntax/parse
         racket/list
         scv-gt/private/syntax-util)

;; Syntax -> Syntax
;; yields provide contract definitions
(define (provide-contract stx)
  (syntax-property-values stx 'provide))

;; [List-of Syntax] -> [Hash Syntax Syntax]
#;(define (require-ctc+def stxs)
    ...)

;; [List-of Syntax] -> [Hash Syntax Syntax]
;; maps raw syntaxes from Typed Racket to an immutable hash mapping
;; exported identifiers to contract definitions
(define (provide-binding+ctc stx)
  (define helper
   (syntax-parser
     #:datum-literals (begin define define-values
                       define-module-boundary-contract)
     [(begin (define _ ...) ...
             (define-values _ ...)
             (define-module-boundary-contract
               _ k v _ ...))
      (list #'k #'v)]))
  (apply hash (append-map helper (syntax-property-values stx 'provide))))

;; Syntax -> [Hash Syntax Syntax]
;; takes syntax from Typed Racket and yields an immutable hash mapping from exported
;; identifiers to contract definitions
(define (require-binding+ctc stx)
  (define helper
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract v k _ ...)))
      (list #'k #'v)]))
  (apply hash (append-map helper (syntax-property-values stx 'require-rename))))

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
    (define renames
      (syntax-property-values
       (expand/base+dir (syntax-fetch path) path)
       'require-rename))
    (check set=?
           (map syntax-e (hash-keys (require-binding+ctc renames)))
           '(stream-first stream-unfold stream3 make-stream stream?
             stream-take stream-get stream-rest))))


(require scv-gt/private/configure
         scv-gt/private/syntax-util
         scv-gt/private/test-util
         racket/set
         racket/pretty)
(ignore-check #t)
(define path (benchmark-path "sieve" "typed" "main.rkt"))
(require-binding+ctc (expand/base+dir (syntax-fetch path) path))


#| PROVIDE
==========
'((begin
    (define-values (generated-contract12) (->* (g17 g16) () any))
    (define-module-boundary-contract
     stream-get
     stream-get
     generated-contract12
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      178
      10)))
  (begin
    (define-values (generated-contract9) (->* (g17) () any))
    (define-module-boundary-contract
     stream-first
     stream-first
     generated-contract9
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      311
      6)))
  (begin
    (define-values (generated-contract14) (->* (g17) () any))
    (define-module-boundary-contract
     stream-unfold
     stream-unfold
     generated-contract14
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      155
      13)))
  (begin
    (define-values (generated-contract8) (->* (g17) () any))
    (define-module-boundary-contract
     stream-rest
     stream-rest
     generated-contract8
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      311
      6)))
  (begin
    (define-values (generated-contract13) (->* (g17 g16) () any))
    (define-module-boundary-contract
     stream-take
     stream-take
     generated-contract13
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      198
      11)))
  (begin
    (define g23 struct-predicate-procedure?)
    (define g24 any/c)
    (define g25 (->* (g24) () any))
    (define g26 (or/c g23 g25))
    (define-values (generated-contract7) g26)
    (define-module-boundary-contract
     stream?
     stream?
     generated-contract7
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      311
      6)))
  (begin
    (define g21 (struct-type/c #f))
    (define-values (generated-contract6) g21)
    (define-module-boundary-contract
     struct:stream
     struct:stream
     generated-contract6
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      311
      6)))
  (begin
    (define-values (generated-contract11) (->* (g16 g18) () any))
    (define-module-boundary-contract
     stream
     stream
     generated-contract11
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      311
      6)))
  (begin
    (define g16 (flat-named-contract 'Natural exact-nonnegative-integer?))
    (define g17 (flat-named-contract 'stream? (lambda (x) (stream? x))))
    (define g18 (simple-result-> g17 0))
    (define-values (generated-contract5) (->* (g16 g18) () any))
    (define-module-boundary-contract
     make-stream
     make-stream
     generated-contract5
     #:pos-source
     blame3
     #:srcloc
     (vector
      '#<path:/home/camoy/1x/11.gradual/scv-gt/private/../test/benchmarks/sieve/typed/streams.rkt>
      #f
      #f
      134
      11))))
|#


#| REQUIRE
==========
'((begin (define g26 (simple-result-> g19 2)) (define-values (stream-get) g26))
  (begin
    (define g19 (flat-named-contract 'Natural exact-nonnegative-integer?))
    (define g20 (simple-result-> g19 1))
    (define-values (stream-first) g20))
  (begin (define-values (stream-unfold) (->* (g15) () (values g19 g16))))
  (begin
    (define g15 any/c)
    (define g16 (flat-named-contract 'stream? (lambda (x) (stream? x))))
    (define g17 (simple-result-> g16 2))
    (define-values (stream3) g17))
  (begin (define-values (make-stream) g17))
  (begin
    (define g28 (listof g19))
    (define-values (stream-take) (->* (g15 g15) () (values g28))))
  (begin
    (define g22 (simple-result-> g16 0))
    (define-values (stream-rest) (->* (g15) () (values g22)))))
|#
