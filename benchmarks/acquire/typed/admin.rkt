#lang typed/racket/no-check
(define-values
  (g255
   g256
   g257
   g252
   g253
   g254
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
   g347
   g348
   g349
   g350
   g351
   g352
   g353
   g354
   g355
   g359
   g360
   g361
   g362
   g363
   g367
   g368
   g369
   g370
   generated-contract233
   g376
   generated-contract234)
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
    (letrec ((g255 (recursive-contract g310 #:impersonator))
             (g256 (recursive-contract g324 #:impersonator))
             (g257 (recursive-contract g329 #:impersonator))
             (g252 (recursive-contract g348 #:impersonator))
             (g253 (recursive-contract g360 #:impersonator))
             (g254 (recursive-contract g367 #:impersonator))
             (g258 (recursive-contract g368 #:impersonator))
             (g259 (recursive-contract g369 #:impersonator))
             (g260 (recursive-contract g370 #:impersonator))
             (g261 any/c)
             (g262 g259)
             (g263 (lambda (x) (equal? x (void))))
             (g264 (-> g261 g262 (values g263)))
             (g265 (lambda (x) (state? x)))
             (g266 (-> any/c any/c g263))
             (g267 string?)
             (g268 (listof g267))
             (g269 '#t)
             (g270 '#f)
             (g271 (or/c g269 g270))
             (g272 (listof g271))
             (g273 (-> g261 g268 (values g272)))
             (g274 (lambda (x) (tile? x)))
             (g275 (-> any/c any/c g263))
             (g276 (or/c g270 g274))
             (g277 (or/c g267 g270))
             (g278 (lambda (x) (player? x)))
             (g279 '())
             (g280 (cons/c g271 g279))
             (g281 (cons/c g267 g280))
             (g282 (listof g281))
             (g283 (cons/c g282 g279))
             (g284 (cons/c g278 g283))
             (g285 (listof g284))
             (g286 (-> g261 (values g276 g277 g285)))
             (g287 (listof g278))
             (g288 (-> g261 (values g287)))
             (g289 (or/c g263 g287))
             (g290 (-> g261 g274 g267 (values g289)))
             (g291 (-> g261 (values g271)))
             (g292 exact-integer?)
             (g293 (or/c g292))
             (g294 (typed-racket-hash/c g267 g293))
             (g295 (or/c g294))
             (g296 (-> g261 g295 (values g295)))
             (g297 'UNTAKEN)
             (g298 'taken-no-hotel)
             (g299 (or/c g267 g297 g298))
             (g300 (typed-racket-hash/c g274 g299))
             (g301 (or/c g300))
             (g302 exact-nonnegative-integer?)
             (g303 (or/c g302))
             (g304 (listof g274))
             (g305
              (object/c-opaque
               (decisions g286)
               (eliminated g288)
               (place g290)
               (place-called g291)
               (reconcile-shares g296)
               (field (board g301))
               (field (cash g303))
               (field (current g278))
               (field (current-state g265))
               (field (hotels g268))
               (field (players g287))
               (field (shares g295))
               (field (tiles g304))))
             (g306 (-> g261 g305 (values g276 g277 g268)))
             (g307 any/c)
             (g308 (-> g261 g265 g307 (values g263)))
             (g309 (-> g305 (values g276 g277 g268)))
             (g310
              (object/c
               (go g264)
               (inform g266)
               (keep g273)
               (receive-tile g275)
               (setup g266)
               (take-turn g306)
               (the-end g308)
               (field (*bad g287))
               (field (*players g287))
               (field (choice g309))
               (field (name g267))))
             (g311 g260)
             (g312 (-> g261 g311 (values g263)))
             (g313 (-> g261 g265 (values g263)))
             (g314 (-> g261 g268 (values g272)))
             (g315 (-> g261 g274 (values g263)))
             (g316 (-> g261 (values g276 g277 g285)))
             (g317 (-> g261 (values g287)))
             (g318 (-> g261 g274 g267 (values g289)))
             (g319 (-> g261 (values g271)))
             (g320 (-> g261 g295 (values g295)))
             (g321
              (object/c
               (decisions g316)
               (eliminated g317)
               (place g318)
               (place-called g319)
               (reconcile-shares g320)
               (field (board g301))
               (field (cash g303))
               (field (current g278))
               (field (current-state g265))
               (field (hotels g268))
               (field (players g287))
               (field (shares g295))
               (field (tiles g304))))
             (g322 (-> g261 g321 (values g276 g277 g268)))
             (g323 (-> g261 g265 g261 (values g263)))
             (g324
              (object/c-opaque
               (go g312)
               (inform g313)
               (keep g314)
               (receive-tile g315)
               (setup g313)
               (take-turn g322)
               (the-end g323)
               (field (*bad g287))
               (field (*players g287))
               (field (choice g309))
               (field (name g267))))
             (g325 g258)
             (g326 (-> g261 g325 (values g263)))
             (g327 (-> g261 g305 (values g276 g277 g268)))
             (g328 (-> g261 g265 g307 (values g263)))
             (g329
              (object/c-opaque
               (go g326)
               (inform g313)
               (keep g314)
               (receive-tile g315)
               (setup g313)
               (take-turn g327)
               (the-end g328)
               (field (*bad g287))
               (field (*players g287))
               (field (choice g309))
               (field (name g267))))
             (g330 (-> (values g263)))
             (g331 'IMPOSSIBLE)
             (g332 'score)
             (g333 'exhausted)
             (g334 'done)
             (g335 (or/c g331 g332 g333 g334))
             (g336 (listof g265))
             (g337 (cons/c g336 g279))
             (g338 (cons/c g261 g337))
             (g339 (cons/c g335 g338))
             (g340 (->* (g261 g303) (#:show g330) (values g339)))
             (g341 (-> g261 (values g268)))
             (g342 g256)
             (g343 (-> g261 g267 g342 (values g267)))
             (g347 (-> g304 (values g274)))
             (g348
              (let ((g340344 g340) (g341345 g341) (g343346 g343))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (next-tile g347))
                 (field (next-tile g347))
                 (run g340344)
                 (show-players g341345)
                 (sign-up g343346)
                 (override (run g340344)
                           (show-players g341345)
                           (sign-up g343346))
                 (super (run g340344) (show-players g341345) (sign-up g343346))
                 (inherit (run g340344)
                          (show-players g341345)
                          (sign-up g343346))
                 (augment)
                 (inherit)
                 (absent))))
             (g349 (-> g263))
             (g350 (cons/c g307 g337))
             (g351 (cons/c g335 g350))
             (g352 (->* (g261 g303) (#:show g349) (values g351)))
             (g353 (-> g261 (values g268)))
             (g354 g257)
             (g355 (-> g261 g267 g354 (values g267)))
             (g359 (-> g304 (values g274)))
             (g360
              (let ((g352356 g352) (g353357 g353) (g355358 g355))
                (class/c
                 (init (next-tile g359))
                 (field (next-tile g347))
                 (run g352356)
                 (show-players g353357)
                 (sign-up g355358)
                 (override (run g352356)
                           (show-players g353357)
                           (sign-up g355358))
                 (super (run g352356) (show-players g353357) (sign-up g355358))
                 (inherit (run g352356)
                          (show-players g353357)
                          (sign-up g355358))
                 (augment)
                 (inherit)
                 (absent))))
             (g361 (->* (g261 g303) (#:show g330) (values g351)))
             (g362 g255)
             (g363 (-> g261 g267 g362 (values g267)))
             (g367
              (let ((g361364 g361) (g353365 g353) (g363366 g363))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (next-tile g347))
                 (field (next-tile g347))
                 (run g361364)
                 (show-players g353365)
                 (sign-up g363366)
                 (override (run g361364)
                           (show-players g353365)
                           (sign-up g363366))
                 (super (run g361364) (show-players g353365) (sign-up g363366))
                 (inherit (run g361364)
                          (show-players g353365)
                          (sign-up g363366))
                 (augment)
                 (inherit)
                 (absent))))
             (g368
              (object/c
               (run g340)
               (show-players g341)
               (sign-up g343)
               (field (next-tile g347))))
             (g369
              (object/c-opaque
               (run g352)
               (show-players g353)
               (sign-up g355)
               (field (next-tile g347))))
             (g370
              (object/c-opaque
               (run g361)
               (show-players g353)
               (sign-up g363)
               (field (next-tile g347))))
             (generated-contract233 g253)
             (g376
              (let ((g286371 g286)
                    (g288372 g288)
                    (g290373 g290)
                    (g291374 g291)
                    (g296375 g296))
                (class/c
                 (init (current-state g265))
                 (field (board g301))
                 (field (cash g303))
                 (field (current g278))
                 (field (current-state g265))
                 (field (hotels g268))
                 (field (players g287))
                 (field (shares g295))
                 (field (tiles g304))
                 (decisions g286371)
                 (eliminated g288372)
                 (place g290373)
                 (place-called g291374)
                 (reconcile-shares g296375)
                 (override (decisions g286371)
                           (eliminated g288372)
                           (place g290373)
                           (place-called g291374)
                           (reconcile-shares g296375))
                 (super
                  (decisions g286371)
                  (eliminated g288372)
                  (place g290373)
                  (place-called g291374)
                  (reconcile-shares g296375))
                 (inherit (decisions g286371)
                          (eliminated g288372)
                          (place g290373)
                          (place-called g291374)
                          (reconcile-shares g296375))
                 (augment)
                 (inherit)
                 (absent))))
             (generated-contract234 g376))
      (values
       g255
       g256
       g257
       g252
       g253
       g254
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
       g347
       g348
       g349
       g350
       g351
       g352
       g353
       g354
       g355
       g359
       g360
       g361
       g362
       g363
       g367
       g368
       g369
       g370
       generated-contract233
       g376
       generated-contract234))))
(require (only-in racket/contract contract-out))
(provide (contract-out (administrator% generated-contract233))
          (contract-out (turn% generated-contract234)))
(provide Administrator% Turn%)
(require require-typed-check
          "../base/types.rkt"
          "board-adapted.rkt"
          "state-adapted.rkt"
          "tree-adapted.rkt")
(require racket/sandbox)
(require "basics.rkt")
(:
  in-sandbox
  (All
   (A B)
   (->* ((-> A) (-> A B) (-> Any B)) (#:time Natural #:memory Natural) B)))
(define (in-sandbox
          producer
          consumer
          failure
          #:time
          (sec-limit 1)
          #:memory
          (mb-limit 30))
   ((let/ec
     fail
     :
     (-> B)
     (let ((a
            :
            A
            (with-handlers
             ((exn:fail:resource?
               (lambda ((x : Any)) (fail (lambda () (failure 'R)))))
              (exn:fail:out-of-memory?
               (lambda ((x : Any)) (fail (lambda () (failure 'R)))))
              (exn:fail? (lambda ((x : Any)) (fail (lambda () (failure 'X))))))
             ((inst call-with-limits A) sec-limit mb-limit producer))))
       (lambda () (consumer a))))))
(: log (-> Any Any Void))
(define (log status msg) (void))
(: administrator% Administrator%)
(define administrator%
   (class object%
     (init-field next-tile)
     (super-new)
     (: *count Natural)
     (define *count 10)
     (: *named-players (Listof (List String (Instance Player%))))
     (define *named-players '())
     (define/public
      (sign-up name player)
      (define pre (if (< (random 100) 50) "player" "spieler"))
      (set! *count (+ *count 1 (random 10)))
      (set! name (format "~a~a:~a" pre (number->string *count) name))
      (set! *named-players (cons (list name player) *named-players))
      name)
     (define/public
      (show-players)
      (for/list : (Listof String) ((n+p (in-list *named-players))) (car n+p)))
     (define/public
      (run turns# #:show (show void))
      (define players (player->internals))
      (when (empty? players) (error 'run "players failed to sign up properly"))
      (define tree0 (generate-tree (setup-all players (apply state0 players))))
      (let loop :
        RunResult
        ((tree : (Instance ATree%) tree0)
         (n : Integer turns#)
         (states : (Listof State) (list (tree-state tree0))))
        (define state (tree-state tree))
        (cond
         ((= n 0) (list DONE (state-score state) (reverse states)))
         ((empty? (state-players state))
          (list EXHAUSTED (state-score state) (reverse states)))
         ((and (is-a? tree lplaced%) (send tree nothing-to-place?))
          (finish state)
          (list SCORE (state-score state) (reverse states)))
         (else
          (define external
            (or (player-external (state-current-player state))
                (error 'external/fail)))
          (define turn (new turn% (current-state state)))
          ((inst
            in-sandbox
            (List (Option Tile) (Option Hotel) (Listof Hotel))
            RunResult)
           #:time
           (* (+ (length (state-players state)) 1) 3)
           (lambda ()
             (let-values (((a b c) (send external take-turn turn)))
               (list a b c)))
           (lambda ((arg : (List (Option Tile) (Option Hotel) (Listof Hotel))))
             (define-values
              (tile hotel-involved buy-shares)
              (values (car arg) (cadr arg) (caddr arg)))
             (cond
              ((boolean? tile)
               (finish state)
               (list
                IMPOSSIBLE
                (state-score state)
                (reverse (cons state states))))
              ((not hotel-involved) (error "bad hotel"))
              (else
               (define merger?
                 (eq? (what-kind-of-spot (state-board state) tile) MERGING))
               (cond
                ((and merger? (not (send turn place-called)))
                 (loop
                  (generate-tree (state-remove-current-player state))
                  (- n 1)
                  states))
                (else
                 (define-values
                  (t1 h1 d*)
                  (if merger? (send turn decisions) (values #f #f '())))
                 (and (equal? tile t1) (equal? hotel-involved h1))
                 (define eliminate (send turn eliminated))
                 (cond
                  ((member (state-current-player state) eliminate)
                   ((failure
                     state
                     states
                     (lambda ((s : (Instance ATree%)))
                       (loop s (- n 1) states)))
                    `(S "current player failed on keep")))
                  (else
                   (define tree/eliminate
                     (if (empty? eliminate)
                       tree
                       (generate-tree (state-eliminate state eliminate))))
                   (exec
                    external
                    tree/eliminate
                    tile
                    hotel-involved
                    d*
                    buy-shares
                    (lambda ((next-tree : (Instance ATree%)) (state : State))
                      (inform-all
                       next-tree
                       state
                       (lambda ((next-tree : (Instance ATree%))
                                (state : State))
                         (cond
                          ((empty? (state-tiles state))
                           (finish state)
                           (list
                            EXHAUSTED
                            (state-score state)
                            (reverse states)))
                          (else
                           (loop next-tree (- n 1) (cons state states)))))))
                    (failure
                     state
                     states
                     (lambda ((s : (Instance ATree%)))
                       (loop s (- n 1) states)))))))))))
           (failure
            state
            states
            (lambda ((s : (Instance ATree%))) (loop s (- n 1) states))))))))
     (:
      failure
      (->
       State
       (Listof State)
       (-> (Instance ATree%) RunResult)
       (-> Any RunResult)))
     (define/private
      ((failure state states continue) status)
      (log status `(turn failure ,(player-name (state-current-player state))))
      (define state/eliminate (state-remove-current-player state))
      (if (empty? (state-players state/eliminate))
        (list EXHAUSTED '(all players failed) (reverse states))
        (continue (generate-tree state/eliminate))))
     (:
      exec
      (->
       (Instance Player%)
       (Instance ATree%)
       Tile
       Hotel
       Decisions
       (Listof Hotel)
       (-> (Instance ATree%) State RunResult)
       (-> Any RunResult)
       RunResult))
     (define/private
      (exec external tree0 placement hotel decisions shares-to-buy succ fail)
      (define-values
       (tile tree)
       (tree-next tree0 placement hotel decisions shares-to-buy next-tile))
      (unless tile (error 'no-tile))
      ((inst in-sandbox Void RunResult)
       (lambda () (send external receive-tile tile))
       (lambda (_void) (succ tree (tree-state tree)))
       fail))
     (:
      inform-all
      (All (A) (-> (Instance ATree%) State (-> (Instance ATree%) State A) A)))
     (define/private
      (inform-all tree state k)
      (define eliminate
        (for/fold
         :
         (Listof Player)
         ((throw-out : (Listof Player) '()))
         ((p : Player (state-players state)))
         ((inst in-sandbox Void (Listof Player))
          (lambda arg*
            (let ((pe (or (player-external p) (error 'external-fail))))
              (send pe inform state)))
          (lambda (_void) throw-out)
          (lambda arg*
            (log (car arg*) `(inform ,(player-name p)))
            (cons p throw-out)))))
      (cond
       ((empty? eliminate) (k tree state))
       (else
        (define state/eliminate (state-eliminate state eliminate))
        (k (generate-tree state/eliminate) state/eliminate))))
     (: player->internals (-> (Listof Player)))
     (define/private
      (player->internals)
      (define-values
       (internals _)
       (for/fold
        :
        (values (Listof Player) (Listof Tile))
        ((internals : (Listof Player) '()) (tile* : (Listof Tile) ALL-TILES))
        ((name+eplayer : (List String (Instance Player%)) *named-players))
        (define name (first name+eplayer))
        (define tiles (take tile* STARTER-TILES#))
        (define player
          (let ((t1 (first tiles))
                (t2 (second tiles))
                (t3 (third tiles))
                (t4 (fourth tiles))
                (t5 (fifth tiles))
                (t6 (sixth tiles)))
            (player0 name t1 t2 t3 t4 t5 t6 (second name+eplayer))))
        (values (cons player internals) (drop tile* STARTER-TILES#))))
      internals)
     (: setup-all (-> (Listof Player) State State))
     (define/private
      (setup-all players state)
      (define misbehaving
        (for/fold
         :
         (Listof Player)
         ((misbehaving : (Listof Player) '()))
         ((p : Player players))
         ((inst in-sandbox Void (Listof Player))
          (lambda arg*
            (let ((pe (or (player-external p) (error 'external-failed))))
              (send pe setup state)))
          (lambda (_void) misbehaving)
          (lambda status
            (log status `(setup ,(player-name p)))
            (cons p misbehaving)))))
      (if (empty? misbehaving) state (state-eliminate state misbehaving)))
     (: finish (-> State Void))
     (define/private
      (finish state)
      (define score (state-score state))
      (for
       ((e : Player (state-players state)))
       ((inst in-sandbox Void Void)
        (lambda ()
          (send (or (player-external e) (error 'noexternal)) the-end
            state
            score))
        void
        (lambda (status) (log status `(end game ,(player-name e)))))))))
(define DONE 'done)
(define EXHAUSTED 'exhausted)
(define SCORE 'score)
(: turn% Turn%)
(define turn%
   (class object%
     (init-field current-state)
     (field
      (board (state-board current-state))
      (current (state-current-player current-state))
      (cash (player-money current))
      (tiles (player-tiles current))
      (shares (state-shares current-state))
      (hotels (state-hotels current-state))
      (players (state-players current-state)))
     (super-new)
     (define/public (reconcile-shares t) t)
     (define/public (eliminated) *eliminated)
     (define/public (decisions) (values *tile *hotel *decisions))
     (define/public (place-called) *called)
     (: *tile (Option Tile))
     (define *tile #f)
     (: *hotel (Option Hotel))
     (define *hotel #f)
     (: *decisions Decisions)
     (define *decisions '())
     (: *eliminated (Listof Player))
     (define *eliminated '())
     (: *called Boolean)
     (define *called #f)
     (define/public
      (place tile hotel)
      (unless *called
        (set! *called #t)
        (set! *tile tile)
        (set! *hotel hotel)
        (define-values (acquirers acquired) (merging-which board tile))
        (define acquired-hotels (append (remove hotel acquirers) acquired))
        (let keep-to-all :
          Any
          ((players : (Listof Player) players))
          (unless (empty? players)
            (define p (first players))
            ((inst in-sandbox (Listof Boolean) Any)
             (lambda ()
               (define ex (player-external p))
               (if (boolean? ex)
                 (map (lambda (_) #t) acquired-hotels)
                 (send ex keep acquired-hotels)))
             (lambda ((p-s-decisions : (Listof Boolean)))
               (set! *decisions
                 (cons
                  (list
                   p
                   (for/list
                    :
                    (Listof (List Hotel Boolean))
                    ((h : Hotel (in-list acquired-hotels))
                     (d : Any (in-list p-s-decisions)))
                    (list h (if d #t #f))))
                  *decisions))
               (keep-to-all (rest players)))
             (lambda (status)
               (log status `(keep failure ,(player-name p)))
               (set! *eliminated (cons p *eliminated))
               (keep-to-all (rest players))))))
        (define state/eliminated (state-eliminate current-state *eliminated))
        (define state/returns
          (state-return-shares state/eliminated *decisions))
        (set! current-state state/returns)
        (state-players state/returns)))))
