(library (choice async)
 (export make-async-handle uv-async-send)
 (import (chezscheme)
         (choice handle)
         
 (define async-init
  (foreign-procedure "uv_async_init" (uptr uptr uptr) int))

 (define (make-async-handle loop cb)
  (let* ((fcb (foreign-callable cb (uptr) void))
         (res (new-handle loop async-init 'async (code->address cb))))
   (replace-cb res 'async fcb)
   (lock-object fcb)
   res))

 (define async-send
  (foreign-procedure "uv_async_send" (uptr) int))

 (define (uv-async-send handle)
  (async-send (uv-handle-ptr handle)))
)
