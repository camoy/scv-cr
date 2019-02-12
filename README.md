# tr-contract

This package converts a Typed Racket module into a module with explicit contracts.

## Using

Say we have the following `typed-module.rkt`.

```rkt
#lang typed/racket

(provide fact)

(: fact (Natural -> Natural))
(define (fact n)
  (if (= n 0)
      1
      (* n (fact (sub1 n)))))
```

Running `raco explicit-contracts typed-module.rkt` will print an equivalent untyped module that is protected by contracts.

Running `raco explicit-contracts -i typed-module.rkt` replaces the file instead of printing.

If you give the command multiple files it will process all of them. Any file not written in Typed Racket will be ignored.

In the example above, the output you'll get is something like:

```rkt
#lang typed/racket/no-check
(require racket/contract
          (prefix-in t: typed-racket/types/numeric-predicates)
          (prefix-in c: racket/class)
          (submod typed-racket/private/type-contract predicates)
          typed-racket/utils/struct-type-c
          typed-racket/utils/vector-contract
          typed-racket/utils/hash-contract
          (prefix-in c: typed-racket/utils/opaque-object))
(begin
   (define g4 exact-nonnegative-integer?)
   (define g5 (or/c g4))
   (define-values (generated-contract3) (-> g5 (values g5)))
   (begin (provide (contract-out (fact generated-contract3)))))
(provide)
(: fact (Natural -> Natural))
(define (fact n) (if (= n 0) 1 (* n (fact (sub1 n)))))
```

This module requires supplemental contract definitions, constructs contracts for all exported identifiers, and attaches the contracts through `contract-out`. The language is changed to `no-check` to prevent Typed Racket from generating its own contracts.

## Installing

Run `raco pkg install` from the directory. You'll also need to install a hacked version of Typed Racket. You can run `etc/setup.sh` to do so. This will download TR, patch it, and force install the new version.

You also need to patch your installation of SCV with `etc/scv.patch`.