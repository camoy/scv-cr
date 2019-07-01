#lang typed/racket/base

(provide (struct-out posn-2d)
         (struct-out posn-3d))

(struct posn-2d ([x : Real] [y : Real]))
(struct posn-3d ([x : Real] [y : Real] [z : Real]))
