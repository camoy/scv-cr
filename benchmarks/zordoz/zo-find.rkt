(module zo-find racket/base
   (#%module-begin
    (provide zo-find (struct-out result))
    (require (only-in racket/list empty?)
             (only-in racket/string string-split string-trim)
             require-typed-check
             racket/match)
    (require "zo-transition.rkt" "zo-string.rkt" "compiler-zo-structs.rkt")
    (struct result (zo path) #:transparent)
    (define (append-all xss)
      (cond
       ((empty? xss) '())
       (else (append (car xss) (append-all (cdr xss))))))
    (define (zo-find z str (lim #f))
      (define-values (_ children) (parse-zo z))
      (append-all (for/list ((z* children)) (zo-find-aux z* '() str 1 lim))))
    (define (may-loop? str)
      (if (member str '("closure" "multi-scope" "scope")) #t #f))
    (define (zo-find-aux z hist str i lim)
      (define-values (title children) (parse-zo z))
      (define results
        (cond
         ((and lim (<= lim i)) '())
         ((and (may-loop? title) (memq z hist)) '())
         (else
          (define hist* (cons z hist))
          (append-all
           (for/list
            ((z* children))
            (zo-find-aux z* hist* str (add1 i) lim))))))
      (if (and (string=? str title) (not (memq z (map result-zo results))))
        (cons (result z hist) results)
        results))
    (define (parse-zo z)
      (define z-spec (zo->spec z))
      (define title (car z-spec))
      (define child-strs (for/list ((pair (cdr z-spec))) (car pair)))
      (values title (get-children z child-strs)))
    (define (get-children z strs)
      (match
       strs
       ('() '())
       ((cons hd tl)
        (define-values (r* success*) (zo-transition z hd))
        (define r r*)
        (define success? success*)
        (cond
         ((not success?) (get-children z tl))
         ((list? r) (append (filter zo? r) (get-children z tl)))
         ((zo? r) (cons r (get-children z tl)))))))))
