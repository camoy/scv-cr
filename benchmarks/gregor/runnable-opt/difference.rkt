(module difference typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (submod "gregor-structs.rkt" #%type-decl ".."))
    (define g25 (lambda (x) (DateTime? x)))
    (define g26 exact-integer?)
    (define g27 (or/c g26))
    (define generated-contract22 (-> g25 g25 (values g27)))
    (define generated-contract23 (-> g25 g25 (values g27)))
    (define generated-contract24 (-> g25 g25 (values g27)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check
             racket/match
             "core-adapter.rkt"
             "gregor-adapter.rkt"
             (only-in racket/math exact-floor))
    (begin (require "ymd.rkt") (void))
    (begin (require "hmsn.rkt") (void))
    (begin (require "date.rkt") (void))
    (begin (require "datetime.rkt") (void))
    (: datetime-months-between (-> DateTime DateTime Integer))
    (define (datetime-months-between dt1 dt2)
      (cond
       ((datetime<? dt2 dt1) (- (datetime-months-between dt2 dt1)))
       (else
        (: d1 Date)
        (define d1 (datetime->date dt1))
        (: d2 Date)
        (define d2 (datetime->date dt2))
        (match*
         ((date->ymd d1) (date->ymd d2))
         (((YMD y1 m1 d1) (YMD y2 m2 d2))
          (: diff Integer)
          (define diff (+ (* (- y2 y1) 12) m2 (- m1)))
          (: start-dom Natural)
          (define start-dom
            (let ((r (if (and (> d1 d2) (= (days-in-month y2 m2) d2)) d2 d1)))
              (abs r)))
          (: dt1a DateTime)
          (define dt1a
            (date+time->datetime (date y1 m1 start-dom) (datetime->time dt1)))
          (define ts1 (- (datetime->jd dt1a) (datetime->jd (datetime y1 m1))))
          (define ts2 (- (datetime->jd dt2) (datetime->jd (datetime y2 m2))))
          (if (< ts2 ts1) (sub1 diff) diff))))))
    (: datetime-days-between (-> DateTime DateTime Integer))
    (define (datetime-days-between dt1 dt2)
      (exact-floor (- (datetime->jd dt2) (datetime->jd dt1))))
    (: datetime-nanoseconds-between (-> DateTime DateTime Integer))
    (define (datetime-nanoseconds-between dt1 dt2)
      (- (datetime->jdns dt2) (datetime->jdns dt1)))
    (: datetime->jdns (-> DateTime Integer))
    (define (datetime->jdns dt) (exact-floor (* (datetime->jd dt) NS/DAY)))
    (provide)
    (provide datetime-nanoseconds-between
             datetime-days-between
             datetime-months-between)))
