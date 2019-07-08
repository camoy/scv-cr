#lang typed/racket/base

(provide (struct-out child))
(struct parent ())
(struct child parent ())
