#lang typed/racket/base/no-check
(define-values
  (g16
   g17
   g18
   g19
   g20
   g21
   g22
   generated-contract3
   generated-contract4
   generated-contract5
   generated-contract6
   generated-contract7
   g23
   g24
   g25
   g26
   generated-contract8
   generated-contract9
   g27
   generated-contract10
   generated-contract11
   generated-contract12
   generated-contract13
   generated-contract14
   g28
   g29
   g30
   g31
   g32
   generated-contract15)
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
    (letrec ((g16 string?)
             (g17 char?)
             (g18 (listof g17))
             (g19 (vectorof g17))
             (g20 (or/c g16 g18 g19))
             (g21 fixnum?)
             (g22 (or/c g21))
             (generated-contract3 (-> g20 g20 (values g22)))
             (generated-contract4 (-> g18 g18 (values g22)))
             (generated-contract5 (-> g18 g18 (values g22)))
             (generated-contract6 (-> g18 g18 (values g22)))
             (generated-contract7 (-> g18 g18 (values g22)))
             (g23 '#t)
             (g24 '#f)
             (g25 (or/c g23 g24))
             (g26 (-> g17 g17 (values g25)))
             (generated-contract8 (-> g18 g18 g26 (values g22)))
             (generated-contract9 (-> g16 g16 (values g22)))
             (g27 (or/c g19))
             (generated-contract10 (-> g27 g27 (values g22)))
             (generated-contract11 (-> g27 g27 (values g22)))
             (generated-contract12 (-> g27 g27 (values g22)))
             (generated-contract13 (-> g27 g27 (values g22)))
             (generated-contract14 (-> g27 g27 g26 (values g22)))
             (g28 exact-integer?)
             (g29 (or/c g28))
             (g30 (vectorof g22))
             (g31 (or/c g30))
             (g32 (-> g29 (values g31)))
             (generated-contract15 (-> g27 g27 g26 g32 (values g22))))
      (values
       g16
       g17
       g18
       g19
       g20
       g21
       g22
       generated-contract3
       generated-contract4
       generated-contract5
       generated-contract6
       generated-contract7
       g23
       g24
       g25
       g26
       generated-contract8
       generated-contract9
       g27
       generated-contract10
       generated-contract11
       generated-contract12
       generated-contract13
       generated-contract14
       g28
       g29
       g30
       g31
       g32
       generated-contract15))))
(require (only-in racket/contract contract-out))
(provide (contract-out (levenshtein generated-contract3))
          (contract-out (list-levenshtein generated-contract4))
          (contract-out (list-levenshtein/eq generated-contract5))
          (contract-out (list-levenshtein/equal generated-contract6))
          (contract-out (list-levenshtein/eqv generated-contract7))
          (contract-out (list-levenshtein/predicate generated-contract8))
          (contract-out (string-levenshtein generated-contract9))
          (contract-out (vector-levenshtein generated-contract10))
          (contract-out (vector-levenshtein/eq generated-contract11))
          (contract-out (vector-levenshtein/equal generated-contract12))
          (contract-out (vector-levenshtein/eqv generated-contract13))
          (contract-out (vector-levenshtein/predicate generated-contract14))
          (contract-out
           (vector-levenshtein/predicate/get-scratch generated-contract15)))
(: %identity (All (A) (-> A A)))
(define (%identity x) x)
(: %string-empty? (-> String Boolean))
(define (%string-empty? v) (zero? (string-length v)))
(: %vector-empty? (-> (Vectorof Char) Boolean))
(define (%vector-empty? v) (zero? (vector-length v)))
(: %string->vector (-> String (Vectorof Char)))
(define (%string->vector s) (list->vector (string->list s)))
(:
  vector-levenshtein/predicate/get-scratch
  (->
   (Vectorof Char)
   (Vectorof Char)
   (-> Char Char Boolean)
   (-> Integer (Vectorof Index))
   Index))
(define (vector-levenshtein/predicate/get-scratch a b pred get-scratch)
   (let:
    ((a-len : Index (vector-length a)) (b-len : Index (vector-length b)))
    (cond
     ((zero? a-len) b-len)
     ((zero? b-len) a-len)
     (else
      (let:
       ((w : (Vectorof Index) (get-scratch (+ 1 b-len))) (next : Index 0))
       (let fill ((k b-len))
         (unless (index? k) (error "vl/p/g invariant error"))
         (vector-set! w k k)
         (or (zero? k) (fill (- k 1))))
       (let loop-i ((i 0))
         (if (= i a-len)
           next
           (let ((a-i (vector-ref a i)))
             (let loop-j ((j 0) (cur (+ 1 i)))
               (if (= j b-len)
                 (begin (vector-set! w b-len next) (loop-i (+ 1 i)))
                 (let ((next*
                        (min
                         (+ 1 (vector-ref w (+ 1 j)))
                         (+ 1 cur)
                         (if (pred a-i (vector-ref b j))
                           (vector-ref w j)
                           (+ 1 (vector-ref w j))))))
                   (unless (index? next*) (error "invariant"))
                   (set! next next*)
                   (unless (index? cur) (error "invariant error"))
                   (vector-set! w j cur)
                   (loop-j (+ 1 j) next))))))))))))
(:
  vector-levenshtein/predicate
  (-> (Vectorof Char) (Vectorof Char) (-> Char Char Boolean) Index))
(define (vector-levenshtein/predicate a b pred)
   (vector-levenshtein/predicate/get-scratch a b pred make-vector))
(: vector-levenshtein/eq (-> (Vectorof Char) (Vectorof Char) Index))
(define (vector-levenshtein/eq a b) (vector-levenshtein/predicate a b eq?))
(: vector-levenshtein/eqv (-> (Vectorof Char) (Vectorof Char) Index))
(define (vector-levenshtein/eqv a b) (vector-levenshtein/predicate a b eqv?))
(: vector-levenshtein/equal (-> (Vectorof Char) (Vectorof Char) Index))
(define (vector-levenshtein/equal a b)
   (vector-levenshtein/predicate a b equal?))
(: vector-levenshtein (-> (Vectorof Char) (Vectorof Char) Index))
(define (vector-levenshtein a b) (vector-levenshtein/equal a b))
(:
  list-levenshtein/predicate
  (-> (Listof Char) (Listof Char) (-> Char Char Boolean) Index))
(define (list-levenshtein/predicate a b pred)
   (cond
    ((null? a) (length b))
    ((null? b) (length a))
    (else
     (vector-levenshtein/predicate (list->vector a) (list->vector b) pred))))
(: list-levenshtein/eq (-> (Listof Char) (Listof Char) Index))
(define (list-levenshtein/eq a b) (list-levenshtein/predicate a b eq?))
(: list-levenshtein/eqv (-> (Listof Char) (Listof Char) Index))
(define (list-levenshtein/eqv a b) (list-levenshtein/predicate a b eqv?))
(: list-levenshtein/equal (-> (Listof Char) (Listof Char) Index))
(define (list-levenshtein/equal a b) (list-levenshtein/predicate a b equal?))
(: list-levenshtein (-> (Listof Char) (Listof Char) Index))
(define (list-levenshtein a b) (list-levenshtein/equal a b))
(: string-levenshtein (-> String String Index))
(define (string-levenshtein a b)
   (cond
    ((zero? (string-length a)) (string-length b))
    ((zero? (string-length b)) (string-length a))
    (else (vector-levenshtein/eqv (%string->vector a) (%string->vector b)))))
(:
  %string-levenshtein/predicate
  (-> String String (-> Char Char Boolean) Index))
(define (%string-levenshtein/predicate a b pred)
   (cond
    ((zero? (string-length a)) (string-length b))
    ((zero? (string-length b)) (string-length a))
    (else
     (vector-levenshtein/predicate
      (%string->vector a)
      (%string->vector b)
      pred))))
(define-type LType (U (Vectorof Char) String (Listof Char)))
(: levenshtein (-> LType LType Index))
(define (levenshtein a b)
   (cond
    ((and (string? a) (string? b)) (string-levenshtein a b))
    ((and (vector? a) (vector? b)) (vector-levenshtein a b))
    ((and (list? a) (list? b)) (list-levenshtein a b))
    (else (error "levenshtein"))))
(provide)
