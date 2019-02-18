#lang typed/racket/base/no-check
(define-values
  (g48
   generated-contract17
   generated-contract18
   g49
   g50
   generated-contract19
   g51
   g52
   g53
   generated-contract20
   g54
   g55
   g56
   g57
   g58
   g59
   g60
   generated-contract21
   g61
   g62
   generated-contract22
   generated-contract23
   generated-contract24
   generated-contract25
   g63
   g64
   g65
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
    (letrec ((g48 (lambda (x) (suffix-tree? x)))
             (generated-contract17 (-> (values g48)))
             (generated-contract18 (-> (values g48)))
             (g49 (lambda (x) (node? x)))
             (g50 (lambda (x) (label? x)))
             (generated-contract19 (-> g49 g50 (values g49)))
             (g51 any/c)
             (g52 '#f)
             (g53 (or/c g52 g49))
             (generated-contract20 (-> g49 g51 (values g53)))
             (g54 (-> any/c g51))
             (g55 fixnum?)
             (g56 (or/c g55))
             (g57 (-> g49 g56 (values g51)))
             (g58 (-> g49 g50 g56 (values g51)))
             (g59 (-> g49 g56 g50 g56 (values g51)))
             (g60 (or/c g51 g51 g51 g51))
             (generated-contract21 (-> g49 g50 g54 g57 g58 g59 (values g60)))
             (g61 '#t)
             (g62 (or/c g61 g52))
             (generated-contract22 (-> g49 g56 (values g62)))
             (generated-contract23 (-> g49 (values g62)))
             (generated-contract24 (-> g49 g56 g50 (values g49 g49)))
             (generated-contract25 (-> g48 (values g49)))
             (g63 (λ (_) #f))
             (g64 (-> g51 (values g62)))
             (g65 (or/c g63 g64))
             (generated-contract26 g65))
      (values
       g48
       generated-contract17
       generated-contract18
       g49
       g50
       generated-contract19
       g51
       g52
       g53
       generated-contract20
       g54
       g55
       g56
       g57
       g58
       g59
       g60
       generated-contract21
       g61
       g62
       generated-contract22
       generated-contract23
       generated-contract24
       generated-contract25
       g63
       g64
       g65
       generated-contract26))))
(require (only-in racket/contract contract-out))
(provide (contract-out (make-tree generated-contract17))
          (contract-out (new-suffix-tree generated-contract18))
          (contract-out (node-add-leaf! generated-contract19))
          (contract-out (node-find-child generated-contract20))
          (contract-out (node-follow/k generated-contract21))
          (contract-out (node-position-at-end? generated-contract22))
          (contract-out (node-root? generated-contract23))
          (contract-out (node-up-splice-leaf! generated-contract24))
          (contract-out (tree-root generated-contract25))
          (contract-out (tree? generated-contract26)))
(require require-typed-check
          (except-in "typed-data.rkt" make-label)
          racket/list)
(require "label.rkt")
(provide)
(: new-suffix-tree (-> Tree))
(define (new-suffix-tree)
   (make-suffix-tree
    (let ((root (make-node (make-label (make-vector 0 'X)) #f (list) #f)))
      root)))
(: node-root? (-> Node Boolean))
(define (node-root? node) (eq? #f (node-parent node)))
(: node-add-leaf! (-> Node Label Node))
(define (node-add-leaf! node label)
   (let ((leaf (make-node label node (list) #f)))
     (node-add-child! node leaf)
     leaf))
(: node-add-child! (-> Node Node Void))
(define (node-add-child! node child)
   (set-node-children! node (cons child (node-children node))))
(: node-remove-child! (-> Node Node Void))
(define (node-remove-child! node child)
   (set-node-children! node (remq child (node-children node))))
(define children-list list)
(: node-leaf? (-> Node Boolean))
(define (node-leaf? node) (empty? (node-children node)))
(: node-find-child (-> Node Any (U Node #f)))
(define (node-find-child node label-element)
   (: loop (-> (Listof Node) (U Node #f)))
   (define (loop children)
     (cond
      ((null? children) #f)
      ((label-element-equal?
        label-element
        (label-ref (node-up-label (first children)) 0))
       (first children))
      (else (loop (rest children)))))
   (loop (node-children node)))
(: node-up-split! (-> Node Index Node))
(define (node-up-split! node offset)
   (let* ((label (node-up-label node))
          (pre-label (sublabel label 0 offset))
          (post-label (sublabel label offset))
          (parent (node-parent node))
          (new-node (make-node pre-label parent (children-list node) #f)))
     (set-node-up-label! node post-label)
     (unless parent (error "node-up-split!"))
     (node-remove-child! parent node)
     (set-node-parent! node new-node)
     (node-add-child! parent new-node)
     new-node))
(: node-up-splice-leaf! (-> Node Index Label (values Node Node)))
(define (node-up-splice-leaf! node offset leaf-label)
   (let* ((split-node (node-up-split! node offset))
          (leaf (node-add-leaf! split-node leaf-label)))
     (values split-node leaf)))
(: tree-contains? (-> Tree Label Boolean))
(define (tree-contains? tree label)
   (node-follow/k
    (suffix-tree-root tree)
    label
    (lambda args #t)
    (lambda args #t)
    (lambda args #f)
    (lambda args #f)))
(:
  node-follow/k
  (All
   (A B C D)
   (->
    Node
    Label
    (-> Node A)
    (-> Node Index B)
    (-> Node Label Index C)
    (-> Node Index Label Index D)
    (U A B C D))))
(define (node-follow/k
          node
          original-label
          matched-at-node/k
          matched-in-edge/k
          mismatched-at-node/k
          mismatched-in-edge/k)
   (: EDGE/k (-> Node Label Index (U A B C D)))
   (define (EDGE/k node label label-offset)
     (: up-label Label)
     (define up-label (node-up-label node))
     (let loop ((k 0))
       (define k+label-offset (+ k label-offset))
       (cond
        ((= k (label-length up-label))
         (unless (index? k+label-offset) (error "node/folllowd"))
         (NODE/k node label k+label-offset))
        ((= k+label-offset (label-length label))
         (unless (index? k) (error "node/followk"))
         (matched-in-edge/k node k))
        ((label-element-equal?
          (label-ref up-label k)
          (label-ref label k+label-offset))
         (loop (add1 k)))
        (else
         (unless (and (index? k) (index? k+label-offset))
           (error "node-follow/k mismatched fail"))
         (mismatched-in-edge/k node k label k+label-offset)))))
   (: NODE/k (-> Node Label Index (U A B C D)))
   (define (NODE/k node label label-offset)
     (if (= (label-length label) label-offset)
       (matched-at-node/k node)
       (let ((child (node-find-child node (label-ref label label-offset))))
         (if child
           (EDGE/k child label label-offset)
           (mismatched-at-node/k node label label-offset)))))
   (NODE/k node (label-copy original-label) 0))
(: node-position-at-end? (-> Node Index Boolean))
(define (node-position-at-end? node offset)
   (label-ref-at-end? (node-up-label node) offset))
(define tree? suffix-tree?)
(define make-tree new-suffix-tree)
(define tree-root suffix-tree-root)
