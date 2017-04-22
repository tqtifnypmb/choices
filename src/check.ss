(library (choice check)
 (export make-check-handle uv-check-start
         uv-check-stop)
 (import (chezscheme)
         (choice handle))

 (define check-init
  (foreign-procedure "uv_check_init" (uptr uptr) int))

 (define (make-check-handle loop)
  (new-handle loop check-init 'check))

 (define check-start
  (foreign-procedure "uv_check_start" (uptr uptr) int))

 (define (uv-check-start handle cb)
  (handle-start check-start handle cb))

 (define check-stop
  (foreign-procedure "uv_check_stop" (uptr) int))

 (define (uv-check-stop handle)
  (handle-stop check-stop handle))
)
