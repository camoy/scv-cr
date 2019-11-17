(module moment-base typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (submod "gregor-structs.rkt" #%type-decl "..")
             (lib "racket/contract/base.rkt"))
    (define g41 (lambda (x) (DateTime? x)))
    (define g42 exact-integer?)
    (define g43 (or/c g42))
    (define g44 string?)
    (define g45 '#f)
    (define g46 (or/c g44 g45))
    (define g47 (lambda (x) (Moment? x)))
    (define generated-contract33 (-> g41 g43 g46 (values g47)))
    (define generated-contract34 (-> g47 (values g44)))
    (define generated-contract35 (-> g47 (values g44)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract
               (lib "racket/contract/base.rkt")
               (lib "typed-racket/types/numeric-predicates.rkt")
               (lib "racket/contract.rkt")
               (lib "racket/base.rkt"))
      (define g36 t:exact-rational?)
      (define g37 (or/c g36))
      (define g38 exact-nonnegative-integer?)
      (define g39 (or/c g38))
      (define g40 string?)
      (define l/1 (-> g37 g39 g40 (values g40)))
      (begin (define ~r** #:opaque))
      (provide g38 g39 g40 l/1 g36 g37 (contract-out (~r** l/1))))
    (require (prefix-in -: (only-in 'require/contracts ~r**))
             (except-in 'require/contracts ~r**))
    (define-values (~r**) (values -:~r**))
    (void)
    (require require-typed-check
             racket/match
             "gregor-adapter.rkt"
             scv-gt/opaque)
    (begin (require "datetime.rkt") (void))
    (begin (void) (void))
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
    (provide (contract-out (moment->iso8601 generated-contract34))
             (contract-out (make-moment generated-contract33))
             (contract-out (moment->iso8601/tzid generated-contract35)))))
