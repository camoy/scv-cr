(module clock typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (submod "gregor-structs.rkt" #%type-decl "..")
             (lib "racket/contract/base.rkt")
             (lib "typed-racket/types/numeric-predicates.rkt"))
    (define g25 t:exact-rational?)
    (define g26 (or/c g25))
    (define g27 (-> (values g26)))
    (define g28 (box/c g27))
    (define g29 exact-nonnegative-integer?)
    (define g30 (or/c g29))
    (define g31 exact-integer?)
    (define g32 string?)
    (define g33 '#f)
    (define g34 (or/c g31 g32 g33))
    (define g35 (lambda (x) (Time? x)))
    (define g36 (lambda (x) (DateTime? x)))
    (define g37 (lambda (x) (Moment? x)))
    (define g38 (lambda (x) (Date? x)))
    (define generated-contract15 g28)
    (define generated-contract16 (-> (values g30)))
    (define generated-contract17
      (case-> (-> (values g35)) (-> g34 (values g35))))
    (define generated-contract18 (-> (values g35)))
    (define generated-contract19
      (case-> (-> (values g36)) (-> g34 (values g36))))
    (define generated-contract20
      (case-> (-> (values g37)) (-> g34 (values g37))))
    (define generated-contract21 (-> (values g37)))
    (define generated-contract22 (-> (values g36)))
    (define generated-contract23
      (case-> (-> (values g38)) (-> g34 (values g38))))
    (define generated-contract24 (-> (values g38)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check
             "../base/types.rkt"
             "tzinfo-adapter.rkt"
             "gregor-adapter.rkt")
    (begin (require "moment.rkt") (void))
    (begin (require "datetime.rkt") (void))
    (: now/moment (->* () ((U tz #f)) Moment))
    (define (now/moment (tz (unbox current-timezone)))
      (unless tz (error "current-timezone is #f"))
      (posix->moment ((unbox current-clock)) tz))
    (: now/moment/utc (-> Moment))
    (define (now/moment/utc) (now/moment "Etc/UTC"))
    (: now (->* () ((U tz #f)) DateTime))
    (define (now (tz (unbox current-timezone)))
      (unless tz (error "now: current-timezone is #f"))
      (moment->datetime/local (now/moment tz)))
    (: now/utc (-> DateTime))
    (define (now/utc) (now "Etc/UTC"))
    (: today (->* () ((U tz #f)) Date))
    (define (today (tz (unbox current-timezone)))
      (unless tz (error "today: current-timezone is #f"))
      (datetime->date (now tz)))
    (: today/utc (-> Date))
    (define (today/utc) (today "Etc/UTC"))
    (: current-time (->* () ((U tz #f)) Time))
    (define (current-time (tz (unbox current-timezone)))
      (unless tz (error "current-time:  current-timezone is #f"))
      (datetime->time (now tz)))
    (: current-time/utc (-> Time))
    (define (current-time/utc) (current-time "Etc/UTC"))
    (: current-posix-seconds (-> Natural))
    (define (current-posix-seconds)
      (let ((r (/ (inexact->exact (current-inexact-milliseconds)) 1000)))
        (unless (index? r) (error "current-posix-seconds"))
        r))
    (: current-clock (Boxof (-> Exact-Rational)))
    (define current-clock (box current-posix-seconds))
    (provide)
    (provide current-time/utc
             today/utc
             now/utc
             now/moment/utc
             current-time
             today
             now
             now/moment
             current-posix-seconds
             current-clock)))
