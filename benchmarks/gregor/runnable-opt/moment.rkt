(module moment typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "typed-racket/types/numeric-predicates.rkt")
             (submod "gregor-structs.rkt" #%type-decl "..")
             (submod "tzinfo-adapter.rkt" #%type-decl ".."))
    (define g49 string?)
    (define g50 exact-integer?)
    (define g51 '#f)
    (define g52 (or/c g50 g49 g51))
    (define g53 (box/c g52))
    (define g54 (lambda (x) (DateTime? x)))
    (define g55 (or/c g50 g49))
    (define g56 (lambda (x) (tzgap? x)))
    (define g57 (lambda (x) (tzoverlap? x)))
    (define g58 (or/c g56 g57))
    (define g59 (or/c g49 g51))
    (define g60 (lambda (x) (Moment? x)))
    (define g61 (or/c g51 g60))
    (define g62 (-> g58 g54 g59 g61 (values g60)))
    (define g63 exact-nonnegative-integer?)
    (define g64 (or/c g63))
    (define g65 (lambda (x) (equal? x '1)))
    (define g66 (lambda (x) (equal? x '2)))
    (define g67 (lambda (x) (equal? x '3)))
    (define g68 (lambda (x) (equal? x '4)))
    (define g69 (lambda (x) (equal? x '5)))
    (define g70 (lambda (x) (equal? x '6)))
    (define g71 (lambda (x) (equal? x '7)))
    (define g72 (lambda (x) (equal? x '8)))
    (define g73 (lambda (x) (equal? x '9)))
    (define g74 (lambda (x) (equal? x '10)))
    (define g75 (lambda (x) (equal? x '11)))
    (define g76 (lambda (x) (equal? x '12)))
    (define g77 (or/c g65 g66 g67 g68 g69 g70 g71 g72 g73 g74 g75 g76))
    (define g78 exact-rational?)
    (define g79 (or/c g78))
    (define g80 (or/c g50))
    (define g81 '#t)
    (define g82 (or/c g81 g51))
    (define g83 (or/c g63 g49))
    (define generated-contract31 g49)
    (define generated-contract32 g53)
    (define generated-contract33 (-> g54 g55 g62 (values g60)))
    (define generated-contract34
      (case->
       (-> g64 (values g60))
       (-> g64 g77 (values g60))
       (-> g64 g77 g64 (values g60))
       (-> g64 g77 g64 g64 (values g60))
       (-> g64 g77 g64 g64 g64 (values g60))
       (-> g64 g77 g64 g64 g64 g64 (values g60))
       (-> g64 g77 g64 g64 g64 g64 g64 (values g60))
       (-> g64 g77 g64 g64 g64 g64 g64 g52 (values g60))
       (-> g64 g77 g64 g64 g64 g64 g64 g52 g62 (values g60))))
    (define generated-contract35 (-> g60 (values g54)))
    (define generated-contract36 (-> g60 (values g79)))
    (define generated-contract37 (-> g60 (values g79)))
    (define generated-contract38 (-> g60 (values g55)))
    (define generated-contract39 (-> g60 (values g59)))
    (define generated-contract40 (-> g60 (values g80)))
    (define generated-contract41 (-> g60 g64 (values g60)))
    (define generated-contract42 (-> g60 (values g60)))
    (define generated-contract43 (-> g60 g60 (values g82)))
    (define generated-contract44 (-> g60 g60 (values g82)))
    (define generated-contract45 (-> g60 g60 (values g82)))
    (define generated-contract46 (-> g79 g55 (values g60)))
    (define generated-contract47 (-> g60 g83 (values g60)))
    (define generated-contract48
      (case-> (-> g60 g83 (values g60)) (-> g60 g83 g62 (values g60))))
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check
             "../base/types.rkt"
             "gregor-adapter.rkt"
             racket/match
             (only-in racket/math exact-round)
             "tzinfo-adapter.rkt")
    (begin (require "hmsn.rkt") (void))
    (begin (require "datetime.rkt") (void))
    (begin (require "moment-base.rkt") (void))
    (begin (require "offset-resolvers.rkt") (void))
    (void)
    (: current-timezone (Boxof (U tz #f)))
    (define current-timezone (box (system-tzid)))
    (:
     moment
     (->*
      (Natural)
      (Month
       Natural
       Natural
       Natural
       Natural
       Natural
       (U tz #f)
       (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
      Moment))
    (define (moment
             year
             (month 1)
             (day 1)
             (hour 0)
             (minute 0)
             (second 0)
             (nano 0)
             (tz (unbox current-timezone))
             (resolve resolve-offset/raise))
      (when (eq? tz #f) (error "no timezone"))
      (datetime+tz->moment
       (datetime year month day hour minute second nano)
       tz
       resolve))
    (:
     datetime+tz->moment
     (->
      DateTime
      (U Integer String)
      (-> (U tzgap tzoverlap) DateTime (U String #f) (U Moment #f) Moment)
      Moment))
    (define (datetime+tz->moment dt zone resolve)
      (cond
       ((string? zone)
        (define res
          (local-seconds->tzoffset zone (exact-round (datetime->posix dt))))
        (cond
         ((tzoffset? res) (make-moment dt (tzoffset-utc-seconds res) zone))
         (else (resolve res dt zone #f))))
       ((index? zone) (make-moment dt zone #f))
       (else (error (format "datetime+tz->moment unknown zone ~a" zone)))))
    (define moment->datetime/local Moment-datetime/local)
    (define moment->utc-offset Moment-utc-offset)
    (define moment->tzid Moment-zone)
    (: moment->timezone (-> Moment tz))
    (define (moment->timezone m) (or (moment->tzid m) (moment->utc-offset m)))
    (: moment-in-utc (-> Moment Moment))
    (define (moment-in-utc m)
      (if (equal? UTC (moment->timezone m)) m (timezone-adjust m UTC)))
    (: moment->jd (-> Moment Exact-Rational))
    (define (moment->jd m)
      (datetime->jd (moment->datetime/local (moment-in-utc m))))
    (: moment->posix (-> Moment Exact-Rational))
    (define (moment->posix m)
      (datetime->posix (moment->datetime/local (moment-in-utc m))))
    (: posix->moment (-> Exact-Rational tz Moment))
    (define (posix->moment p z)
      (: off Integer)
      (define off
        (cond
         ((string? z) (tzoffset-utc-seconds (utc-seconds->tzoffset z p)))
         (else 0)))
      (define dt (posix->datetime (+ p off)))
      (unless (string? z)
        (error "posix->moment: can't call make-moment with an integer"))
      (make-moment dt off z))
    (: moment-add-nanoseconds (-> Moment Natural Moment))
    (define (moment-add-nanoseconds m n)
      (posix->moment
       (+ (moment->posix m) (* n (/ 1 NS/SECOND)))
       (moment->timezone m)))
    (: timezone-adjust (-> Moment (U Natural String) Moment))
    (define (timezone-adjust m z)
      (: dt DateTime)
      (define dt (error 'foo))
      (: neg-sec Integer)
      (define neg-sec (error 'foo))
      (: dt/utc DateTime)
      (define dt/utc (datetime-add-seconds dt (- neg-sec)))
      (cond
       ((string? z)
        (define posix (datetime->posix dt/utc))
        (match-define (tzoffset offset _ _) (utc-seconds->tzoffset z posix))
        (define local (datetime-add-seconds dt/utc offset))
        (make-moment local offset z))
       (else
        (define local (datetime-add-seconds dt/utc z))
        (make-moment local z #f))))
    (:
     timezone-coerce
     (->*
      (Moment (U Natural String))
      ((-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
      Moment))
    (define (timezone-coerce m z (resolve resolve-offset/raise))
      (datetime+tz->moment (moment->datetime/local m) z resolve))
    (: moment=? (-> Moment Moment Boolean))
    (define (moment=? m1 m2) (= (moment->jd m1) (moment->jd m2)))
    (: moment<? (-> Moment Moment Boolean))
    (define (moment<? m1 m2) (< (moment->jd m1) (moment->jd m2)))
    (: moment<=? (-> Moment Moment Boolean))
    (define (moment<=? m1 m2) (<= (moment->jd m1) (moment->jd m2)))
    (: UTC String)
    (define UTC "Etc/UTC")
    (provide moment->iso8601 moment->iso8601/tzid)
    (provide datetime+tz->moment
             moment
             current-timezone
             UTC
             moment<=?
             moment<?
             moment=?
             timezone-coerce
             timezone-adjust
             moment-in-utc
             moment-add-nanoseconds
             posix->moment
             moment->posix
             moment->jd
             moment->tzid
             moment->timezone
             moment->utc-offset
             moment->datetime/local)))
