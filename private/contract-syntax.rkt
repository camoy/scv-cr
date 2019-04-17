#lang racket/base

(provide (struct-out contract-syntax))
(struct contract-syntax (provide-syntax require-syntax))
