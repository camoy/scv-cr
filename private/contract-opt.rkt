#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-opt)

(require racket/require
         (multi-in racket (contract list set function pretty))
         (multi-in scv-gt/private (configure
                                   contract-extract
                                   contract-inject
                                   syntax-compile
                                   syntax-util))
         graph
         syntax/parse
         soft-contract/main)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [List-of Path] [List-of Syntax] -> [List-of Syntax]
;; use SCV to optimize away contracts
(define (contract-opt targets data)
  (define targets*
    (map path->string targets))
  (define raw-stxs
    (map syntax-fetch targets))
  (define-values (m/l/i-hash m/g-hash)
    (values
     (make-hash)
     (make-hash)))
  (define stxs
    (for/list ([target  targets]
               [target* targets*]
               [raw-stx raw-stxs]
               [datum   data])
      (define l/i-hash (make-hash))
      (define stx
        (if datum
            (begin
              (hash-set! m/l/i-hash target* l/i-hash)
              (hash-set! m/g-hash target* (ctc-data-graph datum))
              (syntax-replace-srcloc! l/i-hash
                                      target
                                      (contract-inject target raw-stx datum #t)))
            raw-stx))
      #;(pretty-print (syntax->datum stx))
      (syntax-compile target stx)
      stx))
  (if (verify-off)
      (values stxs stxs)
      (values stxs
              (let* ([blames         (verify-modules targets* stxs)]
                     [_              (print-blames blames)]
                     [blameable-hash (and (not (keep-contracts))
                                          (make-blameable-hash targets*
                                                               m/l/i-hash
                                                               m/g-hash
                                                               blames))])
                (for/list ([target  targets]
                           [target* targets*]
                           [raw-stx raw-stxs]
                           [datum   data])
                  (if datum
                      (begin
                        (when (not (keep-contracts))
                          (erase-contracts! target
                                            datum
                                            (hash-ref blameable-hash target*)))
                        (contract-inject target raw-stx datum #f))
                      raw-stx))))))

;; Path Contract-Data L/I-Hash [Set Symbol] -> Void
;; erase contract by changing them to any/c
(define (erase-contracts! target data blameable)
  (define-values (require-bundle provide-bundle)
    (values (ctc-data-require data)
            (ctc-data-provide data)))
  (set-ctc-bundle-outs! require-bundle
                        (map (make-any blameable)
                             (ctc-bundle-outs require-bundle)))
  (set-ctc-bundle-outs! provide-bundle
                        (map (make-any blameable)
                             (ctc-bundle-outs provide-bundle))))

;; [List-of String] [Hash String L/I-Hash] [Hash String Graph] [List-of Blame]
;; -> [Hash String [Set-of Symbol]]
;; returns a hash mapping module names to a set of identifiers that could
;; potentially incur blame
(define (make-blameable-hash targets m/l/i-hash m/g-hash blames)
  (define blameable-hash
    (make-hash))
  (define cannot-find '())
  (define ((add-to-cannot-find b))
    (set! cannot-find (cons b cannot-find)))
  (for ([target targets])
    (hash-set! blameable-hash target (mutable-set)))
  (for ([blame blames])
    (let* ([def-site  (third blame)]
           [mod       (first def-site)]
           [l+c       (cons (second def-site)
                            (third def-site))]
           [l/i-hash  (hash-ref m/l/i-hash mod (thunk #f))])
      (when l/i-hash
        (let* ([g         (hash-ref m/g-hash mod)]
               [blame-id  (hash-ref l/i-hash l+c (add-to-cannot-find blame))]
               [blameable (hash-ref blameable-hash mod)])
          (pretty-print l/i-hash)
          (when (not (void? blame-id))
            (define-values (h _)
              (bfs g blame-id))
            (define blame-ids
              (hash-keys h))
            (set-union! blameable (apply mutable-set blame-ids)))))))
  (pretty-print blameable-hash)
  (when (not (empty? cannot-find))
    (displayln long-line)
    (displayln "Cannot Handle Blame")
    (displayln long-line)
    (pretty-print cannot-find))
  blameable-hash)

;; [Set Symbol] -> (Syntax -> Syntax)
;; given an element in a contract-out specification will change all contracts
;; to any/c
(define ((make-any blameable) stx)
  (syntax-parse stx
    #:datum-literals (struct contract-out)
    [(contract-out (struct s ((p c) ...)))
     (if (safe-struct? blameable #'s)
         (if (identifier? #'s)
             #'(struct-out s)
             #`(struct-out #,(car (syntax-e #'s))))
         #`(contract-out
            (struct s #,(map (λ (p c)
                              (if (safe-identifier? blameable c)
                                  #`(#,p any/c)
                                  #`(#,p #,c)))
                            (syntax->list #'(p ...))
                            (syntax->list #'(c ...))))))]
    [(contract-out (k v))
     #:when (safe-identifier? blameable #'k)
     #'k]
    [_ stx]))

(define (safe-struct? blameable stx)
  (syntax-parse stx
    [(id super) (safe-identifier? blameable #'id)]
    [id (safe-identifier? blameable #'id)]))

(define (safe-identifier? blameable v)
  (not (set-member? blameable (syntax-e v))))

;; [List-of Blame] -> Void
;; print blames
(define (print-blames blames)
  (when (show-blames)
    (write blames)))
