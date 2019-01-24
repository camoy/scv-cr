#lang racket

(require tr-contract/private/store
         syntax/parse)

(provide struct-data
         [struct-out struct-desc])

(struct struct-desc (name super-struct fields
                     descriptor constructor predicate
                     getters setters) #:transparent)

(define struct-data-singleton%
  (class store%
    (super-new [path "_struct-data.dat"])
    (inherit current-record)
    (inherit-field data)

    (define/override (process record)
      (map syntax->struct-data record))

    (define/public (struct-function? id)
      (ormap
       (λ (datum)
         (cond
           [(equal? id (struct-desc-descriptor datum)) (cons 'descriptor datum)]
           [(equal? id (struct-desc-constructor datum)) (cons 'constructor datum)]
           [(equal? id (struct-desc-predicate datum)) (cons 'predicate datum)]
           [(member id (struct-desc-getters datum)) (cons 'getter datum)]
           [(member id (struct-desc-setters datum)) (cons 'setter datum)]
           [else #f]))
       (current-record)))

    (define/public (struct-fields id)
      (define datum
        (findf (λ (datum) (equal? id (struct-desc-name id)))
               (current-record)))
      (struct-desc-fields datum))
    ))

(define (syntax->struct-data stx)
  (syntax-parse stx
    [(nm ctor desc _ _ pred gets sets sup flds)
      (apply struct-desc
             (map syntax->datum
                  (list #'nm #'sup #'flds
                        #'desc #'ctor #'pred
                        #'gets #'sets)))]))

(define struct-data
  (new struct-data-singleton%))
