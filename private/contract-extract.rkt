#lang racket/base

(require racket/require
         syntax/parse
         (multi-in racket (list match contract))
         (multi-in scv-gt private (syntax-util
                                   struct-extract
                                   provide-munge
                                   require-munge)))

;;
;; data
;;

(provide (struct-out contract-data))
(struct contract-data (provide-defns
                       provide-ids
                       provide-out
                       require-defns
                       require-ids
                       require-out) #:transparent)

;;
;; extraction function
;;

(provide contract-extract)

;; Syntax Syntax -> Contract-Quad
;; extracts and collects contract information from expanded syntax
(define (contract-extract stx-raw stx)
  (define-values (provide-defn-map provide-defns)
    (provide-ctc-defns stx))
  (define-values (require-defn-map require-defns)
    (require-ctc-defns stx))
  (define-values (provide-ids provide-out)
    (provide-ctc-out stx-raw stx provide-defn-map))
  (define-values (require-ids require-out)
    (require-ctc-out stx-raw stx require-defn-map))
  (contract-data provide-defns
                 provide-ids
                 provide-out
                 require-defns
                 require-ids
                 require-out))

;;
;; contract definition functions
;;

(provide provide-ctc-defns
         require-ctc-defns)

;; A I/C-Hash is a [Hash Syntax Syntax] mapping
;; from identifiers to contract definitions.

;; Symbol (Syntax -> Syntax) -> (Syntax -> I/C-Hash Syntax)
;; makes a munged definition function
(define ((make-ctc-defns key munger) stx)
  (define (compare-syntax-pair x y)
    (symbol<? (syntax-e (car x))
              (syntax-e (car y))))
  (define (pair->defn pair)
    #`(define #,(car pair) #,(cdr pair)))
  (let* ([i/c-list (append-map munger (syntax-property-values stx key))]
         [i/c-list* (sort i/c-list compare-syntax-pair)])
    (values (make-hash i/c-list*)
            (map pair->defn i/c-list*))))

;; Syntax -> Syntax
;; yields munged provide contract definitions
(define provide-ctc-defns
  (make-ctc-defns 'provide provide-munge))

;; Syntax -> Syntax
;; yields munged require contract definitions
(define require-ctc-defns
  (make-ctc-defns 'require require-munge))

;;
;; contract out functions
;;

(provide provide-ctc-out
         require-ctc-out)

;; A P/C-Hash is a [Hash Syntax Syntax] mapping
;; provided identifiers to contract definitions.

;; P/C-Hash -> Syntax
;; constructs a provide form from a mapping
;; between identifiers and contract definitions
(define (provide-wrapper p/c-hash struct-outs)
  #`(provide
     (contract-out
      #,@(hash-map p/c-hash list)
      #,@struct-outs)))

(require racket/pretty)

;; Symbol (Syntax -> [Cons Syntax Syntax]) -> (Syntax I/C-Hash -> P/C-Hash)
;; takes a key for searching syntax properties and a syntax parser that yields
;; associations between bindings and contract definitions and constructs a
;; binding+ctc function
(define ((make-ctc-out key struct? transform) stx-raw stx i/c-hash)
  (define p/c-hash
    (make-hash (map transform (syntax-property-values stx key))))
  (define struct-outs
    (if struct?
        (struct-munge! p/c-hash i/c-hash stx-raw)
        '()))
  (values (hash-keys p/c-hash)
          (provide-wrapper p/c-hash struct-outs)))

;; Syntax -> P/C-Hash
;; takes syntax from Typed Racket and yields a hash
;; mapping exported identifiers to contract definitions
(define provide-ctc-out
  (make-ctc-out
   'provide
   #t
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
(define require-ctc-out
  (make-ctc-out
   'require-rename
   #f
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract v k _ ...)))
      (cons #'k #'v)])))
