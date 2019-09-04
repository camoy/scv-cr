(module moment-base typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (submod "gregor-structs.rkt" #%type-decl "..")
             (lib "racket/contract/base.rkt"))
    (define g45 (lambda (x) (DateTime? x)))
    (define g46 exact-integer?)
    (define g47 (or/c g46))
    (define g48 string?)
    (define g49 '#f)
    (define g50 (or/c g48 g49))
    (define g51 (lambda (x) (Moment? x)))
    (define generated-contract42 (-> g45 g47 g50 (values g51)))
    (define generated-contract43 (-> g51 (values g48)))
    (define generated-contract44 (-> g51 (values g48)))
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
             (only-in racket/format ~r))
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
         (~r hrs #:min-width 2 #:pad-string "0" #:sign #f)
         (~r min #:min-width 2 #:pad-string "0" #:sign #f)))))
    (: make-moment (-> DateTime Integer (U String #f) Moment))
    (define (make-moment dt off z)
      (Moment dt off (and z (string->immutable-string z))))
    (provide)
    (provide (contract-out (make-moment generated-contract42))
             (contract-out (moment->iso8601/tzid generated-contract44))
             (contract-out (moment->iso8601 generated-contract43)))))
