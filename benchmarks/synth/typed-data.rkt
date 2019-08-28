(module typed-data typed/racket/base/no-check
   (#%module-begin
    (require racket/contract)
    (module require/contracts racket/base (require racket/contract) (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (void)
    (require require-typed-check)
    (require "data.rkt")
    (define-type Indexes (Vectorof Integer))
    (define-type In-Indexes Indexes)
    (define-type Weighted-Signal (List Array Real))
    (define-type Drum-Symbol (U 'O 'X #f))
    (define-type Pattern (Listof Drum-Symbol))
    (provide Indexes
             In-Indexes
             Weighted-Signal
             Drum-Symbol
             Pattern
             (struct-out Array)
             (struct-out Settable-Array)
             (struct-out Mutable-Array))
    (provide)))
