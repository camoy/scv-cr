#lang racket

(require "../../etc/config.rkt"
         html-parsing)

(define benchmark "sieve")
(define (benchmark-dir benchmark subdir)
  (build-path "/" "home" "camoy" "wrk" "gtp-benchmarks" "benchmarks" benchmark subdir))

(define (everything benchmark)
  (define typed (directory-list (benchmark-dir benchmark "typed")))
  (define both-dir (benchmark-dir benchmark "both"))
  (define both
    (if (directory-exists? both-dir)
        (directory-list both-dir)
        '()))
  (define all (sort (append typed both) (λ (x y) (string<=? (path->string x)
                                                            (path->string y)))))
  all)

(define untyped-blame 0)
(define typed-blame 0)

(define list-of-blames '())

(for ([benchmark BENCHMARKS])
  (define report-name (format "~a-blames.html" benchmark))
  (when (file-exists? report-name)
    (define contents (html->xexp (file->string report-name)))
    (define-values (bits blames)
      (match contents
        [`(*TOP* (html ,_ (body (table ,_ (tr ,_ (td ,bits) ,_ ,blames) ...))))
         (values bits blames)]))
    (define files (everything benchmark))
    (for ([bits bits]
          [blame-list blames])
      (define typed-mapping
        (for/hash ([b bits]
                   [f files])
          (values f (eq? b #\1))))
      (when (not (equal? blame-list '(td)))
        (for ([blame (rest blame-list)])
          (define blame*
            (read (open-input-string blame)))
          #;(set! list-of-blames (append list-of-blames (list blame*)))
          (set! list-of-blames (append list-of-blames (list (first (third blame*)))))
          (define party
            (file-name-from-path (symbol->string (first blame*))))
          (when (hash-has-key? typed-mapping party)
            (if (hash-ref typed-mapping party)
                (set! typed-blame (add1 typed-blame))
                (set! untyped-blame (add1 untyped-blame)))))))))

(displayln (/ typed-blame (+ untyped-blame typed-blame)))

#;(pretty-print list-of-blames)
