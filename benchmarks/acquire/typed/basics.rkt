#lang typed/racket/no-check
(define-values
  (g36
   g37
   g38
   g39
   g40
   g41
   g42
   generated-contract5
   g43
   generated-contract6
   generated-contract7
   generated-contract8
   generated-contract9
   generated-contract10
   g44
   generated-contract11
   g45
   g46
   g47
   generated-contract12
   g48
   g49
   g50
   g51
   g52
   g53
   g54
   generated-contract13
   g55
   generated-contract14
   generated-contract15
   generated-contract16
   g56
   generated-contract17
   generated-contract18
   generated-contract19
   generated-contract20
   generated-contract21
   g57
   generated-contract22
   generated-contract23
   generated-contract24
   generated-contract25
   generated-contract26
   g58
   generated-contract27
   generated-contract28
   generated-contract29
   generated-contract30
   generated-contract31)
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
    (letrec ((g36 string?)
             (g37 exact-nonnegative-integer?)
             (g38 (or/c g37))
             (g39 exact-integer?)
             (g40 (or/c g39))
             (g41 (typed-racket-hash/c g36 g40))
             (g42 (or/c g41))
             (generated-contract5 (-> g36 g38 (values g42)))
             (g43 (listof g36))
             (generated-contract6 g43)
             (generated-contract7 g38)
             (generated-contract8 g38)
             (generated-contract9 g38)
             (generated-contract10 g40)
             (g44 (mutable-hash/c g36 g40))
             (generated-contract11 g44)
             (g45 'majority)
             (g46 'minority)
             (g47 (or/c g45 g46))
             (generated-contract12 (-> g47 g36 g38 (values g38)))
             (g48 (λ (_) #f))
             (g49 any/c)
             (g50 '#t)
             (g51 '#f)
             (g52 (or/c g50 g51))
             (g53 (-> g49 (values g52)))
             (g54 (or/c g48 g53))
             (generated-contract13 g54)
             (g55 (listof g42))
             (generated-contract14 (-> g55 (values g42)))
             (generated-contract15 (-> g42 g36 (values g42)))
             (generated-contract16 (-> g42 g43 (values g52)))
             (g56 symbol?)
             (generated-contract17 (-> g36 (values g56)))
             (generated-contract18 (-> g36 (values g36)))
             (generated-contract19 (-> g36 g36 (values g52)))
             (generated-contract20 g54)
             (generated-contract21 g42)
             (g57 (or/c g37 g51))
             (generated-contract22 (-> g36 g38 (values g57)))
             (generated-contract23 (-> g42 g36 (values g42)))
             (generated-contract24 (-> g42 (values g36)))
             (generated-contract25 (-> g42 g36 (values g40)))
             (generated-contract26 (-> g55 (values g52)))
             (g58 (-> g42 (values g52)))
             (generated-contract27 (-> g42 (values g58)))
             (generated-contract28 (-> g42 g42 (values g42)))
             (generated-contract29 g54)
             (generated-contract30 (-> g42 g42 (values g42)))
             (generated-contract31 g54))
      (values
       g36
       g37
       g38
       g39
       g40
       g41
       g42
       generated-contract5
       g43
       generated-contract6
       generated-contract7
       generated-contract8
       generated-contract9
       generated-contract10
       g44
       generated-contract11
       g45
       g46
       g47
       generated-contract12
       g48
       g49
       g50
       g51
       g52
       g53
       g54
       generated-contract13
       g55
       generated-contract14
       generated-contract15
       generated-contract16
       g56
       generated-contract17
       generated-contract18
       generated-contract19
       generated-contract20
       generated-contract21
       g57
       generated-contract22
       generated-contract23
       generated-contract24
       generated-contract25
       generated-contract26
       g58
       generated-contract27
       generated-contract28
       generated-contract29
       generated-contract30
       generated-contract31))))
(require (only-in racket/contract contract-out))
(provide (contract-out (*create-shares generated-contract5))
          (contract-out (ALL-HOTELS generated-contract6))
          (contract-out (CASH0 generated-contract7))
          (contract-out (FINAL# generated-contract8))
          (contract-out (SAFE# generated-contract9))
          (contract-out (SHARES-PER-TURN# generated-contract10))
          (contract-out (banker-shares0 generated-contract11))
          (contract-out (bonus generated-contract12))
          (contract-out (cash? generated-contract13))
          (contract-out (ext:*combine-shares generated-contract14))
          (contract-out (ext:shares-- generated-contract15))
          (contract-out (ext:shares-available? generated-contract16))
          (contract-out (hotel->color generated-contract17))
          (contract-out (hotel->label generated-contract18))
          (contract-out (hotel<=? generated-contract19))
          (contract-out (hotel? generated-contract20))
          (contract-out (player-shares0 generated-contract21))
          (contract-out (price-per-share generated-contract22))
          (contract-out (shares++ generated-contract23))
          (contract-out (shares->string generated-contract24))
          (contract-out (shares-available generated-contract25))
          (contract-out (shares-combinable? generated-contract26))
          (contract-out (shares-compatible generated-contract27))
          (contract-out (shares-minus generated-contract28))
          (contract-out (shares-order? generated-contract29))
          (contract-out (shares-plus generated-contract30))
          (contract-out (shares? generated-contract31)))
(provide (rename-out (ext:shares-- shares--))
          (rename-out (ext:shares-available? shares-available?))
          (rename-out (ext:*combine-shares *combine-shares)))
(require require-typed-check "../base/types.rkt")
(require "auxiliaries.rkt")
(: MIN-PLAYER# Natural)
(define MIN-PLAYER# 3)
(: MAX-PLAYER# Natural)
(define MAX-PLAYER# 6)
(: SAFE# Natural)
(define SAFE# 12)
(: FINAL# Natural)
(define FINAL# 40)
(: AMERICAN Hotel)
(define AMERICAN "American")
(: CONTINENTAL Hotel)
(define CONTINENTAL "Continental")
(: FESTIVAL Hotel)
(define FESTIVAL "Festival")
(: IMPERIAL Hotel)
(define IMPERIAL "Imperial")
(: SACKSON Hotel)
(define SACKSON "Sackson")
(: TOWER Hotel)
(define TOWER "Tower")
(: WORLDWIDE Hotel)
(define WORLDWIDE "Worldwide")
(: HOTELS (Listof Hotel))
(define HOTELS
   `(,AMERICAN ,CONTINENTAL ,FESTIVAL ,IMPERIAL ,SACKSON ,TOWER ,WORLDWIDE))
(: HOTEL:C (Listof Color))
(define HOTEL:C '(red blue green yellow purple brown orange))
(: hotel? (-> Any Boolean))
(define (hotel? x) (cons? (member x HOTELS)))
(: hotel<=? (-> Hotel Hotel Boolean))
(define hotel<=? string<=?)
(: ALL-HOTELS (Listof Hotel))
(define ALL-HOTELS HOTELS)
(: random-hotel (-> Hotel))
(define random-hotel (lambda () (randomly-pick HOTELS)))
(: hotel->color (-> Hotel Color))
(define (hotel->color h)
   (define r
     (for/fold
      :
      (Option Color)
      ((r : (Option Color) #f))
      ((i : Hotel (in-list HOTELS)) (c : Symbol (in-list HOTEL:C)))
      (or r (and (equal? h i) c))))
   (or r (error 'hotel->color (format "Unbound hotel ~a" h))))
(: string->hotel (-> String (Option Hotel)))
(define (string->hotel n) (and n (member n HOTELS) n))
(: hotel->label (-> Hotel String))
(define (hotel->label x) x)
(: SHARES0 Share)
(define SHARES0 25)
(: SHARES-PER-TURN# Share)
(define SHARES-PER-TURN# 2)
(: shares-order? (-> Any Boolean))
(define (shares-order? x*)
   (define h* (cast x* (Listof Hotel)))
   (and (not (null? h*))
        (let ((h1 : Hotel (car h*)))
          (for/and
           :
           Boolean
           ((h2 : Hotel (in-list (cdr h*))))
           (string=? h1 h2)))
        (<= SHARES-PER-TURN# (length h*))))
(: player-shares0 Shares)
(define player-shares0
   (make-hash
    (for/list
     :
     (Listof (Pairof Hotel Share))
     ((h (in-list ALL-HOTELS)))
     (cons h 0))))
(define banker-shares0
   (make-hash
    (for/list
     :
     (Listof (Pairof Hotel Share))
     ((h (in-list ALL-HOTELS)))
     (cons h SHARES0))))
(: shares? (-> Any Boolean))
(define (shares? x)
   (and (hash? x)
        (for/and
         (((k v) (in-hash x)))
         (and (hotel? k) (exact-nonnegative-integer? k)))))
(: shares-minus (-> Shares Shares Shares))
(define (shares-minus s t)
   (for/fold
    :
    Shares
    ((s : Shares s))
    (((hotel n) (in-hash t)))
    (hash-update s hotel (λ ((m : Share)) (max 0 (- m n))))))
(: shares-plus (-> Shares Shares Shares))
(define (shares-plus s t)
   (for/fold
    :
    Shares
    ((s : Shares s))
    (((hotel n) (in-hash t)))
    (hash-update s hotel (λ ((m : Share)) (+ m n)))))
(: ext:shares-- (-> Shares Hotel Shares))
(define (ext:shares-- s h)
   (unless (> (shares-available s h) 0)
     (error
      'shares--
      (format "Precondition failed: (> (shares-available ~a ~a) 0)" s h)))
   (shares-- s h))
(: shares-- (-> Shares Hotel Shares))
(define (shares-- s h) (hash-update s h sub1))
(: shares++ (-> Shares Hotel Shares))
(define (shares++ s h) (hash-update s h add1))
(: ext:shares-available (-> Shares Hotel Share))
(define (ext:shares-available s h)
   (unless (shares-order? h)
     (error 'shares-available (format "Precondition: shares-order ~a\n" h)))
   (shares-available s h))
(: shares-available (-> Shares Hotel Share))
(define (shares-available s h) (hash-ref s h))
(: ext:shares-available? (-> Shares (Listof Hotel) Boolean))
(define (ext:shares-available? available-s hotels)
   (unless (shares-order? available-s)
     (error 'shares-available "Precondition"))
   (shares-available? available-s hotels))
(: shares-available? (-> Shares (Listof Hotel) Boolean))
(define (shares-available? available-s hotels)
   (hash?
    (for/fold
     :
     (Option Shares)
     ((s : (Option Shares) available-s))
     ((h : Hotel (in-list hotels)))
     (and s (> (shares-available s h) 0) (shares-- s h)))))
(: shares->list (-> Shares (Listof Hotel)))
(define (shares->list s)
   (for/fold
    :
    (Listof Hotel)
    ((l : (Listof Hotel) '()))
    (((hotel count) (in-hash s)))
    (append (make-list count hotel) l)))
(: list->shares (-> (Listof Hotel) Shares))
(define (list->shares hotels)
   (for/fold
    :
    Shares
    ((s : Shares player-shares0))
    ((h : Hotel (in-list hotels)))
    (shares++ s h)))
(: shares-compatible (-> Shares (-> Shares Boolean)))
(define ((shares-compatible s) t)
   (for/and
    (((hotel count) (in-hash t)))
    (>= (shares-available s hotel) count)))
(: string->count (-> String (Option Share)))
(define (string->count x)
   (define n (string->number x))
   (and n (exact-integer? n) (<= 0 n) (<= n SHARES0) n))
(: shares->string (-> Shares String))
(define (shares->string sh)
   (string-join
    (for/list
     :
     (Listof String)
     (((h c) (in-hash sh)))
     (format "~a : ~a " h c))))
(: *create-shares (-> Hotel Natural Shares))
(define (*create-shares h n)
   (for/fold
    :
    Shares
    ((s : Shares player-shares0))
    ((i : Integer (in-range n)))
    (shares++ s h)))
(: shares-combinable? (-> (Listof Shares) Boolean))
(define (shares-combinable? ls)
   (define s (foldr shares-plus player-shares0 ls))
   (for/and (((key count) (in-hash s))) (<= count SHARES0)))
(: *combine-shares (-> (Listof Shares) Shares))
(define (*combine-shares s) (foldr shares-plus player-shares0 s))
(: ext:*combine-shares (-> (Listof Shares) Shares))
(define (ext:*combine-shares s)
   (unless (shares-combinable? s)
     (error
      '*combine-shares
      (format "Precondition error: shares-combinable ~a" s)))
   (*combine-shares s))
(: CASH0 Cash)
(define CASH0 8000)
(define-predicate cash? Cash)
(: string->cash (-> String (Option Cash)))
(define (string->cash s)
   (define n (string->number s))
   (and n (exact-integer? n) (>= n 0) n))
(: cash->string (-> Cash String))
(define (cash->string c) (number->string c))
(define PRICES
   `((Price
      (,WORLDWIDE ,SACKSON)
      (,FESTIVAL ,IMPERIAL ,AMERICAN)
      (,CONTINENTAL ,TOWER))
     (200 2 0 0)
     (300 3 2 0)
     (400 4 3 2)
     (500 5 4 3)
     (600 6 5 4)
     (700 11 6 5)
     (800 21 11 6)
     (900 31 21 11)
     (1000 41 31 21)
     (1100 +inf.0 41 31)
     (1200 +inf.0 +inf.0 41)))
(unless (set=?
          (apply set (apply append (rest (first PRICES))))
          (apply set HOTELS))
   (define hotels:set (apply set HOTELS))
   (define hotels-in-prices (apply set (apply append (rest (first PRICES)))))
   (error 'PRICES "~a" (set-symmetric-difference hotels:set hotels-in-prices)))
(: bonus (-> M*ority Hotel Natural Cash))
(define (bonus mode hotel tile#)
   (*
    (or (price-per-share hotel tile#) (error 'bonus))
    (if (eq? mode 'majority) 10 5)))
(: price-per-share (-> Hotel Natural (Option Cash)))
(define (price-per-share hotel tile#)
   (define table (rest PRICES))
   (define limit-selector
     (or (for/or
          :
          (Option (-> (Listof Real) Real))
          ((hotels : (Listof Hotel) (in-list (rest (first PRICES))))
           (selector
            :
            (-> (Listof Real) Real)
            (in-list (list second third fourth))))
          (and (member hotel hotels) selector))
         (error 'price-per-share)))
   (define price*
     (for/fold
      :
      (Listof Real)
      ((acc : (Listof Real) '()))
      ((price* : (Listof Real) (in-list table)))
      (cons (first price*) acc)))
   (define limit*
     (for/fold
      :
      (Listof Real)
      ((acc : (Listof Real) '()))
      ((price* : (Listof Real) (in-list table)))
      (cons (limit-selector price*) acc)))
   (for/fold
    :
    (Option Cash)
    ((acc : (Option Cash) #f))
    ((price : Real (in-list price*)) (limit : Real (in-list limit*)))
    (or acc (and (>= tile# limit) (assert price exact-nonnegative-integer?)))))
