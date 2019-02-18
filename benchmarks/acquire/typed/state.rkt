#lang typed/racket/no-check
(define-values
  (g279
   g280
   g281
   g282
   g283
   g284
   g285
   g286
   g287
   g288
   generated-contract218
   g289
   g290
   g291
   g292
   g293
   g294
   g295
   generated-contract219
   g296
   generated-contract220
   generated-contract221
   generated-contract222
   g297
   g298
   generated-contract223
   g299
   g300
   g301
   g302
   g303
   g304
   g305
   g306
   g307
   generated-contract224
   generated-contract225
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
   g334
   g335
   g336
   g337
   g338
   g339
   g340
   g341
   g342
   g343
   g344
   g345
   g346
   g347
   g348
   g349
   g350
   g351
   g352
   g353
   g354
   g355
   g356
   g357
   g358
   g359
   g360
   g361
   g362
   g363
   g364
   g365
   g366
   g367
   g368
   g369
   g370
   g371
   g372
   g373
   g374
   g375
   g376
   g377
   g378
   g379
   g380
   g381
   g382
   generated-contract234
   g383
   generated-contract226
   g384
   g385
   generated-contract227
   g386
   generated-contract228
   generated-contract229
   generated-contract230
   generated-contract231
   generated-contract232
   generated-contract235
   generated-contract236
   generated-contract246
   generated-contract237
   generated-contract238
   generated-contract239
   generated-contract240
   generated-contract241
   generated-contract242
   generated-contract243
   generated-contract244
   generated-contract247
   generated-contract248
   generated-contract249
   generated-contract250
   generated-contract251
   g387
   g388
   g389
   generated-contract252
   generated-contract253)
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
    (letrec ((g279 string?)
             (g280 exact-nonnegative-integer?)
             (g281 (or/c g280))
             (g282 exact-integer?)
             (g283 (or/c g282))
             (g284 (typed-racket-hash/c g279 g283))
             (g285 (or/c g284))
             (g286 (lambda (x) (tile? x)))
             (g287 (listof g286))
             (g288 (lambda (x) (player? x)))
             (generated-contract218 (-> g279 g281 g285 g287 (values g288)))
             (g289 'UNTAKEN)
             (g290 'taken-no-hotel)
             (g291 (or/c g279 g289 g290))
             (g292 (typed-racket-hash/c g286 g291))
             (g293 (or/c g292))
             (g294 (listof g288))
             (g295 (lambda (x) (state? x)))
             (generated-contract219 (-> g293 g294 (values g295)))
             (g296 (listof g279))
             (generated-contract220 (->* () () #:rest g296 (values g295)))
             (generated-contract221 (-> g295 g296 (values g295)))
             (generated-contract222 (-> g295 g286 (values g295)))
             (g297 '#f)
             (g298 (or/c g279 g297))
             (generated-contract223 (->* (g295 g286) (g298) (values g295)))
             (g299 '#t)
             (g300 (or/c g299 g297))
             (g301 '())
             (g302 (cons/c g300 g301))
             (g303 (cons/c g279 g302))
             (g304 (listof g303))
             (g305 (cons/c g304 g301))
             (g306 (cons/c g288 g305))
             (g307 (listof g306))
             (generated-contract224 (->* (g295 g307) (g293) (values g295)))
             (generated-contract225 (->* () () #:rest g294 (values g295)))
             (g308 (recursive-contract g336 #:impersonator))
             (g309 (recursive-contract g350 #:impersonator))
             (g310 (recursive-contract g355 #:impersonator))
             (g311 (recursive-contract g371 #:impersonator))
             (g312 (recursive-contract g378 #:impersonator))
             (g313 (recursive-contract g382 #:impersonator))
             (g314 g310)
             (g315 (or/c g297 g314))
             (g316 any/c)
             (g317 g312)
             (g318 (lambda (x) (equal? x (void))))
             (g319 (-> g316 g317 (values g318)))
             (g320 (-> any/c any/c g318))
             (g321 (listof g300))
             (g322 (-> g316 g296 (values g321)))
             (g323 (-> any/c any/c g318))
             (g324 (or/c g297 g286))
             (g325 (-> g316 (values g324 g298 g307)))
             (g326 (-> g316 (values g294)))
             (g327 (or/c g318 g294))
             (g328 (-> g316 g286 g279 (values g327)))
             (g329 (-> g316 (values g300)))
             (g330 (-> g316 g285 (values g285)))
             (g331
              (object/c-opaque
               (decisions g325)
               (eliminated g326)
               (place g328)
               (place-called g329)
               (reconcile-shares g330)
               (field (board g293))
               (field (cash g281))
               (field (current g288))
               (field (current-state g295))
               (field (hotels g296))
               (field (players g294))
               (field (shares g285))
               (field (tiles g287))))
             (g332 (-> g316 g331 (values g324 g298 g296)))
             (g333 any/c)
             (g334 (-> g316 g295 g333 (values g318)))
             (g335 (-> g331 (values g324 g298 g296)))
             (g336
              (object/c
               (go g319)
               (inform g320)
               (keep g322)
               (receive-tile g323)
               (setup g320)
               (take-turn g332)
               (the-end g334)
               (field (*bad g294))
               (field (*players g294))
               (field (choice g335))
               (field (name g279))))
             (g337 g313)
             (g338 (-> g316 g337 (values g318)))
             (g339 (-> g316 g295 (values g318)))
             (g340 (-> g316 g296 (values g321)))
             (g341 (-> g316 g286 (values g318)))
             (g342 (-> g316 (values g324 g298 g307)))
             (g343 (-> g316 (values g294)))
             (g344 (-> g316 g286 g279 (values g327)))
             (g345 (-> g316 (values g300)))
             (g346 (-> g316 g285 (values g285)))
             (g347
              (object/c
               (decisions g342)
               (eliminated g343)
               (place g344)
               (place-called g345)
               (reconcile-shares g346)
               (field (board g293))
               (field (cash g281))
               (field (current g288))
               (field (current-state g295))
               (field (hotels g296))
               (field (players g294))
               (field (shares g285))
               (field (tiles g287))))
             (g348 (-> g316 g347 (values g324 g298 g296)))
             (g349 (-> g316 g295 g316 (values g318)))
             (g350
              (object/c-opaque
               (go g338)
               (inform g339)
               (keep g340)
               (receive-tile g341)
               (setup g339)
               (take-turn g348)
               (the-end g349)
               (field (*bad g294))
               (field (*players g294))
               (field (choice g335))
               (field (name g279))))
             (g351 g311)
             (g352 (-> g316 g351 (values g318)))
             (g353 (-> g316 g331 (values g324 g298 g296)))
             (g354 (-> g316 g295 g333 (values g318)))
             (g355
              (object/c-opaque
               (go g352)
               (inform g339)
               (keep g340)
               (receive-tile g341)
               (setup g339)
               (take-turn g353)
               (the-end g354)
               (field (*bad g294))
               (field (*players g294))
               (field (choice g335))
               (field (name g279))))
             (g356 (-> (values g318)))
             (g357 'IMPOSSIBLE)
             (g358 'score)
             (g359 'exhausted)
             (g360 'done)
             (g361 (or/c g357 g358 g359 g360))
             (g362 (listof g295))
             (g363 (cons/c g362 g301))
             (g364 (cons/c g316 g363))
             (g365 (cons/c g361 g364))
             (g366 (->* (g316 g281) (#:show g356) (values g365)))
             (g367 (-> g316 (values g296)))
             (g368 g309)
             (g369 (-> g316 g279 g368 (values g279)))
             (g370 (-> g287 (values g286)))
             (g371
              (object/c
               (run g366)
               (show-players g367)
               (sign-up g369)
               (field (next-tile g370))))
             (g372 (-> g318))
             (g373 (cons/c g333 g363))
             (g374 (cons/c g361 g373))
             (g375 (->* (g316 g281) (#:show g372) (values g374)))
             (g376 (-> g316 (values g296)))
             (g377 (-> g316 g279 g314 (values g279)))
             (g378
              (object/c-opaque
               (run g375)
               (show-players g376)
               (sign-up g377)
               (field (next-tile g370))))
             (g379 (->* (g316 g281) (#:show g356) (values g374)))
             (g380 g308)
             (g381 (-> g316 g279 g380 (values g279)))
             (g382
              (object/c-opaque
               (run g379)
               (show-players g376)
               (sign-up g381)
               (field (next-tile g370))))
             (generated-contract234
              (-> g279 g287 g281 g285 g315 (values g288)))
             (g383 (λ (_) #f))
             (generated-contract226 g383)
             (g384 (λ (_) #f))
             (g385 (or/c g384 g329))
             (generated-contract227 g385)
             (g386 (or/c g297 g368))
             (generated-contract228 (-> g288 (values g386)))
             (generated-contract229 (-> g288 (values g285)))
             (generated-contract230 (-> g288 (values g281)))
             (generated-contract231 (-> g288 (values g287)))
             (generated-contract232 (-> g288 (values g279)))
             (generated-contract235
              (-> g279 g286 g286 g286 g286 g286 g286 g314 (values g288)))
             (generated-contract236 g385)
             (generated-contract246
              (-> g293 g294 g287 g296 g285 g294 (values g295)))
             (generated-contract237 g383)
             (generated-contract238 g385)
             (generated-contract239 (-> g295 (values g294)))
             (generated-contract240 (-> g295 (values g285)))
             (generated-contract241 (-> g295 (values g296)))
             (generated-contract242 (-> g295 (values g287)))
             (generated-contract243 (-> g295 (values g294)))
             (generated-contract244 (-> g295 (values g293)))
             (generated-contract247 (-> g295 (values g288)))
             (generated-contract248 (-> g295 g294 (values g295)))
             (generated-contract249 (-> g295 (values g300)))
             (generated-contract250 (-> g295 (values g295)))
             (generated-contract251 (-> g295 (values g295)))
             (g387 (cons/c g281 g301))
             (g388 (cons/c g279 g387))
             (g389 (listof g388))
             (generated-contract252 (-> g295 (values g389)))
             (generated-contract253 (-> g295 g285 (values g295))))
      (values
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
       generated-contract218
       g289
       g290
       g291
       g292
       g293
       g294
       g295
       generated-contract219
       g296
       generated-contract220
       generated-contract221
       generated-contract222
       g297
       g298
       generated-contract223
       g299
       g300
       g301
       g302
       g303
       g304
       g305
       g306
       g307
       generated-contract224
       generated-contract225
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
       g334
       g335
       g336
       g337
       g338
       g339
       g340
       g341
       g342
       g343
       g344
       g345
       g346
       g347
       g348
       g349
       g350
       g351
       g352
       g353
       g354
       g355
       g356
       g357
       g358
       g359
       g360
       g361
       g362
       g363
       g364
       g365
       g366
       g367
       g368
       g369
       g370
       g371
       g372
       g373
       g374
       g375
       g376
       g377
       g378
       g379
       g380
       g381
       g382
       generated-contract234
       g383
       generated-contract226
       g384
       g385
       generated-contract227
       g386
       generated-contract228
       generated-contract229
       generated-contract230
       generated-contract231
       generated-contract232
       generated-contract235
       generated-contract236
       generated-contract246
       generated-contract237
       generated-contract238
       generated-contract239
       generated-contract240
       generated-contract241
       generated-contract242
       generated-contract243
       generated-contract244
       generated-contract247
       generated-contract248
       generated-contract249
       generated-contract250
       generated-contract251
       g387
       g388
       g389
       generated-contract252
       generated-contract253))))
(require (only-in racket/contract contract-out))
(provide (contract-out (ext:*create-player generated-contract218))
          (contract-out (ext:*create-state generated-contract219))
          (contract-out (ext:*cs0 generated-contract220))
          (contract-out (ext:state-buy-shares generated-contract221))
          (contract-out (ext:state-move-tile generated-contract222))
          (contract-out (ext:state-place-tile generated-contract223))
          (contract-out (ext:state-return-shares generated-contract224))
          (contract-out (ext:state0 generated-contract225))
          (contract-out
           (struct
            player
            ((name g279)
             (tiles g287)
             (money g281)
             (shares g285)
             (external g315))))
          (contract-out (player0 generated-contract235))
          (contract-out (score? generated-contract236))
          (contract-out
           (struct
            state
            ((board g293)
             (players g294)
             (tiles g287)
             (hotels g296)
             (shares g285)
             (bad g294))))
          (contract-out (state-current-player generated-contract247))
          (contract-out (state-eliminate generated-contract248))
          (contract-out (state-final? generated-contract249))
          (contract-out (state-next-turn generated-contract250))
          (contract-out (state-remove-current-player generated-contract251))
          (contract-out (state-score generated-contract252))
          (contract-out (state-sub-shares generated-contract253)))
(provide (rename-out (ext:*create-player *create-player))
          (rename-out (ext:state0 state0))
          (rename-out (ext:state-place-tile state-place-tile))
          (rename-out (ext:state-buy-shares state-buy-shares))
          (rename-out (ext:state-return-shares state-return-shares))
          (rename-out (ext:state-move-tile state-move-tile))
          (rename-out (ext:*create-state *create-state))
          (rename-out (ext:*cs0 *cs0)))
(: score? (-> Any Boolean))
(define (score? x*)
   (and (list? x*)
        (for/fold
         :
         (U Boolean Cash)
         ((prev : (U Boolean Cash) #t))
         ((x : Any (in-list x*)))
         (and prev
              (list? x)
              (not (null? x))
              (not (null? (cdr x)))
              (null? (cddr x))
              (string? (car x))
              (cash? (cdr x))
              (if (cash? prev)
                (>= (assert prev real?) (assert (cdr x) real?))
                #t)
              (assert (cdr x) exact-nonnegative-integer?)))
        #t))
(define-type Score (Listof (List String Cash)))
(require require-typed-check "../base/types.rkt" "board-adapted.rkt")
(require "basics.rkt")
(require "auxiliaries.rkt")
(define-type Decisions (Listof (List Player (Listof (List Hotel Boolean)))))
(define-type
  Administrator%
  (Class
   (init-field (next-tile (-> (Listof Tile) Tile)))
   (sign-up (-> String (Instance Player%) String))
   (show-players (-> (Listof String)))
   (run (->* (Natural) (#:show (-> Void)) RunResult))))
(define-type
  Turn%
  (Class
   (init-field (current-state State))
   (field (board Board)
          (current Player)
          (cash Cash)
          (tiles (Listof Tile))
          (shares Shares)
          (hotels (Listof Hotel))
          (players (Listof Player)))
   (reconcile-shares (-> Shares Shares))
   (eliminated (-> (Listof Player)))
   (place-called (-> Boolean))
   (decisions (-> (Values (Option Tile) (Option Hotel) Decisions)))
   (place (-> Tile Hotel (U Void (Listof Player))))))
(define-type
  Player%
  (Class
   (init-field (name String) (choice Strategy))
   (field (*players (Listof Player)) (*bad (Listof Player)))
   (go (-> (Instance Administrator%) Void))
   (setup (-> State Void))
   (take-turn
    (-> (Instance Turn%) (Values (Option Tile) (Option Hotel) (Listof Hotel))))
   (keep (-> (Listof Hotel) (Listof Boolean)))
   (receive-tile (-> Tile Void))
   (inform (-> State Void))
   (the-end (-> State Any Void))))
(define-type
  RunResult
  (List (U 'done 'exhausted 'score 'IMPOSSIBLE) Any (Listof State)))
(define-type
  Strategy
  (-> (Instance Turn%) (Values (Option Tile) (Option Hotel) (Listof Hotel))))
(define-type Player player)
(struct
  player
  ((name : String)
   (tiles : (Listof Tile))
   (money : Cash)
   (shares : Shares)
   (external : (Option (Instance Player%))))
  #:transparent)
(:
  player0
  (-> String Tile Tile Tile Tile Tile Tile (Instance Player%) Player))
(define (player0 n t1 t2 t3 t4 t5 t6 x)
   (player n (list t1 t2 t3 t4 t5 t6) CASH0 player-shares0 x))
(: ext:*create-player (-> String Cash Shares (Listof Tile) Player))
(define (ext:*create-player name cash shares tiles)
   (unless (distinct tiles)
     (error '*create-player (format "Precondition: distinct tiles ~a" tiles)))
   (unless (<= STARTER-TILES# (length tiles))
     (error
      '*create-player
      (format "Precondition: <=~a tiles in ~a" STARTER-TILES# tiles)))
   (*create-player name cash shares tiles))
(: *create-player (-> String Cash Shares (Listof Tile) Player))
(define (*create-player name cash shares tiles)
   (player name tiles cash shares #f))
(: player-tile- (-> Player Tile Player))
(define (player-tile- p t)
   (struct-copy player p (tiles (remove t (player-tiles p)))))
(: player-tile+ (-> Player Tile Player))
(define (player-tile+ p t)
   (struct-copy player p (tiles (cons t (player-tiles p)))))
(: player-shares++ (-> Player Hotel * Player))
(define (player-shares++ p . h)
   (if (empty? h)
     p
     (struct-copy
      player
      p
      (shares
       (for/fold
        :
        Shares
        ((s : Shares (player-shares p)))
        ((h : Hotel (in-list h)))
        (shares++ s h))))))
(: player-buy-shares (-> Player (Listof Hotel) Board Player))
(define (player-buy-shares p0 sh board)
   (define amount
     (for/sum
      :
      Cash
      ((h : Hotel sh))
      (or (price-per-share h (size-of-hotel board h)) 0)))
   (define m (assert (- (player-money p0) amount) exact-nonnegative-integer?))
   (apply player-shares++ (struct-copy player p0 (money m)) sh))
(: player-returns-shares (-> Player Shares Board Player))
(define (player-returns-shares p0 transfers board)
   (match-define (player _name _tiles money shares _ext) p0)
   (define amount (shares->money transfers board))
   (struct-copy
    player
    p0
    (money (+ money amount))
    (shares (shares-minus shares transfers))))
(struct
  state
  ((board : Board)
   (players : (Listof Player))
   (tiles : (Listof Tile))
   (hotels : (Listof Hotel))
   (shares : Shares)
   (bad : (Listof Player)))
  #:transparent)
(define-type State state)
(: ext:state0 (-> Player * State))
(define (ext:state0 . p)
   (unless (distinct (apply append (map player-tiles p)))
     (error 'state0 (format "Precondition: distinct tiles for players ~a" p)))
   (apply state0 p))
(: state0 (-> Player * State))
(define (state0 . p)
   (define tiles-owned-by-players (apply append (map player-tiles p)))
   (define tiles-in-pool (remove* tiles-owned-by-players ALL-TILES))
   (state (make-board) p tiles-in-pool ALL-HOTELS banker-shares0 '()))
(: state-sub-shares (-> State Shares State))
(define (state-sub-shares s bad-shares)
   (struct-copy state s (shares (shares-minus (state-shares s) bad-shares))))
(: ext:*cs0 (-> String * State))
(define (ext:*cs0 . names)
   (unless (distinct names)
     (error '*cs0 (format "Precondition: (distinct ~a)" names)))
   (unless (andmap (lambda ((s : String)) (<= (string-length s) 20)) names)
     (error
      'cs0
      (format "Precondition: strings with <=20 characters ~a" names)))
   (apply *cs0 names))
(: *cs0 (-> String * State))
(define (*cs0 . names)
   (let loop :
     State
     ((names : (Listof String) names)
      (tiles : (Listof Tile) ALL-TILES)
      (players : (Listof Player) '()))
     (cond
      ((empty? names)
       (state
        (make-board)
        (reverse players)
        tiles
        ALL-HOTELS
        banker-shares0
        '()))
      (else
       (define first-six (take tiles STARTER-TILES#))
       (define player1
         (player (first names) first-six CASH0 player-shares0 #f))
       (loop
        (rest names)
        (drop tiles STARTER-TILES#)
        (cons player1 players))))))
(: ext:*create-state (-> Board (Listof Player) State))
(define (ext:*create-state b lp)
   (unless (shares-combinable? (map player-shares lp)) (error 'create-state))
   (unless (distinct (apply append (board-tiles b) (map player-tiles lp)))
     (error 'create-state "precond"))
   (*create-state b lp))
(: *create-state (-> Board (Listof Player) State))
(define (*create-state board players)
   (define players-shares
     (for/list
      :
      (Listof Shares)
      ((p : Player (in-list players)))
      (player-shares p)))
   (define remaining-shares
     (for/fold
      :
      Shares
      ((remaining-shares banker-shares0))
      ((s : Shares (in-list players-shares)))
      (shares-minus remaining-shares s)))
   (define remaining-hotels
     (for/list
      :
      (Listof Hotel)
      ((h : Hotel (in-list ALL-HOTELS)) #:when (= (size-of-hotel board h) 0))
      h))
   (define remaining-tiles
     (remove*
      (apply append (board-tiles board) (map player-tiles players))
      ALL-TILES))
   (state board players remaining-tiles remaining-hotels remaining-shares '()))
(: ext:state-place-tile (->* (State Tile) ((Option Hotel)) State))
(define (ext:state-place-tile s tile (hotel #f))
   (unless (member tile (player-tiles (state-current-player s)))
     (error
      'state-place-tile
      (format
       "Precondition: tile ~a belongs to player ~a"
       tile
       (state-current-player s))))
   (unless (not (eq? (what-kind-of-spot (state-board s) tile) 'IMPOSSIBLE))
     (error
      'state-place-tile
      (format "Precondition: impossible position for ~a on board" tile)))
   (let ((spot-type (what-kind-of-spot (state-board s) tile)))
     (when hotel
       (unless (memq spot-type '(FOUNDING MERGING))
         (error
          'state-place-tile
          (format
           "Precondition: expected founding or merging spot for ~a"
           tile))))
     (let ((b (state-board s)) (hotels (state-hotels s)))
       (unless (if
                (and (eq? spot-type 'FOUNDING) (pair? hotels))
                (and hotel (member hotel hotels))
                #t)
         (error
          'state-place-tile
          (format
           "Precondition: if spot is FOUNDING and hotels are available, ~a must be one of them"
           hotel))))
     (unless (if
              (eq? spot-type 'MERGING)
              (and hotel
                   (let-values (((w _) (merging-which (state-board s) tile)))
                     (member hotel w)))
              #t)
       (error
        'state-place-tile
        (format
         "Precondition:  if tile placement causes merger, hotel ~a must be given and an acquirer"
         hotel))))
   (state-place-tile s tile hotel))
(: state-place-tile (->* (State Tile) ((Option Hotel)) State))
(define (state-place-tile s tile (hotel #f))
   (match-define (state board players tiles hotels shares _bad) s)
   (define current (player-tile- (first players) tile))
   (define others (rest players))
   (define players-next (cons current others))
   (define tiles-next (remove tile tiles))
   (define spot (what-kind-of-spot board tile))
   (cond
    ((or (eq? SINGLETON spot)
         (eq? GROWING spot)
         (and (eq? FOUNDING spot) (not hotel)))
     (define new-board
       (if (eq? GROWING spot) (grow-hotel board tile) (place-tile board tile)))
     (struct-copy
      state
      s
      (board new-board)
      (tiles tiles-next)
      (players players-next)))
    ((eq? FOUNDING spot)
     (define t
       (struct-copy
        state
        s
        (hotels (remove hotel hotels))
        (tiles tiles-next)
        (board (found-hotel board tile hotel))))
     (if (= (shares-available shares hotel) 0)
       (struct-copy state t (players players-next))
       (struct-copy
        state
        t
        (shares (shares-- shares hotel))
        (players (cons (player-shares++ current hotel) others)))))
    ((eq? MERGING spot)
     (define-values (w l) (merging-which board tile))
     (define acquired (append (remove hotel w) l))
     (define next-state
       (struct-copy
        state
        s
        (board (merge-hotels board tile (or hotel (error 'hotel=#f))))
        (hotels (append acquired hotels))
        (tiles tiles-next)
        (players players-next)))
     (foldr (state-distribute-bonus board) next-state acquired))
    (else (error 'condfailed))))
(: state-distribute-bonus (-> Board (-> Hotel State State)))
(define ((state-distribute-bonus board) acquired-hotel s)
   (define size-acquired (size-of-hotel board acquired-hotel))
   (define players (state-players s))
   (define selector
     (lambda ((p : Player))
       (shares-available (player-shares p) acquired-hotel)))
   (define owners-of-acquired
     (filter (lambda ((p : Player)) (> (selector p) 0)) players))
   (define owners-of-acquired-sorted
     (sort
      owners-of-acquired
      (lambda ((x : Player) (y : Player)) (> (selector x) (selector y)))))
   (cond
    ((empty? owners-of-acquired-sorted) s)
    (else
     (define majority-minority
       ((inst aux:partition Player Player)
        owners-of-acquired-sorted
        selector
        (lambda ((x : Player)) x)))
     (define majority (first majority-minority))
     (define minority
       (if (empty? (rest majority-minority)) '() (second majority-minority)))
     (define majority-bonus (bonus 'majority acquired-hotel size-acquired))
     (define minority-bonus (bonus 'minority acquired-hotel size-acquired))
     (cond
      ((pair? (rest majority))
       (define total-bonus (+ majority-bonus minority-bonus))
       (define bonus-per (quotient total-bonus (length majority)))
       (struct-copy
        state
        s
        (players (foldr (state-pay-out bonus-per) players majority))))
      ((cons? minority)
       (define single-majority (first majority))
       (define majority-payed
         ((state-pay-out majority-bonus) single-majority players))
       (define bonus-per (quotient minority-bonus (length minority)))
       (struct-copy
        state
        s
        (players (foldr (state-pay-out bonus-per) majority-payed minority))))
      ((empty? minority)
       (define single-majority (first majority))
       (struct-copy
        state
        s
        (players
         ((state-pay-out majority-bonus) single-majority players))))))))
(: state-pay-out (-> Cash (-> Player (Listof Player) (Listof Player))))
(define (state-pay-out bonus)
   (lambda ((pay-to : Player) (players : (Listof Player)))
     (define the-name (player-name pay-to))
     (for/list
      :
      (Listof Player)
      ((p : Player (in-list players)))
      (match-define (player name _tiles money _shares _ext) p)
      (if (string=? name the-name)
        (struct-copy player p (money (+ money bonus)))
        p))))
(: ext:state-move-tile (-> State Tile State))
(define (ext:state-move-tile s t)
   (unless (member t (state-tiles s))
     (error
      'state-move-tile
      (format
       "Precondition: tile ~a must be a member of ~a"
       t
       (state-tiles s))))
   (state-move-tile s t))
(: state-move-tile (-> State Tile State))
(define (state-move-tile s t)
   (match-define (state _board players tiles _hotels _shares _bad) s)
   (struct-copy
    state
    s
    (players (cons (player-tile+ (first players) t) (rest players)))
    (tiles (remove t tiles))))
(: state-next-turn (-> State State))
(define (state-next-turn s)
   (define players (state-players s))
   (struct-copy
    state
    s
    (players (append (rest players) (list (first players))))))
(: state-remove-current-player (-> State State))
(define (state-remove-current-player s)
   (define players (state-players s))
   (struct-copy
    state
    s
    (players (rest players))
    (bad (cons (first players) (state-bad s)))))
(: state-eliminate (-> State (Listof Player) State))
(define (state-eliminate s ep)
   (struct-copy
    state
    s
    (players (remove* ep (state-players s)))
    (bad (append ep (state-bad s)))))
(: state-current-player (-> State Player))
(define (state-current-player s) (first (state-players s)))
(: ext:state-buy-shares (-> State (Listof Hotel) State))
(define (ext:state-buy-shares s sh)
   (unless (shares-order? sh) (error 'state-buy-shares "Preciondignos"))
   (unless (affordable?
            (state-board s)
            sh
            (player-money (state-current-player s)))
     (error
      'state-buy-shares
      (format
       "Precondition: player ~a cannot afford to buy ~a"
       (state-current-player s)
       sh)))
   (unless (let
            ((banker-s-shares (state-shares s)))
            (shares-available? banker-s-shares sh))
     (error 'state-buy-shares (format "shares ~a are not available")))
   (state-buy-shares s sh))
(: state-buy-shares (-> State (Listof Hotel) State))
(define (state-buy-shares s sh)
   (match-define (state board players _tiles _hotels shares _bad) s)
   (struct-copy
    state
    s
    (players
     (cons (player-buy-shares (first players) sh board) (rest players)))
    (shares
     (for/fold
      :
      Shares
      ((s : Shares shares))
      ((h : Hotel sh))
      (shares-- s h)))))
(:
  ext:state-return-shares
  (->*
   (State (Listof (List Player (Listof (List Hotel Boolean)))))
   (Board)
   State))
(define (ext:state-return-shares s decisions (board (state-board s)))
   (unless (= (length (state-players s)) (length decisions))
     (error
      'state-return-shares
      (format "Precondition: need same number of players and decisions")))
   (state-return-shares s decisions board))
(:
  state-return-shares
  (->*
   (State (Listof (List Player (Listof (List Hotel Boolean)))))
   (Board)
   State))
(define (state-return-shares s decisions (board (state-board s)))
   (for/fold
    :
    State
    ((s : State s))
    ((d : (List Player (Listof (List Hotel Boolean))) decisions))
    (state-return-shares/player s (first d) (second d) board)))
(:
  state-return-shares/player
  (->* (State Player (Listof (List Hotel Boolean))) (Board) State))
(define (state-return-shares/player s p p-s-decisions (board (state-board s)))
   (define the-name (player-name p))
   (define player-s (player-shares p))
   (define transfers (shares-to-be-moved+their-value player-s p-s-decisions))
   (match-define (state _board players _tiles _hotels shares _bad) s)
   (define new-players
     (for/list
      :
      (Listof Player)
      ((q : Player players))
      (if (string=? (player-name q) the-name)
        (player-returns-shares q transfers board)
        q)))
   (struct-copy
    state
    s
    (shares (shares-plus shares transfers))
    (players new-players)))
(:
  shares-to-be-moved+their-value
  (-> Shares (Listof (List Hotel Boolean)) Shares))
(define (shares-to-be-moved+their-value player-s-shares decisions)
   (for/fold
    :
    Shares
    ((shares : Shares player-shares0))
    ((d : (List Hotel Boolean) decisions))
    (define hotel (first d))
    (cond
     ((second d) shares)
     (else
      (define available (shares-available player-s-shares hotel))
      (for/fold
       :
       Shares
       ((shares : Shares shares))
       ((n : Natural (in-range available)))
       (shares++ shares hotel))))))
(: state-score (-> State (Listof (List String Cash))))
(define (state-score s0)
   (define board (state-board s0))
   (define bonus (state-distribute-bonus board))
   (define state/bonus
     (foldr
      (lambda ((h : Hotel) (s : State))
        (if (= (size-of-hotel board h) 0) s (bonus h s)))
      s0
      ALL-HOTELS))
   (define scores
     (for/list
      :
      (Listof (List String Cash))
      ((p : Player (in-list (state-players state/bonus))))
      (match-define (player name _tiles money shares _external) p)
      (list name (+ money (shares->money shares board)))))
   (sort
    scores
    (lambda ((p : (List String Cash)) (q : (List String Cash)))
      (or (> (second p) (second q))
          (and (= (second p) (second q)) (string<=? (first p) (first q)))))))
(: shares->money (-> Shares Board Cash))
(define (shares->money shares board)
   (assert
    (for/sum
     :
     Integer
     (((hotel n) (in-hash shares)))
     (define size (size-of-hotel board hotel))
     (define price (price-per-share hotel size))
     (if (and (> size 0) price) (* price n) 0))
    exact-nonnegative-integer?))
(: state-final? (-> State Boolean))
(define (state-final? s)
   (define board (state-board s))
   (define-values
    (winner? founded safe)
    (for/fold
     :
     (Values Boolean (Listof Hotel) (Listof Hotel))
     ((winner? : Boolean #f)
      (founded : (Listof Hotel) '())
      (safe : (Listof Hotel) '()))
     ((h : Hotel ALL-HOTELS))
     (define s (size-of-hotel board h))
     (cond
      ((>= s SAFE#) (values (>= s FINAL#) (cons h founded) (cons h safe)))
      ((> s 0) (values winner? (cons h founded) safe))
      (else (values winner? founded safe)))))
   (or winner? (and (cons? founded) (= (length founded) (length safe)))))
