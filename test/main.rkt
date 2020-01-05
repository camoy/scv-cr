#lang racket/base

(module+ test
  (require
   racket/require
   rackunit
   (multi-in racket (function list path rerequire))
   scv-cr
   (multi-in scv-cr private (syntax-util proxy-resolver)))

  ;; Module-Path -> Void
  ;; checks to make sure running optimization on the modules does not yield
  ;; an issue; runs the main target
  (define (test-optimize main targets)
    (after
     (define main* (path->complete-path main))
     (optimize targets #:ignore-check #t)
     (in-dir main*
       (check-not-exn
         (thunk
          (parameterize ([current-namespace (make-base-namespace)])
            (dynamic-require main* #f)))))
     (for-each module-delete-zo targets)))

  ;; String -> Void
  ;; takes benchmark name and runs all files with test-optimize
  (define (test-benchmark benchmark)
    (let* ([benchmark-files
            (directory-list benchmark #:build? benchmark)]
           [benchmark-files*
            (filter (curryr path-has-extension? #".rkt") benchmark-files)]
           [is-main?
            (λ (p) (string=? (path->string (file-name-from-path p))
                             "main.rkt"))]
           [main
            (findf is-main? benchmark-files*)])
      (test-case
        benchmark
        (test-optimize main benchmark-files*))))

  (test-case
    "basic programs"
    (test-optimize "basic/abs.rkt"
                   '("basic/abs.rkt")))

  (test-case
    "basic posn"
    (test-optimize "basic/posn-typed-client.rkt"
                   '("basic/posn-typed-client.rkt"
                     "basic/posn-untyped-server.rkt")))

  (test-case
    "bad adder"
    (test-optimize "bad/untyped.rkt"
                   '("bad/untyped.rkt"
                     "bad/typed.rkt")))

  (test-case
    "bad struct"
    (test-optimize "bad_struct/untyped.rkt"
                   '("bad_struct/untyped.rkt"
                     "bad_struct/typed.rkt"
                     "bad_struct/data.rkt")))

  (test-case
    "unexported identifier"
    (test-optimize "unexported/main.rkt"
                   '("unexported/main.rkt"
                     "unexported/server.rkt"
                     "unexported/client.rkt")))

  (test-case
    "hash"
    (test-optimize "hash/client.rkt"
                   '("hash/client.rkt"
                     "hash/server.rkt")))

  (test-case
    "super structs simple"
    (test-optimize "super/both.rkt"
                   '("super/both.rkt")))

  (test-case
    "super structs"
    (test-optimize "super/main.rkt"
                   '("super/main.rkt"
                     "super/parent.rkt"
                     "super/child.rkt")))

  (test-case
    "mutable"
    (test-optimize "mutable/client.rkt"
                   '("mutable/client.rkt"
                     "mutable/server.rkt")))

  (test-case
    "predicate"
    (test-optimize "predicate/main.rkt"
                   '("predicate/main.rkt"
                     "predicate/typed.rkt")))

  (test-case
    "adaptor"
    (test-optimize "adaptor/const.rkt"
                   '("adaptor/const.rkt"
                     "adaptor/data-adaptor.rkt"
                     "adaptor/data.rkt")))

  #;(test-case
    "require provide"
    (test-optimize "require_provide/main.rkt"
                   '("require_provide/main.rkt"
                     "require_provide/adapter.rkt"
                     "require_provide/abs.rkt")))

  #;(test-case
    "opaque"
    (test-optimize "opaque/main.rkt"
                   '("opaque/main.rkt"
                     "opaque/adapter.rkt")))

  (test-case
    "opaque require"
    (test-optimize "opaque_require/main.rkt"
                   '("opaque_require/main.rkt")))

  (test-case
    "untyped opaque require"
    (test-optimize "untyped_opaque_require/main.rkt"
                   '("untyped_opaque_require/main.rkt")))

  (test-case
    "typed opaque require"
    (test-optimize "typed_opaque_require/main.rkt"
                   '("typed_opaque_require/main.rkt")))

  (test-benchmark "sieve")
  (test-benchmark "morsecode"))
