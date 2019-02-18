#lang typed/racket/base/no-check
(define-values
  (g49
   g50
   g51
   generated-contract33
   g52
   generated-contract28
   g53
   g54
   g55
   g56
   g57
   g58
   g59
   generated-contract29
   generated-contract30
   generated-contract31
   g60
   g61
   g62
   g63
   generated-contract34)
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
    (letrec ((g49 (lambda (x) (zo? x)))
             (g50 (listof g49))
             (g51 (lambda (x) (result? x)))
             (generated-contract33 (-> g49 g50 (values g51)))
             (g52 (λ (_) #f))
             (generated-contract28 g52)
             (g53 (λ (_) #f))
             (g54 any/c)
             (g55 '#t)
             (g56 '#f)
             (g57 (or/c g55 g56))
             (g58 (-> g54 (values g57)))
             (g59 (or/c g53 g58))
             (generated-contract29 g59)
             (generated-contract30 (-> g51 (values g50)))
             (generated-contract31 (-> g51 (values g49)))
             (g60 string?)
             (g61 exact-nonnegative-integer?)
             (g62 (or/c g61 g56))
             (g63 (listof g51))
             (generated-contract34 (->* (g49 g60) (#:limit g62) (values g63))))
      (values
       g49
       g50
       g51
       generated-contract33
       g52
       generated-contract28
       g53
       g54
       g55
       g56
       g57
       g58
       g59
       generated-contract29
       generated-contract30
       generated-contract31
       g60
       g61
       g62
       g63
       generated-contract34))))
(require (only-in racket/contract contract-out))
(provide (contract-out (struct result ((zo g49) (path g50))))
          (contract-out (zo-find generated-contract34)))
(provide)
(require (only-in racket/list empty?)
          (only-in racket/string string-split string-trim)
          require-typed-check
          "../base/typed-zo-structs.rkt"
          racket/match)
(require "zo-transition.rkt")
(require "zo-string.rkt")
(struct result ((zo : zo) (path : (Listof zo))) #:transparent)
(: append-all (All (A) (-> (Listof (Listof A)) (Listof A))))
(define (append-all xss)
   (cond ((empty? xss) '()) (else (append (car xss) (append-all (cdr xss))))))
(: zo-find (-> zo String (#:limit (U Natural #f)) (Listof result)))
(define (zo-find z str #:limit (lim #f))
   (define-values (_ children) (parse-zo z))
   (append-all
    (for/list
     :
     (Listof (Listof result))
     ((z* : zo children))
     (zo-find-aux z* '() str 1 lim))))
(: may-loop? (-> String Boolean))
(define (may-loop? str)
   (if (member str '("closure" "multi-scope" "scope")) #t #f))
(:
  zo-find-aux
  (-> zo (Listof zo) String Natural (U Natural #f) (Listof result)))
(define (zo-find-aux z hist str i lim)
   (define-values (title children) (parse-zo z))
   (define zstr (format "~a" z))
   (: results (Listof result))
   (define results
     (cond
      ((and lim (<= lim i)) '())
      ((and (may-loop? title) (memq z hist)) '())
      (else
       (: hist* (Listof zo))
       (define hist* (cons z hist))
       (append-all
        (for/list
         :
         (Listof (Listof result))
         ((z* : zo children))
         (zo-find-aux z* hist* str (add1 i) lim))))))
   (if (and (string=? str title) (not (memq z (map result-zo results))))
     (cons (result z hist) results)
     results))
(: parse-zo (-> zo (values String (Listof zo))))
(define (parse-zo z)
   (: z-spec Spec)
   (define z-spec (zo->spec z))
   (: title String)
   (define title (car z-spec))
   (: child-strs (Listof String))
   (define child-strs
     (for/list
      :
      (Listof String)
      ((pair : (Pair String (-> (U String Spec))) (cdr z-spec)))
      (car pair)))
   (values title (get-children z child-strs)))
(: get-children (-> zo (Listof String) (Listof zo)))
(define (get-children z strs)
   (match
    strs
    ('() '())
    ((cons hd tl)
     (define-values (r* success*) (zo-transition z hd))
     (: r (U zo (Listof zo)))
     (define r r*)
     (: success? Boolean)
     (define success? success*)
     (cond
      ((not success?) (get-children z tl))
      ((list? r) (append (filter zo? r) (get-children z tl)))
      ((zo? r) (cons r (get-children z tl)))))))
