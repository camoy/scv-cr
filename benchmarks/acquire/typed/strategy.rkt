#lang typed/racket/no-check
(define-values
  (g37
   g38
   g39
   g40
   g41
   g42
   g43
   g44
   g45
   g46
   g47
   g48
   g49
   g50
   g51
   g52
   g53
   g54
   g55
   g56
   g57
   g58
   g59
   g60
   g61
   g62
   g63
   g64
   g65
   g66
   g67
   g68
   g69
   g70
   g71
   g72
   g73
   g74
   g75
   generated-contract22
   generated-contract23)
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
    (letrec ((g37 any/c)
             (g38 '#f)
             (g39 (lambda (x) (tile? x)))
             (g40 (or/c g38 g39))
             (g41 string?)
             (g42 (or/c g41 g38))
             (g43 (lambda (x) (player? x)))
             (g44 '#t)
             (g45 (or/c g44 g38))
             (g46 '())
             (g47 (cons/c g45 g46))
             (g48 (cons/c g41 g47))
             (g49 (listof g48))
             (g50 (cons/c g49 g46))
             (g51 (cons/c g43 g50))
             (g52 (listof g51))
             (g53 (-> g37 (values g40 g42 g52)))
             (g54 (listof g43))
             (g55 (-> g37 (values g54)))
             (g56 (lambda (x) (equal? x (void))))
             (g57 (or/c g56 g54))
             (g58 (-> g37 g39 g41 (values g57)))
             (g59 (-> g37 (values g45)))
             (g60 exact-integer?)
             (g61 (or/c g60))
             (g62 (typed-racket-hash/c g41 g61))
             (g63 (or/c g62))
             (g64 (-> g37 g63 (values g63)))
             (g65 'UNTAKEN)
             (g66 'taken-no-hotel)
             (g67 (or/c g41 g65 g66))
             (g68 (typed-racket-hash/c g39 g67))
             (g69 (or/c g68))
             (g70 exact-nonnegative-integer?)
             (g71 (or/c g70))
             (g72 (lambda (x) (state? x)))
             (g73 (listof g41))
             (g74 (listof g39))
             (g75
              (object/c
               (decisions g53)
               (eliminated g55)
               (place g58)
               (place-called g59)
               (reconcile-shares g64)
               (field (board g69))
               (field (cash g71))
               (field (current g43))
               (field (current-state g72))
               (field (hotels g73))
               (field (players g54))
               (field (shares g63))
               (field (tiles g74))))
             (generated-contract22 (-> g75 (values g40 g42 g73)))
             (generated-contract23 (-> g75 (values g40 g42 g73))))
      (values
       g37
       g38
       g39
       g40
       g41
       g42
       g43
       g44
       g45
       g46
       g47
       g48
       g49
       g50
       g51
       g52
       g53
       g54
       g55
       g56
       g57
       g58
       g59
       g60
       g61
       g62
       g63
       g64
       g65
       g66
       g67
       g68
       g69
       g70
       g71
       g72
       g73
       g74
       g75
       generated-contract22
       generated-contract23))))
(require (only-in racket/contract contract-out))
(provide (contract-out (ordered-s generated-contract22))
          (contract-out (random-s generated-contract23)))
(provide)
(require require-typed-check
          "../base/types.rkt"
          "board-adapted.rkt"
          "state-adapted.rkt")
(require "basics.rkt")
(require "auxiliaries.rkt")
(: nat-SHARES-PER-TURN# Natural)
(define nat-SHARES-PER-TURN#
   (assert SHARES-PER-TURN# exact-nonnegative-integer?))
(: alphabetically-first (-> (Listof Hotel) Hotel))
(define (alphabetically-first w) (first (sort w hotel<=?)))
(:
  pick-hotel
  (->
   Board
   Tile
   Kind
   (Listof Hotel)
   (-> (Listof Hotel) Hotel)
   (-> (Listof Hotel) Hotel)
   (Option Hotel)))
(define (pick-hotel
          b
          to-place
          kind
          available-hotels
          select-founding-hotel
          select-merger)
   (cond
    ((eq? FOUNDING kind)
     (and (cons? available-hotels) (select-founding-hotel available-hotels)))
    ((eq? MERGING kind)
     (define-values (w _) (merging-which b to-place))
     (select-merger w))
    (else #f)))
(: to-buy (-> Board Cash Shares Natural (Listof Hotel)))
(define (to-buy b my-cash available-shares BUY-N)
   (let loop :
     (Listof Hotel)
     ((hotels : (Listof Hotel) ALL-HOTELS)
      (n : Natural 0)
      (to-buy : (Listof Hotel) '())
      (cash : Cash my-cash)
      (as : Shares available-shares))
     (cond
      ((or (empty? hotels) (= BUY-N n)) (reverse to-buy))
      (else
       (define h (first hotels))
       (define available-h (shares-available as h))
       (cond
        ((= 0 available-h) (loop (rest hotels) n to-buy cash as))
        (else
         (define price (price-per-share h (size-of-hotel b h)))
         (if (and price (<= price cash))
           (if (and (<= (* 2 price) cash) (> available-h 1))
             (list h h)
             (list h))
           (loop (rest hotels) n to-buy cash as))))))))
(:
  strategy/d
  (->
   (-> (Listof Hotel) Hotel)
   (-> (Listof Hotel) Hotel)
   (-> Natural Natural)
   Strategy))
(define (strategy/d choose-founding choose-merger choose-shares#)
   (lambda ((turn : (Instance Turn%)))
     (define b (get-field board turn))
     (define my-cash (get-field cash turn))
     (define available-shares (get-field shares turn))
     (define available-hotels (get-field hotels turn))
     (define tile-kind
       (for/or
        :
        (Option (List Tile Kind))
        ((t : Tile (sort (get-field tiles turn) tile<=?)))
        (let ((s (what-kind-of-spot b t)))
          (and (not (eq? s IMPOSSIBLE)) (list t s)))))
     (cond
      (tile-kind
       (define-values
        (to-place kind)
        (values (car tile-kind) (cadr tile-kind)))
       (define hotel
         (pick-hotel
          b
          to-place
          kind
          available-hotels
          choose-founding
          choose-merger))
       (define board (set-board b to-place kind hotel))
       (define shares
         (if (and (eq? FOUNDING kind)
                  hotel
                  (> (shares-available available-shares hotel) 0))
           (shares-- available-shares hotel)
           available-shares))
       (when (and (eq? MERGING kind) hotel) (send turn place to-place hotel))
       (define buy (to-buy board my-cash shares nat-SHARES-PER-TURN#))
       (values to-place hotel buy))
      (else
       (define buy
         (to-buy
          b
          my-cash
          available-shares
          (choose-shares# nat-SHARES-PER-TURN#)))
       (values #f #f buy)))))
(: id (All (A) (-> A A)))
(define (id x) x)
(: ordered-s Strategy)
(define ordered-s
   (strategy/d
    (inst first Hotel Hotel)
    alphabetically-first
    (inst id Natural)))
(: random+1 (-> Natural Natural))
(define (random+1 n) (ann (random (+ n 1)) Natural))
(: random-s Strategy)
(define random-s (strategy/d randomly-pick randomly-pick random+1))
