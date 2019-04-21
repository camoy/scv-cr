#lang racket/base

(provide (struct-out contract-pair))
(struct contract-pair (provides requires))
