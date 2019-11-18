#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide contract-opt)

(require racket/require
         (multi-in racket (contract list set function pretty math))
         (multi-in scv-gt/private (configure
                                   contract-extract
                                   contract-inject
                                   syntax-compile
                                   syntax-util))
         graph
         syntax/parse
         syntax/strip-context
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
      #;(pretty-print
       (syntax->datum
        ((if datum typed-replace-require/opaque untyped-replace-require/opaque)
         stx)))
      (syntax-compile target stx)
      ((if datum typed-replace-require/opaque untyped-replace-require/opaque)
       stx)))
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
(define (erase-contracts! target data blameable-pair)
  (define-values (require-bundle provide-bundle blameable partial-hash)
    (values (ctc-data-require data)
            (ctc-data-provide data)
            (car blameable-pair)
            (cdr blameable-pair)))
  (set-ctc-bundle-outs! require-bundle
                        (map (remove-safe-ctcs blameable)
                             (ctc-bundle-outs require-bundle)))
  (set-ctc-bundle-outs! provide-bundle
                        (map (remove-safe-ctcs blameable)
                             (ctc-bundle-outs provide-bundle)))
  (set-ctc-bundle-defns! require-bundle
                         (map (make-any partial-hash
                                        (ctc-bundle-i/c-hash require-bundle))
                              (ctc-bundle-defns require-bundle)))
  (set-ctc-bundle-defns! provide-bundle
                         (map (make-any partial-hash
                                        (ctc-bundle-i/c-hash provide-bundle))
                              (ctc-bundle-defns provide-bundle))))

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
    (hash-set! blameable-hash
               target
               (cons (mutable-set) (make-hash))))
  (for ([blame blames])
    (let* ([def-site  (third blame)]
           [mod       (first def-site)]
           [l+c       (cons (second def-site)
                            (third def-site))]
           [l/i-hash  (hash-ref m/l/i-hash mod (thunk #f))])
      (when l/i-hash
        (let* ([g             (hash-ref m/g-hash mod)]
               [blame-id+stx  (hash-ref l/i-hash l+c (add-to-cannot-find blame))]
               [blameable     (hash-ref blameable-hash mod)]
               [blameable-set (car blameable)]
               [partial-hash  (cdr blameable)]
               [blame-id      (car blame-id+stx)]
               [blame-stx     (cdr blame-id+stx)])
          (when (not (void? blame-id))
            (add-to-partial-hash! partial-hash blame-id blame-stx)
            (define-values (h _)
              (bfs g blame-id))
            (define blame-ids
              (filter-map
               (λ (p)
                 (and (not (infinite? (cdr p))) (car p)))
               (hash->list h)))
            (set-union! blameable-set (apply mutable-set blame-ids)))))))
  (when (not (empty? cannot-find))
    (displayln long-line)
    (displayln "Cannot Handle Blame")
    (displayln long-line)
    (pretty-print cannot-find))
  blameable-hash)

(define (add-to-partial-hash! p-hash id blame-stx)
  (unless (hash-has-key? p-hash id)
    (hash-set! p-hash id (mutable-set)))
  (when (hash-ref p-hash id)
    (cond
      [(identifier? blame-stx)
       (set-add! (hash-ref p-hash id) (syntax-e blame-stx))]
      [else
       (hash-set! p-hash id #f)])))

;; [Set Symbol] -> (Syntax -> Syntax)
;; given an element in a contract-out specification will change all contracts
;; to any/c
(define ((remove-safe-ctcs blameable) stx)
  (syntax-parse stx
    #:datum-literals (struct contract-out)
    [(contract-out (struct s ((p c) ...)))
     (if (safe-struct? blameable #'s)
         (if (identifier? #'s)
             #'(struct-out s)
             #`(struct-out #,(car (syntax-e #'s))))
         #`(contract-out
            (struct s ((p c) ...))))]
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
;; print blames (we don't pretty print easier report collection)
(define (print-blames blames)
  (when (show-blames)
    (write blames)))

;; Syntax -> Syntax
;; take untyped syntax and replace require/opaque forms with corresponding
;; SCV define with #:opaque
(define (untyped-replace-require/opaque stx)
  (define opaque-requires '())
  (define stx*
    (let go ([stx stx])
      (syntax-parse stx
        #:datum-literals (require/opaque)
        [(require/opaque m x:opaque-clause ...)
         (set! opaque-requires
               (cons
                (replace-context
                 stx
                 #'(begin (require soft-contract/fake-contract) x.opaque-def ...))
                opaque-requires))
         (datum->syntax stx '(void))]
        [(f args ...)
         (datum->syntax
          stx
          (map go (syntax->list #'(f args ...))))]
        ;; Catch-all case
        [other #'other])))
  (syntax-parse stx*
    [(mod name lang (mb x ...))
     #`(mod name lang (mb #,@opaque-requires x ...))]))

;; Syntax -> Syntax
;; take typed syntax and replace require/opaque forms with corresponding
;; SCV define with #:opaque
(define (typed-replace-require/opaque stx)
  (define opaque-requires '())
  (define stx*
    (let go ([stx stx])
      (syntax-parse stx
        #:datum-literals (require/opaque)
        [(require/opaque m x:rt-clause ...)
         (set! opaque-requires
               (cons
                (replace-context
                 stx
                 #'(begin (require soft-contract/fake-contract) x.opaque-def ...))
                opaque-requires))
         (datum->syntax stx '(void))]
        [(f args ...)
         (datum->syntax
          stx
          (map go (syntax->list #'(f args ...))))]
        ;; Catch-all case
        [other #'other])))
  (syntax-parse stx*
    [(mod name lang (mb x ...))
     #`(mod name lang (mb #,@opaque-requires x ...))]))

(define-syntax-class opaque-clause
  #:attributes (opaque-def)
  (pattern n:id
           #:with opaque-def #'(define n #:opaque))
  (pattern [(~datum #:struct) sn:struct-name (f:id ...)]
           #:with opaque-def (if (syntax-e #'sn.super)
                                 #'(struct sn.name sn.super (f ...) #:transparent)
                                 #'(struct sn.name (f ...) #:transparent)))
  (pattern [(~datum #:opaque) _ pred:id]
           #:with opaque-def #'(define pred #:opaque)))

(define-syntax-class rt-clause
  #:attributes (opaque-def)
  (pattern [n:id _]
           #:with opaque-def #'(define n #:opaque))
  (pattern [(~datum #:struct) sn:struct-name ([f:id : t] ...)]
           #:with opaque-def (if (syntax-e #'sn.super)
                                 #'(struct sn.name sn.super ([f : t] ...) #:transparent)
                                 #'(struct sn.name ([f : t] ...) #:transparent)))
  (pattern [(~datum #:opaque) _ pred:id]
           #:with opaque-def #'(define pred #:opaque)))


(define ((make-any partial-hash i/c-hash) stx)
  (syntax-parse stx
    #:datum-literals (define)
    [(define id body)
     #:when (generated-contract-number (syntax-e #'id))
     (define partial-erasure-set
       (hash-ref partial-hash (syntax-e #'id) (λ () #f)))
     (if partial-erasure-set
         #`(define id
             #,(let go ([stx #'body])
                 (syntax-parse stx
                   [(f x ...)
                    #`(f #,@(map go (syntax->list #'(x ...))))]
                   [x
                    #:when (and (not (set-member? partial-erasure-set
                                                  (syntax-e #'x)))
                                (hash-ref-stx i/c-hash #'x))
                      #'any/c]
                   [x stx])))
         stx)]
    [_ stx]))
