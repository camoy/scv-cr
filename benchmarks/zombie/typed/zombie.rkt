#lang typed/racket/base/no-check
(define-values
  (g13
   g14
   g15
   g16
   g17
   g18
   g19
   g20
   g21
   g22
   g23
   g24
   g25
   g26
   g27
   g28
   g29
   g30
   g31
   g32
   g33
   g34
   g35
   g36
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
   generated-contract8
   generated-contract9
   generated-contract10)
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
    (letrec ((g13 (recursive-contract g38 #:chaperone))
             (g14 (recursive-contract g49 #:chaperone))
             (g15 (recursive-contract g56 #:chaperone))
             (g16 symbol?)
             (g17 'stop-when)
             (g18 '#t)
             (g19 '#f)
             (g20 (or/c g18 g19))
             (g21 (-> (values g20)))
             (g22 (cons/c g17 g21))
             (g23 'to-draw)
             (g24 (lambda (x) (image? x)))
             (g25 (-> g24))
             (g26 (cons/c g23 g25))
             (g27 'on-tick)
             (g28 g15)
             (g29 (-> (values g28)))
             (g30 (cons/c g27 g29))
             (g31 'on-mouse)
             (g32 real?)
             (g33 (or/c g32))
             (g34 string?)
             (g35 (-> g33 g33 g34 (values g28)))
             (g36 (cons/c g31 g35))
             (g37 (or/c g22 g26 g30 g36))
             (g38 (-> g16 (values g37)))
             (g39 (-> (values g20)))
             (g40 (cons/c g17 g39))
             (g41 (-> (values g24)))
             (g42 (cons/c g23 g41))
             (g43 g14)
             (g44 (-> (values g43)))
             (g45 (cons/c g27 g44))
             (g46 (-> g33 g33 g34 (values g43)))
             (g47 (cons/c g31 g46))
             (g48 (or/c g40 g42 g45 g47))
             (g49 (-> g16 (values g48)))
             (g50 g13)
             (g51 (-> (values g50)))
             (g52 (cons/c g27 g51))
             (g53 (-> g33 g33 g34 (values g50)))
             (g54 (cons/c g31 g53))
             (g55 (or/c g40 g42 g52 g54))
             (g56 (-> g16 (values g55)))
             (generated-contract8 g14)
             (generated-contract9 (-> g28 (values g46)))
             (generated-contract10 (-> g28 (values g44))))
      (values
       g13
       g14
       g15
       g16
       g17
       g18
       g19
       g20
       g21
       g22
       g23
       g24
       g25
       g26
       g27
       g28
       g29
       g30
       g31
       g32
       g33
       g34
       g35
       g36
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
       generated-contract8
       generated-contract9
       generated-contract10))))
(require (only-in racket/contract contract-out))
(provide (contract-out (w0 generated-contract8))
          (contract-out (world-on-mouse generated-contract9))
          (contract-out (world-on-tick generated-contract10)))
(provide)
(require require-typed-check
          (for-syntax racket/sequence racket/base syntax/parse racket/syntax)
          "image-adapted.rkt")
(require "math.rkt")
(define WIDTH 400)
(define HEIGHT 400)
(define MT-SCENE (empty-scene WIDTH HEIGHT))
(define PLAYER-SPEED 4)
(define ZOMBIE-SPEED 2)
(define ZOMBIE-RADIUS 20)
(define PLAYER-RADIUS 20)
(define PLAYER-IMG (circle PLAYER-RADIUS "solid" "green"))
(define-syntax make-fake-object-type*
   (syntax-parser
    ((_ ty (f* t*) ...)
     #:with
     (id* ...)
     (for/list
      ((f (in-list (syntax->list #'(f* ...)))))
      (format-id
       #'ty
       "~a-~a"
       (string-downcase (symbol->string (syntax-e #'ty)))
       f))
     #:with
     (f-sym* ...)
     (for/list ((f (in-list (syntax->list #'(f* ...))))) (syntax-e f))
     #'(begin
         (define-type ty (-> Symbol (U (Pairof 'f-sym* t*) ...)))
         (begin
           (: id* (-> ty t*))
           (define (id* v)
             (let ((r (v 'f-sym*)))
               (if (eq? 'f-sym* (car r)) (cdr r) (error 'id* "type error")))))
         ...))))
(make-fake-object-type*
  Posn
  (x (-> Real))
  (y (-> Real))
  (posn (-> Posn))
  (move-toward/speed (-> Posn Real Posn))
  (move (-> Real Real Posn))
  (draw-on/image (-> Image Image Image))
  (dist (-> Posn Real)))
(make-fake-object-type*
  Player
  (posn (-> Posn))
  (move-toward (-> Posn Player))
  (draw-on (-> Image Image)))
(make-fake-object-type*
  Zombie
  (posn (-> Posn))
  (draw-on/color (-> String Image Image))
  (touching? (-> Posn Boolean))
  (move-toward (-> Posn Zombie)))
(make-fake-object-type*
  Horde
  (dead (-> Zombies))
  (undead (-> Zombies))
  (draw-on (-> Image Image))
  (touching? (-> Posn Boolean))
  (move-toward (-> Posn Horde))
  (eat-brains (-> Horde)))
(make-fake-object-type*
  Zombies
  (move-toward (-> Posn Zombies))
  (draw-on/color (-> String Image Image))
  (touching? (-> Posn Boolean))
  (kill-all (-> Zombies Horde)))
(make-fake-object-type*
  World
  (on-mouse (-> Real Real String World))
  (on-tick (-> World))
  (to-draw (-> Image))
  (stop-when (-> Boolean)))
(: new-world (-> Player Posn Horde World))
(define (new-world player mouse zombies)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'on-mouse)
       (cons
        'on-mouse
        (lambda ((x : Real) (y : Real) (me : String))
          (new-world
           player
           (if (equal? me "leave") ((player-posn player)) (new-posn x y))
           zombies))))
      ((equal? msg 'on-tick)
       (cons
        'on-tick
        (lambda ()
          (new-world
           ((player-move-toward player) mouse)
           mouse
           ((horde-move-toward ((horde-eat-brains zombies)))
            ((player-posn player)))))))
      ((equal? msg 'to-draw)
       (cons
        'to-draw
        (lambda ()
          ((player-draw-on player) ((horde-draw-on zombies) MT-SCENE)))))
      ((equal? msg 'stop-when)
       (cons
        'stop-when
        (lambda () ((horde-touching? zombies) ((player-posn player))))))
      (else (error 'world "unknown message")))))
(: new-player (-> Posn Player))
(define (new-player p)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'posn) (cons 'posn (lambda () p)))
      ((equal? msg 'move-toward)
       (cons
        'move-toward
        (lambda ((q : Posn))
          (new-player ((posn-move-toward/speed p) q PLAYER-SPEED)))))
      ((equal? msg 'draw-on)
       (cons
        'draw-on
        (lambda ((scn : Image)) ((posn-draw-on/image p) PLAYER-IMG scn))))
      (else (error 'player "unknown message")))))
(: new-horde (-> Zombies Zombies Horde))
(define (new-horde undead dead)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'dead) (cons 'dead (lambda () dead)))
      ((equal? msg 'undead) (cons 'undead (lambda () undead)))
      ((equal? msg 'draw-on)
       (cons
        'draw-on
        (lambda ((scn : Image))
          ((zombies-draw-on/color undead)
           "yellow"
           ((zombies-draw-on/color dead) "black" scn)))))
      ((equal? msg 'touching?)
       (cons
        'touching?
        (lambda ((p : Posn))
          (or ((zombies-touching? undead) p) ((zombies-touching? dead) p)))))
      ((equal? msg 'move-toward)
       (cons
        'move-toward
        (lambda ((p : Posn))
          (new-horde ((zombies-move-toward undead) p) dead))))
      ((equal? msg 'eat-brains)
       (cons 'eat-brains (lambda () ((zombies-kill-all undead) dead))))
      (else (error 'horde "unknown message")))))
(: new-cons-zombies (-> Zombie Zombies Zombies))
(define (new-cons-zombies z r)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'move-toward)
       (cons
        'move-toward
        (lambda ((p : Posn))
          (new-cons-zombies
           ((zombie-move-toward z) p)
           ((zombies-move-toward r) p)))))
      ((equal? msg 'draw-on/color)
       (cons
        'draw-on/color
        (lambda ((c : String) (s : Image))
          ((zombie-draw-on/color z) c ((zombies-draw-on/color r) c s)))))
      ((equal? msg 'touching?)
       (cons
        'touching?
        (lambda ((p : Posn))
          (or ((zombie-touching? z) p) ((zombies-touching? r) p)))))
      ((equal? msg 'kill-all)
       (cons
        'kill-all
        (lambda ((dead : Zombies))
          (cond
           ((or ((zombies-touching? r) ((zombie-posn z)))
                ((zombies-touching? dead) ((zombie-posn z))))
            ((zombies-kill-all r) (new-cons-zombies z dead)))
           (else
            (let ((res ((zombies-kill-all r) dead)))
              (new-horde
               (new-cons-zombies z ((horde-undead res)))
               ((horde-dead res)))))))))
      (else (error 'zombies "unknown message")))))
(: new-mt-zombies (-> Zombies))
(define (new-mt-zombies)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'move-toward)
       (cons 'move-toward (lambda ((p : Posn)) (new-mt-zombies))))
      ((equal? msg 'draw-on/color)
       (cons 'draw-on/color (lambda ((c : String) (s : Image)) s)))
      ((equal? msg 'touching?) (cons 'touching? (lambda ((p : Posn)) #f)))
      ((equal? msg 'kill-all)
       (cons
        'kill-all
        (lambda ((dead : Zombies)) (new-horde (new-mt-zombies) dead))))
      (else (error 'zombies "unknown message")))))
(: new-zombie (-> Posn Zombie))
(define (new-zombie p)
   (lambda ((msg : Symbol))
     (cond
      ((equal? msg 'posn) (cons 'posn (lambda () p)))
      ((equal? msg 'draw-on/color)
       (cons
        'draw-on/color
        (lambda ((c : String) (s : Image))
          ((posn-draw-on/image p) (circle ZOMBIE-RADIUS "solid" c) s))))
      ((equal? msg 'touching?)
       (cons
        'touching?
        (lambda ((q : Posn)) (<= ((posn-dist p) q) ZOMBIE-RADIUS))))
      ((equal? msg 'move-toward)
       (cons
        'move-toward
        (lambda ((q : Posn))
          (new-zombie ((posn-move-toward/speed p) q ZOMBIE-SPEED)))))
      (else (error 'zombie "unknown message")))))
(: new-posn (-> Real Real Posn))
(define (new-posn x y)
   (lambda ((msg : Symbol))
     (let ((this (new-posn x y)))
       (cond
        ((equal? msg 'x) (cons 'x (lambda () x)))
        ((equal? msg 'y) (cons 'y (lambda () y)))
        ((equal? msg 'posn) (cons 'posn (lambda () this)))
        ((equal? msg 'move-toward/speed)
         (cons
          msg
          (lambda ((p : Posn) (speed : Real))
            (let* ((x2 (- ((posn-x p)) x))
                   (y2 (- ((posn-y p)) y))
                   (move-distance (min speed (max (abs x2) (abs y2)))))
              (cond
               ((< (abs x2) (abs y2))
                ((posn-move this)
                 0
                 (if (positive? y2) move-distance (- 0 move-distance))))
               (else
                ((posn-move this)
                 (if (positive? x2) move-distance (- 0 move-distance))
                 0)))))))
        ((equal? msg 'move)
         (cons
          'move
          (lambda ((x2 : Real) (y2 : Real)) (new-posn (+ x x2) (+ y y2)))))
        ((equal? msg 'draw-on/image)
         (cons
          'draw-on/image
          (lambda ((img : Image) (scn : Image)) (place-image img x y scn))))
        ((equal? msg 'dist)
         (cons
          'dist
          (lambda ((p : Posn))
            (msqrt (+ (sqr (- ((posn-y p)) y)) (sqr (- ((posn-x p)) x)))))))
        (else (error 'posn "unknown message"))))))
(: w0 World)
(define w0
   (new-world
    (new-player (new-posn 0 0))
    (new-posn 0 0)
    (new-horde
     (new-cons-zombies
      (new-zombie (new-posn 100 300))
      (new-cons-zombies (new-zombie (new-posn 100 200)) (new-mt-zombies)))
     (new-cons-zombies (new-zombie (new-posn 200 200)) (new-mt-zombies)))))
