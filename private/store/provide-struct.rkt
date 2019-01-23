#lang racket

(require tr-contract/private/store
         syntax/parse)

(provide provide-struct)

(struct struct-data (name super-struct fields
                     descriptor constructor predicate
                     getters setters) #:transparent)

(define provide-struct-singleton%
  (class store%
    (super-new [path "_provide-struct.dat"])
    (inherit-field data)

    (define/override (process record)
      (map syntax->struct-data record))

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
