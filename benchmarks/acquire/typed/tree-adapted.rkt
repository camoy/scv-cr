#lang typed/racket/no-check
(define-values
  ()
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
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(provide Tree<%>
          ATree%
          Placed%
          LPlaced%
          tree-state
          lplaced%
          generate-tree
          tree-next)
(require require-typed-check
          "../base/types.rkt"
          "board-adapted.rkt"
          "state-adapted.rkt")
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
   (init-field (lplaced (Listof (Instance Placed%))) (state State))))
(require "tree.rkt")
