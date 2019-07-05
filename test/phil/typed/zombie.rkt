#lang typed/racket/base/no-check
(require racket/contract
          (lib "racket/contract.rkt")
          (lib "racket/base.rkt")
          (lib "racket/contract/base.rkt")
          (submod "image-adapted.rkt" #%type-decl ".."))
(define g13 (recursive-contract g38 #:chaperone))
(define g14 (recursive-contract g49 #:chaperone))
(define g15 (recursive-contract g56 #:chaperone))
(define g16 symbol?)
(define g17 'stop-when)
(define g18 '#t)
(define g19 '#f)
(define g20 (or/c g18 g19))
(define g21 (-> (values g20)))
(define g22 (cons/c g17 g21))
(define g23 'to-draw)
(define g24 (lambda (x) (image? x)))
(define g25 (-> g24))
(define g26 (cons/c g23 g25))
(define g27 'on-tick)
(define g28 g15)
(define g29 (-> (values g28)))
(define g30 (cons/c g27 g29))
(define g31 'on-mouse)
(define g32 real?)
(define g33 (or/c g32))
(define g34 string?)
(define g35 (-> g33 g33 g34 (values g28)))
(define g36 (cons/c g31 g35))
(define g37 (or/c g22 g26 g30 g36))
(define g38 (-> g16 (values g37)))
(define g39 (-> (values g20)))
(define g40 (cons/c g17 g39))
(define g41 (-> (values g24)))
(define g42 (cons/c g23 g41))
(define g43 g14)
(define g44 (-> (values g43)))
(define g45 (cons/c g27 g44))
(define g46 (-> g33 g33 g34 (values g43)))
(define g47 (cons/c g31 g46))
(define g48 (or/c g40 g42 g45 g47))
(define g49 (-> g16 (values g48)))
(define g50 g13)
(define g51 (-> (values g50)))
(define g52 (cons/c g27 g51))
(define g53 (-> g33 g33 g34 (values g50)))
(define g54 (cons/c g31 g53))
(define g55 (or/c g40 g42 g52 g54))
(define g56 (-> g16 (values g55)))
(define generated-contract8 g14)
(define generated-contract9 (-> g28 (values g46)))
(define generated-contract10 (-> g28 (values g44)))
(provide (contract-out
           (world-on-tick generated-contract10)
           (world-on-mouse generated-contract9)
           (w0 generated-contract8)))
(module require/contracts racket/base
   (require racket/contract
            "math.rkt"
            (lib "racket/contract.rkt")
            (lib "racket/base.rkt")
            (lib "racket/contract/base.rkt"))
   (define g11 real?)
   (define g12 (or/c g11))
   (define lifted/1 (-> g12 g12 (values g12)))
   (define lifted/3 (-> g12 g12 (values g12)))
   (define lifted/5 (-> g12 (values g12)))
   (define lifted/7 (-> g12 (values g12)))
   (define lifted/9 (-> g12 (values g12)))
   (provide (contract-out
             (min lifted/1)
             (max lifted/3)
             (abs lifted/5)
             (sqr lifted/7)
             (msqrt lifted/9))))
(require (prefix-in -: (only-in 'require/contracts msqrt sqr abs max min))
          (except-in 'require/contracts msqrt sqr abs max min))
(define g11 real?)
(define g12 (or/c g11))
(define lifted/1 (-> g12 g12 (values g12)))
(define lifted/3 (-> g12 g12 (values g12)))
(define lifted/5 (-> g12 (values g12)))
(define lifted/7 (-> g12 (values g12)))
(define lifted/9 (-> g12 (values g12)))
(define-values
  (msqrt sqr abs max min)
  (values -:msqrt -:sqr -:abs -:max -:min))
(provide)
(require require-typed-check
          (for-syntax racket/sequence racket/base syntax/parse racket/syntax)
          "image-adapted.rkt")
(void)
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
