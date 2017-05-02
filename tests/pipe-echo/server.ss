(import (chezscheme)
        (choice))

(define-record-type server
 (fields (mutable loop) 
         (mutable handle)
         (mutable cli)
         (mutable srv))
 (protocol (lambda (new) (lambda () (new #f #f #f #f)))))

(define (server-init srv)
 (let* ((loop (make-default-loop))
       (handle (make-pipe-handle loop #t)))
  (server-loop-set! srv loop)
  (server-handle-set! srv handle)))

(define (server-run srv path)
 (let ((handle (server-handle srv))
       (loop (server-loop srv)))
  (uv-pipe-bind handle path)
  (uv-listen handle 64 (handle-conn srv))
  (uv-run loop uv-run-default)))

(define (handle-conn srv)
 (let ((srv srv))
  (lambda (server status)
   (let ((client (make-tcp-handle (server-loop srv))))
    (uv-accept server client)
    (server-srv-set! server)
    (server-cli-set! client)
    (echo-start srv)))))

(define (echo-start srv)
 (let ((client (server-cli srv)))
  (uv-read-start client alloc-cb read-cb)))

(define (alloc-cb hanlde size buf)
 (uv-buf-fill buf size))

(define (read-cb handle size buf)
 (if (> size 0)
  (let ((cnt (uv-buf->string buf)))
   (display cnt)
   (uv-try-write handle buf 1))
  (uv-close handle)))

(define (server-stop srv)
 (let ((loop (server-loop srv))
       (handle (server-handle srv)))
  (uv-close handle close-cb)
  (uv-loop-stop loop)))

(define (close-cb handle)
 (display "closed"))
