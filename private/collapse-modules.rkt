#lang racket/base

(require racket/function
         racket/path
         racket/list
         syntax/parse)

;; [List-of Path] [List-of Syntax] -> Syntax
;; collapses modules down to a single one with many submodules
;; for consumption by SCV
(define (collapse-modules targets stxs)
  #`(module top racket/base
      (#%module-begin
       #,@(map collapse-module targets stxs))))

;; Path -> Symbol
;; converts a path to a symbol
(define path->symbol
  (compose string->symbol path->string))

;; Path Syntax -> Syntax
;; collapses a single module down
(define (collapse-module target stx)
  (syntax-parse stx
    #:datum-literals (module)
    [(module _ lang (mb forms ...))
     (define name* (path->symbol (simplify-path target)))
     #`(module #,name* lang
         #,(transform-require target #'(mb forms ...)))]))

;; Path Syntax -> Syntax
;; converts require forms to submod form
(define (transform-require target stx)
  (define target-dir (path-only target))
  (define ((convert-require depth) mod)
    (define mod* (syntax-e mod))
    (cond
      [(string? mod*)
       (let* ([complete    (simplify-path (build-path target-dir mod*))]
              [submod-name (path->symbol complete)]
              [dots        (map (const "..") (range depth))])
         #`(submod #,@dots #,submod-name))]
      [else mod]))
  (let loop ([depth 1]
             [stx* stx])
    (syntax-parse stx*
      #:datum-literals (module require)
      [(require x ...)
       #`(require #,@(map (convert-require depth)
                          (syntax-e #'(x ...))))]
      [(module x ...)
       #`(module #,@(map (curry loop (add1 depth))
                         (syntax-e #'(x ...))))]
      [(x ...)
       #`(#,@(map (curry loop depth)
                  (syntax-e #'(x ...))))]
      [x #'x])))

;;
;; test
;;

(define client-stx
  #'(module client racket/base
      (#%module-begin
        (module inner racket/base
          (require "../nested/server.rkt"))
        (require 'inner))))

(define client-path
  "/home/camoy/buried/client.rkt")

(define server-stx
  #'(module server racket/base
      (#%module-begin
       42)))

(define server-path
  "/home/camoy/nested/server.rkt")

(syntax->datum
 (collapse-modules (list server-path client-path)
                  (list server-stx client-stx)))

#|
 (module motion typed/racket/no-check
    (#%module-begin
     (module require/contracts racket/base
       (require racket/contract typed-racket/utils/struct-type-c)
       (require "const.rkt")
       (require "data.rkt")
       (require "motion-help.rkt")
       (define g12 exact-integer?)
       (define g15 any/c)
       (define g16 '#t)
       (define g17 '#f)
       (define g18 (or/c g16 g17))
       (define g20 (lambda (x) (snake? x)))
       (define g21 (-> any/c g20))
       (define lifted/1 g12)
       (define lifted/3 g12)
       (define lifted/5 (-> g15 g15 (values g18)))
       (define lifted/7 g21)
       (define lifted/9 g21)
       (provide (contract-out
                 (BOARD-HEIGHT lifted/3)
                 (snake-grow lifted/9)
                 (BOARD-WIDTH lifted/1)
                 (snake-slither lifted/7)
                 (posn=? lifted/5))))
     (require 'require/contracts)
     (require racket/contract typed-racket/utils/struct-type-c)
     (define g25 (lambda (x) (world? x)))
     (define g27 '"up")
     (define g28 '"down")
     (define g29 '"left")
|#
