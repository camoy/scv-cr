#lang errortrace racket/base

(require racket/require
         (multi-in racket (list match contract))
         syntax/parse
         (multi-in scv-gt private (syntax-util
                                   contract-munge
                                   struct-extract)))

;;
;; data
;;

(provide (struct-out contract-data)
         (struct-out contract-bundle))

(struct contract-data (provide require))
(struct contract-bundle (defns outs deps
                         i/c-hash p/c-hash s/o-hash))

;;
;; extraction function
;;

(provide contract-extract)

;; Syntax -> Contract-Data
;; extracts and collects contract information from expanded syntax
(define (contract-extract stx)
  (contract-data (hashes->bundle (provide-ctc-defns stx)
                                 (provide-ctc-outs stx)
                                 'provide
                                 stx)
                 (hashes->bundle (require-ctc-defns stx)
                                 (require-ctc-outs stx)
                                 'require-rename
                                 stx)))

;; I/C-Hash P/C-Hash Symbol Syntax -> Contract-Bundle
;; convert hashes to contract bundle
(define (hashes->bundle i/c-hash p/c-hash key stx)
  (define s/o-hash
    (p/c-remove-structs! i/c-hash p/c-hash key stx))
  (contract-bundle (hashes->defns i/c-hash p/c-hash s/o-hash)
                   (hashes->outs i/c-hash p/c-hash s/o-hash)
                   (hashes->deps i/c-hash p/c-hash s/o-hash)
                   i/c-hash
                   p/c-hash
                   s/o-hash))

;; I/C-Hash P/C-Hash S/O-Hash -> [List-of Syntax]
(define (hashes->defns i/c-hash p/c-hash s/o-hash)
  (hash-map i/c-hash (λ (k v) #`(define #,k #,v))))

;; I/C-Hash P/C-Hash S/O-Hash -> [List-of Syntax]
(define (hashes->outs i/c-hash p/c-hash s/o-hash)
  (append
   (hash-map
    p/c-hash
    (λ (k v) #`(#,k #,v)))
   (hash-map
    s/o-hash
    (λ (k v) v))))

;; I/C-Hash P/C-Hash S/O-Hash -> [List-of Syntax]
(define (hashes->deps i/c-hash p/c-hash s/o-hash)
  (define deps
    (hash-map
     i/c-hash
     (λ (k v) (syntax-dependencies v))))
  (apply append deps))

;;
;; contract definition function
;;

;; A I/C-Hash is a [Hash Syntax Syntax] mapping
;; from identifiers to contract definitions.

;; A Munger is a [Syntax -> [List-of [Cons Syntax Syntax]]]
;; that maps a syntax object to an associative list between
;; identifiers and their contract definition.

;; Symbol Munger -> (Syntax -> I/C-Hash)
;; makes a munged definition function where key is the syntax property
;; we inspect and munger is the function we use to munge the contract
;; definitions
(define ((make-ctc-defns key munger) stx)
  (define (compare x y)
    (symbol<? (syntax-e (car x))
              (syntax-e (car y))))
  (let* ([i/c-raw         (syntax-property-values stx key)]
         [i/c-assoc-list  (append-map munger i/c-raw)]
         [i/c-assoc-list* (sort i/c-assoc-list compare)])
    (make-hash i/c-assoc-list*)))

;; Syntax -> Syntax
;; yields munged provide contract definitions
(define provide-ctc-defns
  (make-ctc-defns
   'provide
   (syntax-parser
     #:datum-literals (begin
                        define
                        define-values
                        define-module-boundary-contract)
     [(begin (define xs xs-def) ...
             (define-values (y) y-def)
             (define-module-boundary-contract
               _ ...))
      (with-syntax ([(xs-def* ...)
                     (map contract-munge
                          (syntax-e #'(xs ...))
                          (syntax-e #'(xs-def ...)))]
                    [y-def*
                     (contract-munge #'y #'y-def)])
        (map cons
             (syntax-e #'(xs ... y))
             (syntax-e #'(xs-def* ... y-def*))))])))

;; Syntax -> Syntax
;; yields munged require contract definitions
(define require-ctc-defns
  (make-ctc-defns
   'require
   (syntax-parser
     #:datum-literals (begin define define-values)
     [(begin (define xs xs-def) ...
             (define-values (y) y-def))
      (with-syntax ([(xs-def* ...)
                     (map contract-munge
                          (syntax-e #'(xs ...))
                          (syntax-e #'(xs-def ...)))]
                    [y-def*
                     (contract-munge #'y #'y-def)])
        (map cons
             (syntax-e #'(xs ... y))
             (syntax-e #'(xs-def* ... y-def*))))])))

;;
;; contract outs function
;;

;; A P/C-Hash is a [Hash Syntax Syntax] mapping
;; provided identifiers to contract definitions.

;; Symbol Munger -> (Syntax -> P/C-Hash)
;; makes a munged out function where key is the syntax property
;; we inspect and munger is the function we use to munge the identifier
;; contract associations
(define ((make-ctc-outs key munger) stx)
  (let* ([p/c-raw         (syntax-property-values stx key)]
         [p/c-assoc-list  (map munger p/c-raw)])
    (make-hash p/c-assoc-list)))

;; Syntax -> P/C-Hash
;; takes syntax from Typed Racket and yields a hash
;; mapping exported identifiers to contract definitions
(define provide-ctc-outs
  (make-ctc-outs
   'provide
   (syntax-parser
     #:datum-literals (begin define define-values
                       define-module-boundary-contract)
     [(begin (define _ ...) ...
             (define-values _ ...)
             (define-module-boundary-contract
               _ k v _ ...))
      (cons #'k #'v)])))

;; Syntax -> P/C-Hash
;; takes syntax from Typed Racket and yields an immutable hash mapping from imported
;; identifiers to contract definitions
(define require-ctc-outs
  (make-ctc-outs
   'require-rename
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract v k _ ...)))
      (cons #'k #'v)])))

;;
;; contract bundle utils
;;

(provide contract-bundle-provided?)

(define (contract-bundle-provided? bundle id)
  (or (memf (λ (x) (equal? (syntax-e id)
                           (syntax-e x)))
            (hash-keys (contract-bundle-p/c-hash bundle)))
      (memf (λ (x) (equal? (struct-name id)
                           (syntax-e x)))
            (hash-keys (contract-bundle-s/o-hash bundle)))))

(define struct-name
  (syntax-parser
    #:datum-literals (struct-out)
    [(struct-out y) (syntax-e #'y)]
    [_ #f]))
