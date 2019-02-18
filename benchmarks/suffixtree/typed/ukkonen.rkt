#lang typed/racket/base/no-check
(define-values
  (g55
   g56
   g57
   g58
   generated-contract20
   g59
   g60
   g61
   generated-contract21
   g62
   g63
   g64
   generated-contract22
   generated-contract23
   g65
   g66
   generated-contract24
   generated-contract25
   generated-contract26)
  (let ()
    (local-require
     racket/contract
     racket/class
     (prefix-in t: typed-racket/types/numeric-predicates)
     (submod typed-racket/private/type-contract predicates)
     typed-racket/utils/struct-type-c
     typed-racket/utils/vector-contract
     typed-racket/utils/hash-contract
     typed-racket/utils/opaque-object)
    (letrec ((g55 (lambda (x) (node? x)))
             (g56 fixnum?)
             (g57 (or/c g56))
             (g58 (lambda (x) (label? x)))
             (generated-contract20 (-> g55 g57 g58 g57 (values g55)))
             (g59 '#f)
             (g60 (or/c g59 g55))
             (g61 (or/c g56 g59))
             (generated-contract21 (-> g55 g58 g57 g57 (values g60 g61 g61)))
             (g62 exact-integer?)
             (g63 '#t)
             (g64 (or/c g62 g63 g59))
             (generated-contract22 (-> g55 (values g55 g64)))
             (generated-contract23 (-> g55 g58 (values g55 g57)))
             (g65 (lambda (x) (suffix-tree? x)))
             (g66 (lambda (x) (equal? x (void))))
             (generated-contract24 (-> g65 g58 (values g66)))
             (generated-contract25 (-> g65 g58 (values g66)))
             (generated-contract26 (-> g55 g55 (values g66))))
      (values
       g55
       g56
       g57
       g58
       generated-contract20
       g59
       g60
       g61
       generated-contract21
       g62
       g63
       g64
       generated-contract22
       generated-contract23
       g65
       g66
       generated-contract24
       generated-contract25
       generated-contract26))))
(require (only-in racket/contract contract-out))
(provide (contract-out (extend-at-point! generated-contract20))
          (contract-out
           (find-next-extension-point/add-suffix-link! generated-contract21))
          (contract-out (jump-to-suffix generated-contract22))
          (contract-out (skip-count generated-contract23))
          (contract-out (suffix-tree-add! generated-contract24))
          (contract-out (tree-add! generated-contract25))
          (contract-out (try-to-set-suffix-edge! generated-contract26)))
(require (except-in "typed-data.rkt" make-label) require-typed-check)
(require "label.rkt")
(require "structs.rkt")
(define dummy-node (node (make-label "dummy") #f '() #f))
(provide)
(: skip-count (-> Node Label (values Node Index)))
(define (skip-count node label)
   (define l-l (label-length label))
   (unless (index? l-l) (error "skip-count"))
   (skip-count-helper node label 0 l-l))
(: skip-count-helper (-> Node Label Index Index (values Node Index)))
(define (skip-count-helper node label k N)
   (: loop (-> Node Integer (values Node Index)))
   (define (loop node k)
     (let* ((child (node-find-child node (label-ref label k)))
            (child-label
             (begin
               (unless child (error "skip-count-hlper"))
               (node-up-label child)))
            (child-label-length (label-length child-label))
            (rest-of-chars-left-to-skip (- N k)))
       (if (> rest-of-chars-left-to-skip child-label-length)
         (loop child (+ k child-label-length))
         (begin
           (unless (index? rest-of-chars-left-to-skip)
             (error "skip-count=hlper !!!"))
           (values child rest-of-chars-left-to-skip)))))
   (if (>= k N)
     (values node (label-length (node-up-label node)))
     (loop node k)))
(provide)
(: jump-to-suffix (-> Node (values Node (U Boolean Integer))))
(define (jump-to-suffix node)
   (define PARENT (node-parent node))
   (cond
    ((node-root? node) (values node #f))
    ((node-suffix-link node)
     (begin
       (let ((node2 (node-suffix-link node)))
         (unless node2 (error "jump to suffix"))
         (values node2 0))))
    ((and PARENT (node-root? PARENT)) (values PARENT #f))
    (else
     (let* ((parent (node-parent node))
            (sl
             (begin (unless parent (error "j2s")) (node-suffix-link parent))))
       (unless sl (error "j2s whoahao"))
       (values sl (label-length (node-up-label node)))))))
(provide)
(: try-to-set-suffix-edge! (-> Node Node Void))
(define (try-to-set-suffix-edge! from-node to-node)
   (when (not (node-suffix-link from-node))
     (set-node-suffix-link! from-node to-node)))
(provide)
(:
  find-next-extension-point/add-suffix-link!
  (-> Node Label Index Index (values (U #f Node) (U #f Index) (U #f Index))))
(define (find-next-extension-point/add-suffix-link! node label initial-i j)
   (: fixed-start (-> (U Integer #f) Index))
   (define (fixed-start suffix-offset)
     (let ((i (if suffix-offset (- initial-i suffix-offset) j)))
       (unless (index? i) (error "find-next"))
       i))
   (define-values (suffix-node suffix-offset) (jump-to-suffix node))
   (define K
     (fixed-start
      (cond
       ((integer? suffix-offset) suffix-offset)
       ((eq? #t suffix-offset) 1)
       ((eq? #f suffix-offset) #f)
       (else (error "find-next")))))
   (define N
     (let ((i (label-length label)))
       (unless (index? i) (error "find-next"))
       i))
   (: loop-first (-> Index (values (U #f Node) (U #f Index) (U #f Index))))
   (define (loop-first i)
     (loop-general
      i
      (lambda ((skipped-node : Node) (skip-offset : Index))
        (when (node-position-at-end? skipped-node skip-offset)
          (try-to-set-suffix-edge! node skipped-node)))))
   (: loop-rest (-> Index (values (U #f Node) (U #f Index) (U #f Index))))
   (define (loop-rest i)
     (loop-general
      i
      (lambda ((skipped-node : Node) (skip-offset : Index)) (void))))
   (:
    loop-general
    (->
     Index
     (-> Node Index Void)
     (values (U #f Node) (U #f Index) (U #f Index))))
   (define (loop-general i first-shot)
     (cond
      ((>= i N) (values #f #f #f))
      (else
       (define-values
        (skipped-node skipped-offset)
        (skip-count-helper suffix-node label K i))
       (first-shot skipped-node skipped-offset)
       (if (node-position-at-end? skipped-node skipped-offset)
         (find-extension-at-end! skipped-node skipped-offset i)
         (find-extension-in-edge skipped-node skipped-offset i)))))
   (:
    find-extension-in-edge
    (-> Node Index Index (values (U #f Node) (U #f Index) (U #f Index))))
   (define (find-extension-in-edge skipped-node skip-offset i)
     (cond
      ((label-element-equal?
        (label-ref label i)
        (label-ref (node-up-label skipped-node) skip-offset))
       (let ((n (add1 i)))
         (unless (index? n) (error "find-next"))
         (loop-rest n)))
      (else (values skipped-node skip-offset i))))
   (:
    find-extension-at-end!
    (-> Node Index Index (values (U #f Node) (U #f Index) (U #f Index))))
   (define (find-extension-at-end! skipped-node skip-offset i)
     (cond
      ((node-find-child skipped-node (label-ref label i))
       (let ((n (add1 i)))
         (unless (index? n) (error "find-next"))
         (loop-rest n)))
      (else (values skipped-node skip-offset i))))
   (loop-first initial-i))
(provide)
(: extend-at-point! (-> Node Index Label Index Node))
(define (extend-at-point! node offset label i)
   (: main-logic (-> Node Index Label Index Node))
   (define (main-logic node offset label i)
     (if (should-extend-as-leaf? node offset)
       (attach-as-leaf! node label i)
       (splice-with-internal-node! node offset label i)))
   (: should-extend-as-leaf? (-> Node Index Boolean))
   (define (should-extend-as-leaf? node offset)
     (node-position-at-end? node offset))
   (: attach-as-leaf! (-> Node Label Index Node))
   (define (attach-as-leaf! node label i)
     (: leaf Node)
     (define leaf (node-add-leaf! node (sublabel label i)))
     node)
   (: splice-with-internal-node! (-> Node Index Label Index Node))
   (define (splice-with-internal-node! node offset label i)
     (define-values
      (split-node leaf)
      (node-up-splice-leaf! node offset (sublabel label i)))
     split-node)
   (main-logic node offset label i))
(provide)
(: suffix-tree-add! (-> Tree Label Void))
(define (suffix-tree-add! tree label)
   (: do-construction! (-> Tree Label Void))
   (define (do-construction! tree label)
     (define pr (add-first-suffix! tree label))
     (define starting-node (car pr))
     (define starting-offset (cdr pr))
     (add-rest-suffixes! label starting-node starting-offset))
   (: add-first-suffix! (-> Tree Label (Pairof Node Index)))
   (define (add-first-suffix! tree label)
     (: matched-at-node (-> Node (Pairof Node Index)))
     (define (matched-at-node node) (report-implicit-tree-constructed))
     (: matched-in-node (-> Node Index (Pairof Node Index)))
     (define (matched-in-node node offset) (report-implicit-tree-constructed))
     (: mismatched-at-node (-> Node Label Index (Pairof Node Index)))
     (define (mismatched-at-node node label label-offset)
       (define leaf (node-add-leaf! node (sublabel label label-offset)))
       (cons node label-offset))
     (: mismatched-in-node (-> Node Index Label Index (Pairof Node Index)))
     (define (mismatched-in-node node offset label label-offset)
       (define-values
        (joint leaf)
        (node-up-splice-leaf! node offset (sublabel label label-offset)))
       (cons joint label-offset))
     (define res
       (node-follow/k
        (suffix-tree-root tree)
        label
        matched-at-node
        matched-in-node
        mismatched-at-node
        mismatched-in-node))
     res)
   (: add-rest-suffixes! (-> Label Node Index Void))
   (define (add-rest-suffixes! label starting-node starting-offset)
     (add-rest-suffixes-loop!
      label
      (let ((i (label-length label))) (unless (index? i) (error "ars")) i)
      (max starting-offset 1)
      1
      starting-node))
   (: add-rest-suffixes-loop! (-> Label Index Index Index Node Void))
   (define (add-rest-suffixes-loop! label N i j active-node)
     (when (< j N)
       (define-values
        (next-extension-node next-extension-offset i*)
        (find-next-extension-point/add-suffix-link! active-node label i j))
       (if i*
         (begin
           (let ((new-active-node
                  (extend-at-point!
                   (begin
                     (unless next-extension-node (error "bar bar bar"))
                     next-extension-node)
                   (begin
                     (unless next-extension-offset (error "fofodofdof"))
                     next-extension-offset)
                   label
                   i*)))
             (try-to-set-suffix-edge! active-node new-active-node)
             (add-rest-suffixes-loop!
              label
              N
              (let ((num (max i* (add1 j))))
                (unless (index? num) (error "foo"))
                num)
              (let ((num (add1 j))) (unless (index? num) (error "foo")) num)
              new-active-node)))
         (begin (report-implicit-tree-constructed) (void)))))
   (: report-implicit-tree-constructed (-> (Pairof Node Index)))
   (define (report-implicit-tree-constructed) (cons dummy-node 0))
   (do-construction! tree label))
(provide)
(define tree-add! suffix-tree-add!)
