#lang racket

(require racket/serialize
         racket/hash)

(provide store%
         current-target)

(define current-target
  (make-parameter (void)))

(define store%
  (class object%
    (init-field path)
    (field [data (make-hash)])
    (super-new)

    (define/public (make)
      (with-output-to-file path #:exists 'replace
        (λ () (write (serialize (make-hash))))))

    (define/public (delete)
      (delete-file path))

    (define/public (get)
      (deserialize (with-input-from-file path read)))

    (define/public (set new-data)
      (with-output-to-file path #:exists 'replace
        (λ () (write (serialize new-data)))))

    (define/public (load)
      (hash-union! data (get))
      (make))

    (define/public (intercept target-path stx)
      (when (file-exists? path)
        (let* ([target (resolved-module-path-name target-path)]
               [data* (get)]
               [record (hash-ref data* target '())]
               [record* (cons (syntax->datum stx) record)])
          (hash-set! data* target record*)
          (set data*)))
      stx)
    
    (define/public (finalize)
      (define (process-pair k v)
        (parameterize ([current-target k])
          (hash-set! data k (process v))))
      (hash-for-each data process-pair))

    (define/public (process record)
      record)

    (define/public (current-record)
      (hash-ref data (current-target)))

    ))
