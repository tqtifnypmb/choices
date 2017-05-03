(import (chezscheme)
        (choice))

(define-record-type client
 (fields (mutable loop)
         (mutable handle)
         (mutable wreq)
         (mutable creq)
         (mutable tosend))
 (protocol (lambda (new) (lambda () (new #f #f #f #f #f)))))

(define (client-run cli path)
 (let* ((loop (make-loop))
        (handle (make-pipe-handle loop #t))
        (req (make-request 'connect)))
  (client-loop-set! cli loop)
  (client-handle-set! cli handle)
  (client-creq-set! cli handle)
  (uv-pipe-connect req handle path conn-cb)))

(define (conn-cb req status)
 (display "connected\n"))

(define (write-cb req status)
 (display "client writed"))

(define (client-send cli data)
 (let ((req (make-request 'write))
       (handle (client-handle cli))
       (buf (string->uv-buf data)))
  (client-wreq-set! cli req)
  (client-tosend-set! cli buf)
  (uv-write req handle buf 1 write-cb)))

(define (client-stop cli)
 (uv-close (client-handle cli) close-cb)
 (uv-loop-stop (client-loop cli)))

(define (close-cb handle)
 (display "closed"))
