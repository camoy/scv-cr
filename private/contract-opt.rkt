#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-opt)

(require racket/require
         (multi-in racket (contract list set pretty))
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
                                      (contract-inject target raw-stx datum)))
            raw-stx))
      (syntax-compile target stx)
      stx))
  (if (verify-off)
      stxs
      (let* ([blames         (verify-modules targets* stxs)]
             [blameable-hash (make-blameable-hash targets*
                                                  m/l/i-hash
                                                  m/g-hash
                                                  blames)])
        (when (show-contracts)
          (displayln long-line)
          (displayln "Blames")
          (displayln long-line)
          (pretty-print blames))
        (for/list ([target  targets]
                   [target* targets*]
                   [raw-stx raw-stxs]
                   [datum   data])
          (if datum
              (begin
                (erase-contracts! target
                                  datum
                                  (hash-ref blameable-hash target*))
                (contract-inject target raw-stx datum))
              raw-stx)))))

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
;; -> [List-of Symbol]
;; returns a list of contract identifiers that could potentially incur blame
(define (make-blameable-hash targets m/l/i-hash m/g-hash blames)
  (define blameable-hash
    (make-hash))
  (for ([target targets])
    (hash-set! blameable-hash target (mutable-set)))
  (for ([blame blames])
    (let* ([def-site  (third blame)]
           [mod       (first def-site)]
           [pos       (third def-site)]
           [l/i-hash  (hash-ref m/l/i-hash mod)]
           [g         (hash-ref m/g-hash mod)]
           [blame-id  (hash-ref l/i-hash pos)]
           [blameable (hash-ref blameable-hash mod)])
      (define-values (h _)
        (bfs g blame-id))
      (define blame-ids
        (hash-keys h))
      (set-union! blameable (apply mutable-set blame-ids))))
  blameable-hash)

;; [Set Symbol] -> (Syntax -> Syntax)
;; given an element in a contract-out specification will change all contracts
;; to any/c
(define (make-any blameable)
  (syntax-parser
    #:datum-literals (struct)
    [(struct s (p ...))
     #`(struct s #,(map (make-any blameable)
                        (syntax-e #'(p ...))))]
    [(k v)
     #:when (not (set-member? blameable (syntax-e #'v)))
     #'(k any/c)]
    [(k v) #'(k v)]))
