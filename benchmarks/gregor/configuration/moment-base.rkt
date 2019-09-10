(module moment-base typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/contract/base.rkt")
             (lib "racket/base.rkt")
             (submod "gregor-structs.rkt" #%type-decl "..")
             (lib "racket/contract.rkt"))
    (define g35 (lambda (x) (DateTime? x)))
    (define g36 exact-integer?)
    (define g37 (or/c g36))
    (define g38 string?)
    (define g39 '#f)
    (define g40 (or/c g38 g39))
    (define g41 (lambda (x) (Moment? x)))
    (define generated-contract32 (-> g35 g37 g40 (values g41)))
    (define generated-contract33 (-> g41 (values g38)))
    (define generated-contract34 (-> g41 (values g38)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check
             racket/match
             "gregor-adapter.rkt"
             "format-adapter.rkt")
    (begin (require "datetime.rkt") (void))
    (: moment->iso8601/tzid (-> Moment String))
    (define (moment->iso8601/tzid m)
      (: iso String)
      (define iso (moment->iso8601 m))
      (match m ((Moment _ _ z) #:when z (format "~a[~a]" iso z)) (_ iso)))
    (: moment->iso8601 (-> Moment String))
    (define (moment->iso8601 m)
      (match
       m
       ((Moment d 0 _) (string-append (datetime->iso8601 d) "Z"))
       ((Moment d o _)
        (define sign (if (< o 0) "-" "+"))
        (define sec (abs o))
        (define hrs (quotient sec 3600))
        (define min (quotient (- sec (* hrs 3600)) 60))
        (format
         "~a~a~a:~a"
         (datetime->iso8601 d)
         sign
         (~r** hrs 2 "0")
         (~r** min 2 "0")))))
    (: make-moment (-> DateTime Integer (U String #f) Moment))
    (define (make-moment dt off z)
      (Moment dt off (and z (string->immutable-string z))))
    (provide)
    (provide (contract-out (moment->iso8601 generated-contract33))
             (contract-out (make-moment generated-contract32))
             (contract-out (moment->iso8601/tzid generated-contract34)))))
