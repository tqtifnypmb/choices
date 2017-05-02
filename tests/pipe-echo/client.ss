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
 (let* ((loop (make-default-loop))
        (handle (make-pipe-handle loop #t))
        (req (make-request 'connect)))
  (client-loop-set! loop)
  (client-handle-set! handle)
  (client-creq-set! handle)
  (uv-pipe-connect req handle path (read-cb cli))))

(define (read-cb cli)
 (let ((cli cli))
  (lambda (handle req status)
   (let ((req (make-request 'write))
         (handle (client-handle cli))
         (buf (string->uv-buf "message from client")))
    (client-wreq-set! req handle )
    (client-tosend-set! buf)
    (uv-write req handle buf 1 write-cb)))))

(define (write-cb req status)
 (display "client writed"))

(define (client-stop cli)
 (uv-close (client-handle cli close-cb))
 (uv-loop-stop (client-loop cli)))

(define (close-cb handle)
 (display "closed"))
