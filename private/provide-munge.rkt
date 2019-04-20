#lang racket

(provide provide-munge)

(define provide-munge values)

#|
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
