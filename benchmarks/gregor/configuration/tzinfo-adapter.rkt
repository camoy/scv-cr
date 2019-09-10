(module tzinfo-adapter typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/base.rkt")
             (lib "racket/contract.rkt")
             (lib "racket/contract/base.rkt"))
    (define g62 struct-type?)
    (define g63 (λ (_) #f))
    (define g64 any/c)
    (define g65 '#t)
    (define g66 '#f)
    (define g67 (or/c g65 g66))
    (define g68 (-> g64 (values g67)))
    (define g69 (or/c g63 g68))
    (define g70 (lambda (x) (tzgap? x)))
    (define g71 (lambda (x) (tzoffset? x)))
    (define g72 exact-nonnegative-integer?)
    (define g73 (or/c g72))
    (define g74 string?)
    (define g75 exact-integer?)
    (define g76 (or/c g75))
    (define g77 (lambda (x) (tzoverlap? x)))
    (define generated-contract29 g62)
    (define generated-contract30 g62)
    (define generated-contract31 g62)
    (define generated-contract32 g69)
    (define generated-contract33 (-> g70 (values g71)))
    (define generated-contract34 (-> g70 (values g71)))
    (define generated-contract35 (-> g70 (values g73)))
    (define generated-contract36 g69)
    (define generated-contract37 (-> g71 (values g74)))
    (define generated-contract38 (-> g71 (values g67)))
    (define generated-contract39 (-> g71 (values g76)))
    (define generated-contract40 g69)
    (define generated-contract41 (-> g77 (values g71)))
    (define generated-contract42 (-> g77 (values g71)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract
               (lib "typed-racket/types/numeric-predicates.rkt")
               (lib "racket/contract.rkt")
               (lib "racket/base.rkt")
               (lib "racket/contract/base.rkt"))
      (define g43 exact-integer?)
      (define g44 string?)
      (define g45 '#f)
      (define g46 (or/c g43 g44 g45))
      (define g47 exact-nonnegative-integer?)
      (define g48 (or/c g47))
      (define g49 (lambda (x) (tzoffset? x)))
      (define g50 (lambda (x) (tzgap? x)))
      (define g51 (-> any/c g49))
      (define g52 (or/c g43))
      (define g53 '#t)
      (define g54 (or/c g53 g45))
      (define g55 (-> any/c g44))
      (define g56 (lambda (x) (tzoverlap? x)))
      (define g57 (-> any/c any/c g56))
      (define g58 (-> any/c g49))
      (define g59 (or/c g56 g50 g49))
      (define g60 t:exact-rational?)
      (define g61 (or/c g60))
      (define l/1 (-> (values g46)))
      (define l/119 g57)
      (define l/121 g58)
      (define l/123 g58)
      (define l/126 (-> g44 g52 (values g59)))
      (define l/130 (-> g44 g61 (values g49)))
      (define l/37 (-> g48 g49 g49 (values g50)))
      (define l/39 (-> g50 (values g48)))
      (define l/41 g51)
      (define l/43 g51)
      (define l/78 (-> g52 g54 g44 (values g49)))
      (define l/80 (-> g49 (values g52)))
      (define l/82 (-> g49 (values g54)))
      (define l/84 g55)
      (begin
        (define system-tzid #:opaque)
        (struct tzgap (starts-at offset-before offset-after) #:transparent)
        (struct tzoffset (utc-seconds dst? abbreviation) #:transparent)
        (struct tzoverlap (offset-before offset-after) #:transparent)
        (define local-seconds->tzoffset #:opaque)
        (define utc-seconds->tzoffset #:opaque))
      (provide g61
               l/130
               g56
               g57
               l/119
               g52
               g53
               g54
               l/78
               g47
               g48
               g49
               g50
               l/37
               g43
               g44
               g45
               g46
               l/1
               g59
               l/126
               g55
               l/84
               l/43
               l/123
               l/82
               g51
               l/41
               g58
               l/121
               l/80
               l/39
               g60
               (contract-out (system-tzid l/1))
               (contract-out (local-seconds->tzoffset l/126))
               (contract-out (utc-seconds->tzoffset l/130))
               (contract-out
                (struct
                 tzgap
                 ((starts-at g48) (offset-before g49) (offset-after g49))))
               (contract-out
                (struct
                 tzoffset
                 ((utc-seconds g52) (dst? g54) (abbreviation g44))))
               (contract-out
                (struct
                 tzoverlap
                 ((offset-before any/c) (offset-after any/c))))))
    (require (prefix-in
              -:
              (only-in
               'require/contracts
               utc-seconds->tzoffset
               local-seconds->tzoffset
               system-tzid
               tzoverlap?
               tzoffset?
               tzgap?))
             (except-in
              'require/contracts
              utc-seconds->tzoffset
              local-seconds->tzoffset
              system-tzid
              tzoverlap?
              tzoffset?
              tzgap?))
    (define-values
     (utc-seconds->tzoffset
      local-seconds->tzoffset
      system-tzid
      tzoverlap?
      tzoffset?
      tzgap?)
     (values
      -:utc-seconds->tzoffset
      -:local-seconds->tzoffset
      -:system-tzid
      -:tzoverlap?
      -:tzoffset?
      -:tzgap?))
    (require scv-gt/opaque)
    (begin
      (void)
      (provide system-tzid
               (struct-out tzgap)
               tzgap?
               (struct-out tzoffset)
               tzoffset?
               (struct-out tzoverlap)
               tzoverlap?
               local-seconds->tzoffset
               utc-seconds->tzoffset))
    (void)
    (define-type tz (U String Integer))
    (provide tz)
    (provide)))
