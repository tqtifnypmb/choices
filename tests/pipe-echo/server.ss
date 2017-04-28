(import (chezscheme)
        (choice))

(define (init-server loop path)
 (let ((handle (make-pipe-handle loop #t)))
  (uv-pipe-bind handle path)
  (uv-listen handle 64 handle-conn)
  handle))

(define (handle-conn server status)
 (let ((client (make-tcp-handle (make-default-loop))))
 (uv-accept server client)
 (echo client)))

(define (echo client)
 (uv-read-start client alloc-cb read-cb)
)

(define (alloc-cb hanlde size buf)
 (fill-uv-buf buf size))

(define (read-cb handle size buf)
 (if (> size 0)
  (let ((cnt (uv->buf->string buf)))
   (display cnt)
   (uv-try-write handle buf 1))
  (uv-close handle)))

(define (run loop)
 (uv-run loop 'uv-run-default))

(define (run-server path)
 (init-server (make-default-loop) path)
 (uv-run (make-default-loop)))

(define (stop-server)
 (uv-loop-stop (make-default-loop)))
