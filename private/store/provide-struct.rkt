#lang racket

(require tr-contract/private/store
         syntax/parse)

(provide provide-struct
         [struct-out struct-data])

(struct struct-data (name super-struct fields
                     descriptor constructor predicate
                     getters setters) #:transparent)

(define provide-struct-singleton%
  (class store%
    (super-new [path "_provide-struct.dat"])
    (inherit current-record)
    (inherit-field data)

    (define/override (process record)
      (map syntax->struct-data record))

    (define/public (struct-function? id)
      (ormap
       (λ (datum)
         (cond
           [(equal? id (struct-data-descriptor datum)) (cons 'descriptor datum)]
           [(equal? id (struct-data-constructor datum)) (cons 'constructor datum)]
           [(equal? id (struct-data-predicate datum)) (cons 'predicate datum)]
           [(member id (struct-data-getters datum)) (cons 'getter datum)]
           [(member id (struct-data-setters datum)) (cons 'setter datum)]
           [else #f]))
       (current-record)))

    (define/public (struct-fields id)
      (define datum
        (findf (λ (datum) (equal? id (struct-data-name id)))
               (current-record)))
      (struct-data-fields datum))
    ))

(define (syntax->struct-data stx)
  (syntax-parse stx
    [(nm ctor desc _ _ pred gets sets sup flds)
      (apply struct-data
             (map syntax->datum
                  (list #'nm #'sup #'flds
                        #'desc #'ctor #'pred
                        #'gets #'sets)))]))

(define provide-struct
  (new provide-struct-singleton%))
