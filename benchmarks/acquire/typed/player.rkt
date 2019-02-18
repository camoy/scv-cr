#lang typed/racket/no-check
(define-values
  (g229
   g230
   g231
   g232
   g233
   g234
   g235
   g236
   g237
   g238
   g239
   g240
   g241
   g242
   g243
   g244
   g245
   g246
   g247
   g248
   g249
   g250
   g251
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
   generated-contract100
   g332
   generated-contract101
   generated-contract102)
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
    (letrec ((g229 (recursive-contract g285 #:impersonator))
             (g230 (recursive-contract g299 #:impersonator))
             (g231 (recursive-contract g304 #:impersonator))
             (g232 (recursive-contract g319 #:impersonator))
             (g233 (recursive-contract g327 #:impersonator))
             (g234 (recursive-contract g331 #:impersonator))
             (g235 exact-nonnegative-integer?)
             (g236 (or/c g235))
             (g237 g230)
             (g238 any/c)
             (g239 g233)
             (g240 (lambda (x) (equal? x (void))))
             (g241 (-> g238 g239 (values g240)))
             (g242 (lambda (x) (state? x)))
             (g243 (-> any/c any/c g240))
             (g244 string?)
             (g245 (listof g244))
             (g246 '#t)
             (g247 '#f)
             (g248 (or/c g246 g247))
             (g249 (listof g248))
             (g250 (-> g238 g245 (values g249)))
             (g251 (lambda (x) (tile? x)))
             (g252 (-> any/c any/c g240))
             (g253 (or/c g247 g251))
             (g254 (or/c g244 g247))
             (g255 (lambda (x) (player? x)))
             (g256 '())
             (g257 (cons/c g248 g256))
             (g258 (cons/c g244 g257))
             (g259 (listof g258))
             (g260 (cons/c g259 g256))
             (g261 (cons/c g255 g260))
             (g262 (listof g261))
             (g263 (-> g238 (values g253 g254 g262)))
             (g264 (listof g255))
             (g265 (-> g238 (values g264)))
             (g266 (or/c g240 g264))
             (g267 (-> g238 g251 g244 (values g266)))
             (g268 (-> g238 (values g248)))
             (g269 exact-integer?)
             (g270 (or/c g269))
             (g271 (typed-racket-hash/c g244 g270))
             (g272 (or/c g271))
             (g273 (-> g238 g272 (values g272)))
             (g274 'taken-no-hotel)
             (g275 'UNTAKEN)
             (g276 (or/c g244 g274 g275))
             (g277 (typed-racket-hash/c g251 g276))
             (g278 (or/c g277))
             (g279 (listof g251))
             (g280
              (object/c-opaque
               (decisions g263)
               (eliminated g265)
               (place g267)
               (place-called g268)
               (reconcile-shares g273)
               (field (board g278))
               (field (cash g236))
               (field (current g255))
               (field (current-state g242))
               (field (hotels g245))
               (field (players g264))
               (field (shares g272))
               (field (tiles g279))))
             (g281 (-> g238 g280 (values g253 g254 g245)))
             (g282 any/c)
             (g283 (-> g238 g242 g282 (values g240)))
             (g284 (-> g280 (values g253 g254 g245)))
             (g285
              (object/c
               (go g241)
               (inform g243)
               (keep g250)
               (receive-tile g252)
               (setup g243)
               (take-turn g281)
               (the-end g283)
               (field (*bad g264))
               (field (*players g264))
               (field (choice g284))
               (field (name g244))))
             (g286 g234)
             (g287 (-> g238 g286 (values g240)))
             (g288 (-> g238 g242 (values g240)))
             (g289 (-> g238 g245 (values g249)))
             (g290 (-> g238 g251 (values g240)))
             (g291 (-> g238 (values g253 g254 g262)))
             (g292 (-> g238 (values g264)))
             (g293 (-> g238 g251 g244 (values g266)))
             (g294 (-> g238 (values g248)))
             (g295 (-> g238 g272 (values g272)))
             (g296
              (object/c
               (decisions g291)
               (eliminated g292)
               (place g293)
               (place-called g294)
               (reconcile-shares g295)
               (field (board g278))
               (field (cash g236))
               (field (current g255))
               (field (current-state g242))
               (field (hotels g245))
               (field (players g264))
               (field (shares g272))
               (field (tiles g279))))
             (g297 (-> g238 g296 (values g253 g254 g245)))
             (g298 (-> g238 g242 g238 (values g240)))
             (g299
              (object/c-opaque
               (go g287)
               (inform g288)
               (keep g289)
               (receive-tile g290)
               (setup g288)
               (take-turn g297)
               (the-end g298)
               (field (*bad g264))
               (field (*players g264))
               (field (choice g284))
               (field (name g244))))
             (g300 g232)
             (g301 (-> g238 g300 (values g240)))
             (g302 (-> g238 g280 (values g253 g254 g245)))
             (g303 (-> g238 g242 g282 (values g240)))
             (g304
              (object/c-opaque
               (go g301)
               (inform g288)
               (keep g289)
               (receive-tile g290)
               (setup g288)
               (take-turn g302)
               (the-end g303)
               (field (*bad g264))
               (field (*players g264))
               (field (choice g284))
               (field (name g244))))
             (g305 (-> (values g240)))
             (g306 'IMPOSSIBLE)
             (g307 'score)
             (g308 'exhausted)
             (g309 'done)
             (g310 (or/c g306 g307 g308 g309))
             (g311 (listof g242))
             (g312 (cons/c g311 g256))
             (g313 (cons/c g238 g312))
             (g314 (cons/c g310 g313))
             (g315 (->* (g238 g236) (#:show g305) (values g314)))
             (g316 (-> g238 (values g245)))
             (g317 (-> g238 g244 g237 (values g244)))
             (g318 (-> g279 (values g251)))
             (g319
              (object/c
               (run g315)
               (show-players g316)
               (sign-up g317)
               (field (next-tile g318))))
             (g320 (-> g240))
             (g321 (cons/c g282 g312))
             (g322 (cons/c g310 g321))
             (g323 (->* (g238 g236) (#:show g320) (values g322)))
             (g324 (-> g238 (values g245)))
             (g325 g231)
             (g326 (-> g238 g244 g325 (values g244)))
             (g327
              (object/c-opaque
               (run g323)
               (show-players g324)
               (sign-up g326)
               (field (next-tile g318))))
             (g328 (->* (g238 g236) (#:show g305) (values g322)))
             (g329 g229)
             (g330 (-> g238 g244 g329 (values g244)))
             (g331
              (object/c-opaque
               (run g328)
               (show-players g324)
               (sign-up g330)
               (field (next-tile g318))))
             (generated-contract100 (-> g236 (values g237)))
             (g332 (listof g237))
             (generated-contract101 (-> g236 (values g332)))
             (generated-contract102 (-> g236 (values g332))))
      (values
       g229
       g230
       g231
       g232
       g233
       g234
       g235
       g236
       g237
       g238
       g239
       g240
       g241
       g242
       g243
       g244
       g245
       g246
       g247
       g248
       g249
       g250
       g251
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
       generated-contract100
       g332
       generated-contract101
       generated-contract102))))
(require (only-in racket/contract contract-out))
(provide (contract-out (inf-loop-player generated-contract100))
          (contract-out (ordered-players generated-contract101))
          (contract-out (random-players generated-contract102)))
(provide)
(require require-typed-check "../base/types.rkt" "state-adapted.rkt")
(require "admin.rkt")
(require "basics.rkt")
(require "strategy.rkt")
(: create (-> String Strategy (Instance Player%)))
(define (create n c) (new player% (name n) (choice c)))
(: player% Player%)
(define player%
   (class object%
     (init-field name choice)
     (super-new)
     (field (*players '()) (*bad '()))
     (: *my-game-name String)
     (define *my-game-name "")
     (define/public
      (go administrator)
      (set! *my-game-name (send administrator sign-up name this)))
     (define/public (setup s) (bad-players (state-players s)))
     (define/public
      (take-turn turn)
      (bad-players (get-field players turn))
      (choice (reconcile turn)))
     (define/public
      (keep hotels)
      (map (lambda (h) (< (random 100) 50)) hotels))
     (define/public (receive-tile t) (void))
     (define/public (inform s) (bad-players (state-players s)))
     (define/public (the-end state results) (void))
     (: bad-players (-> (Listof Player) Void))
     (define/private
      (bad-players players)
      (set! *bad
        (for/fold
         :
         (Listof Player)
         ((bad : (Listof Player) *bad))
         ((old-player : Player (in-list *players)))
         (define n (player-name old-player))
         (if (findf
              (lambda ((current : Player)) (string=? (player-name current) n))
              players)
           bad
           (cons old-player bad))))
      (set! *players players))
     (: reconcile (-> (Instance Turn%) (Instance Turn%)))
     (define/private
      (reconcile turn)
      (define bad-shares (*combine-shares (map player-shares *bad)))
      (send turn reconcile-shares bad-shares)
      turn)))
(: players (-> Strategy Natural (Listof (Instance Player%))))
(define (players S n)
   (for/list
    ((name '("a" "b" "c" "d" "e" "f")) (i (in-range n)))
    (create name S)))
(: random-players (-> Natural (Listof (Instance Player%))))
(define (random-players n) (players random-s n))
(: ordered-players (-> Natural (Listof (Instance Player%))))
(define (ordered-players n) (players ordered-s n))
(: inf-loop-player (-> Natural (Instance Player%)))
(define (inf-loop-player n)
   (define m 0)
   (: S Strategy)
   (define (S t)
     (if (> n m) (begin (set! m (+ m 1)) (ordered-s t)) (let L () (L))))
   (create (format "inf loop after ~a" n) S))
