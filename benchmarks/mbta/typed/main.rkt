#lang typed/racket/no-check
(define-values
  ()
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
    (letrec () (values))))
(require (only-in racket/contract contract-out))
(provide)
(require require-typed-check)
(require (only-in racket/string string-join))
(require "run-t.rkt")
(: dat->station-names (-> Path-String (Listof String)))
(define (dat->station-names fname)
   (for/list
    ((line (in-list (file->lines fname)))
     #:when
     (and (< 0 (string-length line)) (not (eq? #\- (string-ref line 0)))))
    (string-trim line)))
(define BLUE-STATIONS (dat->station-names "../base/blue.dat"))
(define GREEN-STATIONS (dat->station-names "../base/green.dat"))
(: path (-> String String String))
(define (path from to) (format "from ~a to ~a" from to))
(: enable (-> String String))
(define (enable s) (format "enable ~a" s))
(: disable (-> String String))
(define (disable s) (format "disable ~a" s))
(: assert (-> String Natural Void))
(define (assert result expected-length)
   (define num-result (length (string-split result "\n")))
   (unless (= num-result expected-length)
     (error
      (format
       "Expected ~a results, got ~a\nFull list:~a"
       expected-length
       num-result
       result))))
(: main (-> Void))
(define (main)
   (: run-query (-> String String))
   (define (run-query str)
     (define r (run-t str))
     (if r
       r
       (error 'main (format "run-t failed to respond to query ~e\n" str))))
   (assert (run-query (path "Airport" "Northeastern")) 14)
   (assert (run-query (disable "Government")) 1)
   (assert (run-query (path "Airport" "Northeastern")) 16)
   (assert (run-query (enable "Government")) 1)
   (assert (run-query (path "Airport" "Harvard Square")) 12)
   (assert (run-query (disable "Park Street")) 1)
   (assert (run-query (path "Northeastern" "Harvard Square")) 1)
   (assert (run-query (enable "Park Street")) 1)
   (assert (run-query (path "Northeastern" "Harvard Square")) 12)
   (for*
    ((s1 (in-list GREEN-STATIONS)) (s2 (in-list BLUE-STATIONS)))
    (run-query (path s1 s2))))
(time (main))
