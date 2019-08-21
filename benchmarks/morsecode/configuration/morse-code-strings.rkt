(module morse-code-strings racket/base
   (#%module-begin
    (provide string->morse)
    (require "morse-code-table.rkt")
    (define (char->dit-dah-string letter)
      (define res (hash-ref char-table (char-downcase letter) #f))
      (if (eq? #f res)
        (raise-argument-error 'letter-map "character in map" 0 letter)
        res))
    (define (string->morse str)
      (define morse-list (for/list ((c str)) (char->dit-dah-string c)))
      (apply string-append morse-list))))
