(module offset-resolvers typed/racket/base/no-check
   (#%module-begin
    (require soft-contract/fake-contract
             (lib "racket/contract.rkt")
             (lib "racket/base.rkt")
             (lib "racket/contract/base.rkt")
             (submod "tzinfo-adapter.rkt" #%type-decl "..")
             (submod "gregor-structs.rkt" #%type-decl ".."))
    (define g70 (lambda (x) (tzgap? x)))
    (define g71 (lambda (x) (DateTime? x)))
    (define g72 string?)
    (define g73 '#f)
    (define g74 (or/c g72 g73))
    (define g75 (lambda (x) (Moment? x)))
    (define g76 (or/c g73 g75))
    (define g77 (-> g70 g71 g74 g76 (values g75)))
    (define g78 (lambda (x) (tzoverlap? x)))
    (define g79 (-> g78 g71 g74 g76 (values g75)))
    (define g80 (or/c g78 g70))
    (define g81 (-> g80 g71 g74 g76 (values g75)))
    (define generated-contract57 (-> g77 g79 (values g81)))
    (define generated-contract58 (-> g70 g71 g74 g76 (values g75)))
    (define generated-contract59 (-> g70 g71 g74 g76 (values g75)))
    (define generated-contract60 (-> g70 g71 g74 g76 (values g75)))
    (define generated-contract67 (-> g78 g71 g74 g76 (values g75)))
    (define generated-contract68 (-> g78 g71 g74 g76 (values g75)))
    (define generated-contract69 (-> g78 g71 g74 g76 (values g75)))
    (module require/contracts racket/base
      (require soft-contract/fake-contract)
      (provide))
    (require (prefix-in -: (only-in 'require/contracts))
             (except-in 'require/contracts))
    (define-values () (values))
    (require require-typed-check
             "tzinfo-adapter.rkt"
             "core-adapter.rkt"
             "gregor-adapter.rkt"
             racket/match)
    (begin (require "hmsn.rkt") (void))
    (begin (require "datetime.rkt") (void))
    (begin (require "moment-base.rkt") (void))
    (void)
    (struct exn:gregor exn:fail ())
    (struct exn:gregor:invalid-offset exn:gregor ())
    (: raise-invalid-offset (-> Any DateTime Any Any Moment))
    (define (raise-invalid-offset g/o target-dt target-tzid orig)
      (raise
       (exn:gregor:invalid-offset
        (format
         "Illegal moment: local time ~a ~a in time zone ~a"
         (datetime->iso8601 target-dt)
         (if (tzgap? g/o) "does not exist" "is ambiguous")
         target-tzid)
        (current-continuation-marks))))
    (: resolve-gap/pre (-> tzgap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-gap/pre gap target-dt target-tzid orig)
      (match-define (tzgap tm (tzoffset delta _ _) _) gap)
      (make-moment
       (posix->datetime (+ tm delta (- (/ 1 NS/SECOND))))
       delta
       target-tzid))
    (: resolve-gap/post (-> tzgap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-gap/post gap target-dt target-tzid orig)
      (define tm (tzgap-starts-at gap))
      (define delta (tzoffset-utc-seconds (tzgap-offset-before gap)))
      (define sum (+ tm delta))
      (make-moment (posix->datetime sum) delta target-tzid))
    (: resolve-gap/push (-> tzgap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-gap/push gap target-dt target-tzid orig)
      (define tm (tzgap-starts-at gap))
      (define delta1 (tzoffset-utc-seconds (tzgap-offset-before gap)))
      (define delta2 (tzoffset-utc-seconds (tzgap-offset-after gap)))
      (make-moment
       (posix->datetime (+ (datetime->posix target-dt) (- delta2 delta1)))
       delta2
       target-tzid))
    (:
     resolve-overlap/pre
     (-> tzoverlap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-overlap/pre overlap target-dt target-tzid orig)
      (match-define (tzoverlap (tzoffset delta _ _) _) overlap)
      (make-moment target-dt delta target-tzid))
    (:
     resolve-overlap/post
     (-> tzoverlap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-overlap/post overlap target-dt target-tzid orig)
      (match-define (tzoverlap _ (tzoffset delta _ _)) overlap)
      (make-moment target-dt delta target-tzid))
    (:
     resolve-overlap/retain
     (-> tzoverlap DateTime (U String #f) (U #f Moment) Moment))
    (define (resolve-overlap/retain overlap target-dt target-tzid orig)
      (define delta1 (tzoffset-utc-seconds (tzoverlap-offset-before overlap)))
      (define delta2 (tzoffset-utc-seconds (tzoverlap-offset-after overlap)))
      (make-moment
       target-dt
       (or (and orig (= (Moment-utc-offset orig) delta1) delta1) delta2)
       target-tzid))
    (:
     offset-resolver
     (->
      (-> tzgap DateTime (U String #f) (U #f Moment) Moment)
      (-> tzoverlap DateTime (U String #f) (U #f Moment) Moment)
      (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment)))
    (define (offset-resolver rg ro)
      (λ ((g/o : (U tzgap tzoverlap))
          (target-dt : DateTime)
          (target-tzid : (U String #f))
          (orig : (U #f Moment)))
        (cond
         ((tzgap? g/o) (rg g/o target-dt target-tzid orig))
         (else (ro g/o target-dt target-tzid orig)))))
    (:
     resolve-offset/pre
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
    (define resolve-offset/pre
      (offset-resolver resolve-gap/pre resolve-overlap/pre))
    (:
     resolve-offset/post
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
    (define resolve-offset/post
      (offset-resolver resolve-gap/post resolve-overlap/post))
    (:
     resolve-offset/post-gap/pre-overlap
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
    (define resolve-offset/post-gap/pre-overlap
      (offset-resolver resolve-gap/post resolve-overlap/pre))
    (:
     resolve-offset/retain
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
    (define resolve-offset/retain
      (offset-resolver resolve-gap/post resolve-overlap/retain))
    (:
     resolve-offset/push
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U #f Moment) Moment))
    (define resolve-offset/push
      (offset-resolver resolve-gap/push resolve-overlap/post))
    (:
     resolve-offset/raise
     (-> (U tzgap tzoverlap) DateTime (U String #f) (U Moment #f) Moment))
    (define (resolve-offset/raise g/o target-dt target-tzid orig)
      (raise-invalid-offset g/o target-dt target-tzid orig))
    (provide)
    (provide (contract-out
              (resolve-offset/post-gap/pre-overlap
               (-> g80 g71 g74 g76 (values g75))))
             (contract-out
              (resolve-offset/post (-> g80 g71 g74 g76 (values g75))))
             (contract-out
              (resolve-offset/pre (-> g80 g71 g74 g76 (values g75))))
             (contract-out (resolve-overlap/retain generated-contract69))
             (contract-out (resolve-overlap/post generated-contract67))
             (contract-out (resolve-overlap/pre generated-contract68))
             (contract-out (resolve-gap/push generated-contract60))
             (contract-out (resolve-gap/post generated-contract58))
             (contract-out (resolve-gap/pre generated-contract59))
             (contract-out (offset-resolver generated-contract57))
             (contract-out
              (resolve-offset/raise (-> g80 g71 g74 g76 (values g75))))
             (contract-out
              (resolve-offset/push (-> g80 g71 g74 g76 (values g75))))
             (contract-out
              (resolve-offset/retain (-> g80 g71 g74 g76 (values g75)))))))
