(library (choice prepare)
 (export make-prepare-handle uv-prepare-start
         uv-prepare-stop)
 (import (chezscheme)
         (choice handle))

 (define prepare-init
  (foreign-procedure "uv_prepare_init" (uptr uptr) int))

 (define (make-prepare-handle loop)
  (new-handle loop prepare-init 'prepare))

 (define prepare-start
  (foreign-procedure "uv_prepare_start" (uptr uptr) int))

 (define (uv-prepare-start handle cb)
  (handle-start prepare-start handle cb))

 (define prepare-stop
  (foreign-procedure "uv_prepare_stop" (uptr) int))

 (define (uv-prepare-stop handle)
  (handle-stop prepare-stop handle))
)
