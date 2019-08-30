#lang racket/base

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(provide (struct-out ctc-data)
         (struct-out ctc-bundle)
         contract-extract
         ctc-bundle-provides)

(require racket/require
         (multi-in racket (list string syntax))
         (multi-in scv-gt/private (contract-munge struct-extract syntax-util))
         syntax/parse
         graph)

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntaxes is a [List-of Syntax].

;; Ctc-Data is a (ctc-data Ctc-Bundle Ctc-Bundle Graph D/I-Hash M/I-Hash)
;; containing contract information for both provided identifiers and required
;; identifiers, a graph describing contract dependencies, and hashes
;; describing mappings between predicates and their contracts.
(struct ctc-data (provide require graph d-pred m-pred) #:transparent)

;; A Ctc-Bundle is a (ctc-bundle Syntaxes Syntaxes Syntaxes I/C-Hash P/C-Hash
;; S/O-Hash C/C-List) bundling together all the contract information necessary.
(struct
  ctc-bundle
  (defns outs deps i/c-hash p/c-hash s/o-hash c/c-list)
  #:mutable
  #:transparent)

;; A I/C-Hash is a [Hash Syntax Syntax] of auxiliary contract definitions,
;; mapping an identifier to a contract.

;; A P/C-Hash is a [Hash Syntax Syntax] mapping provided identifiers to contract
;; definitions, usually just an auxiliary identifier.

;; An S/O-Hash is a [Hash Syntax Syntax] mapping struct names to their struct-out
;; declaration for contract-out.

;; A C/C-Hash is a [Hash Symbol Symbol] mapping an identifier to the contract
;; definition its contained in.

;; A Munger is a [Syntax -> [List-of [Cons Syntax Syntax]]] that maps a syntax
;; object to an associative list between identifiers and their contract
;; definition.

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Syntax -> Ctc-Data
;; extracts and collects contract information from expanded syntax
(define (contract-extract targets stx stx-raw)
  (define-values (provide-bundle require-bundle)
    (values (hashes->bundle targets
                            (provide-ctc-defns stx)
                            (provide-ctc-outs stx)
                            'provide
                            stx-raw)
            (hashes->bundle targets
                            (require-ctc-defns stx)
                            (require-ctc-outs stx)
                            'require-rename
                            stx-raw)))
  (define ctc-graph
    (hashes->graph (ctc-bundle-c/c-list provide-bundle)
                   (ctc-bundle-c/c-list require-bundle)))
  (define-values (d-pred m-pred)
    (list->predicate-hashes (syntax-property-values stx 'make-predicate)))
  (ctc-data provide-bundle require-bundle ctc-graph d-pred m-pred))

;; [List-of Path] I/C-Hash P/C-Hash Symbol Syntax -> Ctc-Bundle
;; convert hashes to contract bundle
(define (hashes->bundle targets i/c-hash p/c-hash kind stx)
  (define s/o-hash
    (p/c-remove-structs! i/c-hash p/c-hash kind stx))
  (define deps
    (hashes->deps i/c-hash p/c-hash s/o-hash))
  (define c/c-list
    (hashes->c/c-list p/c-hash s/o-hash i/c-hash))
  (ctc-bundle (hashes->defns targets i/c-hash p/c-hash s/o-hash)
              (hashes->outs i/c-hash p/c-hash s/o-hash)
              deps
              i/c-hash
              p/c-hash
              s/o-hash
              c/c-list))

;; [List-of Path] I/C-Hash P/C-Hash S/O-Hash -> Syntaxes
;; constructs a list of define forms that provide auxiliary definitions
;; for contracts, sorting definitions such that a dependency occurs
;; before its usage
(define (hashes->defns targets i/c-hash p/c-hash s/o-hash)
  (let* ([i/c-assoc-list  (hash->list i/c-hash)]
         [i/c-assoc-list* (sort i/c-assoc-list compare)])
    (map (λ (p)
           #`(define
               #,(car p)
               #,(syntax-scope-external targets (cdr p))))
         i/c-assoc-list*)))

;; I/C-Hash P/C-Hash S/O-Hash -> [List-of Syntax]
;; constructs forms that will be injected inside of a contract-out
(define (hashes->outs i/c-hash p/c-hash s/o-hash)
  (append (hash-map p/c-hash
                    (λ (k v)
                      #`(contract-out #,(syntax-within #`(#,k #,v)
                                                       k))))
          (hash-map s/o-hash
                    (λ (k v)
                      #`(contract-out #,(syntax-within #`(struct #,k #,v)
                                                       k))))))

;; I/C-Hash P/C-Hash S/O-Hash -> [List-of Syntax]
;; constructs a minimal list of dependencies for injection into a
;; require form as well as a hash that maps module names to the
;; syntax introducer that was used on it
(define (hashes->deps i/c-hash p/c-hash s/o-hash)
  (define deps
    (hash-map i/c-hash (λ (k v) (syntax-dependencies v))))
  (map (λ (x) (syntax-preserve ((make-syntax-introducer)
                                (datum->syntax #f x))))
       (remove-duplicates (apply append deps))))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; C/C-List C/C-List -> Graph
;; converts c/c-lists from provide and requires into a collective contract
;; dependency graph
(define (hashes->graph c/c-p c/c-r)
  (unweighted-graph/directed (append c/c-p c/c-r)))

;; P/C-Hash S/O-Hash I/C-Hash -> C/C-List
;; converts an I/C-Hash into a C/C-List
(define (hashes->c/c-list p/c-hash s/o-hash i/c-hash)
  (define c/c-list (box '()))
  (hash-for-each
   p/c-hash
   (λ (k v)
     (hash-map-identifier! c/c-list (syntax-e k) v)))
  (hash-for-each
   s/o-hash
   (λ (k v)
     (define k* (syntax-e k))
     (define k** (if (pair? k*)
                     (syntax-e (car k*))
                     k*))
     (for ([x (in-list (syntax-e v))])
       (define ctc (cadr (syntax-e x)))
       (hash-map-identifier! c/c-list k** ctc))))
  (hash-for-each
   i/c-hash
   (λ (k v)
     (hash-map-identifier! c/c-list (syntax-e k) v)))
  (unbox c/c-list))

;; [Box C/C-List] Symbol Syntax -> Void
;; adds identifier mappings to c/c-hash from the syntax e
(define (hash-map-identifier! c/c-list k e)
  (let go ([e e])
    (cond
      [(identifier? e)
       (set-box! c/c-list (cons (list (syntax-e e) k)
                                (unbox c/c-list)))]
      [(syntax? e)
       (go (syntax-e e))]
      [(pair? e)
       (go (car e))
       (go (cdr e))]
      [else
       (void)])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Symbol Munger -> (Syntax -> I/C-Hash)
;; makes a munged definition function where kind is the key of the syntax
;; property we inspect and the munger is the function we use to munge the
;; contract definitions
(define ((make-ctc-defns kind munger) stx)
  (let* ([i/c-raw        (syntax-property-values stx kind)]
         [i/c-assoc-list (append-map munger i/c-raw)])
    (make-hash i/c-assoc-list)))

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
        (map (λ (k v)
               (cons (lifted->l-within k)
                     (syntax-within v k)))
             (syntax-e #'(xs ... y))
             (syntax-e #'(xs-def* ... y-def*))))]
     [_ '()])))

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
        (map (λ (k v)
               (cons (lifted->l-within k)
                     (syntax-within v k)))
             (syntax-e #'(xs ... y))
             (syntax-e #'(xs-def* ... y-def*))))]
     [_ '()])))

;; Syntax -> Syntax
;; changes lifted identifiers and attaches within syntax property
(define (lifted->l-within stx)
  (syntax-within (lifted->l stx) stx))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

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
             (~optional (define-values _ ...))
             (define-module-boundary-contract
               _ k v _ ...))
      (cons #'k (contract-munge #'_ (lifted->l #'v)))])))

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
      (cons #'k (contract-munge #'_ (lifted->l #'v)))])))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; Ctc-Bundle Ctc-Bundle -> (Syntax -> [List-of Syntax])
;; determines if an identifier had already been provided with a contract-out
(define ((ctc-bundle-provides p-bundle r-bundle) id)
  (define s-name
    (datum->syntax #f (struct-out->name id)))
  (define-values (p-p/c p-s/o r-p/c)
    (values (hash-ref-stx (ctc-bundle-p/c-hash p-bundle) id)
            (hash-ref-struct (ctc-bundle-s/o-hash p-bundle) s-name)
            (hash-ref-struct (ctc-bundle-s/o-hash r-bundle) s-name)))
  (cond
    [p-p/c '()]
    [p-s/o '()]
    [r-p/c (list id (format-id s-name "~a?" s-name))]
    [else (list id)]))

;; Syntax -> Symbol
;; extract out a struct name from a struct-out form
(define struct-out->name
  (syntax-parser
    #:datum-literals (struct-out)
    [(struct-out y) (syntax-e #'y)]
    [_ #f]))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [List-of [Cons Syntax Syntax]] -> D/I-Hash M/I-Hash
;; makes predicate hashes
(define (list->predicate-hashes xs)
  (define xs* (filter pair? xs))
  (define-values (d-list m-list)
    (partition (λ (x)
                 (syntax-parse (car x)
                   #:datum-literals (define-predicate)
                   [(define-predicate _ _) #t]
                   [_ #f]))
               (map (λ (x) (cons (car x)
                                 (lifted->l (cdr x)))) xs*)))
  (values (make-hash d-list) (make-hash m-list)))

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;; [List-of (Symbol -> Number)]
;; list of functions for ordering identifiers
(define identifier-orders
  (list g-number generated-contract-number lifted-number))

;; Syntax Syntax -> Boolean
;; compares identifiers based on numeric suffix
(define (compare x y)
  (define-values (x* y*)
    (values (syntax-e (car x))
            (syntax-e (car y))))
  (let go ([orders identifier-orders])
    (if (empty? orders)
        (symbol<? x* y*)
        (let ([x** ((car orders) x*)]
              [y** ((car orders) y*)])
          (if (and x** y**)
              (< x** y**)
              (go (cdr orders)))))))
