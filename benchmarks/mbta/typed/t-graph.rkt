#lang typed/racket/no-check
(define-values
  (g108
   g109
   g110
   g111
   g112
   g113
   g114
   g115
   g116
   g117
   g118
   g119
   g120
   g121
   g122
   g123
   g124
   g125
   g126
   g127
   g128
   g129
   g130
   g131
   g132
   g133
   g134
   g135
   g136
   g137
   g138
   g139
   generated-contract79)
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
    (letrec ((g108 any/c)
             (g109 string?)
             (g110 '"green")
             (g111 '"E")
             (g112 '"D")
             (g113 '"C")
             (g114 '"B")
             (g115 '"red")
             (g116 '"Mattapan")
             (g117 '"Braintree")
             (g118 '"orange")
             (g119 '"blue")
             (g120 (or/c g110 g111 g112 g113 g114 g115 g116 g117 g118 g119))
             (g121 (set/c g120))
             (g122 '())
             (g123 (cons/c g121 g122))
             (g124 (cons/c g109 g123))
             (g125 (listof g124))
             (g126 (listof g125))
             (g127 (-> g108 g109 g109 (values g126)))
             (g128 (set/c g109))
             (g129 (-> g108 g128 (values g109)))
             (g130 (listof g109))
             (g131 (or/c g109 g130))
             (g132 (-> g108 g109 (values g131)))
             (g133 '#t)
             (g134 '#f)
             (g135 (or/c g133 g134))
             (g136 (-> g108 g109 (values g135)))
             (g137 graph?)
             (g138 (-> g109 g109 (values g121)))
             (g139
              (object/c-opaque
               (find-path g127)
               (render g129)
               (station g132)
               (station? g136)
               (field (G g137))
               (field (bundles g125))
               (field (connection-on g138))
               (field (stations g130))))
             (generated-contract79 (-> (values g139))))
      (values
       g108
       g109
       g110
       g111
       g112
       g113
       g114
       g115
       g116
       g117
       g118
       g119
       g120
       g121
       g122
       g123
       g124
       g125
       g126
       g127
       g128
       g129
       g130
       g131
       g132
       g133
       g134
       g135
       g136
       g137
       g138
       g139
       generated-contract79))))
(require (only-in racket/contract contract-out))
(provide (contract-out (read-t-graph generated-contract79)))
(provide)
(require "../base/t-graph-types.rkt")
(require "../base/my-graph.rkt")
(define-type Line->Connection* (Listof (List Line Connection*)))
(define-type Connection* (Listof Connection))
(define-type Connection (List Station Station))
(define SOURCE-DIRECTORY "../base/~a.dat")
(define COLORS '("blue" "orange" "green" "red"))
(: line-specification (-> String (U False Line*)))
(define (line-specification line)
   (define r (regexp-match #px"--* (.*)" line))
   (and r (cadr r) (cast (string-split (cast (cadr r) String)) Line*)))
(: read-t-graph (-> (Instance MBTA)))
(define (read-t-graph)
   (define-values
    (stations connections lines color->lines)
    (read-parse-organize))
   (define-values (graph connection-on) (generate-graph connections lines))
   (new
    mbta%
    (G graph)
    (stations stations)
    (bundles color->lines)
    (connection-on connection-on)))
(:
  read-parse-organize
  (-> (Values Station* Connection* Line->Connection* Colors->Lines)))
(define (read-parse-organize)
   (for/fold
    :
    (Values Station* Connection* Line->Connection* Colors->Lines)
    ((s* : Station* '())
     (c* : Connection* '())
     (lc : Line->Connection* '())
     (cl : Colors->Lines '()))
    ((color COLORS))
    (define-values (new-s* new-lc) (read-t-line-from-file color))
    (define new-c*
      ((inst map Connection* (List Line Connection*)) second new-lc))
    (define new-cl
      (list color (apply set (map (inst first Line Connection*) new-lc))))
    (values
     (append new-s* s*)
     (apply append c* new-c*)
     (append new-lc lc)
     (cons new-cl cl))))
(:
  generate-graph
  (->
   Connection*
   Line->Connection*
   (Values Graph (Station Station -> (Setof Line)))))
(define (generate-graph connections lines)
   (define graph (unweighted-graph/directed connections))
   (define-values
    (connection-on _ connection-on-set!)
    (attach-edge-property graph #:init (ann (set) (Setof Line))))
   (for
    ((line (in-list lines)))
    (define name (first line))
    (for
     ((c (second line)))
     (define from (first c))
     (define to (second c))
     (connection-on-set! from to (set-add (connection-on from to) name))))
   (values graph connection-on))
(struct partial-line ((pred : Station) (connections : Connection*)))
(define-type PartialLine partial-line)
(define-type H-Line->Connection* (HashTable Line PartialLine))
(: read-t-line-from-file (-> String (Values Station* Line->Connection*)))
(define (read-t-line-from-file line-file)
   (define file*0 (file->lines (format SOURCE-DIRECTORY line-file)))
   (: lines->hash (-> Line* (Values Station* Line->Connection*)))
   (define (lines->hash lines0)
     (define mt-partial-line : Connection* '())
     (define first-station (second file*0))
     (define hlc0
       (make-immutable-hash
        (for/list
         :
         (Listof (Pairof Line PartialLine))
         ((line lines0))
         (cons line (partial-line first-station mt-partial-line)))))
     (define-values
      (stations hlc)
      (process-file-body (cddr file*0) (list first-station) lines0 hlc0))
     (define line->connection*
       (for/list
        :
        Line->Connection*
        ((((line : Line) (partial-line : PartialLine)) hlc))
        (list line (partial-line-connections partial-line))))
     (values (reverse stations) line->connection*))
   (:
    process-file-body
    (->
     (Listof String)
     Station*
     Line*
     H-Line->Connection*
     (Values Station* H-Line->Connection*)))
   (define (process-file-body file* stations lines hlc)
     (cond
      ((empty? file*) (values stations hlc))
      (else
       (define ?station (string-trim (first file*)))
       (cond
        ((line-specification ?station)
         =>
         (lambda (lines) (process-file-body (rest file*) stations lines hlc)))
        (else
         (define new-hlc (add-station-to-lines hlc lines ?station))
         (process-file-body
          (rest file*)
          (cons ?station stations)
          lines
          new-hlc))))))
   (:
    add-station-to-lines
    (-> H-Line->Connection* Line* Station H-Line->Connection*))
   (define (add-station-to-lines hlc lines station)
     (for/fold
      :
      H-Line->Connection*
      ((hlc1 hlc))
      ((line lines))
      (define the-partial-line
        (hash-ref hlc1 line (lambda () (error "KNOLWEDGE: impossible"))))
      (define predecessor (partial-line-pred the-partial-line))
      (define prefix (partial-line-connections the-partial-line))
      (define connections
        (list* (list predecessor station) (list station predecessor) prefix))
      (hash-set hlc1 line (partial-line station connections))))
   (define lines0 (line-specification (first file*0)))
   (unless lines0
     (error "KNOWLEDGE: we know that the file is properly formatted"))
   (lines->hash lines0))
(: mbta% MBTA)
(define mbta%
   (class object%
     (init-field G stations connection-on bundles)
     (: stations-set (Setof Station))
     (define stations-set (apply set stations))
     (super-new)
     (define/public
      (render b)
      (define r
        (memf
         (lambda ((c : (List String (Setof Line)))) (subset? (second c) b))
         bundles))
      (if r
        (first (first r))
        (string-join (set-map b (lambda ((x : String)) x)) " ")))
     (define/public
      (station word)
      (define word# (regexp-quote word))
      (define candidates
        (for/list
         :
         Station*
         ((s stations-set) #:when (regexp-match word# s))
         s))
      (if (and (cons? candidates) (empty? (rest candidates)))
        (first candidates)
        candidates))
     (define/public (station? s) (set-member? stations-set s))
     (define/public
      (find-path from0 to)
      (define paths* (find-path/aux from0 to))
      (for/list
       :
       (Listof Path)
       ((path paths*))
       (define start (first path))
       (cond
        ((empty? (rest path)) (list (list start (ann (set) (Setof Line)))))
        (else
         (define next (connection-on start (second path)))
         (define-values
          (_ result)
          (for/fold
           :
           (Values Any Path)
           ((predecessor : Station start) (r : Path (list (list start next))))
           ((station : Station (rest path)))
           (values
            station
            (cons (list station (connection-on station predecessor)) r))))
         (reverse result)))))
     (: find-path/aux (-> Station Station (Listof (Pairof Station Station*))))
     (define/private
      (find-path/aux from0 to)
      (let search :
        (Listof (Pairof Station Station*))
        ((from from0) (visited '()))
        (cond
         ((equal? from to) (list (list from)))
         ((member from visited) (list))
         (else
          (define visited* (cons from visited))
          (for/fold
           :
           (Listof (Pairof Station Station*))
           ((all-paths : (Listof (Pairof Station Station*)) '()))
           ((n (in-neighbors G from)))
           (define paths-from-from-to-to
             (map
              (lambda ((p : Station*))
                :
                (Pairof Station Station*)
                (cons from p))
              (search n visited*)))
           (append all-paths paths-from-from-to-to))))))))
