#lang typed/racket/base/no-check
(define-values
  (g25
   g26
   g27
   g28
   g29
   g30
   g31
   generated-contract3
   generated-contract4
   generated-contract5
   g32
   generated-contract6
   generated-contract7
   g33
   g34
   g35
   g36
   generated-contract8
   g37
   g38
   g39
   generated-contract9
   generated-contract10
   generated-contract11
   g40
   g41
   generated-contract12
   generated-contract13
   g42
   g43
   generated-contract14
   generated-contract15
   generated-contract16
   generated-contract17
   generated-contract18
   generated-contract19
   generated-contract20
   generated-contract21
   g44
   generated-contract22
   generated-contract23
   g45
   g46
   generated-contract24)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g25 string?)
             (g26 symbol?)
             (g27 char?)
             (g28 (or/c g26 g27))
             (g29 (vectorof g28))
             (g30 (or/c g25 g29))
             (g31 (lambda (x) (label? x)))
             (generated-contract3 (-> g30 (values g31)))
             (generated-contract4 (-> g31 (values g25)))
             (generated-contract5 (-> g31 (values g25)))
             (g32 (or/c g29))
             (generated-contract6 (-> g31 (values g32)))
             (generated-contract7 (-> g31 (values g31)))
             (g33 any/c)
             (g34 '#t)
             (g35 '#f)
             (g36 (or/c g34 g35))
             (generated-contract8 (-> g33 g33 (values g36)))
             (g37 (λ (_) #f))
             (g38 (-> g33 (values g36)))
             (g39 (or/c g37 g38))
             (generated-contract9 g39)
             (generated-contract10 (-> g31 (values g36)))
             (generated-contract11 (-> g31 g31 (values g36)))
             (g40 fixnum?)
             (g41 (or/c g40))
             (generated-contract12 (-> g31 (values g41)))
             (generated-contract13 (-> g31 g31 (values g36)))
             (g42 exact-integer?)
             (g43 (or/c g42))
             (generated-contract14 (-> g31 g43 (values g28)))
             (generated-contract15 (-> g31 g43 (values g36)))
             (generated-contract16 (-> g31 g31 (values g36)))
             (generated-contract17 (-> g31 g31 (values g36)))
             (generated-contract18 (-> g31 (values g43)))
             (generated-contract19 (-> g25 (values g31)))
             (generated-contract20 (-> g25 (values g31)))
             (generated-contract21 (->* (g31 g41) (g41) (values g31)))
             (g44 (lambda (x) (equal? x (void))))
             (generated-contract22 (->* (g31 g41) (g41) (values g44)))
             (generated-contract23 (-> g32 (values g31)))
             (g45 (vectorof g27))
             (g46 (or/c g45))
             (generated-contract24 (-> g46 (values g31))))
      (values
       g25
       g26
       g27
       g28
       g29
       g30
       g31
       generated-contract3
       generated-contract4
       generated-contract5
       g32
       generated-contract6
       generated-contract7
       g33
       g34
       g35
       g36
       generated-contract8
       g37
       g38
       g39
       generated-contract9
       generated-contract10
       generated-contract11
       g40
       g41
       generated-contract12
       generated-contract13
       g42
       g43
       generated-contract14
       generated-contract15
       generated-contract16
       generated-contract17
       generated-contract18
       generated-contract19
       generated-contract20
       generated-contract21
       g44
       generated-contract22
       generated-contract23
       g45
       g46
       generated-contract24))))
(require (only-in racket/contract contract-out))
(provide (contract-out (ext:make-label generated-contract3))
          (contract-out (label->string generated-contract4))
          (contract-out (label->string/removing-sentinel generated-contract5))
          (contract-out (label->vector generated-contract6))
          (contract-out (label-copy generated-contract7))
          (contract-out (label-element-equal? generated-contract8))
          (contract-out (label-element? generated-contract9))
          (contract-out (label-empty? generated-contract10))
          (contract-out (label-equal? generated-contract11))
          (contract-out (label-length generated-contract12))
          (contract-out (label-prefix? generated-contract13))
          (contract-out (label-ref generated-contract14))
          (contract-out (label-ref-at-end? generated-contract15))
          (contract-out (label-same-source? generated-contract16))
          (contract-out (label-source-eq? generated-contract17))
          (contract-out (label-source-id generated-contract18))
          (contract-out (string->label generated-contract19))
          (contract-out (string->label/with-sentinel generated-contract20))
          (contract-out (sublabel generated-contract21))
          (contract-out (sublabel! generated-contract22))
          (contract-out (vector->label generated-contract23))
          (contract-out (vector->label/with-sentinel generated-contract24)))
(require "typed-data.rkt")
(: label-element? (-> Any Boolean))
(define (label-element? obj) #t)
(: label-element-equal? (-> Any Any Boolean))
(define label-element-equal? equal?)
(provide (rename-out (ext:make-label make-label)))
(: ext:make-label (-> (U String (Vectorof (U Char Symbol))) Label))
(define (ext:make-label label-element)
   (cond
    ((string? label-element) (string->label label-element))
    ((vector? label-element) (vector->label label-element))
    (else
     (error
      'make-label
      "Don't know how to make label from ~S"
      label-element))))
(: make-sentinel (-> Symbol))
(define (make-sentinel) (gensym 'sentinel))
(: sentinel? (-> Any Boolean))
(define (sentinel? datum) (symbol? datum))
(: vector->label (-> (Vectorof (U Char Symbol)) label))
(define (vector->label vector)
   (make-label (vector->immutable-vector vector) 0 (vector-length vector)))
(: vector->label/with-sentinel (-> (Vectorof Char) label))
(define (vector->label/with-sentinel vector)
   (: N Index)
   (define N (vector-length vector))
   (: V (Vectorof (U Char Symbol)))
   (define V (make-vector (add1 N) (make-sentinel)))
   (let loop ((i 0))
     (if (< i N)
       (begin (vector-set! V i (vector-ref vector i)) (loop (add1 i)))
       (vector->label V))))
(: string->label (-> String label))
(define (string->label str) (vector->label (list->vector (string->list str))))
(: string->label/with-sentinel (-> String label))
(define (string->label/with-sentinel str)
   (vector->label/with-sentinel (list->vector (string->list str))))
(: label-length (-> label Index))
(define (label-length label)
   (define len (- (label-j label) (label-i label)))
   (unless (index? len) (error "label-length"))
   len)
(: label-ref (-> label Integer (U Symbol Char)))
(define (label-ref label k)
   (unless (index? k) (error "label ref INDEX"))
   (vector-ref (label-datum label) (+ k (label-i label))))
(: sublabel (case-> (-> label Index label) (-> label Index Index label)))
(define sublabel
   (case-lambda
    ((label i) (sublabel label i (label-length label)))
    ((label i j)
     (unless (<= i j) (error 'sublabel "illegal sublabel [~a, ~a]" i j))
     (make-label
      (label-datum label)
      (+ i (label-i label))
      (+ j (label-i label))))))
(: sublabel! (case-> (-> label Index Void) (-> label Index Index Void)))
(define sublabel!
   (case-lambda
    ((label i) (sublabel! label i (label-length label)))
    ((label i j)
     (begin
       (set-label-j! label (+ j (label-i label)))
       (set-label-i! label (+ i (label-i label)))
       (void)))))
(: label-prefix? (-> label label Boolean))
(define (label-prefix? prefix other-label)
   (let ((m (label-length prefix)) (n (label-length other-label)))
     (if (> m n)
       #f
       (let loop ((k 0))
         (if (= k m)
           #t
           (and (index? k)
                (equal? (label-ref prefix k) (label-ref other-label k))
                (loop (add1 k))))))))
(: label-equal? (-> label label Boolean))
(define (label-equal? l1 l2)
   (and (= (label-length l1) (label-length l2)) (label-prefix? l1 l2)))
(: label-empty? (-> label Boolean))
(define (label-empty? label) (>= (label-i label) (label-j label)))
(: label->string (-> label String))
(define (label->string label)
   (: V (Vectorof (U Char Symbol)))
   (define V (label->vector label))
   (: L (Listof Char))
   (define L
     (for/list
      :
      (Listof Char)
      ((c : (U Char Symbol) (in-vector V)))
      (unless (char? c) (error "label->string invariant broken"))
      c))
   (list->string L))
(: label->string/removing-sentinel (-> label String))
(define (label->string/removing-sentinel label)
   (let* ((ln (label-length label))
          (N
           (if (and (> ln 0) (sentinel? (label-ref label (sub1 ln))))
             (sub1 ln)
             ln)))
     (build-string
      N
      (lambda ((i : Integer))
        (unless (index? i) (error "label->string 1"))
        (let ((val (label-ref label i)))
          (unless (char? val) (error "label->string 2"))
          val)))))
(: label->vector (-> label (Vectorof (U Char Symbol))))
(define (label->vector label)
   (: N Integer)
   (define N (label-length label))
   (: buffer (Vectorof (U Char Symbol)))
   (define buffer (make-vector N 'X))
   (let loop ((i 0))
     (if (and (< i N) (index? i))
       (begin (vector-set! buffer i (label-ref label i)) (loop (add1 i)))
       (vector->immutable-vector buffer))))
(: label-copy (-> label label))
(define (label-copy label)
   (make-label (label-datum label) (label-i label) (label-j label)))
(: label-ref-at-end? (-> label Integer Boolean))
(define (label-ref-at-end? label offset) (= offset (label-length label)))
(: label-source-id (-> label Integer))
(define (label-source-id label) (eq-hash-code (label-datum label)))
(: label-same-source? (-> label label Boolean))
(define (label-same-source? label-1 label-2)
   (eq? (label-datum label-1) (label-datum label-2)))
(define label-source-eq? label-same-source?)
