#lang typed/racket/base/no-check
(define-values
  (g139
   g140
   g141
   g136
   g137
   g138
   g133
   g134
   g135
   g142
   g143
   g144
   g145
   g146
   g147
   g148
   g149
   g150
   g151
   g152
   g153
   g154
   g155
   g156
   g157
   g158
   g159
   g160
   g161
   g162
   g163
   g164
   g165
   g166
   g167
   g168
   generated-contract125
   g169
   g170
   g171
   g172
   g173
   g174
   g175
   g176
   g177
   g178
   g179
   generated-contract126)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g139 (recursive-contract g151 #:impersonator))
             (g140 (recursive-contract g154 #:impersonator))
             (g141 (recursive-contract g157 #:impersonator))
             (g136 (recursive-contract g159 #:impersonator))
             (g137 (recursive-contract g143 #:impersonator))
             (g138 (recursive-contract g161 #:impersonator))
             (g133 (recursive-contract g167 #:impersonator))
             (g134 (recursive-contract g168 #:impersonator))
             (g135 (recursive-contract g168 #:impersonator))
             (g142 g134)
             (g143 (listof g142))
             (g144 '#f)
             (g145 'EXIT)
             (g146 g138)
             (g147 exact-integer?)
             (g148 (or/c g147))
             (g149 (listof g148))
             (g150 (cons/c g146 g149))
             (g151 (or/c g144 g145 g150))
             (g152 g137)
             (g153 (cons/c g152 g149))
             (g154 (or/c g144 g145 g153))
             (g155 g136)
             (g156 (cons/c g155 g149))
             (g157 (or/c g144 g145 g156))
             (g158 g135)
             (g159 (listof g158))
             (g160 g133)
             (g161 (listof g160))
             (g162 string?)
             (g163 any/c)
             (g164 g139)
             (g165 (-> g155 g149 g163 (values g164)))
             (g166 symbol?)
             (g167
              (object/c
               (field (descr g162))
               (field (exec g165))
               (field (id g166))))
             (g168
              (object/c-opaque
               (field (descr g162))
               (field (exec g165))
               (field (id g166))))
             (generated-contract125 g143)
             (g169 (recursive-contract g175 #:impersonator))
             (g170 (recursive-contract g178 #:impersonator))
             (g171 (recursive-contract g179 #:impersonator))
             (g172 any/c)
             (g173 g140)
             (g174 (-> g146 g149 g172 (values g173)))
             (g175
              (let ()
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (id g166))
                 (init (descr g162))
                 (init (exec g174))
                 (field (descr g162))
                 (field (exec g165))
                 (field (id g166))
                 (override)
                 (super)
                 (inherit)
                 (augment)
                 (inherit)
                 (absent))))
             (g176 g141)
             (g177 (-> g152 g149 g163 (values g176)))
             (g178
              (let ()
                (class/c
                 (init (id g166))
                 (init (descr g162))
                 (init (exec g177))
                 (field (descr g162))
                 (field (exec g165))
                 (field (id g166))
                 (override)
                 (super)
                 (inherit)
                 (augment)
                 (inherit)
                 (absent))))
             (g179
              (let ()
                (class/c
                 #:opaque
                 #:ignore-local-member-names
                 (init (id g166))
                 (init (descr g162))
                 (init (exec g165))
                 (field (descr g162))
                 (field (exec g165))
                 (field (id g166))
                 (override)
                 (super)
                 (inherit)
                 (augment)
                 (inherit)
                 (absent))))
             (generated-contract126 g170))
      (values
       g139
       g140
       g141
       g136
       g137
       g138
       g133
       g134
       g135
       g142
       g143
       g144
       g145
       g146
       g147
       g148
       g149
       g150
       g151
       g152
       g153
       g154
       g155
       g156
       g157
       g158
       g159
       g160
       g161
       g162
       g163
       g164
       g165
       g166
       g167
       g168
       generated-contract125
       g169
       g170
       g171
       g172
       g173
       g174
       g175
       g176
       g177
       g178
       g179
       generated-contract126))))
(require (only-in racket/contract contract-out))
(provide (contract-out (CMD* generated-contract125))
          (contract-out (command% generated-contract126)))
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
(define-predicate singleton-list? (List Any))
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
