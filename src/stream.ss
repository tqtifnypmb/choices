(library (choice stream)
 (export uv-shutdown uv-listen uv-accept
         uv-read-start uv-read-stop
         uv-write uv-try-write
         uv-is-readable uv-is-writable
         uv-stream-set-blocking)
 (import (chezscheme)
         (choice handle))

 (define shutdown
  (foreign-procedure "uv_shutdown" (uptr uptr uptr) int))

 (define (uv-shutdown req handle cb)
  (let ((fcb (cb->fcb handle 'shutdown cb (uptr int) void)))
   (shutdown req (uv-handle-ptr handle) (code->address fcb))))

 (define listen
  (foreign-procedure "uv_listen" (uptr int uptr) int))

 (define (uv-listen handle backlog cb)
  (let ((fcb (cb->fcb handle 'listen cb (uptr int) void)))
   (listen (uv-handle-ptr handle) backlog (code->address fcb))))

 (define accept
  (foreign-procedure "uv_accept" (uptr uptr) int))

 (define (uv-accept serv cli)
  (accept (uv-handle-ptr serv)
          (uv-handle-ptr cli)))

 (define read-start
  (foreign-procedure "uv_read_start" (uptr uptr uptr) int))

 (define (uv-read-start handle alloc-cb read-cb)
  (let ((afcb (cb->fcb handle 'alloc alloc-cb (uptr size_t (* uv-buf)) void))
        (rfcb (cb->fcb handle 'read read-cb (uptr size_t (* uv-buf)) void)))
   (read-start (uv-handle-ptr handle) 
               (code->address afcb) 
               (code->address rfcb))))
  
 (define read-stop
  (foreign-procedure "uv_read_stop" (uptr) int))

 (define (uv-read-stop handle)
  (release-cb handle 'read)
  (read-stop (uv-handle-ptr handle)))

 (define write-f
  (foreign-procedure "uv_write" (uptr uptr (* uv-buf) unsigned-int uptr) int))

 (define (uv-write req handle bufs nbufs cb)
  (let ((fcb (cb->fcb handle 'write cb (uptr int) void)))
   (write-f req (uv-handle-ptr handle) bufs nbufs (code->address fcb))))

 (define try-write 
  (foreign-procedure "uv_try_write" (uptr (* uv-buf) unsigned-int) int))

 (define (uv-try-write handle bufs nbufs)
  (try-write (uv-handle-ptr handle) bufs nbufs))

 (define is-readable
  (foreign-procedure "uv_is_readable" (uptr) boolean))

 (define (uv-is-readable handle)
  (is-readable (uv-handle-ptr handle)))

 (define is-writable
  (foreign-procedure "uv_is_writable" (uptr) boolean))

 (define (uv-is-writable handle)
  (is-writable (uv-handle-ptr handle)))

 (define stream-set-blocking
  (foreign-procedure "uv_stream_set_blocking" (uptr boolean) int))

 (define (uv-stream-set-blocking handle block)
  (stream-set-blocking (uv-handle-ptr handle) block))
)
