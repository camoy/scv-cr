#lang typed/racket/base/no-check
(define-values
  (g59
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
   g76
   g77
   g78
   g79
   g80
   g81
   g82
   g83
   g84
   g85
   g86
   g87
   g88
   g89
   g90
   g91
   g92
   g93
   g94
   generated-contract57
   g99
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
    (letrec ((g59 (recursive-contract g87 #:impersonator))
             (g60 (recursive-contract g94 #:impersonator))
             (g61 (recursive-contract g94 #:impersonator))
             (g62 exact-nonnegative-integer?)
             (g63 (or/c g62))
             (g64 (lambda (x) (card? x)))
             (g65 (listof g64))
             (g66 (-> g65 (values g65)))
             (g67 any/c)
             (g68 g61)
             (g69 (-> g67 g68 (values g65)))
             (g70 (-> g67 (values g63)))
             (g71 (lambda (x) (equal? x (void))))
             (g72 (-> g67 g65 (values g71)))
             (g73 (-> g67 g68 (values g64)))
             (g74 (-> g65 (values g65)))
             (g75
              (object/c-opaque
               (choose g69)
               (name g70)
               (start-round g72)
               (start-turn g73)
               (field (my-cards g65))
               (field (n g63))
               (field (order g74))))
             (g76 (-> g67 (values g65)))
             (g77 (-> g67 g64 (values g65)))
             (g78 '#t)
             (g79 '#f)
             (g80 (or/c g78 g79))
             (g81 (-> g67 g64 (values g80)))
             (g82 (-> any/c any/c g71))
             (g83 (-> g67 g65 g64 (values g63)))
             (g84 (or/c g64 g65))
             (g85 (-> g67 g64 g84 (values g63)))
             (g86 (listof g65))
             (g87
              (object/c
               (fewest-bulls g76)
               (fit g77)
               (larger-than-some-top-of-stacks? g81)
               (push g82)
               (replace g83)
               (replace-stack g85)
               (field (cards0 g65))
               (field (my-stacks g86))))
             (g88 (-> g67 (values g65)))
             (g89 (-> g67 g64 (values g65)))
             (g90 (-> g67 g64 (values g80)))
             (g91 (-> g67 g64 (values g71)))
             (g92 (-> g67 g65 g64 (values g63)))
             (g93 (-> g67 g64 g84 (values g63)))
             (g94
              (object/c-opaque
               (fewest-bulls g88)
               (fit g89)
               (larger-than-some-top-of-stacks? g90)
               (push g91)
               (replace g92)
               (replace-stack g93)
               (field (cards0 g65))
               (field (my-stacks g86))))
             (generated-contract57 (->* (g63) (g66) (values g75)))
             (g99
              (let ((g6995 g69) (g7096 g70) (g7297 g72) (g7398 g73))
                (class/c
                 (init (n g63))
                 (init (order g66))
                 (field (my-cards g65))
                 (field (n g63))
                 (field (order g74))
                 (choose g6995)
                 (name g7096)
                 (start-round g7297)
                 (start-turn g7398)
                 (override (choose g6995)
                           (name g7096)
                           (start-round g7297)
                           (start-turn g7398))
                 (super
                  (choose g6995)
                  (name g7096)
                  (start-round g7297)
                  (start-turn g7398))
                 (inherit (choose g6995)
                          (name g7096)
                          (start-round g7297)
                          (start-turn g7398))
                 (augment)
                 (inherit)
                 (absent))))
             (generated-contract58 g99))
      (values
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
       g76
       g77
       g78
       g79
       g80
       g81
       g82
       g83
       g84
       g85
       g86
       g87
       g88
       g89
       g90
       g91
       g92
       g93
       g94
       generated-contract57
       g99
       generated-contract58))))
(require (only-in racket/contract contract-out))
(provide (contract-out (create-player generated-contract57))
          (contract-out (player% generated-contract58)))
(provide)
(require "basics-types.rkt"
          "card-adapted.rkt"
          "deck-types.rkt"
          "player-types.rkt"
          "stack-types.rkt"
          typed/racket/class
          (only-in racket/list first rest))
(: create-player (->* (Name) ((-> (Listof Card) (Listof Card))) Player))
(define (create-player i (order default-order))
   (new player% (n i) (order order)))
(: default-order (-> (Listof Card) (Listof Card)))
(define (default-order loc) ((inst sort Card Natural) loc > #:key card-face))
(: player% Player%)
(define player%
   (class object%
     (init-field n (order default-order))
     (field (my-cards '()))
     (define/public (name) n)
     (define/public (start-round loc) (set! my-cards (order loc)))
     (define/public
      (start-turn _d)
      (begin0 (first my-cards) (set! my-cards (rest my-cards))))
     (define/public
      (choose d)
      (define fewest-bulls (send d fewest-bulls))
      fewest-bulls)
     (super-new)))
