 (define idle-init
  (foreign-procedure "uv_idle_init" (uptr uptr) int))

 (define (make-idle-handle loop)
  (new-handle loop idle-init 'idle))

 (define idle-start
  (foreign-procedure "uv_idle_start" (uptr uptr) int))

 (define (uv-idle-start handle cb)
  (handle-start idle-start handle cb))

 (define idle-stop
  (foreign-procedure "uv_idle_stop" (uptr) int))

 (define (uv-idle-stop handle)
  (handle-stop idle-stop handle))
