#lang typed/racket/base/no-check
(define-values
  (g258
   g259
   g260
   g261
   g262
   g263
   generated-contract236
   g264
   g265
   generated-contract237)
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
    (letrec ((g258 (lambda (x) (zo? x)))
             (g259 string?)
             (g260 (mutable-vector/c g258 g259))
             (g261 (immutable-vector/c g258 g259))
             (g262 (or/c g260 g261))
             (g263 (lambda (x) (equal? x (void))))
             (generated-contract236 (-> g262 (values g263)))
             (g264 path?)
             (g265 (or/c g264 g259))
             (generated-contract237 (-> g265 (values g258))))
      (values
       g258
       g259
       g260
       g261
       g262
       g263
       generated-contract236
       g264
       g265
       generated-contract237))))
(require (only-in racket/contract contract-out))
(provide (contract-out (init generated-contract236))
          (contract-out (zo-read generated-contract237)))
(provide)
(require require-typed-check
          (only-in racket/string string-split string-join string-trim)
          "../base/typed-zo-structs.rkt"
          racket/match)
(require "zo-string.rkt")
(require "zo-transition.rkt")
(require "zo-find.rkt")
(require "../base/compiler-zo-parse.rkt")
(define DEBUG #f)
(define VERSION 1.0)
(define VNAME "vortex")
(define-type Context (U zo (Listof zo) (Listof result)))
(define-type History (Listof Context))
(define-type History* (Listof History))
(: init (-> (Vector zo String) Void))
(define (init args) (match args ((vector ctx arg) (find-all ctx (list arg)))))
(: zo-read (-> Path-String zo))
(define (zo-read fname)
   (call-with-input-file fname (lambda (port) (zo-parse port))))
(struct
  command
  ((name : String)
   (num-args : Natural)
   (aliases : (Listof String))
   (help-msg : String))
  #:transparent)
(define-type Command command)
(define ALST
   (command "alst" 0 (list "a" "alias" "aliases") "Print command aliases"))
(define BACK
   (command
    "back"
    0
    (list "b" "up" "u" ".." "../" "cd .." "cd ../")
    "Move up to the previous context"))
(define DIVE
   (command
    "dive"
    1
    (list "d" "cd" "next" "step")
    "Step into struct field ARG"))
(define FIND
   (command
    "find"
    1
    (list "f" "query" "search" "look")
    "Search the current subtree for structs with the name ARG"))
(define HELP
   (command
    "help"
    0
    (list "h" "-h" "--h" "-help" "--help")
    "Print this message"))
(define INFO
   (command
    "info"
    0
    (list "i" "ls" "print" "p" "show")
    "Show information about current context"))
(define JUMP
   (command "jump" 0 (list "j" "warp" "top") "Revert to last saved position"))
(define SAVE
   (command "save" 0 (list "mark") "Save the current context as jump target"))
(define QUIT
   (command "quit" 0 (list "q" "exit" "leave" "bye") "Exit the interpreter"))
(define COMMANDS (list ALST BACK DIVE FIND HELP INFO JUMP SAVE QUIT))
(: cmd? (-> Command (-> String Boolean)))
(define ((cmd? c) str)
   (define splt (string-split str))
   (or (and (string=? "back" (command-name c))
            (member? str (list "cd .." "cd ../")))
       (and (= (sub1 (length splt)) (command-num-args c))
            (or (string=? (car splt) (command-name c))
                (member? (car splt) (command-aliases c))))))
(: filename->shell (-> String Void))
(define (filename->shell name)
   (print-info (format "Loading bytecode file '~a'..." name))
   (call-with-input-file
    name
    (lambda ((port : Input-Port))
      (print-info "Parsing bytecode...")
      (define ctx (zo-parse port))
      (print-info "Parsing complete!")
      (print-welcome)
      ((repl ctx '() '()) '()))))
(: zo->shell (-> zo Void))
(define (zo->shell z) (print-welcome) ((repl z '() '()) '()))
(: split-cd (-> (Listof String) (Listof String)))
(define (split-cd cmd*)
   (match
    cmd*
    ('() '())
    ((cons cd-cmd rest)
     #:when
     (starts-with? cd-cmd "cd ")
     (append
      (map
       (lambda ((x : String)) (string-append "cd " x))
       (string-split (substring cd-cmd 3) "/"))
      (split-cd rest)))
    ((cons cmd rest) (cons cmd (split-cd rest)))))
(: repl (-> Context History (Listof History) (-> (Listof String) Void)))
(define ((repl ctx hist pre-hist) cmd*)
   (when DEBUG (print-history hist))
   (match
    cmd*
    ('()
     (print-prompt ctx)
     (define ln (read-line))
     (if (eof-object? ln)
       (error 'zo-shell:repl "EOF: you have penetrated me")
       ((repl ctx hist pre-hist)
        (split-cd
         (for/list
          :
          (Listof String)
          ((str (in-list (string-split ln ";"))))
          (string-trim str))))))
    ((cons (? (cmd? ALST) raw) cmd*)
     (print-alias)
     ((repl ctx hist pre-hist) cmd*))
    ((cons (? (cmd? BACK) raw) cmd*)
     ((call-with-values (lambda () (back raw ctx hist pre-hist)) repl) cmd*))
    ((cons (? (cmd? DIVE) raw) cmd*)
     ((call-with-values (lambda () (dive raw ctx hist pre-hist)) repl) cmd*))
    ((cons (? (cmd? FIND) raw) cmd*)
     ((call-with-values (lambda () (find raw ctx hist pre-hist)) repl) cmd*))
    ((cons (? (cmd? HELP) raw) cmd*)
     (begin (print-help) ((repl ctx hist pre-hist) cmd*)))
    ((cons (? (cmd? INFO) raw) cmd*)
     (begin (print-context ctx) ((repl ctx hist pre-hist) cmd*)))
    ((cons (? (cmd? JUMP) raw) cmd*)
     ((call-with-values (lambda () (jump raw ctx hist pre-hist)) repl) cmd*))
    ((cons (? (cmd? SAVE) raw) cmd*)
     ((call-with-values (lambda () (save raw ctx hist pre-hist)) repl) cmd*))
    ((cons (? (cmd? QUIT) raw) cmd*) (print-goodbye))
    ((cons raw cmd*)
     (begin (print-unknown raw) ((repl ctx hist pre-hist) cmd*)))))
(define BACK-WARNING
   (string-append
    "BACK removing most recent 'save' mark. "
    "Be sure to save if you want to continue exploring search result."))
(:
  back
  (-> String Context History History* (Values Context History History*)))
(define (back raw ctx hist pre-hist)
   (match
    (list hist pre-hist)
    ((list '() '()) (print-unknown raw) (values ctx hist pre-hist))
    ((list '() _)
     (displayln BACK-WARNING)
     (define-values (hist* pre-hist*) (pop pre-hist))
     (back raw ctx hist* pre-hist*))
    (_ (define-values (ctx* hist*) (pop hist)) (values ctx* hist* pre-hist))))
(:
  dive
  (-> String Context History History* (Values Context History History*)))
(define (dive raw ctx hist pre-hist)
   (define arg (split-snd raw))
   (define-values
    (ctx* hist*)
    (cond
     ((not arg) (print-unknown raw) (values ctx hist))
     ((list? ctx) (dive-list ctx hist arg))
     ((zo? ctx) (dive-zo ctx hist arg))
     (else (error 'zo-shell:dive (format "Invalid context '~a'" ctx)))))
   (values ctx* hist* pre-hist))
(:
  dive-list
  (-> (U (Listof result) (Listof zo)) History String (Values Context History)))
(define (dive-list ctx hist arg)
   (define index (string->number arg))
   (cond
    ((or (not index) (not (index? index)) (< index 0) (>= index (length ctx)))
     (print-unknown (format "dive ~a" arg))
     (values ctx hist))
    (else
     (define res (list-ref ctx index))
     (if (result? res)
       (values (result-zo res) (result-path res))
       (values res (push hist ctx))))))
(: dive-zo (-> zo History String (Values Context History)))
(define (dive-zo ctx hist field)
   (define-values (ctx* success?) (zo-transition ctx field))
   (cond
    (success? (values ctx* (push hist ctx)))
    (else (print-unknown (format "dive ~a" field)) (values ctx hist))))
(:
  find
  (-> String Context History History* (Values Context History History*)))
(define (find raw ctx hist pre-hist)
   (define arg (split-snd raw))
   (cond
    ((and arg (zo? ctx))
     (define results (zo-find ctx arg))
     (printf "FIND returned ~a results\n" (length results))
     (match
      results
      ('() (values ctx hist pre-hist))
      (_
       (printf "FIND automatically saving context\n")
       (print-context results)
       (save "" results (push hist ctx) pre-hist))))
    (else (print-unknown raw) (values ctx hist pre-hist))))
(:
  jump
  (-> String Context History History* (Values Context History History*)))
(define (jump raw ctx hist pre-hist)
   (match
    pre-hist
    ('() (print-unknown raw) (values ctx hist pre-hist))
    (_
     (define-values (hist* pre-hist*) (pop pre-hist))
     (back raw ctx hist* pre-hist*))))
(:
  save
  (-> String Context History History* (Values Context History History*)))
(define (save raw ctx hist pre-hist)
   (values ctx '() (push pre-hist (push hist ctx))))
(: push (All (A) (-> (Listof A) A (Listof A))))
(define (push hist ctx) (cons ctx hist))
(: pop (All (A) (-> (Listof A) (values A (Listof A)))))
(define (pop hist) (values (car hist) (cdr hist)))
(define (print-alias)
   (displayln "At your service. Command aliases:")
   (displayln
    (string-join
     (for/list
      :
      (Listof String)
      ((cmd : Command COMMANDS))
      (format
       "  ~a        ~a"
       (command-name cmd)
       (string-join (command-aliases cmd))))))
   (newline))
(: print-history (-> History Void))
(define (print-history hist) (printf "History is: ~a\n" hist))
(define (print-help)
   (displayln "At your service. Available commands:")
   (displayln
    (string-join
     (for/list
      :
      (Listof String)
      ((cmd COMMANDS))
      (format
       "  ~a~a    ~a"
       (command-name cmd)
       (if (= 1 (command-num-args cmd)) " ARG" "    ")
       (command-help-msg cmd)))
     "\n")))
(: print-context (-> Context Void))
(define (print-context ctx)
   (match
    ctx
    ((? zo?) (displayln (zo->string ctx)))
    ('() (displayln "'()"))
    ((cons x _)
     (define z (if (result? x) (result-zo x) x))
     (printf "~a[~a]\n" (zo->string z #:deep? #f) (length ctx)))
    (_ (error 'zo-shell:info (format "Unknown context '~a'" ctx)))))
(: print-unknown (-> String Void))
(define (print-unknown raw) (printf "'~a' not permitted.\n" raw))
(define (print-goodbye)
   (printf "Ascending to second-level meditation. Goodbye.\n\n"))
(: print-debug (-> String Void))
(define (print-debug str) (printf "DEBUG: ~a\n" str))
(define (print-welcome)
   (display
    (format
     "\e[1;34m--- Welcome to the .zo shell, version ~a '~a' ---\e[0;0m\n"
     VERSION
     VNAME)))
(: print-prompt (-> Context Void))
(define (print-prompt ctx)
   (define tag
     (cond
      ((list? ctx) (format "[~a]" (length ctx)))
      ((zo? ctx) (format "(~a)" (car (zo->spec ctx))))
      (else "")))
   (display (string-append tag " \e[1;32mzo> \e[0;0m")))
(: print-info (-> String Void))
(define (print-info str) (printf "INFO: ~a\n" str))
(: print-warn (-> String Void))
(define (print-warn str) (printf "WARN: ~a\n" str))
(define (print-error str) (printf "ERROR: ~a\n" str))
(define USAGE "Usage: zo-shell <OPTIONS> FILE.zo")
(define (print-usage) (displayln USAGE))
(: member? (-> String (Listof String) Boolean))
(define (member? s str*) (if (member s str*) #t #f))
(: starts-with? (-> String String Boolean))
(define (starts-with? str prefix)
   (and (<= (string-length prefix) (string-length str))
        (for/and
         ((c1 (in-string str)) (c2 (in-string prefix)))
         (char=? c1 c2))))
(: find-all (->* (zo (Listof String)) (#:limit (U Natural #f)) Void))
(define (find-all ctx args #:limit (lim #f))
   (for ((arg (in-list args))) (void (length (zo-find ctx arg #:limit lim))))
   (void))
(: split-snd (-> String (U #f String)))
(define (split-snd raw)
   (define splt (string-split raw))
   (match
    splt
    ((list _ x) x)
    ((list _ x ys ...)
     (print-warn (format "Ignoring extra arguments: '~a'" ys))
     x)
    (_ #f)))
(: has-any-flags? (-> (Vectorof String) Boolean))
(define (has-any-flags? v)
   (for/or
    ((str (in-vector v)))
    (and (< 0 (string-length str)) (eq? #\- (string-ref str 0)))))
