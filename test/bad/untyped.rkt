#lang racket/base

(require "typed.rkt")
(if #t
    (adder 0)
    (adder "bad"))
