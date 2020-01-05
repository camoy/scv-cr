#lang racket/base

(require racket/class
         racket/draw
         pict)

(provide save-pict*)

(define ps-setup
  (new ps-setup%))

(send ps-setup set-margin 0 0)
(send ps-setup set-scaling 1 1)

(define (save-pict* path pict)
  (parameterize ([current-ps-setup ps-setup])
    (define dc
      (new post-script-dc%
           [interactive #f]
           [parent #f]
           [use-paper-bbox #f]
           [as-eps #t]
           [width  (pict-width pict)]
           [height (pict-height pict)]
           [output (format "~a.ps" path)]))
    (send dc start-doc "Rendering")
    (send dc start-page)
    (draw-pict pict dc 0 0)
    (send dc end-page)
    (send dc end-doc)))
