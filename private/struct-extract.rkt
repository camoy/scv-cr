#lang racket/base

(require racket/list
         racket/set
         racket/syntax
         racket/string
         racket/function
         mischief/dict)

(define (extract-structs stx)
  (define name->fields
    (make-hash))
  (let go ([stx stx])
    (syntax-case stx (struct :)
      [(struct name ((fld : type) ...))
       (hash-set! name->fields
                  (syntax-e #'name)
                  (syntax->datum #'(fld ...)))
       stx]
      [(x ...)
       (for-each go (syntax-e #'(x ...)))
       stx]
      [_ stx]))
  name->fields)

(define (struct-exports name flds)
  (append (list name
                (format-symbol "~a?" name)
                (format-symbol "struct:~a" name))
          (struct-accessors name flds)
          (struct-mutators name flds)))

(define (struct-accessors name flds)
  (map (curry format-symbol "~a-~a" name) flds))

(define (struct-mutators name flds)
  (map (curry format-symbol "set-~a-~a!" name) flds))

(define ((make-struct-proc? kind) name->fields)
  (define exports
    (apply append
           (hash-map name->fields
                     (λ (name flds)
                       (map (λ (fld) (cons fld name))
                            (kind name flds))))))
  (dict->procedure exports #:failure #f))

(define struct-export? (make-struct-proc? struct-exports))
(define struct-accessor? (make-struct-proc? struct-accessors))
(define struct-mutator? (make-struct-proc? struct-mutators))

(provide struct-munge)

(define (chase-codomain id id->ctc)
  (syntax-case (hash-ref id->ctc id) (->)
    [(-> _ x) #'x]
    [x        (chase-codomain #'x id->ctc)]))

(define (get-field id)
  (car (string-split (symbol->string id) "-")))

(define (add-to-struct-hash p struct-hash id->ctc)
  (let* ([id (car p)]
         [acc-ctc (cdr p)]
         [fld (get-field id)]
         [fld-ctc (chase-codomain acc-ctc id->ctc)])
    (hash-set! (hash-ref struct-hash id)
               fld
               fld-ctc)))

(define (make-struct-out struct-hash)
  (hash-map struct-hash
            (λ (name flds+ctcs)
              #`(struct #,name #,(hash->list flds+ctcs)))))

(define (struct-munge pairs stx id->ctc)
  (let* ([name->fields (extract-structs stx)]
         [export?      (struct-export? name->fields)]
         [accessor?    (struct-accessor? name->fields)]
         [struct-hash  (make-hash (hash-map name->fields
                                            (λ (name _)
                                              (cons name (make-hash)))))])
    (append (filter (λ (p)
                      (or (not (accessor? (car p)))
                          (begin
                            (add-to-struct-hash p struct-hash id->ctc)
                            #f)))
                    pairs)
            (make-struct-out struct-hash))))

(module+ test
  (require rackunit)

  (define posn-hash
    (make-hash '((posn . (x y z)))))

  (test-case
    "extract-structs"
    (check-equal?
     (extract-structs
      #'(module root typed/racket/base
          (struct posn ((x : Real) (y : Real) (z : Real)))))
     posn-hash))

  (test-case
    "struct-exports"
    (check-equal?
     (struct-exports 'posn '(x y z))
     '(posn
       posn?
       struct:posn
       posn-x posn-y posn-z
       set-posn-x! set-posn-y! set-posn-z!)))

  (define posn-export? (struct-export? posn-hash))
  (define posn-accessor? (struct-accessor? posn-hash))
  (define posn-mutator? (struct-mutator? posn-hash))

  (test-case
    "struct-export?"
    (check-equal? (posn-export? 'posn) 'posn)
    (check-equal? (posn-export? 'posn-x) 'posn)
    (check-false  (posn-export? 'posn-w))
    (check-equal? (posn-export? 'set-posn-y!) 'posn)
    (check-equal? (posn-export? 'posn?) 'posn)
    (check-equal? (posn-export? 'struct:posn) 'posn)
    )

  (test-case
    "struct-accessor?"
    (check-false  (posn-accessor? 'posn))
    (check-equal? (posn-accessor? 'posn-x) 'posn)
    (check-equal? (posn-accessor? 'posn-y) 'posn)
    (check-equal? (posn-accessor? 'posn-z) 'posn)
    (check-false  (posn-accessor? 'posn-w))
    (check-false (posn-accessor? 'set-posn-y!))
    (check-false (posn-accessor? 'posn?))
    (check-false (posn-accessor? 'struct:posn))
    )

  (test-case
    "struct-mutator?"
    (check-false  (posn-mutator? 'posn))
    (check-false (posn-mutator? 'posn-x))
    (check-false  (posn-mutator? 'posn-w))
    (check-equal? (posn-mutator? 'set-posn-x!) 'posn)
    (check-equal? (posn-mutator? 'set-posn-y!) 'posn)
    (check-equal? (posn-mutator? 'set-posn-z!) 'posn)
    (check-false (posn-mutator? 'posn?))
    (check-false (posn-mutator? 'struct:posn))
    )
  )
