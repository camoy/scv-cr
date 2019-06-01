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

;; Syntax -> Contract-Quad
;; extracts and collects contract information from expanded syntax
(define (contract-extract stx)
  (define-values (provide-defn-map provide-defns)
    (provide-ctc-defns stx))
  (define-values (require-defn-map require-defns)
    (require-ctc-defns stx))
  (define-values (provide-ids provide-out)
    (provide-ctc-out stx provide-defn-map))
  (define-values (require-ids require-out)
    (require-ctc-out stx require-defn-map))
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

;; Symbol (Syntax -> Syntax) -> Syntax -> [Listof Syntax] TODO
;; makes a munged definition function
(define ((make-ctc-defns key munger) stx)
  (let* ([id->ctc
          (append-map munger (syntax-property-values stx key))]
         [id->ctc*
          (sort id->ctc (λ (x y) (symbol<? (syntax-e (car x))
                                           (syntax-e (car y)))))]
         [pair->stx
          (λ (p) #`(define #,(car p) #,(cdr p)))])
    (values id->ctc*
            (map pair->stx id->ctc*))))

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

;; [List-of [Cons Syntax Syntax]] -> Syntax
;; constructs a provide form from a mapping between identifiers and contract definitions
(define (provide-wrapper p/c-items)
  (if (empty? p/c-items)
      #'(provide)
      #`(provide (contract-out #,@p/c-items))))

;; Symbol (Syntax -> [List-of Syntax]) -> (Syntax -> [List-of [List-of Syntax]])
;; takes a key for searching syntax properties and a syntax parser that yields
;; associations between bindings and contract definitions and constructs a
;; binding+ctc function
(define ((make-ctc-out key transform) stx defn-map)
  (define pairs
    (map transform (syntax-property-values stx key)))
  (define pairs*
    (struct-munge pairs stx defn-map))
  (values (map car pairs)
          (provide-wrapper pairs)))

;; Syntax -> [List-of [List-of Syntax]]
;; takes syntax from Typed Racket and yields an immutable hash mapping from exported
;; identifiers to contract definitions
(define provide-ctc-out
  (make-ctc-out
   'provide
   (syntax-parser
     #:datum-literals (begin define define-values
                       define-module-boundary-contract)
     [(begin (define _ ...) ...
             (define-values _ ...)
             (define-module-boundary-contract
               _ k v _ ...))
      (list #'k #'v)])))

;; Syntax -> [List-of [List-of Syntax]]
;; takes syntax from Typed Racket and yields an immutable hash mapping from imported
;; identifiers to contract definitions
(define require-ctc-out
  (make-ctc-out
   'require-rename
   (syntax-parser
     #:datum-literals (begin require rename-without-provide
                       define-ignored contract)
     [(begin (require _ ...)
             (rename-without-provide _ ...)
             (define-ignored _ (contract v k _ ...)))
      (list #'k #'v)])))
