#lang typed/racket/base/no-check
(define-values
  (g65 g66 g67 g68 g69 g70 g71 generated-contract35)
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
    (letrec ((g65 (λ (_) #f))
             (g66 any/c)
             (g67 '#t)
             (g68 '#f)
             (g69 (or/c g67 g68))
             (g70 (-> g66 (values g69)))
             (g71 (or/c g65 g70))
             (generated-contract35 g71))
      (values g65 g66 g67 g68 g69 g70 g71 generated-contract35))))
(require (only-in racket/contract contract-out))
(provide (contract-out (board? generated-contract35)))
(provide Board
          Tile
          tile?
          tile<=?
          tile->string
          ALL-TILES
          STARTER-TILES#
          FOUNDING
          GROWING
          MERGING
          SINGLETON
          IMPOSSIBLE
          *create-board-with-hotels
          affordable?
          board-tiles
          deduplicate/hotel
          distinct-and-properly-formed
          found-hotel
          free-spot?
          grow-hotel
          growing-which
          make-board
          merge-hotels
          merging-which
          place-tile
          set-board
          size-of-hotel
          what-kind-of-spot)
(require require-typed-check "../base/types.rkt")
(define-type Board (HashTable Tile Content))
(define-type Tile tile)
(define board? hash?)
(require "board.rkt")
