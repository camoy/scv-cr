#lang racket/base

(provide (struct-out child))
(require "parent.rkt")
(struct child parent (a b))
