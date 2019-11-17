(module time typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (submod "gregor-structs.rkt" #%type-decl "..")
             (submod "core-structs.rkt" #%type-decl ".."))
    (define g38 exact-nonnegative-integer?)
    (define g39 (or/c g38))
    (define g40 (lambda (x) (Time? x)))
    (define g41 exact-integer?)
    (define g42 (or/c g41))
    (define g43 (lambda (x) (HMSN? x)))
    (define g44 string?)
    (define g45 '#t)
    (define g46 '#f)
    (define g47 (or/c g45 g46))
    (define generated-contract25 (-> g39 (values g40)))
    (define generated-contract26
      (case->
       (-> g42 (values g40))
       (-> g42 g42 (values g40))
       (-> g42 g42 g42 (values g40))
       (-> g42 g42 g42 g42 (values g40))))
    (define generated-contract27 (-> g40 (values g43)))
    (define generated-contract28 (-> g40 (values g44)))
    (define generated-contract29 (-> g40 (values g39)))
    (define generated-contract30 (-> g40 g40 (values g47)))
    (define generated-contract31 (-> g40 g40 (values g47)))
    (define generated-contract32 (-> g40 g40 (values g47)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract
               "fake-format.rkt"
               (lib "typed-racket/types/numeric-predicates.rkt"))
      (define g33 exact-rational?)
      (define g34 (or/c g33))
      (define g35 exact-nonnegative-integer?)
      (define g36 (or/c g35))
      (define g37 string?)
      (define l/1 (-> g34 g36 g37 (values g37)))
      (define l/3 (-> g34 g36 (values g37)))
      (provide l/3
               g33
               g34
               g35
               g36
               g37
               l/1
               (contract-out (~r* l/3))
               (contract-out (~r l/1))))
    (require (prefix-in -: (only-in 'require/contracts ~r ~r*))
             (except-in 'require/contracts ~r ~r*))
    (define-values (~r ~r*) (values -:~r -:~r*))
    (void)
    (require require-typed-check
             "core-adapter.rkt"
             "gregor-adapter.rkt"
             racket/match)
    (begin (require "hmsn.rkt") (void))
    (begin (void) (void))
    (: time-equal-proc (-> Time Time Boolean))
    (define (time-equal-proc x y) (= (Time-ns x) (Time-ns y)))
    (: time-hash-proc (-> Time (-> Natural Integer) Integer))
    (define (time-hash-proc x fn) (fn (Time-ns x)))
    (: time-write-proc (-> Time Output-Port Any Void))
    (define (time-write-proc t out mode)
      (fprintf out "#<time ~a>" (time->iso8601 t)))
    (: time? (-> Any Boolean))
    (define time? Time?)
    (: time->hmsn (-> Time HMSN))
    (define time->hmsn Time-hmsn)
    (: time->ns (-> Time Natural))
    (define (time->ns t) (Time-ns t))
    (: hmsn->time (-> HMSN Time))
    (define (hmsn->time hmsn) (Time hmsn (hmsn->day-ns hmsn)))
    (: day-ns->time (-> Natural Time))
    (define (day-ns->time ns) (Time (day-ns->hmsn ns) ns))
    (: make-time (->* (Integer) (Integer Integer Integer) Time))
    (define (make-time h (m 0) (s 0) (n 0)) (hmsn->time (HMSN h m s n)))
    (: time->iso8601 (-> Time String))
    (define (time->iso8601 t)
      (: f (-> Integer Natural String))
      (define (f n l) (~r n l "0"))
      (match-define (HMSN h m s n) (time->hmsn t))
      (define fsec (+ s (/ n NS/SECOND)))
      (define pad (if (>= s 10) "" "0"))
      (format "~a:~a:~a~a" (f h 2) (f m 2) pad (~r* fsec 9)))
    (: time=? (-> Time Time Boolean))
    (define (time=? t1 t2) (= (time->ns t1) (time->ns t2)))
    (: time<=? (-> Time Time Boolean))
    (define (time<=? t1 t2) (<= (time->ns t1) (time->ns t2)))
    (: time<? (-> Time Time Boolean))
    (define (time<? t1 t2) (< (time->ns t1) (time->ns t2)))
    (provide)
    (provide time->iso8601
             day-ns->time
             time->ns
             time->hmsn
             make-time
             time<=?
             time<?
             time=?)))
