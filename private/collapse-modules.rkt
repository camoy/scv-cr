#lang racket/base

(provide collapse-modules)

(require racket/function
         racket/set
         racket/dict
         racket/path
         racket/list
         mischief/sort
         mischief/dict
         syntax/parse)

(define current-dependencies
  (make-parameter (void)))

;; [List-of Path] [List-of Syntax] -> Syntax
;; collapses modules down to a single one with many submodules
;; for consumption by SCV
(define (collapse-modules targets stxs)
  (define-values (target->stx target->deps)
    (for/lists (t->s t->d)
               ([target targets]
                [stx stxs])
      (define-values (stx* deps)
        (collapse-module target stx))
      (define target* (string->symbol target))
      (values (cons target* stx*)
              (cons target* deps))))
  (define targets*
    (topological-sort (map string->symbol targets)
                      (dict->procedure #:failure (const empty)
                                       target->deps)))
  #`(module top racket/base
      (#%module-begin
       #,@(map (curry dict-ref target->stx) targets*))))

;; Path -> Symbol
;; converts a path to a symbol
(define path->symbol
  (compose string->symbol path->string))

;; Path Syntax -> Syntax [List-of Path]
;; collapses a single module down and returns the paths
;; it depends on
(define (collapse-module target stx)
  (syntax-parse stx
    #:datum-literals (module)
    [(module _ lang (mb forms ...))
     (define name* (path->symbol (simplify-path target)))
     (parameterize ([current-dependencies (mutable-set)])
       (values #`(module #,name* lang
                   #,(transform-require target #'(mb forms ...)))
               (set->list (current-dependencies))))]))

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
         (set-add! (current-dependencies)
                   (path->symbol complete))
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
