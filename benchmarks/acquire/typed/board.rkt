#lang typed/racket/no-check
(define-values
  (g81
   g82
   generated-contract28
   g83
   generated-contract29
   g84
   generated-contract30
   g85
   generated-contract31
   g86
   generated-contract32
   g87
   generated-contract33
   g88
   g89
   generated-contract34
   g90
   g91
   g92
   g93
   g94
   g95
   generated-contract35
   generated-contract36
   g96
   generated-contract37
   g97
   g98
   g99
   g100
   g101
   g102
   generated-contract38
   generated-contract39
   generated-contract40
   generated-contract41
   generated-contract42
   g103
   generated-contract43
   generated-contract44
   g104
   generated-contract45
   generated-contract46
   g105
   generated-contract47
   g106
   generated-contract48
   generated-contract49
   generated-contract50
   g107
   generated-contract51
   g108
   generated-contract56
   g109
   g110
   g111
   g112
   generated-contract52
   generated-contract53
   generated-contract54
   generated-contract57
   generated-contract58)
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
    (letrec ((g81 (lambda (x) (tile? x)))
             (g82 (listof g81))
             (generated-contract28 g82)
             (g83 'FOUNDING)
             (generated-contract29 g83)
             (g84 'GROWING)
             (generated-contract30 g84)
             (g85 'IMPOSSIBLE)
             (generated-contract31 g85)
             (g86 'MERGING)
             (generated-contract32 g86)
             (g87 'SINGLETON)
             (generated-contract33 g87)
             (g88 exact-nonnegative-integer?)
             (g89 (or/c g88))
             (generated-contract34 g89)
             (g90 string?)
             (g91 'UNTAKEN)
             (g92 'taken-no-hotel)
             (g93 (or/c g90 g91 g92))
             (g94 (typed-racket-hash/c g81 g93))
             (g95 (or/c g94))
             (generated-contract35 (-> (values g95)))
             (generated-contract36 (-> g95 (values g82)))
             (g96 (listof g90))
             (generated-contract37 (-> g96 (values g96)))
             (g97 (cons/c g90 g82))
             (g98 (listof g97))
             (g99 '#t)
             (g100 '#f)
             (g101 (or/c g99 g100))
             (g102 (-> g98 (values g101)))
             (generated-contract38 (-> g82 (values g102)))
             (generated-contract39 (-> g82 g98 (values g95)))
             (generated-contract40 (-> g95 g96 g89 (values g101)))
             (generated-contract41 (-> g95 g81 g90 (values g95)))
             (generated-contract42 (-> g95 g81 (values g95)))
             (g103 (or/c g90 g100))
             (generated-contract43 (-> g95 g81 (values g103)))
             (generated-contract44 (-> g95 g81 g90 (values g95)))
             (g104 (cons/c g90 g96))
             (generated-contract45 (-> g95 g81 (values g104 g96)))
             (generated-contract46 (-> g95 g81 (values g95)))
             (g105 (or/c g83 g84 g86 g87))
             (generated-contract47 (-> g95 g81 g105 g103 (values g95)))
             (g106 (or/c g83 g84 g86 g87 g85))
             (generated-contract48 (-> g95 g81 (values g106)))
             (generated-contract49 (-> g95 g81 (values g101)))
             (generated-contract50 (-> g95 g90 (values g89)))
             (g107 (λ (_) #f))
             (generated-contract51 g107)
             (g108 symbol?)
             (generated-contract56 (-> g89 g108 (values g81)))
             (g109 (λ (_) #f))
             (g110 any/c)
             (g111 (-> g110 (values g101)))
             (g112 (or/c g109 g111))
             (generated-contract52 g112)
             (generated-contract53 (-> g81 (values g108)))
             (generated-contract54 (-> g81 (values g89)))
             (generated-contract57 (-> g81 (values g90)))
             (generated-contract58 (-> g81 g81 (values g101))))
      (values
       g81
       g82
       generated-contract28
       g83
       generated-contract29
       g84
       generated-contract30
       g85
       generated-contract31
       g86
       generated-contract32
       g87
       generated-contract33
       g88
       g89
       generated-contract34
       g90
       g91
       g92
       g93
       g94
       g95
       generated-contract35
       generated-contract36
       g96
       generated-contract37
       g97
       g98
       g99
       g100
       g101
       g102
       generated-contract38
       generated-contract39
       generated-contract40
       generated-contract41
       generated-contract42
       g103
       generated-contract43
       generated-contract44
       g104
       generated-contract45
       generated-contract46
       g105
       generated-contract47
       g106
       generated-contract48
       generated-contract49
       generated-contract50
       g107
       generated-contract51
       g108
       generated-contract56
       g109
       g110
       g111
       g112
       generated-contract52
       generated-contract53
       generated-contract54
       generated-contract57
       generated-contract58))))
(require (only-in racket/contract contract-out))
(provide (contract-out (ALL-TILES generated-contract28))
          (contract-out (FOUNDING generated-contract29))
          (contract-out (GROWING generated-contract30))
          (contract-out (IMPOSSIBLE generated-contract31))
          (contract-out (MERGING generated-contract32))
          (contract-out (SINGLETON generated-contract33))
          (contract-out (STARTER-TILES# generated-contract34))
          (contract-out (board generated-contract35))
          (contract-out (board-tiles generated-contract36))
          (contract-out (deduplicate/hotel generated-contract37))
          (contract-out (distinct-and-properly-formed generated-contract38))
          (contract-out (ext:*create-board-with-hotels generated-contract39))
          (contract-out (ext:affordable? generated-contract40))
          (contract-out (ext:found-hotel generated-contract41))
          (contract-out (ext:grow-hotel generated-contract42))
          (contract-out (ext:growing-which generated-contract43))
          (contract-out (ext:merge-hotels generated-contract44))
          (contract-out (ext:merging-which generated-contract45))
          (contract-out (ext:place-tile generated-contract46))
          (contract-out (ext:set-board generated-contract47))
          (contract-out (ext:what-kind-of-spot generated-contract48))
          (contract-out (free-spot? generated-contract49))
          (contract-out (size-of-hotel generated-contract50))
          (contract-out (struct tile ((column g89) (row g108))))
          (contract-out (tile->string generated-contract57))
          (contract-out (tile<=? generated-contract58)))
(provide (rename-out (board make-board))
          (rename-out (ext:what-kind-of-spot what-kind-of-spot))
          (rename-out (ext:growing-which growing-which))
          (rename-out (ext:merging-which merging-which))
          (rename-out (ext:merge-hotels merge-hotels))
          (rename-out (ext:found-hotel found-hotel))
          (rename-out (ext:grow-hotel grow-hotel))
          (rename-out (ext:place-tile place-tile))
          (rename-out (ext:set-board set-board))
          (rename-out (ext:affordable? affordable?))
          (rename-out
           (ext:*create-board-with-hotels *create-board-with-hotels)))
(require require-typed-check "../base/types.rkt")
(require "basics.rkt")
(require "auxiliaries.rkt")
(define-type Board (HashTable Tile Content))
(define-type HT (Listof Tile))
(: COLUMNS (Listof Natural))
(define COLUMNS '(1 2 3 4 5 6 7 8 9 10 11 12 13))
(: column? (-> Any Boolean))
(define (column? c) (if (member c COLUMNS) #t #f))
(: random-column (-> Natural))
(define (random-column) (randomly-pick COLUMNS))
(: column-> (-> Natural (Option Natural)))
(define (column-> c)
   (let loop :
     (Option Natural)
     ((col* : (Listof Natural) COLUMNS))
     (cond
      ((or (null? col*) (null? (cdr col*))) #f)
      ((eq? c (car col*)) (cadr col*))
      (else (loop (cdr col*))))))
(: column-< (-> Natural (Option Natural)))
(define (column-< c)
   (let loop :
     (Option Natural)
     ((prev : (Option Natural) #f) (col* : (Listof Natural) COLUMNS))
     (cond
      ((null? col*) #f)
      ((eq? c (car col*)) prev)
      (else (loop (car col*) (cdr col*))))))
(: column<= (-> Natural Natural Boolean))
(define column<= <=)
(: string->column (-> Any (Option Natural)))
(define (string->column s)
   (and (string? s)
        (let ((n (string->number s)))
          (and n (member n COLUMNS) (exact-nonnegative-integer? n) n))))
(: column->string (-> Natural String))
(define column->string number->string)
(: ROWS (Listof Row))
(define ROWS '(A B C D E F G H I))
(: row? (-> Any Boolean))
(define (row? r) (if (member r ROWS) #t #f))
(: random-row (-> Row))
(define (random-row) (randomly-pick ROWS))
(: row-v (-> Row (Option Row)))
(define (row-v r)
   (let loop :
     (Option Row)
     ((row* : (Listof Row) ROWS))
     (cond
      ((or (null? row*) (null? (cdr row*))) #f)
      ((eq? (car row*) r) (cadr row*))
      (else (loop (cdr row*))))))
(: row-^ (-> Row (Option Row)))
(define (row-^ r)
   (let loop :
     (Option Row)
     ((prev : (Option Row) #f) (row* : (Listof Row) ROWS))
     (cond
      ((null? row*) #f)
      ((eq? (car row*) r) prev)
      (else (loop (car row*) (cdr row*))))))
(: list-index (-> Symbol (Listof Symbol) Integer))
(define (list-index x y*)
   (or (for/or
        :
        (Option Integer)
        ((y : Symbol (in-list y*)) (i : Natural (in-naturals)))
        (and (eq? x y) i))
       90))
(: row<= (-> Row Row Boolean))
(define (row<= q r) (<= (list-index q ROWS) (list-index r ROWS)))
(: row<< (-> Row Row Boolean))
(define (row<< q r) (< (list-index q ROWS) (list-index r ROWS)))
(: string->row (-> String (Option Row)))
(define (string->row s)
   (and (string? s) (let ((n (string->symbol s))) (and n (member n ROWS) n))))
(: row->string (-> Row String))
(define row->string symbol->string)
(: CELL-SIZE Natural)
(define CELL-SIZE 66)
(define-type Tile tile)
(struct tile ((column : Column) (row : Row)) #:transparent)
(: TILE-SIZE Natural)
(define TILE-SIZE (assert (- CELL-SIZE 3) exact-nonnegative-integer?))
(: TILE-COLOR Symbol)
(define TILE-COLOR 'gray)
(: STARTER-TILES# Natural)
(define STARTER-TILES# 6)
(define-syntax-rule (ctile letter number) (tile/c number 'letter))
(: tile/c (-> Column Row Tile))
(define (tile/c c r)
   (if (and (column? c) (row? r))
     (tile c r)
     (error 'tile "not (column,row): ~e, ~e" c r)))
(: ALL-TILES (Listof Tile))
(define ALL-TILES
   (for*/list
    :
    (Listof Tile)
    ((r : Row ROWS) (c : Natural COLUMNS))
    (tile c r)))
(: tile<=? (-> Tile Tile Boolean))
(define (tile<=? t1 t2)
   (or (row<< (tile-row t1) (tile-row t2))
       (and (row<= (tile-row t1) (tile-row t2))
            (column<= (tile-column t1) (tile-column t2)))))
(: tile<? (-> Tile Tile Boolean))
(define (tile<? s t) (and (tile<=? s t) (not (equal? s t))))
(: tile>? (-> Tile Tile Boolean))
(define (tile>? s t) (and (tile<=? t s) (not (equal? s t))))
(: tile->string (-> Tile String))
(define (tile->string t) (format "(~a,~a)" (tile-column t) (tile-row t)))
(define FOUNDING 'FOUNDING)
(define GROWING 'GROWING)
(define MERGING 'MERGING)
(define SINGLETON 'SINGLETON)
(define IMPOSSIBLE 'IMPOSSIBLE)
(define UNTAKEN 'UNTAKEN)
(define TAKEN-NO-HOTEL 'taken-no-hotel)
(: board? (-> Any Boolean))
(define (board? x) (and (hash? x)))
(: board (-> Board))
(define (board) #hash())
(: board-tiles (-> Board (Listof Tile)))
(define (board-tiles b) (hash-keys b))
(: board* (-> Tile * Board))
(define (board* . t*)
   (for/fold
    :
    Board
    ((b : Board (board)))
    ((t : Tile (in-list t*)))
    (place-tile b t)))
(:
  ext:*create-board-with-hotels
  (-> (Listof Tile) (Listof (Pairof Hotel (Listof Tile))) Board))
(define (ext:*create-board-with-hotels lt lh)
   (unless (distinct lt) (error 'create-board-with-hotels "precondition"))
   (unless ((distinct-and-properly-formed lt) lh)
     (error 'create-board-with-hotels "precondition"))
   (*create-board-with-hotels lt lh))
(:
  *create-board-with-hotels
  (-> (Listof Tile) (Listof (Pairof Hotel (Listof Tile))) Board))
(define (*create-board-with-hotels lt lh)
   (for/fold
    :
    Board
    ((b : Board (apply board* lt)))
    ((h : (Pairof Hotel (Listof Tile)) lh))
    (define name (first h))
    (define til* (rest h))
    (for/fold
     :
     Board
     ((b : Board b))
     ((t : Tile (in-list (rest h))))
     (hash-set b t name))))
(: board-ref (-> Board Column Row Content))
(define (board-ref b c r)
   ((inst hash-ref Tile Content Content)
    b
    (tile c r)
    (lambda () (ann UNTAKEN Content))))
(: board-set (->* (Board Column Row) (Content) Board))
(define (board-set b c r (h (ann TAKEN-NO-HOTEL Content)))
   (hash-set b (tile c r) h))
(:
  neighbors
  (->
   Board
   Column
   Row
   (-> Content Content Content Content (Listof Content))
   (Listof Content)))
(define (neighbors b c r f)
   (f (north b c r) (east b c r) (south b c r) (west b c r)))
(:
  cardinal-direction
  (->
   (-> Row (U Boolean Row))
   (-> Column (U Boolean Column))
   (-> Board Column Row Content)))
(define (cardinal-direction n-s e-w)
   (lambda ((b : Board) (c : Column) (r : Row))
     (define north-south (n-s r))
     (define east-west (e-w c))
     (cond
      ((boolean? north-south) (ann UNTAKEN Content))
      ((boolean? east-west) (ann UNTAKEN Content))
      (else (board-ref b east-west north-south)))))
(: north (-> Board Column Row Content))
(define north (cardinal-direction row-^ (lambda ((x : Column)) x)))
(: south (-> Board Column Row Content))
(define south (cardinal-direction row-v (lambda ((x : Column)) x)))
(: east (-> Board Column Row Content))
(define east (cardinal-direction (lambda ((x : Row)) x) column->))
(: west (-> Board Column Row Content))
(define west (cardinal-direction (lambda ((x : Row)) x) column-<))
(: tiles-with-specific-label (-> Board Hotel (Listof Tile)))
(define (tiles-with-specific-label b h)
   (define t*
     (for/list
      :
      (Listof Tile)
      (((s label) (in-hash b)) #:when (equal? h label))
      s))
   (sort t* tile<=?))
(: free-spot? (-> Board Tile Boolean))
(define (free-spot? board tile)
   (eq? (board-ref board (tile-column tile) (tile-row tile)) UNTAKEN))
(: ext:what-kind-of-spot (-> Board Tile SpotType))
(define (ext:what-kind-of-spot board tile)
   (unless (free-spot? board tile)
     (error
      'what-kind-of-spot
      (format "Precondition: (free-spot ~a ~a)" board tile)))
   (what-kind-of-spot board tile))
(: what-kind-of-spot (-> Board Tile SpotType))
(define (what-kind-of-spot board tile)
   (define column (tile-column tile))
   (define row (tile-row tile))
   (define surroundings (neighbors board column row list))
   (define hotels
     (deduplicate/hotel
      (for/list
       :
       (Listof Hotel)
       ((s : Content (in-list surroundings)) #:when (hotel? s))
       (assert s string?))))
   (define hotels# (length hotels))
   (define neighbor-taken-no-hotel?
     (for/or
      :
      (Option Content)
      ((s (in-list surroundings)))
      (and (eq? TAKEN-NO-HOTEL s) s)))
   (cond
    ((= hotels# 0)
     (ann (if neighbor-taken-no-hotel? FOUNDING SINGLETON) SpotType))
    ((= hotels# 1)
     (ann (if neighbor-taken-no-hotel? IMPOSSIBLE GROWING) SpotType))
    ((>= hotels# 2)
     (define any-hotel-safe?
       (for/or
        :
        Boolean
        ((h : Hotel (in-list hotels)))
        (>= (size-of-hotel board h) SAFE#)))
     (ann
      (if (or neighbor-taken-no-hotel? any-hotel-safe?) IMPOSSIBLE MERGING)
      SpotType))
    (else (error 'nope))))
(: ext:growing-which (-> Board Tile (Option Hotel)))
(define (ext:growing-which board tile)
   (unless (eq? (what-kind-of-spot board tile) GROWING)
     (error
      'growing-which
      (format
       "Precondition: expected growing, got ~a"
       (what-kind-of-spot board tile))))
   (growing-which board tile))
(: growing-which (-> Board Tile (Option Hotel)))
(define (growing-which board tile)
   (define n* (neighbors board (tile-column tile) (tile-row tile) list))
   (for/or
    :
    (Option Hotel)
    ((c : (Option Content) (in-list n*)))
    (and (hotel? c) (assert c string?))))
(:
  ext:merging-which
  (-> Board Tile (Values (Pairof Hotel (Listof Hotel)) (Listof Hotel))))
(define (ext:merging-which board tile)
   (unless (eq? (what-kind-of-spot board tile) MERGING)
     (error
      'merging-which
      (format
       "Precondition: expected merging, got ~a"
       (what-kind-of-spot board tile))))
   (merging-which board tile))
(:
  merging-which
  (-> Board Tile (Values (Pairof Hotel (Listof Hotel)) (Listof Hotel))))
(define (merging-which board tile)
   (define surroundings
     (neighbors board (tile-column tile) (tile-row tile) list))
   (define hotels
     (deduplicate/hotel
      (for/list
       :
       (Listof Hotel)
       ((s : Content (in-list surroundings)) #:when (hotel? s))
       (assert s string?))))
   (define sorted
     (let ((x*
            (for/list
             :
             (Listof (List Hotel Natural))
             ((h : Hotel (in-list hotels)))
             (list h (size-of-hotel board h)))))
       (sort
        x*
        (lambda ((x : (List Hotel Natural)) (y : (List Hotel Natural)))
          (> (cadr x) (cadr y))))))
   (define partitioned
     ((inst aux:partition (List Hotel Natural) Hotel)
      sorted
      second
      (lambda ((x : (List Hotel Natural))) (car x))))
   (values
    (cast (first partitioned) (Pairof Hotel (Listof Hotel)))
    (apply append (rest partitioned))))
(: deduplicate/hotel (-> (Listof Hotel) (Listof Hotel)))
(define (deduplicate/hotel h*)
   (let loop :
     (Listof Hotel)
     ((h* : (Listof Hotel) h*))
     (cond
      ((null? h*) '())
      ((member (car h*) (cdr h*)) (loop (cdr h*)))
      (else (cons (car h*) (loop (cdr h*)))))))
(: size-of-hotel (-> Board Hotel Natural))
(define (size-of-hotel board hotel)
   (for/fold
    :
    Natural
    ((size : Natural 0))
    (((key value) (in-hash board)))
    (if (equal? hotel value) (+ size 1) size)))
(: ext:grow-hotel (-> Board Tile Board))
(define (ext:grow-hotel board tile)
   (unless (eq? (what-kind-of-spot board tile) GROWING)
     (error
      'grow-hotel
      (format
       "Precondition: expected founding, got ~a"
       (what-kind-of-spot board tile))))
   (grow-hotel board tile))
(: grow-hotel (-> Board Tile Board))
(define (grow-hotel board tile)
   (define row (tile-row tile))
   (define column (tile-column tile))
   (define surroundings (neighbors board column row list))
   (define hotel-that-touches (first (filter hotel? surroundings)))
   (board-set board column row hotel-that-touches))
(: ext:merge-hotels (-> Board Tile Hotel Board))
(define (ext:merge-hotels board tile hotel)
   (unless (eq? (what-kind-of-spot board tile) MERGING)
     (error
      'merge-hotels
      (format
       "Precondition: expected merging, got ~a"
       (eq? (what-kind-of-spot board tile) MERGING))))
   (unless (let-values (((w _) (merging-which board tile))) (member hotel w))
     (error
      'merge-hotels
      (format "Precondition: hotel ~a is not on a merging spot" hotel)))
   (merge-hotels board tile hotel))
(: merge-hotels (-> Board Tile Hotel Board))
(define (merge-hotels board tile hotel)
   (define row (tile-row tile))
   (define column (tile-column tile))
   (define-values (acquirers acquired) (merging-which board tile))
   (define acquired-hotels (append (remq hotel acquirers) acquired))
   (define relabeled-hotel
     (for/hash
      :
      Board
      (((key current-content) (in-hash board)))
      (if (memq current-content acquired-hotels)
        (values key hotel)
        (values key current-content))))
   (board-set relabeled-hotel column row hotel))
(: ext:found-hotel (-> Board Tile Hotel Board))
(define (ext:found-hotel board tile hotel)
   (unless (eq? (what-kind-of-spot board tile) FOUNDING)
     (error
      'found-hotel
      (format
       "Precondition: expected founding, got ~a"
       (what-kind-of-spot board tile))))
   (found-hotel board tile hotel))
(: found-hotel (-> Board Tile Hotel Board))
(define (found-hotel board tile hotel)
   (define row (tile-row tile))
   (define column (tile-column tile))
   (board-set
    (hotel-take-over-neighboring-tiles board column row hotel)
    column
    row
    hotel))
(: hotel-take-over-neighboring-tiles (-> Board Column Row Hotel Board))
(define (hotel-take-over-neighboring-tiles board column row hotel)
   (let loop :
     Board
     ((board : Board board)
      (to-visit : (Listof Tile) (list (tile column row)))
      (visited : (Listof Tile) '()))
     (cond
      ((empty? to-visit) board)
      ((member (first to-visit) visited) (loop board (rest to-visit) visited))
      (else
       (define column (tile-column (first to-visit)))
       (define row (tile-row (first to-visit)))
       (define-values
        (n e s w)
        (let ((r (neighbors board column row list)))
          (values (car r) (cadr r) (caddr r) (cadddr r))))
       (define no-tiles (ann '() (Listof Tile)))
       (loop
        (board-set board column row hotel)
        (append
         (if (equal? TAKEN-NO-HOTEL n)
           (list (tile column (or (row-^ row) (error 'badrow))))
           no-tiles)
         (if (equal? TAKEN-NO-HOTEL e)
           (list (tile (or (column-> column) (error 'badcol)) row))
           no-tiles)
         (if (equal? TAKEN-NO-HOTEL s)
           (list (tile column (or (row-v row) (error 'badrow))))
           no-tiles)
         (if (equal? TAKEN-NO-HOTEL w)
           (list (tile (or (column-< column) (error 'badcol)) row))
           no-tiles)
         (rest to-visit))
        (cons (first to-visit) visited))))))
(: ext:place-tile (-> Board Tile Board))
(define (ext:place-tile board tile)
   (unless (memq
            (what-kind-of-spot board tile)
            (list SINGLETON GROWING FOUNDING))
     (error 'place-tile "precondition"))
   (place-tile board tile))
(: place-tile (-> Board Tile Board))
(define (place-tile board tile)
   (define row (tile-row tile))
   (define column (tile-column tile))
   (board-set board column row))
(: ext:set-board (-> Board Tile Kind (Option Hotel) Board))
(define (ext:set-board board tile kind hotel)
   (unless (free-spot? board tile) (error 'set-board "Precondition"))
   (unless (if hotel (or (eq? FOUNDING kind) (eq? MERGING kind)) #t)
     (error 'set-board "Precondition"))
   (unless (if (eq? MERGING kind) hotel #t) (error 'set-board "Precondition"))
   (set-board board tile kind hotel))
(: set-board (-> Board Tile Kind (Option Hotel) Board))
(define (set-board board tile kind hotel)
   (cond
    ((eq? FOUNDING kind)
     (if hotel (found-hotel board tile hotel) (place-tile board tile)))
    ((and hotel (eq? MERGING kind)) (merge-hotels board tile hotel))
    ((and hotel (eq? SINGLETON kind)) (place-tile board tile))
    ((and hotel (eq? GROWING kind)) (grow-hotel board tile))
    (else (error 'nopers))))
(: ext:affordable? (-> Board (Listof Hotel) Cash Boolean))
(define (ext:affordable? board hotels budget)
   (unless (shares-order? hotels) (error 'afoordable "precondigin"))
   (affordable? board hotels budget))
(: affordable? (-> Board (Listof Hotel) Cash Boolean))
(define (affordable? board hotels budget)
   (define prices
     (for/list
      :
      (Listof (Option Cash))
      ((h : Hotel (in-list hotels)))
      (price-per-share h (size-of-hotel board h))))
   (define s
     (for/fold
      :
      Cash
      ((acc : Cash 0))
      ((c : (Option Cash) (in-list prices)))
      (if c (+ c acc) acc)))
   (if (ormap boolean? prices) #f (<= s budget)))
(:
  distinct-and-properly-formed
  (-> (Listof Tile) (-> (Listof (Pairof Hotel (Listof Tile))) Boolean)))
(define ((distinct-and-properly-formed free-tiles) hotels-as-lists)
   (define hotel-tiles
     (for/list
      :
      (Listof (Listof Tile))
      ((hl : (Pairof Hotel (Listof Tile)) (in-list hotels-as-lists)))
      (cdr hl)))
   (define first*
     (for/list
      :
      (Listof Hotel)
      ((hl : (Pairof Hotel (Listof Tile)) (in-list hotels-as-lists)))
      (car hl)))
   (and (or (distinct first*) (tee/#f "hotel names not distinct"))
        (or (andmap contains-at-least-two hotel-tiles)
            (tee/#f "hotels don't have 2 tiles"))
        (or (distinct (apply append free-tiles hotel-tiles))
            (tee/#f "hotel & free tiles overlap"))
        (or (andmap connected-graph hotel-tiles) (tee/#f "hotels not graphs"))
        (or (no-two-hotels-touch hotel-tiles) (tee/#f "two hotels touch"))))
(: tee/#f (-> String Boolean))
(define (tee/#f s) (error 'distint-and-properly-formed s))
(: contains-at-least-two (-> (Listof Tile) Boolean))
(define (contains-at-least-two ht) (and (cons? ht) (cons? (rest ht))))
(: connected-graph (-> HT Boolean))
(define (connected-graph hotel-tiles)
   (define start (first hotel-tiles))
   (define remaining (rest hotel-tiles))
   (define next (connected-to start remaining))
   (and (cons? next)
        (let loop :
          Boolean
          ((frontier next) (remaining (remove* next remaining)))
          (cond
           ((empty? remaining) #t)
           (else
            (define one-step
              (apply
               append
               (map (λ ((f : Tile)) (connected-to f remaining)) frontier)))
            (and (cons? one-step)
                 (loop one-step (remove* one-step remaining))))))))
(: no-two-hotels-touch (-> (Listof HT) Boolean))
(define (no-two-hotels-touch hotel-tiles*)
   (and-over-pairs-of-distinct-hotels
    (lambda ((one : HT) (other : HT))
      (not (connected-graph (append one other))))
    hotel-tiles*))
(:
  and-over-pairs-of-distinct-hotels
  (-> (-> HT HT Boolean) (Listof HT) Boolean))
(define (and-over-pairs-of-distinct-hotels f hotel-tiles*)
   (or (empty? hotel-tiles*)
       (let loop :
         Boolean
         ((preceding : (Listof HT) '())
          (current : HT (first hotel-tiles*))
          (remaining : (Listof HT) (rest hotel-tiles*)))
         (cond
          ((empty? remaining) #t)
          (else
           (and (for/and
                 :
                 Boolean
                 ((h : (Listof Tile) (append preceding remaining)))
                 (f current h))
                (loop
                 (cons current preceding)
                 (first remaining)
                 (rest remaining))))))))
(: connected-to (-> Tile HT (Listof Tile)))
(define (connected-to t hotel-tiles*)
   (define r (tile-row t))
   (define c (tile-column t))
   (: in (-> (Option Row) (Option Column) (Listof Tile)))
   (define (in r c)
     (if (and r c)
       (let ((m (member (tile c r) hotel-tiles*))) (if m (list (first m)) '()))
       '()))
   (append
    (in (or (row-^ r) (error 'badr)) c)
    (in (or (row-v r) (error 'badr)) c)
    (in r (or (column-> c) (error 'badc)))
    (in r (or (column-< c) (error 'badc)))))
