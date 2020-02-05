#lang racket/base

(provide benchmark->blame-report)

(require txexpr
         racket/list
         racket/string
         racket/path
         racket/port
         racket/match
         racket/function)

(define (benchmark->blame-report name idx dir blames)
  (display (data->html (out->data name idx dir)
                       blames)))

(define (data->html data infos)
  (define heading
    `(tr
      (th "Configuration")
      (th "Performance")
      (th "SCV-CR: expand")
      (th "SCV-CR: compile")
      (th "SCV-CR: SCV")
      (th "SCV-CR: Total")
      (th "SCV-CR: GC Stats")
      (th "Blames")))
  (define rows
    (for/list ([r data]
               [info infos])
      (define-values (config perf)
        (values (first r) (second r)))
      (define blame (hash-ref info 'blames))
      `(tr
        ((bgcolor ,(get-color blame)))
        (td ,config)
        (td ,(string-join perf "\n"))
        (td ,(format "~a" (hash-ref info 'expand (const 0))))
        (td ,(format "~a" (hash-ref info 'compile (const 0))))
        (td ,(format "~a" (hash-ref info 'verify-modules (const 0))))
        (td ,(format "~a" (hash-ref info 'total (const 0))))
        (td (code (pre ,(format "~a" (hash-ref info 'gc (const 0))))))
        (td (code (pre ,(string-join (map ->string blame) "\n")))))))
  (define tbl
    (txexpr 'table '() (cons heading rows)))
  (xexpr->html (within-body tbl)))

(define (out->data name idx dir)
  (define prefix-length
    (string-length (format "0-~a" name)))
  (define (path->number path)
    (define n
      (substring (path->string (path-replace-extension path #""))
                 prefix-length))
    (if (non-empty-string? n)
        (string->number n)
        0))
  (define outs
    (filter (λ (path)
              (and (path-has-extension? path #".out")
                   (path->number path)))
            (directory-list dir)))
  (define (compare x y)
    (< (path->number x) (path->number y)))
  (append-map
   (λ (x)
     (define f (open-input-file (build-path dir x)))
     (let go ([xs '()]
              [x  (read f)])
       (if (eof-object? x)
           (reverse xs)
           (go (cons x xs) (read f)))))
   (sort outs compare)))

(define (get-color blame)
  (match blame
    [(list 'error _) "#FF4136"]
    [(list 'unexpected _ ) "grey"]
    [(list x _ ...) "#FFDC00"]
    [(list) "white"]))

(define (within-body x)
  `(html (head (meta ((charset "utf-8"))))
         (body ,x)))

(define (->string x)
  (with-output-to-string (λ () (display x))))
