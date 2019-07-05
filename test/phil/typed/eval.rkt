#lang typed/racket/base/no-check
(require racket/contract
          (lib "typed-racket/utils/opaque-object.rkt")
          (lib "racket/class.rkt")
          (lib "racket/base.rkt")
          (lib "racket/contract.rkt")
          (lib "racket/contract/base.rkt"))
(define g50 (recursive-contract g68 #:impersonator))
(define g51 (recursive-contract g70 #:impersonator))
(define g52 (recursive-contract g72 #:impersonator))
(define g53 (recursive-contract g78 #:impersonator))
(define g54 (recursive-contract g79 #:impersonator))
(define g55 (recursive-contract g79 #:impersonator))
(define g56 (recursive-contract g83 #:impersonator))
(define g57 (recursive-contract g85 #:impersonator))
(define g58 (recursive-contract g87 #:impersonator))
(define g59 string?)
(define g60 (listof g59))
(define g61 '#f)
(define g62 g51)
(define g63 (or/c g61 g62))
(define g64 exact-integer?)
(define g65 (or/c g64))
(define g66 (listof g65))
(define g67 g55)
(define g68 (listof g67))
(define g69 g54)
(define g70 (listof g69))
(define g71 g53)
(define g72 (listof g71))
(define g73 g50)
(define g74 any/c)
(define g75 g56)
(define g76 (-> g73 g66 g74 (values g75)))
(define g77 symbol?)
(define g78
   (object/c (field (descr g59)) (field (exec g76)) (field (id g77))))
(define g79
   (object/c-opaque (field (descr g59)) (field (exec g76)) (field (id g77))))
(define g80 g52)
(define g81 (cons/c g80 g66))
(define g82 'EXIT)
(define g83 (or/c g61 g81 g82))
(define g84 (cons/c g62 g66))
(define g85 (or/c g61 g84 g82))
(define g86 (cons/c g73 g66))
(define g87 (or/c g61 g86 g82))
(define generated-contract49 (-> g60 (values g63 g66)))
(provide (contract-out (forth-eval* generated-contract49)))
(module require/contracts racket/base
   (require racket/contract)
   (provide (contract-out)))
(require (prefix-in -: (only-in 'require/contracts))
          (except-in 'require/contracts))
(define-values () (values))
(provide)
(require require-typed-check
          racket/match
          typed/racket/class
          "../base/command-types.rkt"
          (only-in racket/port with-input-from-string))
(require "command.rkt")
(require "stack.rkt")
(: defn-command (Instance Command%))
(define defn-command
   (new
    command%
    (id 'define)
    (descr "Define a new command as a sequence of existing commands")
    (exec
     (lambda ((E : Env) (S : Stack) (v : Any))
       (match
        v
        ((cons (or ': 'define) (cons w defn*-any))
         (define defn* (assert defn*-any list?))
         (define cmd
           (new
            command%
            (id (assert w symbol?))
            (descr (format "~a" defn*))
            (exec
             (lambda ((E : Env) (S : Stack) (v : Any))
               (if (equal? v (list w))
                 (let-values (((e+ s+)
                               (for/fold
                                :
                                (Values (Option Env) Stack)
                                ((e (ann E (Option Env))) (s S))
                                ((d (in-list defn*)))
                                (if e
                                  (forth-eval e s (list d))
                                  (values e s)))))
                   (if e+ (cons e+ s+) e+))
                 #f)))))
         (cons (cons cmd E) S))
        (_ #f))))))
(: forth-eval* (-> (Listof String) (Values (Option Env) Stack)))
(define (forth-eval* in)
   (for/fold
    :
    (Values (Option Env) Stack)
    ((e (ann (cons defn-command CMD*) (Option Env))) (s (stack-init)))
    ((ln (in-list in)))
    (define token* (forth-tokenize ln))
    (cond
     ((or (null? token*) (not (list? e))) (values '() s))
     (else (forth-eval e s token*)))))
(: forth-eval (-> Env State (Listof Any) (Values (Option Env) Stack)))
(define (forth-eval E S token*)
   (match
    (for/or : Result ((c (in-list E))) ((get-field exec c) E S token*))
    ('EXIT (values #f S))
    (#f (printf "Unrecognized command '~a'.\n" token*) (values E S))
    ((? pair? E+S) (values (car E+S) (cdr E+S)))))
(: forth-tokenize (-> String (Listof Any)))
(define (forth-tokenize str)
   (parameterize
    ((read-case-sensitive #f))
    (with-input-from-string
     str
     (lambda ()
       (de-nest
        (let loop ()
          (match (read) ((? eof-object?) '()) (val (cons val (loop))))))))))
(: de-nest (-> (Listof Any) (Listof Any)))
(define (de-nest v*)
   (if (and (list? v*) (not (null? v*)) (list? (car v*)) (null? (cdr v*)))
     (de-nest (car v*))
     v*))
