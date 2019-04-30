#lang racket/base

(require racket/require
         syntax/parse
         (multi-in racket (list match contract))
         (multi-in scv-gt private (syntax-util
                                   provide-munge
                                   require-munge)))

;;
;; data
;;

(provide (struct-out contract-quad))
(struct contract-quad (provide-defns
                       provide-out
                       require-defns
                       require-out) #:transparent)

;;
;; extraction function
;;

(provide contract-extract)

;; Syntax -> Contract-Quad
;; extracts and collects contract information from expanded syntax
(define (contract-extract stx)
  (contract-quad (provide-ctc-defns stx)
                 (provide-ctc-out stx)
                 (require-ctc-defns stx)
                 (require-ctc-out stx)))

;;
;; contract definition functions
;;

(provide provide-ctc-defns
         require-ctc-defns)

;; Symbol (Syntax -> Syntax) -> Syntax -> Syntax
;; makes a munged definition function
(define ((make-ctc-defns key munger) stx)
  #`(begin
      #,@(map munger (reverse (syntax-property-values stx key)))))

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
(define ((make-ctc-out key transform) stx)
  (provide-wrapper (map transform (syntax-property-values stx key))))

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
