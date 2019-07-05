#lang typed/racket/base/no-check
(require racket/contract
          (lib "racket/contract.rkt")
          (lib "typed-racket/utils/opaque-object.rkt")
          (lib "racket/class.rkt")
          (lib "racket/base.rkt")
          (lib "racket/contract/base.rkt"))
(define g123 (recursive-contract g157 #:impersonator))
(define g124 (recursive-contract g158 #:impersonator))
(define g125 (recursive-contract g158 #:impersonator))
(define g126 (recursive-contract g149 #:impersonator))
(define g127 (recursive-contract g133 #:impersonator))
(define g128 (recursive-contract g151 #:impersonator))
(define g129 (recursive-contract g141 #:impersonator))
(define g130 (recursive-contract g144 #:impersonator))
(define g131 (recursive-contract g147 #:impersonator))
(define g132 g124)
(define g133 (listof g132))
(define g134 '#f)
(define g135 'EXIT)
(define g136 g128)
(define g137 exact-integer?)
(define g138 (or/c g137))
(define g139 (listof g138))
(define g140 (cons/c g136 g139))
(define g141 (or/c g134 g135 g140))
(define g142 g127)
(define g143 (cons/c g142 g139))
(define g144 (or/c g134 g135 g143))
(define g145 g126)
(define g146 (cons/c g145 g139))
(define g147 (or/c g134 g135 g146))
(define g148 g125)
(define g149 (listof g148))
(define g150 g123)
(define g151 (listof g150))
(define g152 string?)
(define g153 any/c)
(define g154 g129)
(define g155 (-> g145 g139 g153 (values g154)))
(define g156 symbol?)
(define g157
   (object/c (field (descr g152)) (field (exec g155)) (field (id g156))))
(define g158
   (object/c-opaque
    (field (descr g152))
    (field (exec g155))
    (field (id g156))))
(define g159 (recursive-contract g165 #:impersonator))
(define g160 (recursive-contract g168 #:impersonator))
(define g161 (recursive-contract g169 #:impersonator))
(define g162 any/c)
(define g163 g130)
(define g164 (-> g136 g139 g162 (values g163)))
(define g165
   (let ()
     (class/c
      #:opaque
      #:ignore-local-member-names
      (init (id g156))
      (init (descr g152))
      (init (exec g164))
      (field (descr g152))
      (field (exec g155))
      (field (id g156))
      (override)
      (super)
      (inherit)
      (augment)
      (inherit)
      (absent))))
(define g166 g131)
(define g167 (-> g142 g139 g153 (values g166)))
(define g168
   (let ()
     (class/c
      (init (id g156))
      (init (descr g152))
      (init (exec g167))
      (field (descr g152))
      (field (exec g155))
      (field (id g156))
      (override)
      (super)
      (inherit)
      (augment)
      (inherit)
      (absent))))
(define g169
   (let ()
     (class/c
      #:opaque
      #:ignore-local-member-names
      (init (id g156))
      (init (descr g152))
      (init (exec g155))
      (field (descr g152))
      (field (exec g155))
      (field (id g156))
      (override)
      (super)
      (inherit)
      (augment)
      (inherit)
      (absent))))
(define generated-contract118 g133)
(define generated-contract119 g160)
(provide (contract-out
           (CMD* generated-contract118)
           (command% generated-contract119)))
(module require/contracts racket/base
   (require racket/contract
            (lib "racket/contract/base.rkt")
            (lib "racket/base.rkt"))
   (define g120 any/c)
   (define g121 '())
   (define g122 (cons/c g120 g121))
   (define lifted/1 g122)
   (provide (contract-out)))
(require (prefix-in -: (only-in 'require/contracts))
          (except-in 'require/contracts))
(define g120 any/c)
(define g121 '())
(define g122 (cons/c g120 g121))
(define lifted/1 g122)
(define-values () (values))
(provide)
(require require-typed-check
          racket/match
          typed/racket/class
          "../base/command-types.rkt"
          (only-in racket/string string-join)
          (for-syntax racket/base racket/syntax syntax/parse))
(require "stack.rkt")
(: command% Command%)
(define command% (class object% (super-new) (init-field id descr exec)))
(define singleton-list? lifted/1)
(define-type
  Binop-Command%
  (Class
   (init (binop (-> Integer Integer Integer)) (descr String))
   (field (binop (-> Integer Integer Integer))
          (descr String)
          (exec (-> Env State Any (U False 'EXIT (Pairof Env State))))
          (id Symbol))))
(: binop-command% Binop-Command%)
(define binop-command%
   (class command%
     (init-field binop)
     (super-new
      (id (assert (object-name binop) symbol?))
      (exec
       (lambda ((E : Env) (S : Stack) (v : Any))
         (if (singleton-list? v)
           (if (eq? (car v) (get-field id this))
             (let*-values (((v1 S1) (stack-pop S)) ((v2 S2) (stack-pop S1)))
               (cons E (stack-push S2 (binop v2 v1))))
             #f)
           #f))))))
(define-syntax make-stack-command
   (syntax-parser
    ((_ opcode:id d:str)
     #:with
     stack-cmd
     (format-id #'opcode "stack-~a" (syntax-e #'opcode))
     #`(new
        command%
        (id '#,(syntax-e #'opcode))
        (descr d)
        (exec
         (lambda ((E : Env) (S : Stack) (v : Any))
           (and (singleton-list? v)
                (eq? '#,(syntax-e #'opcode) (car v))
                (cons E (stack-cmd S)))))))))
(: CMD* (Listof (Instance Command%)))
(define CMD*
   (list
    (new
     command%
     (id 'exit)
     (descr "End the REPL session")
     (exec
      (lambda ((E : Env) (S : Stack) (v : Any))
        (if (or (eof-object? v)
                (and (symbol? v) (exit? v))
                (and (list? v) (not (null? v)) (exit? (car v))))
          'EXIT
          #f))))
    (new
     command%
     (id 'help)
     (descr "Print help information")
     (exec
      (lambda ((E : Env) (S : Stack) (v : Any))
        (cond
         ((and (symbol? v) (help? v)) (displayln (show-help E)) (cons E S))
         ((and (list? v) (not (null? v)) (help? (car v)))
          (displayln (show-help E (and (not (null? (cdr v))) (cdr v))))
          (cons E S))
         (else #f)))))
    (instantiate binop-command% (+)
      (descr "Add the top two numbers on the stack"))
    (instantiate binop-command% (-)
      (descr "Subtract the top item of the stack from the second item."))
    (instantiate binop-command% (*)
      (descr "Multiply the top two item on the stack."))
    (make-stack-command drop "Drop the top item from the stack")
    (make-stack-command dup "Duplicate the top item of the stack")
    (make-stack-command
     over
     "Duplicate the top item of the stack, but place the duplicate in the third position of the stack.")
    (make-stack-command swap "Swap the first two numbers on the stack")
    (new
     command%
     (id 'push)
     (descr "Push a number onto the stack")
     (exec
      (lambda ((E : Env) (S : Stack) (v : Any))
        (match
         v
         (`(push ,(? exact-integer? n)) (cons E (stack-push S n)))
         (`(,(? exact-integer? n)) (cons E (stack-push S n)))
         (_ #f)))))
    (new
     command%
     (id 'show)
     (descr "Print the current stack")
     (exec
      (lambda ((E : Env) (S : Stack) (v : Any))
        (match v (`(,(? show?)) (displayln S) (cons E S)) (_ #f)))))))
(: exit? (-> Any Boolean))
(define (exit? sym) (and (memq sym '(exit quit q leave bye)) #t))
(: find-command (-> Env Symbol (Option (Instance Command%))))
(define (find-command E sym)
   (for/or
    :
    (Option (Instance Command%))
    ((c : (Instance Command%) (in-list E)))
    (get-field id c)
    (error 'no)))
(: help? (-> Any Boolean))
(define (help? sym) (and (memq sym '(help ? ??? -help --help h)) #t))
(: show? (-> Any Boolean))
(define (show? sym) (and (memq sym '(show print pp ls stack)) #t))
(: show-help (->* (Env) (Any) String))
(define (show-help E (v #f))
   (match
    v
    (#f
     (string-join
      (for/list
       :
       (Listof String)
       ((c : (Instance Command%) (in-list E)))
       (format "    ~a : ~a" (get-field id c) (get-field descr c)))
      "\n"
      #:before-first
      "Available commands:\n"))
    ((or (list (? symbol? s)) (? symbol? s))
     (define c (find-command E (assert s symbol?)))
     (if c (get-field descr c) (format "Unknown command '~a'" s)))
    (x (format "Cannot help with '~a'" x))))
