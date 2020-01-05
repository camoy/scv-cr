(module zo-shell racket/base
   (#%module-begin
    (begin
      (require soft-contract/fake-contract)
      (define zo-parse #:opaque)
      (define zo? #:opaque))
    (provide zo-read init)
    (require require-typed-check
             (only-in racket/string string-split string-join string-trim)
             racket/match)
    (require "zo-string.rkt" "zo-transition.rkt" "zo-find.rkt" scv-cr/opaque)
    (void)
    (define DEBUG #f)
    (define VERSION 1.0)
    (define VNAME "vortex")
    (define (init args)
      (match args ((vector ctx arg) (find-all ctx (list arg)))))
    (define (zo-read fname)
      (call-with-input-file fname (lambda (port) (zo-parse port))))
    (struct command (name num-args aliases help-msg) #:transparent)
    (define index? integer?)
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
      (command
       "jump"
       0
       (list "j" "warp" "top")
       "Revert to last saved position"))
    (define SAVE
      (command
       "save"
       0
       (list "mark")
       "Save the current context as jump target"))
    (define QUIT
      (command
       "quit"
       0
       (list "q" "exit" "leave" "bye")
       "Exit the interpreter"))
    (define COMMANDS (list ALST BACK DIVE FIND HELP INFO JUMP SAVE QUIT))
    (define ((cmd? c) str)
      (define splt (string-split str))
      (or (and (string=? "back" (command-name c))
               (member? str (list "cd .." "cd ../")))
          (and (= (sub1 (length splt)) (command-num-args c))
               (or (string=? (car splt) (command-name c))
                   (member? (car splt) (command-aliases c))))))
    (define (filename->shell name)
      (print-info (format "Loading bytecode file '~a'..." name))
      (call-with-input-file
       name
       (lambda (port)
         (print-info "Parsing bytecode...")
         (define ctx (zo-parse port))
         (print-info "Parsing complete!")
         (print-welcome)
         ((repl ctx '() '()) '()))))
    (define (zo->shell z) (print-welcome) ((repl z '() '()) '()))
    (define (split-cd cmd*)
      (match
       cmd*
       ('() '())
       ((cons cd-cmd rest)
        #:when
        (starts-with? cd-cmd "cd ")
        (append
         (map
          (lambda (x) (string-append "cd " x))
          (string-split (substring cd-cmd 3) "/"))
         (split-cd rest)))
       ((cons cmd rest) (cons cmd (split-cd rest)))))
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
             ((str (in-list (string-split ln ";"))))
             (string-trim str))))))
       ((cons (? (cmd? ALST) raw) cmd*)
        (print-alias)
        ((repl ctx hist pre-hist) cmd*))
       ((cons (? (cmd? BACK) raw) cmd*)
        ((let-values (((c h p) (back raw ctx hist pre-hist))) (repl c h p))
         cmd*))
       ((cons (? (cmd? DIVE) raw) cmd*)
        ((let-values (((c h p) (dive raw ctx hist pre-hist))) (repl c h p))
         cmd*))
       ((cons (? (cmd? FIND) raw) cmd*)
        ((let-values (((c h p) (find raw ctx hist pre-hist))) (repl c h p))
         cmd*))
       ((cons (? (cmd? HELP) raw) cmd*)
        (begin (print-help) ((repl ctx hist pre-hist) cmd*)))
       ((cons (? (cmd? INFO) raw) cmd*)
        (begin (print-context ctx) ((repl ctx hist pre-hist) cmd*)))
       ((cons (? (cmd? JUMP) raw) cmd*)
        ((let-values (((c h p) (jump raw ctx hist pre-hist))) (repl c h p))
         cmd*))
       ((cons (? (cmd? SAVE) raw) cmd*)
        ((let-values (((c h p) (save raw ctx hist pre-hist))) (repl c h p))
         cmd*))
       ((cons (? (cmd? QUIT) raw) cmd*) (print-goodbye))
       ((cons raw cmd*)
        (begin (print-unknown raw) ((repl ctx hist pre-hist) cmd*)))))
    (define BACK-WARNING
      (string-append
       "BACK removing most recent 'save' mark. "
       "Be sure to save if you want to continue exploring search result."))
    (define (back raw ctx hist pre-hist)
      (match
       (list hist pre-hist)
       ((list '() '()) (print-unknown raw) (values ctx hist pre-hist))
       ((list '() _)
        (displayln BACK-WARNING)
        (define-values (hist* pre-hist*) (pop pre-hist))
        (back raw ctx hist* pre-hist*))
       (_
        (define-values (ctx* hist*) (pop hist))
        (values ctx* hist* pre-hist))))
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
    (define (dive-list ctx hist arg)
      (define index (string->number arg))
      (cond
       ((or (not index)
            (not (index? index))
            (< index 0)
            (>= index (length ctx)))
        (print-unknown (format "dive ~a" arg))
        (values ctx hist))
       (else
        (define res (list-ref ctx index))
        (if (result? res)
          (values (result-zo res) (result-path res))
          (values res (push hist ctx))))))
    (define (dive-zo ctx hist field)
      (define-values (ctx* success?) (zo-transition ctx field))
      (cond
       (success? (values ctx* (push hist ctx)))
       (else (print-unknown (format "dive ~a" field)) (values ctx hist))))
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
    (define (jump raw ctx hist pre-hist)
      (match
       pre-hist
       ('() (print-unknown raw) (values ctx hist pre-hist))
       (_
        (define-values (hist* pre-hist*) (pop pre-hist))
        (back raw ctx hist* pre-hist*))))
    (define (save raw ctx hist pre-hist)
      (values ctx '() (push pre-hist (push hist ctx))))
    (define (push hist ctx) (cons ctx hist))
    (define (pop hist) (values (car hist) (cdr hist)))
    (define (print-alias)
      (displayln "At your service. Command aliases:")
      (displayln
       (string-join
        (for/list
         ((cmd COMMANDS))
         (format
          "  ~a        ~a"
          (command-name cmd)
          (string-join (command-aliases cmd))))))
      (newline))
    (define (print-history hist) (printf "History is: ~a\n" hist))
    (define (print-help)
      (displayln "At your service. Available commands:")
      (displayln
       (string-join
        (for/list
         ((cmd COMMANDS))
         (format
          "  ~a~a    ~a"
          (command-name cmd)
          (if (= 1 (command-num-args cmd)) " ARG" "    ")
          (command-help-msg cmd)))
        "\n")))
    (define (print-context ctx)
      (match
       ctx
       ((? zo?) (displayln (zo->string ctx)))
       ('() (displayln "'()"))
       ((cons x _)
        (define z (if (result? x) (result-zo x) x))
        (printf "~a[~a]\n" (zo->string z #f) (length ctx)))
       (_ (error 'zo-shell:info (format "Unknown context '~a'" ctx)))))
    (define (print-unknown raw) (printf "'~a' not permitted.\n" raw))
    (define (print-goodbye)
      (printf "Ascending to second-level meditation. Goodbye.\n\n"))
    (define (print-debug str) (printf "DEBUG: ~a\n" str))
    (define (print-welcome)
      (display
       (format
        "\e[1;34m--- Welcome to the .zo shell, version ~a '~a' ---\e[0;0m\n"
        VERSION
        VNAME)))
    (define (print-prompt ctx)
      (define tag
        (cond
         ((list? ctx) (format "[~a]" (length ctx)))
         ((zo? ctx) (format "(~a)" (car (zo->spec ctx))))
         (else "")))
      (display (string-append tag " \e[1;32mzo> \e[0;0m")))
    (define (print-info str) (printf "INFO: ~a\n" str))
    (define (print-warn str) (printf "WARN: ~a\n" str))
    (define (print-error str) (printf "ERROR: ~a\n" str))
    (define USAGE "Usage: zo-shell <OPTIONS> FILE.zo")
    (define (print-usage) (displayln USAGE))
    (define (member? s str*) (if (member s str*) #t #f))
    (define (starts-with? str prefix)
      (and (<= (string-length prefix) (string-length str))
           (for/and
            ((i1 (in-range (string-length str)))
             (i2 (in-range (string-length prefix))))
            (char=? (string-ref str i1) (string-ref prefix i2)))))
    (define (find-all ctx args (lim #f))
      (for ((arg (in-list args))) (void (length (zo-find ctx arg lim))))
      (void))
    (define (split-snd raw)
      (define splt (string-split raw))
      (match
       splt
       ((list _ x) x)
       ((list _ x ys ...)
        (print-warn (format "Ignoring extra arguments: '~a'" ys))
        x)
       (_ #f)))
    (define (has-any-flags? v)
      (for/or
       ((i (in-range (vector-length v))))
       (let ((str (vector-ref v i)))
         (and (< 0 (string-length str)) (eq? #\- (string-ref str 0))))))))
