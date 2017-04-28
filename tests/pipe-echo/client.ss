(import (chezscheme)
        (choice))

(define (run-client path)
 (let ((handle (make-pipe-handle (make-default-loop) #t))
       (req (make-tcp-handle (make-default-loop))))
  (uv-connect req handle path read-cb)
  handle)) 
    
(define (read-cb handle size buf)
 (if (> size 0)
  (let ((cnt (uv->buf->string buf)))
   (display cnt)
   (uv-try-write handle buf 1))
  (uv-close handle)))


