#lang racket/base

(provide collapse-modules)

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

(module+ test
  (require rackunit
           scv-gt/private/test-util)

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

  (define expected
    #'(module top racket/base
        (#%module-begin
         (module /home/camoy/nested/server.rkt racket/base
           (#%module-begin 42))
         (module /home/camoy/buried/client.rkt racket/base
           (#%module-begin
            (module inner racket/base
              (require (submod ".."
                               ".."
                               /home/camoy/nested/server.rkt)))
            (require 'inner))))))

  (test-case
    "collapse-modules"
    (check syntax=?
           (collapse-modules (list server-path client-path)
                             (list server-stx client-stx))
           expected)))
