#lang typed/racket/base/no-check
(define-values
  (g106
   g107
   g108
   g100
   g101
   g102
   g103
   g104
   g105
   g109
   g110
   g111
   g112
   g113
   g114
   g115
   g116
   g117
   g118
   g119
   g120
   g121
   g122
   g123
   g124
   g125
   g126
   g127
   g128
   g129
   g130
   g131
   g132
   g133
   g134
   g135
   g136
   g137
   generated-contract52)
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
    (letrec ((g106 (recursive-contract g120 #:impersonator))
             (g107 (recursive-contract g122 #:impersonator))
             (g108 (recursive-contract g125 #:impersonator))
             (g100 (recursive-contract g127 #:impersonator))
             (g101 (recursive-contract g129 #:impersonator))
             (g102 (recursive-contract g131 #:impersonator))
             (g103 (recursive-contract g136 #:impersonator))
             (g104 (recursive-contract g137 #:impersonator))
             (g105 (recursive-contract g137 #:impersonator))
             (g109 string?)
             (g110 (listof g109))
             (g111 '#f)
             (g112 g101)
             (g113 (or/c g111 g112))
             (g114 exact-integer?)
             (g115 (or/c g114))
             (g116 (listof g115))
             (g117 g102)
             (g118 (cons/c g117 g116))
             (g119 'EXIT)
             (g120 (or/c g111 g118 g119))
             (g121 (cons/c g112 g116))
             (g122 (or/c g111 g121 g119))
             (g123 g100)
             (g124 (cons/c g123 g116))
             (g125 (or/c g111 g124 g119))
             (g126 g105)
             (g127 (listof g126))
             (g128 g104)
             (g129 (listof g128))
             (g130 g103)
             (g131 (listof g130))
             (g132 any/c)
             (g133 g106)
             (g134 (-> g123 g116 g132 (values g133)))
             (g135 symbol?)
             (g136
              (object/c
               (field (descr g109))
               (field (exec g134))
               (field (id g135))))
             (g137
              (object/c-opaque
               (field (descr g109))
               (field (exec g134))
               (field (id g135))))
             (generated-contract52 (-> g110 (values g113 g116))))
      (values
       g106
       g107
       g108
       g100
       g101
       g102
       g103
       g104
       g105
       g109
       g110
       g111
       g112
       g113
       g114
       g115
       g116
       g117
       g118
       g119
       g120
       g121
       g122
       g123
       g124
       g125
       g126
       g127
       g128
       g129
       g130
       g131
       g132
       g133
       g134
       g135
       g136
       g137
       generated-contract52))))
(require (only-in racket/contract contract-out))
(provide (contract-out (forth-eval* generated-contract52)))
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
