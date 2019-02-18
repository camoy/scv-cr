#lang typed/racket/base/no-check
(define-values
  (g250
   g251
   g252
   g247
   g248
   g249
   g244
   g245
   g246
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
   g309
   g310
   g317
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
   generated-contract193)
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
    (letrec ((g250 (recursive-contract g296 #:impersonator))
             (g251 (recursive-contract g301 #:impersonator))
             (g252 (recursive-contract g302 #:impersonator))
             (g247 (recursive-contract g310 #:impersonator))
             (g248 (recursive-contract g317 #:impersonator))
             (g249 (recursive-contract g324 #:impersonator))
             (g244 (recursive-contract g333 #:impersonator))
             (g245 (recursive-contract g340 #:impersonator))
             (g246 (recursive-contract g340 #:impersonator))
             (g253 any/c)
             (g254 g245)
             (g255 (lambda (x) (card? x)))
             (g256 (listof g255))
             (g257 (-> g253 g254 (values g256)))
             (g258 exact-nonnegative-integer?)
             (g259 (or/c g258))
             (g260 (-> g253 (values g259)))
             (g261 (lambda (x) (equal? x (void))))
             (g262 (-> g253 g256 (values g261)))
             (g263 (-> g253 g254 (values g255)))
             (g264 (-> g256 (values g256)))
             (g265
              (object/c
               (choose g257)
               (name g260)
               (start-round g262)
               (start-turn g263)
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))))
             (g266 (listof g265))
             (g267 '#t)
             (g268 '#f)
             (g269 (or/c g267 g268))
             (g270 (-> g253 (values g269)))
             (g271 (-> g256 (values g256)))
             (g272 (-> (values g259)))
             (g273 symbol?)
             (g274 '())
             (g275 (cons/c g259 g274))
             (g276 (cons/c g273 g275))
             (g277 (cons/c g259 g275))
             (g278 (listof g277))
             (g279 (cons/c g278 g274))
             (g280 (cons/c g276 g279))
             (g281 (->* (g253) (g271 g272) (values g280)))
             (g282 (-> g253 g271 g272 (values g261)))
             (g283 (-> g253 g259 (values g280)))
             (g284 g247)
             (g285 g250)
             (g286 (listof g285))
             (g287 g244)
             (g288 (-> g253 g287 (values g256)))
             (g289 (-> g253 (values g259)))
             (g290 (-> g253 g256 (values g261)))
             (g291 (-> g253 g287 (values g255)))
             (g292
              (object/c-opaque
               (choose g288)
               (name g289)
               (start-round g290)
               (start-turn g291)
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))))
             (g293 (listof g292))
             (g294
              (object/c-opaque
               (any-player-done? g270)
               (play-game g281)
               (play-round g282)
               (present-results g283)
               (field (internal% g284))
               (field (internals g286))
               (field (players g293))))
             (g295 (-> g253 g259 (values g261)))
             (g296
              (object/c
               (add-score g295)
               (bulls g260)
               (choose g257)
               (name g260)
               (start-round g262)
               (start-turn g263)
               (field (my-bulls g259))
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))
               (field (player g292))))
             (g297 (-> g253 g259 (values g261)))
             (g298 g246)
             (g299 (-> g253 g298 (values g256)))
             (g300 (-> g253 g298 (values g255)))
             (g301
              (object/c-opaque
               (add-score g297)
               (bulls g289)
               (choose g299)
               (name g289)
               (start-round g290)
               (start-turn g300)
               (field (my-bulls g259))
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))
               (field (player g292))))
             (g302
              (object/c-opaque
               (add-score g297)
               (bulls g289)
               (choose g288)
               (name g289)
               (start-round g290)
               (start-turn g291)
               (field (my-bulls g259))
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))
               (field (player g292))))
             (g309
              (object/c-opaque
               (choose g299)
               (name g289)
               (start-round g290)
               (start-turn g300)
               (field (my-cards g256))
               (field (n g259))
               (field (order g264))))
             (g310
              (let ((g295303 g295)
                    (g260304 g260)
                    (g257305 g257)
                    (g260306 g260)
                    (g262307 g262)
                    (g263308 g263))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (player g309))
                 (field (my-bulls g259))
                 (field (my-cards g256))
                 (field (n g259))
                 (field (order g264))
                 (field (player g292))
                 (add-score g295303)
                 (bulls g260304)
                 (choose g257305)
                 (name g260306)
                 (start-round g262307)
                 (start-turn g263308)
                 (override (add-score g295303)
                           (bulls g260304)
                           (choose g257305)
                           (name g260306)
                           (start-round g262307)
                           (start-turn g263308))
                 (super
                  (add-score g295303)
                  (bulls g260304)
                  (choose g257305)
                  (name g260306)
                  (start-round g262307)
                  (start-turn g263308))
                 (inherit (add-score g295303)
                          (bulls g260304)
                          (choose g257305)
                          (name g260306)
                          (start-round g262307)
                          (start-turn g263308))
                 (augment)
                 (inherit)
                 (absent))))
             (g317
              (let ((g297311 g297)
                    (g289312 g289)
                    (g299313 g299)
                    (g289314 g289)
                    (g290315 g290)
                    (g300316 g300))
                (class/c
                 (init (player g265))
                 (field (my-bulls g259))
                 (field (my-cards g256))
                 (field (n g259))
                 (field (order g264))
                 (field (player g292))
                 (add-score g297311)
                 (bulls g289312)
                 (choose g299313)
                 (name g289314)
                 (start-round g290315)
                 (start-turn g300316)
                 (override (add-score g297311)
                           (bulls g289312)
                           (choose g299313)
                           (name g289314)
                           (start-round g290315)
                           (start-turn g300316))
                 (super
                  (add-score g297311)
                  (bulls g289312)
                  (choose g299313)
                  (name g289314)
                  (start-round g290315)
                  (start-turn g300316))
                 (inherit (add-score g297311)
                          (bulls g289312)
                          (choose g299313)
                          (name g289314)
                          (start-round g290315)
                          (start-turn g300316))
                 (augment)
                 (inherit)
                 (absent))))
             (g324
              (let ((g297318 g297)
                    (g289319 g289)
                    (g288320 g288)
                    (g289321 g289)
                    (g290322 g290)
                    (g291323 g291))
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (player g292))
                 (field (my-bulls g259))
                 (field (my-cards g256))
                 (field (n g259))
                 (field (order g264))
                 (field (player g292))
                 (add-score g297318)
                 (bulls g289319)
                 (choose g288320)
                 (name g289321)
                 (start-round g290322)
                 (start-turn g291323)
                 (override (add-score g297318)
                           (bulls g289319)
                           (choose g288320)
                           (name g289321)
                           (start-round g290322)
                           (start-turn g291323))
                 (super
                  (add-score g297318)
                  (bulls g289319)
                  (choose g288320)
                  (name g289321)
                  (start-round g290322)
                  (start-turn g291323))
                 (inherit (add-score g297318)
                          (bulls g289319)
                          (choose g288320)
                          (name g289321)
                          (start-round g290322)
                          (start-turn g291323))
                 (augment)
                 (inherit)
                 (absent))))
             (g325 (-> g253 (values g256)))
             (g326 (-> g253 g255 (values g256)))
             (g327 (-> g253 g255 (values g269)))
             (g328 (-> any/c any/c g261))
             (g329 (-> g253 g256 g255 (values g259)))
             (g330 (or/c g255 g256))
             (g331 (-> g253 g255 g330 (values g259)))
             (g332 (listof g256))
             (g333
              (object/c
               (fewest-bulls g325)
               (fit g326)
               (larger-than-some-top-of-stacks? g327)
               (push g328)
               (replace g329)
               (replace-stack g331)
               (field (cards0 g256))
               (field (my-stacks g332))))
             (g334 (-> g253 (values g256)))
             (g335 (-> g253 g255 (values g256)))
             (g336 (-> g253 g255 (values g269)))
             (g337 (-> g253 g255 (values g261)))
             (g338 (-> g253 g256 g255 (values g259)))
             (g339 (-> g253 g255 g330 (values g259)))
             (g340
              (object/c-opaque
               (fewest-bulls g334)
               (fit g335)
               (larger-than-some-top-of-stacks? g336)
               (push g337)
               (replace g338)
               (replace-stack g339)
               (field (cards0 g256))
               (field (my-stacks g332))))
             (generated-contract193 (-> g266 (values g294))))
      (values
       g250
       g251
       g252
       g247
       g248
       g249
       g244
       g245
       g246
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
       g309
       g310
       g317
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
       generated-contract193))))
(require (only-in racket/contract contract-out))
(provide (contract-out (create-dealer generated-contract193)))
(provide)
(require "basics-types.rkt"
          "card-adapted.rkt"
          "card-pool-types.rkt"
          "dealer-types.rkt"
          "deck-types.rkt"
          "player-types.rkt"
          racket/list
          require-typed-check
          typed/racket/class)
(require "basics.rkt")
(require "card-pool.rkt")
(require "deck.rkt")
(require "player.rkt")
(: default-order (-> (Listof Card) (Listof Card)))
(define (default-order loc) ((inst sort Card Natural) loc > #:key card-face))
(: default-faces (-> Bulls))
(define (default-faces) MIN-BULL)
(: create-dealer (-> (Listof Player) Dealer))
(define (create-dealer players) (new dealer% (players players)))
(define dealer%
   :
   Dealer%
   (class object%
     (init-field (players : (Listof Player)))
     (super-new)
     (field
      (internal%
       :
       Internal%
       (class player%
         (init-field player)
         (super-new (n (send player name)) (order default-order))
         (field (my-bulls 0))
         (define/public (bulls) (get-field my-bulls this))
         (define/public
          (add-score n)
          (set-field! my-bulls this (+ n (get-field my-bulls this))))))
      (internals
       (for/list
        :
        (Listof Internal)
        ((p : Player (in-list (get-field players this))))
        (new internal% (player p)))))
     (define/public
      (play-game (shuffle values) (faces default-faces))
      (define n (length (get-field internals this)))
      (when (> (+ (* n HAND) STACKS) FACE)
        (error 'play-game "cannot play with ~a players; more cards needed" n))
      (let play-game :
        Result
        ((i : Natural 1))
        (play-round shuffle faces)
        (if (any-player-done?) (present-results i) (play-game (+ i 1)))))
     (define/public
      (present-results i)
      (define sorted
        ((inst sort Internal Natural)
         (get-field internals this)
         <
         #:key
         (lambda ((i : Internal)) (send i bulls))))
      `((after-round ,i)
        ,(for/list
          :
          (Listof (List Name Natural))
          ((p : Internal (in-list sorted)))
          `(,(send p name) ,(send p bulls)))))
     (define/public
      (any-player-done?)
      (for/or
       :
       Boolean
       ((p : Internal (in-list (get-field internals this))))
       (> (send p bulls) SIXTYSIX)))
     (define/public
      (play-round shuffle faces)
      (define card-pool (create-card-pool shuffle faces))
      (define deck (create-deck card-pool))
      (deal-cards card-pool)
      (for ((p HAND)) (play-turn deck)))
     (: deal-cards (-> CardPool Void))
     (define/private
      (deal-cards card-pool)
      (for
       ((p : Internal (in-list (get-field internals this))))
       (send p start-round (send card-pool draw-hand))))
     (: play-turn (-> Deck Void))
     (define/private
      (play-turn deck)
      (define played-cards
        (for/list
         :
         (Listof (List Internal Card))
         ((p : Internal (in-list (get-field internals this))))
         (list p (send p start-turn deck))))
      (define sorted-played-cards
        ((inst sort (List Internal Card) Face)
         played-cards
         <
         #:key
         (lambda ((x : (List Internal Card))) (card-face (second x)))))
      (place-cards deck sorted-played-cards))
     (: place-cards (-> Deck (Listof (List Internal Card)) Void))
     (define/private
      (place-cards deck sorted-player-cards)
      (for
       ((p+c : (List Internal Card) (in-list sorted-player-cards)))
       (define player (first p+c))
       (define card (second p+c))
       (cond
        ((send deck larger-than-some-top-of-stacks? card)
         (define closest-fit-stack (send deck fit card))
         (cond
          ((< (length closest-fit-stack) FIVE) (send deck push card))
          ((= (length closest-fit-stack) FIVE)
           (define bulls (send deck replace closest-fit-stack card))
           (send player add-score bulls))))
        (else
         (define chosen-stack (send player choose deck))
         (define bulls (send deck replace chosen-stack card))
         (send player add-score bulls)))))))
