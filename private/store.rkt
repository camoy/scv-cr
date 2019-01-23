#lang racket

(require racket/serialize
         racket/hash
         tr-contract/private/store/provide-struct
         tr-contract/private/store/provide-contract
         tr-contract/private/store/require-mapping
         tr-contract/private/store/require-contract)

(provide
 (all-from-out tr-contract/private/store/provide-struct
               tr-contract/private/store/provide-contract
               tr-contract/private/store/require-mapping
               tr-contract/private/store/require-contract)
 (all-defined-out))

(define store->path
  (hasheq provide-struct-store "_provide-struct-store.dat"
          provide-contract-store "_provide-contract-store.dat"
          require-mapping-store "_require-mapping-store.dat"
          require-contract-store "_require-contract-store.dat"))

(define-values (store-all persistent-all)
  (values (hash-keys store->path)
          (hash-values store->path)))

(define (persistent-init path)
  (with-output-to-file path #:exists 'replace
    (λ () (write (serialize (make-hash))))))

(define persistent-delete delete-file)

(define (persistent-get path)
  (deserialize (with-input-from-file path read)))

(define (persistent-set path new-data)
  (with-output-to-file path #:exists 'replace
    (λ () (write (serialize new-data)))))

(define (store-load store)
  (define path
    (hash-ref store->path store))
  (hash-union! store (persistent-get path))
  (persistent-init path))

(define (intercept store target-path stx)
  (define store-path
    (hash-ref store->path store))
  (when (file-exists? store-path)
    (let* ([target (resolved-module-path-name target-path)]
           [persistent (persistent-get store-path)]
           [record (hash-ref persistent target '())]
           [record* (cons (syntax->datum stx) record)])
      (hash-set! persistent target record*)
      (persistent-set store-path persistent)))
  stx)
