#lang racket

(require racket/struct
         tr-contract/private/store/generic)

(provide provide-structs-store)

;; TODO: DRY this up

(define (syntax->datum* stx)
  (cond [(syntax? stx) (syntax->datum stx)]
        [(list? stx) (map syntax->datum stx)]
        [else stx]))

(define provide-structs-singleton%
  (class store% (super-new [filename "_provide-structs.dat"])
    (inherit get-hash set-hash)
    (define/override (intercept target-path stx)
      (when (file-exists? "_provide-structs.dat")
        (define target
          (resolved-module-path-name target-path))
        (define current-hash (get-hash))
        (define file-record
          (hash-ref current-hash target '()))
        (hash-set! current-hash
                   target
                   (cons (map syntax->datum* (struct->list stx))
                         file-record))
        (set-hash current-hash))
      stx)
    ))

(define provide-structs-store
  (new provide-structs-singleton%))
