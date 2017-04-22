(library (choice pipe)
 (export make-pipe-handle uv-pipe-open
         uv-pipe-bind uv-pipe-connect
         uv-pipe-getsockname uv-pipe-getpeername
         uv-pipe-pending-count)
 (import (chezscheme)
         (choice handle))

 (define pipe-init
  (foreign-procedure "uv_pipe_init" (uptr uptr boolean) int))

 (define (make-pipe-handle loop ipc)
  (new-handle loop pipe-init ipc))

 (define pipe-open
  (foreign-procedure "uv_pipe_open" (uptr int) int))

 (define (uv-pipe-open handle file)
  (pipe-open (uv-handle-ptr handle) file))

 (define pipe-bind
  (foreign-procedure "uv_pipe_bind" (uptr string) int))

 (define (uv-pipe-bind handle name)
  (pipe-bind (uv-handle-ptr handle) name))

 (define pipe-connect
  (foreign-procedure "uv_pipe_connect" (uptr uptr string uptr) void ))

 (define (uv-pipe-connect req handle name cb)
  (let ((fcb (cb->fcb handle 'pipe-connect cb (uptr int) void)))
   (pipe-connect req (uv-handle-ptr handle) name (code->address fcb))))

 (define pipe-getsockname
  (foreign-procedure "uv_pipe_getsockname" (uptr uptr size_t) int))

 (define (uv-pipe-getsockname handle buf)
  (let ((ptr (ftype-ref uv-buf (base) buf))
        (len (ftype-ref uv-buf (len) buf)))
   (pipe-getsockname (uv-handle-ptr handle) ptr len)))

 (define pipe-getpeername
  (foreign-procedure "uv_pipe_getpeername" (uptr uptr size_t) int))
    
 (define (uv-pipe-getpeername handle buf)
  (let ((ptr (ftype-ref uv-buf (base) buf))
        (len (ftype-ref uv-buf (len) buf)))
   (pipe-getpeername (uv-handle-ptr handle) ptr len)))

 (define pipe-pending-count
  (foreign-procedure "uv_pipe_pending_count" (uptr) int))

 (define (uv-pipe-pending-count handle)
  (pipe-pending-count (uv-handle-ptr handle)))
)
