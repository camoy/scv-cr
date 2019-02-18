#lang typed/racket/no-check
(define-values
  (g252
   g253
   g254
   g255
   g256
   g257
   g258
   g259
   g260
   g261
   g262
   g263
   g264
   g265
   g266
   g267
   g268
   g269
   g270
   g271
   g272
   g273
   g274
   g275
   g276
   g277
   g278
   g279
   g280
   g281
   g282
   g283
   g284
   g285
   g286
   g287
   g288
   g289
   g290
   g291
   g292
   g293
   g294
   g295
   g296
   g297
   g298
   g299
   g300
   g301
   g302
   g303
   g304
   g305
   g306
   g307
   g308
   g309
   g310
   g311
   g312
   g313
   g314
   g315
   g316
   g317
   g318
   g319
   g320
   g321
   g322
   g323
   g324
   g325
   g326
   g327
   g328
   g329
   g330
   g331
   g332
   g333
   generated-contract234
   g334
   g335
   generated-contract235
   g336
   g337
   g338
   g346
   g347
   g348
   g356
   g357
   g365
   generated-contract236
   generated-contract237
   generated-contract238)
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
    (letrec ((g252 (recursive-contract g293 #:impersonator))
             (g253 (recursive-contract g303 #:impersonator))
             (g254 (recursive-contract g310 #:impersonator))
             (g255 (recursive-contract g322 #:impersonator))
             (g256 (recursive-contract g328 #:impersonator))
             (g257 (recursive-contract g333 #:impersonator))
             (g258 (lambda (x) (state? x)))
             (g259 g253)
             (g260 any/c)
             (g261 exact-nonnegative-integer?)
             (g262 (or/c g261))
             (g263 string?)
             (g264 (listof g263))
             (g265 (listof g264))
             (g266 (-> g260 g262 g265 (values g262)))
             (g267 (lambda (x) (tile? x)))
             (g268 (listof g267))
             (g269 (-> g268 (values g267)))
             (g270 (lambda (x) (hand-out? x)))
             (g271 (listof g270))
             (g272 '#f)
             (g273 (or/c g272 g267))
             (g274 g254)
             (g275 (-> g260 g269 g271 (values g273 g274)))
             (g276 (or/c g263 g272))
             (g277 (lambda (x) (player? x)))
             (g278 '#t)
             (g279 (or/c g278 g272))
             (g280 '())
             (g281 (cons/c g279 g280))
             (g282 (cons/c g263 g281))
             (g283 (listof g282))
             (g284 (cons/c g283 g280))
             (g285 (cons/c g277 g284))
             (g286 (listof g285))
             (g287 (-> g260 g267 g276 g286 g264 g269 (values g273 g274)))
             (g288 (-> g260 (values g279)))
             (g289 (-> any/c g258))
             (g290 g257)
             (g291 (-> g290 (values g262)))
             (g292 (-> g260 g262 g265 g291 (values g262)))
             (g293
              (object/c
               (founding g266)
               (lookup-tile g275)
               (merging g266)
               (next g287)
               (nothing-to-place? g288)
               (to-state g289)
               (traversal g292)
               (field (state g258))))
             (g294 (-> g260 g262 g265 (values g262)))
             (g295 (-> g268 (values g267)))
             (g296 (-> g260 g295 g271 (values g273 g259)))
             (g297 (-> g260 g267 g276 g286 g264 g295 (values g273 g259)))
             (g298 (-> g260 (values g279)))
             (g299 (-> g260 (values g258)))
             (g300 g256)
             (g301 (-> g300 (values g262)))
             (g302 (-> g260 g262 g265 g301 (values g262)))
             (g303
              (object/c-opaque
               (founding g294)
               (lookup-tile g296)
               (merging g294)
               (next g297)
               (nothing-to-place? g298)
               (to-state g299)
               (traversal g302)
               (field (state g258))))
             (g304 g252)
             (g305 (-> g260 g269 g271 (values g273 g304)))
             (g306 (-> g260 g267 g276 g286 g264 g269 (values g273 g304)))
             (g307 g255)
             (g308 (-> g307 (values g262)))
             (g309 (-> g260 g262 g265 g308 (values g262)))
             (g310
              (object/c-opaque
               (founding g294)
               (lookup-tile g305)
               (merging g294)
               (next g306)
               (nothing-to-place? g298)
               (to-state g299)
               (traversal g309)
               (field (state g258))))
             (g311 (-> g260 g265 (values g265)))
             (g312 (or/c g271 g274))
             (g313 (-> g260 g286 g264 (values g312)))
             (g314 (listof g274))
             (g315 (-> g260 g286 g264 (values g314)))
             (g316 'FOUNDING)
             (g317 'GROWING)
             (g318 'MERGING)
             (g319 'SINGLETON)
             (g320 'IMPOSSIBLE)
             (g321 (or/c g316 g317 g318 g319 g320))
             (g322
              (object/c
               (acceptable-policies g311)
               (purchase g313)
               (to-trees g315)
               (field (hotel g276))
               (field (reason g321))
               (field (state g258))
               (field (state/tile g258))
               (field (tile g267))))
             (g323 (-> g260 g265 (values g265)))
             (g324 (or/c g271 g259))
             (g325 (-> g260 g286 g264 (values g324)))
             (g326 (listof g259))
             (g327 (-> g260 g286 g264 (values g326)))
             (g328
              (object/c-opaque
               (acceptable-policies g323)
               (purchase g325)
               (to-trees g327)
               (field (hotel g276))
               (field (reason g321))
               (field (state g258))
               (field (state/tile g258))
               (field (tile g267))))
             (g329 (or/c g271 g304))
             (g330 (-> g260 g286 g264 (values g329)))
             (g331 (listof g304))
             (g332 (-> g260 g286 g264 (values g331)))
             (g333
              (object/c-opaque
               (acceptable-policies g323)
               (purchase g330)
               (to-trees g332)
               (field (hotel g276))
               (field (reason g321))
               (field (state g258))
               (field (state/tile g258))
               (field (tile g267))))
             (generated-contract234 (-> g258 (values g259)))
             (g334 (λ (_) #f))
             (g335 (or/c g334 g298))
             (generated-contract235 g335)
             (g336 (recursive-contract g348 #:impersonator))
             (g337 (recursive-contract g357 #:impersonator))
             (g338 (recursive-contract g365 #:impersonator))
             (g346 (listof g300))
             (g347 (listof g307))
             (g348
              (let ((g266339 g266)
                    (g275340 g275)
                    (g266341 g266)
                    (g287342 g287)
                    (g288343 g288)
                    (g289344 g289)
                    (g292345 g292))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (lplaced g346))
                 (init (state g258))
                 (field (lplaced g347))
                 (field (state g258))
                 (founding g266339)
                 (lookup-tile g275340)
                 (merging g266341)
                 (next g287342)
                 (nothing-to-place? g288343)
                 (to-state g289344)
                 (traversal g292345)
                 (override (founding g266339)
                           (lookup-tile g275340)
                           (merging g266341)
                           (next g287342)
                           (nothing-to-place? g288343)
                           (to-state g289344)
                           (traversal g292345))
                 (super
                  (founding g266339)
                  (lookup-tile g275340)
                  (merging g266341)
                  (next g287342)
                  (nothing-to-place? g288343)
                  (to-state g289344)
                  (traversal g292345))
                 (inherit (founding g266339)
                          (lookup-tile g275340)
                          (merging g266341)
                          (next g287342)
                          (nothing-to-place? g288343)
                          (to-state g289344)
                          (traversal g292345))
                 (augment)
                 (inherit)
                 (absent))))
             (g356 (listof g290))
             (g357
              (let ((g294349 g294)
                    (g296350 g296)
                    (g294351 g294)
                    (g297352 g297)
                    (g298353 g298)
                    (g299354 g299)
                    (g302355 g302))
                (class/c
                 (init (lplaced g356))
                 (init (state g258))
                 (field (lplaced g347))
                 (field (state g258))
                 (founding g294349)
                 (lookup-tile g296350)
                 (merging g294351)
                 (next g297352)
                 (nothing-to-place? g298353)
                 (to-state g299354)
                 (traversal g302355)
                 (override (founding g294349)
                           (lookup-tile g296350)
                           (merging g294351)
                           (next g297352)
                           (nothing-to-place? g298353)
                           (to-state g299354)
                           (traversal g302355))
                 (super
                  (founding g294349)
                  (lookup-tile g296350)
                  (merging g294351)
                  (next g297352)
                  (nothing-to-place? g298353)
                  (to-state g299354)
                  (traversal g302355))
                 (inherit (founding g294349)
                          (lookup-tile g296350)
                          (merging g294351)
                          (next g297352)
                          (nothing-to-place? g298353)
                          (to-state g299354)
                          (traversal g302355))
                 (augment)
                 (inherit)
                 (absent))))
             (g365
              (let ((g294358 g294)
                    (g305359 g305)
                    (g294360 g294)
                    (g306361 g306)
                    (g298362 g298)
                    (g299363 g299)
                    (g309364 g309))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (lplaced g347))
                 (init (state g258))
                 (field (lplaced g347))
                 (field (state g258))
                 (founding g294358)
                 (lookup-tile g305359)
                 (merging g294360)
                 (next g306361)
                 (nothing-to-place? g298362)
                 (to-state g299363)
                 (traversal g309364)
                 (override (founding g294358)
                           (lookup-tile g305359)
                           (merging g294360)
                           (next g306361)
                           (nothing-to-place? g298362)
                           (to-state g299363)
                           (traversal g309364))
                 (super
                  (founding g294358)
                  (lookup-tile g305359)
                  (merging g294360)
                  (next g306361)
                  (nothing-to-place? g298362)
                  (to-state g299363)
                  (traversal g309364))
                 (inherit (founding g294358)
                          (lookup-tile g305359)
                          (merging g294360)
                          (next g306361)
                          (nothing-to-place? g298362)
                          (to-state g299363)
                          (traversal g309364))
                 (augment)
                 (inherit)
                 (absent))))
             (generated-contract236 g337)
             (generated-contract237
              (-> g274 g267 g263 g286 g264 g295 (values g273 g259)))
             (generated-contract238 (-> g274 (values g258))))
      (values
       g252
       g253
       g254
       g255
       g256
       g257
       g258
       g259
       g260
       g261
       g262
       g263
       g264
       g265
       g266
       g267
       g268
       g269
       g270
       g271
       g272
       g273
       g274
       g275
       g276
       g277
       g278
       g279
       g280
       g281
       g282
       g283
       g284
       g285
       g286
       g287
       g288
       g289
       g290
       g291
       g292
       g293
       g294
       g295
       g296
       g297
       g298
       g299
       g300
       g301
       g302
       g303
       g304
       g305
       g306
       g307
       g308
       g309
       g310
       g311
       g312
       g313
       g314
       g315
       g316
       g317
       g318
       g319
       g320
       g321
       g322
       g323
       g324
       g325
       g326
       g327
       g328
       g329
       g330
       g331
       g332
       g333
       generated-contract234
       g334
       g335
       generated-contract235
       g336
       g337
       g338
       g346
       g347
       g348
       g356
       g357
       g365
       generated-contract236
       generated-contract237
       generated-contract238))))
(require (only-in racket/contract contract-out))
(provide (contract-out (generate-tree generated-contract234))
          (contract-out (lplaced% generated-contract236))
          (contract-out (tree-next generated-contract237))
          (contract-out (tree-state generated-contract238)))
(provide)
(require require-typed-check
          "../base/types.rkt"
          "board-adapted.rkt"
          "state-adapted.rkt")
(require "basics.rkt")
(define-type
  Tree<%>
  (Class
   (to-state (-> State))
   (next
    (->
     Tile
     (Option Hotel)
     Decisions
     (Listof Hotel)
     (-> (Listof Tile) Tile)
     (Values (Option Tile) (Instance ATree%))))
   (founding (-> Natural (Listof (Listof Hotel)) Natural))
   (traversal
    (->
     Natural
     (Listof (Listof Hotel))
     (-> (Instance Placed%) Natural)
     Natural))
   (lookup-tile
    (->
     (-> (Listof Tile) Tile)
     (Listof HandOut)
     (Values (Option Tile) (Instance ATree%))))
   (merging (-> Natural (Listof (Listof Hotel)) Natural))))
(define-type
  ATree%
  (Class
   #:implements
   Tree<%>
   (init-field (state State))
   (nothing-to-place? (-> Boolean))))
(define-type
  Placed%
  (Class
   (init-field
    (state State)
    (tile Tile)
    (hotel (Option Hotel))
    (state/tile State)
    (reason SpotType))
   (purchase
    (-> Decisions (Listof Hotel) (U (Instance ATree%) (Listof HandOut))))
   (to-trees (-> Decisions (Listof Hotel) (Listof (Instance ATree%))))
   (acceptable-policies (-> (Listof (Listof Hotel)) (Listof (Listof Hotel))))))
(define-type
  LPlaced%
  (Class
   #:implements
   ATree%
   (init-field (lplaced (Listof (Instance Placed%))) (state State))
   (nothing-to-place? (-> Boolean))))
(struct hand-out ((tile : Tile) (tree : (Instance ATree%))))
(define-type HandOut hand-out)
(: placed-tile (-> (Instance Placed%) Tile))
(define (placed-tile p) (get-field tile p))
(: placed-hotel (-> (Instance Placed%) (Option Hotel)))
(define (placed-hotel p) (get-field hotel p))
(: atree% ATree%)
(define atree%
   (class object%
     (init-field (state : State))
     (super-new)
     (define/public (nothing-to-place?) #f)
     (define/public (to-state) (get-field state this))
     (define/public (next t h d* h* pt) (error 'not-implemented))
     (define/public
      (founding n order-policies)
      (unless (shares-order? order-policies)
        (error 'atree-founding "Precondition"))
      (traversal n order-policies (is-action FOUNDING)))
     (define/public
      (merging n order-policies)
      (traversal n order-policies (is-action MERGING)))
     (define/public (traversal n order-policies i) (error 'not-impolementd))
     (: is-action (-> Symbol (-> (Instance Placed%) (U 1 0))))
     (define
      ((is-action tag) p)
      (if (and (placed-hotel p) (eq? (get-field reason p) tag)) 1 0))
     (define/public (lookup-tile pick-tile lo-handout) (values #f this))))
(: state% ATree%)
(define state%
   (class atree%
     (super-new)
     (define/override
      (next . _)
      (error 'tree-next "finale state can't transition"))
     (define/override (traversal n policies p?) 0)
     (define/override (lookup-tile pick-tile lo-handout) (values #f this))))
(: lplaced% LPlaced%)
(define lplaced%
   (class atree%
     (super-new)
     (init-field (lplaced : (Listof (Instance Placed%))))
     (define/override (nothing-to-place?) (null? lplaced))
     (define/override
      (next tile hotel decisions shares-to-buy pick-tile)
      (define intermediate
        (send (lookup-purchase tile hotel) purchase decisions shares-to-buy))
      (unless (list? intermediate) (error "Expected a HandOut, got a State%"))
      (send this lookup-tile pick-tile intermediate))
     (: lookup-purchase (-> Tile (Option Hotel) (Instance Placed%)))
     (define/private
      (lookup-purchase t h)
      (or (for/or
           :
           (Option (Instance Placed%))
           ((p : (Instance Placed%) lplaced)
            #:when
            (and (equal? (placed-hotel p) h) (equal? (placed-tile p) t)))
           p)
          (error 'noplace)))
     (define/override
      (lookup-tile pick-tile lo-hand-out)
      (define tile (pick-tile (map hand-out-tile lo-hand-out)))
      (define st
        (for/or
         :
         (Option (Instance ATree%))
         ((p : HandOut lo-hand-out) #:when (equal? (hand-out-tile p) tile))
         (hand-out-tree p)))
      (values tile (or st (error 'lookupfailed))))
     (define/override
      (traversal n policies p?)
      (if (= n 0)
        0
        (for/sum
         :
         Natural
         ((branch : (Instance Placed%) (in-list lplaced)))
         (define d*
           (map
            (lambda ((p : Player)) (list p '()))
            (state-players (get-field state/tile branch))))
         (define a (send branch acceptable-policies policies))
         (+
          (p? branch)
          (if (empty? a)
            0
            (*
             (length a)
             (for/sum
              :
              Natural
              ((st : (Instance ATree%) (send branch to-trees d* (first a))))
              (send st traversal (- n 1) policies p?))))))))))
(: placed% Placed%)
(define placed%
   (class object%
     (init-field state tile hotel state/tile reason)
     (super-new)
     (define/public
      (purchase decisions share-order)
      (when (eq? MERGING reason)
        (define players (state-players state/tile))
        (unless (= (length decisions) (length players))
          (printf "contract failure: received wrong number of decisions")
          (error 'purchase "done")))
      (define state/decisions
        (if (eq? MERGING reason)
          (state-return-shares state/tile decisions (state-board state))
          state/tile))
      (define state/bought (state-buy-shares state/decisions share-order))
      (define available-tiles (state-tiles state/bought))
      (if (empty? available-tiles)
        (new state% (state state/bought))
        (for/list
         :
         (Listof HandOut)
         ((tile : Tile available-tiles))
         (hand-out
          tile
          (generate-tree
           (state-next-turn (state-move-tile state/bought tile)))))))
     (define/public
      (to-trees decisions share-order)
      (define state-or-hand-out (purchase decisions share-order))
      (cond
       ((list? state-or-hand-out) (map hand-out-tree state-or-hand-out))
       (else (list state-or-hand-out))))
     (define/public
      (acceptable-policies policies)
      (unless (andmap shares-order? policies)
        (error 'acceptable-policies "Precondigion"))
      (define state state/tile)
      (define budget (player-money (state-current-player state)))
      (define board (state-board state))
      (define shares (state-shares state))
      (for/list
       ((p : (Listof Hotel) policies)
        #:when
        (and (shares-available? shares p) (affordable? board p budget)))
       p))))
(: generate-tree (-> State (Instance ATree%)))
(define (generate-tree state)
   (cond
    ((state-final? state) (new state% (state state)))
    (else
     (define board (state-board state))
     (define available-hotels (state-hotels state))
     (define lplaced
       (for/fold
        :
        (Listof (Instance Placed%))
        ((lo-placed : (Listof (Instance Placed%)) '()))
        ((t : Tile (player-tiles (state-current-player state))))
        (define kind (what-kind-of-spot board t))
        (: hotels (Listof (Option Hotel)))
        (define hotels
          (cond
           ((eq? kind IMPOSSIBLE) '())
           ((and (eq? FOUNDING kind) (cons? available-hotels))
            available-hotels)
           ((eq? MERGING kind)
            (define-values (acquirers _) (merging-which board t))
            acquirers)
           (else (list #f))))
        (define new-placements
          (for/list
           :
           (Listof (Instance Placed%))
           ((h : (Option Hotel) (in-list hotels)))
           (define state/tile
             (if h (state-place-tile state t h) (state-place-tile state t)))
           (new
            placed%
            (state state)
            (tile t)
            (hotel h)
            (state/tile state/tile)
            (reason kind))))
        (append new-placements lo-placed)))
     (new lplaced% (state state) (lplaced lplaced)))))
(:
  tree-next
  (->
   (Instance ATree%)
   Tile
   Hotel
   Decisions
   (Listof Hotel)
   (-> (Listof Tile) Tile)
   (Values (Option Tile) (Instance ATree%))))
(define (tree-next current-tree tile hotel decisions shares-to-buy pick-tile)
   (send current-tree next tile hotel decisions shares-to-buy pick-tile))
(: tree-state (-> (Instance ATree%) State))
(define (tree-state t) (send t to-state))
