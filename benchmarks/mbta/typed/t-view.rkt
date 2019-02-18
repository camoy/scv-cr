#lang typed/racket/no-check
(define-values
  (g158
   g159
   g160
   g161
   g162
   g163
   g167
   g168
   g169
   g170
   g171
   g172
   g173
   g174
   g175
   g176
   g177
   g178
   g179
   g180
   g181
   g182
   g183
   g184
   g185
   g186
   g187
   g188
   g189
   g190
   g191
   g192
   g193
   g194
   g195
   g196
   generated-contract125)
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
    (letrec ((g158 any/c)
             (g159 string?)
             (g160 '#f)
             (g161 (or/c g159 g160))
             (g162 (-> g158 g159 (values g161)))
             (g163 (-> g158 g159 g159 (values g159)))
             (g167 (listof g159))
             (g168 '"blue")
             (g169 '"orange")
             (g170 '"Braintree")
             (g171 '"Mattapan")
             (g172 '"red")
             (g173 '"B")
             (g174 '"C")
             (g175 '"D")
             (g176 '"E")
             (g177 '"green")
             (g178 (or/c g168 g169 g170 g171 g172 g173 g174 g175 g176 g177))
             (g179 (set/c g178))
             (g180 '())
             (g181 (cons/c g179 g180))
             (g182 (cons/c g159 g181))
             (g183 (listof g182))
             (g184 (listof g183))
             (g185 (-> g158 g159 g159 (values g184)))
             (g186 (set/c g159))
             (g187 (-> g158 g186 (values g159)))
             (g188 (or/c g159 g167))
             (g189 (-> g158 g159 (values g188)))
             (g190 '#t)
             (g191 (or/c g190 g160))
             (g192 (-> g158 g159 (values g191)))
             (g193 graph?)
             (g194 (-> g159 g159 (values g179)))
             (g195
              (object/c-opaque
               (find-path g185)
               (render g187)
               (station g189)
               (station? g192)
               (field (G g193))
               (field (bundles g183))
               (field (connection-on g194))
               (field (stations g167))))
             (g196
              (let ((g162164 g162) (g163165 g163) (g162166 g162))
                (class/c
                 (field (disabled g167))
                 (field (mbta-subways g195))
                 (add-to-disabled g162164)
                 (find g163165)
                 (remove-from-disabled g162166)
                 (override (add-to-disabled g162164)
                           (find g163165)
                           (remove-from-disabled g162166))
                 (super
                  (add-to-disabled g162164)
                  (find g163165)
                  (remove-from-disabled g162166))
                 (inherit (add-to-disabled g162164)
                          (find g163165)
                          (remove-from-disabled g162166))
                 (augment)
                 (inherit)
                 (absent))))
             (generated-contract125 g196))
      (values
       g158
       g159
       g160
       g161
       g162
       g163
       g167
       g168
       g169
       g170
       g171
       g172
       g173
       g174
       g175
       g176
       g177
       g178
       g179
       g180
       g181
       g182
       g183
       g184
       g185
       g186
       g187
       g188
       g189
       g190
       g191
       g192
       g193
       g194
       g195
       g196
       generated-contract125))))
(require (only-in racket/contract contract-out))
(provide (contract-out (manage% generated-contract125)))
(provide)
(require require-typed-check)
(require "../base/t-view-types.rkt")
(require "../base/t-graph-types.rkt")
(require "t-graph.rkt")
(: selector (All (X) (-> (Listof (Listof X)) (Listof X))))
(define (selector l)
   (((inst curry (-> (Listof X) Real) (Listof X) (Listof (Listof X)))
     argmin
     (lambda ((p : (Listof X))) (length (filter string? p))))
    l))
(define INTERNAL
   "find path: it is impossible to get from ~a to ~a [internal error]")
(define CURRENT-LOCATION "disambiguate your current location: ~a")
(define CURRENT-LOCATION-0 "no such station: ~a")
(define DESTINATION "disambiguate your destination: ~a")
(define DESTINATION-0 "no such destination: ~a")
(define NO-PATH "it is currently impossible to reach ~a from ~a via subways")
(define DISABLED "clarify station to be disabled: ~a")
(define ENABLED "clarify station to be enabled: ~a")
(define DISABLED-0 "no such station to disable: ~a")
(define ENABLED-0 "no such station to enable: ~a")
(define ENSURE "---ensure you are on ~a")
(define SWITCH "---switch from ~a to ~a")
(define-type Path* (Listof (U String Station-x-Line)))
(: manage% Manage)
(define manage%
   (class object%
     (super-new)
     (field (mbta-subways (read-t-graph)) (disabled '()))
     (define/public
      (add-to-disabled s)
      (define station (send mbta-subways station s))
      (cond
       ((string? station) (set! disabled (cons station disabled)) #f)
       ((empty? station) (format DISABLED-0 s))
       (else (format DISABLED (string-join station)))))
     (define/public
      (remove-from-disabled s)
      (define station (send mbta-subways station s))
      (cond
       ((string? station) (set! disabled (remove* (list station) disabled)) #f)
       ((empty? station) (format ENABLED-0 s))
       (else (format ENABLED (string-join station)))))
     (define/public
      (find from to)
      (define from-station (send mbta-subways station from))
      (define to-station (send mbta-subways station to))
      (cond
       ((string=? from to)
        (format
         "Close your eyes and tap your heels three times. Open your eyes. You will be at ~a."
         to))
       ((cons? from-station)
        (format CURRENT-LOCATION (string-join from-station)))
       ((cons? to-station) (format DESTINATION (string-join to-station)))
       ((empty? from-station) (format CURRENT-LOCATION-0 from))
       ((empty? to-station) (format DESTINATION-0 to))
       (else
        (define paths (send mbta-subways find-path from-station to-station))
        (define path* (removed-paths-with-disabled-stations paths))
        (cond
         ((empty? paths) (format INTERNAL from-station to-station))
         ((empty? path*) (format NO-PATH to-station from-station))
         (else
          (define paths-with-switch
            (for/list : (Listof Path*) ((p path*)) (insert-switch p)))
          (define best-path-as-string*
            (for/list
             :
             (Listof String)
             ((station-or-comment (pick-best-path paths-with-switch)))
             (match
              station-or-comment
              (`(,name ,line)
               (string-append name ", take " (send mbta-subways render line)))
              ((? string? comment) comment))))
          (string-join best-path-as-string* "\n"))))))
     (: removed-paths-with-disabled-stations (-> (Listof Path) (Listof Path)))
     (define/private
      (removed-paths-with-disabled-stations paths*)
      (for/list
       ((p : Path paths*)
        #:unless
        (let ((stations ((inst map Station Station-x-Line) first p)))
          (for/or : Any ((s stations)) (member s disabled))))
       p))
     (: pick-best-path (-> (Listof Path*) Path*))
     (define/private (pick-best-path paths*) (selector paths*))
     (: insert-switch : (-> Path Path*))
     (define/private
      (insert-switch path0)
      (define start (first path0))
      (define pred-lines0 (second start))
      (define pred-string0 (send mbta-subways render pred-lines0))
      (cons
       start
       (let loop :
         Path*
         ((pred-lines : (Setof Line) pred-lines0)
          (pred-string : String pred-string0)
          (path : Path (rest path0)))
         (cond
          ((empty? path) '())
          (else
           (define stop (first path))
           (define name (first stop))
           (define stop-lines (second stop))
           (define stop-string (send mbta-subways render stop-lines))
           (define remainder (loop stop-lines stop-string (rest path)))
           (cond
            ((proper-subset? stop-lines pred-lines)
             (list* (format ENSURE stop-string) stop remainder))
            ((set-empty? (set-intersect stop-lines pred-lines))
             (list* (format SWITCH pred-string stop-string) stop remainder))
            (else (cons stop remainder))))))))))
