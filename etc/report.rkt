#lang racket/base

(require racket/list
         racket/string
         racket/port
         racket/match
         txexpr)

(define data-paths
  (current-command-line-arguments))

(define (->string x)
  (with-output-to-string (λ () (display x))))

(define (get-color blame)
  (match blame
    [(list 'error _) "#FF4136"]
    [(list 'unexpected _ ) "grey"]
    [(list x _ ...) "#FFDC00"]))

(define (dat->html dat)
  (define data (call-with-input-file dat read))
  (define heading
    (txexpr* 'tr '()
             (txexpr* 'th '() "Configuration")
             (txexpr* 'th '() "Performance")
             (txexpr* 'th '() "Blame")))
  (define rows
    (map (λ (r)
           (define-values (config perf blame)
             (values (first r) (second r) (third r)))
           (txexpr* 'tr
                    (list (list 'bgcolor (get-color blame)))
                    (txexpr* 'td '() config)
                    (txexpr* 'td '() (string-join perf "\n"))
                    (txexpr* 'td '() (string-join (map ->string blame)
                                                  "\n"))))
         data))

  (with-output-to-file (path-replace-extension dat #".html") #:exists 'replace
    (λ () (display (xexpr->html (txexpr 'table '() (cons heading rows)))))))

(for ([p (in-vector data-paths)])
  (dat->html p))
