 (define (make-loop)
  (new loop-init (uv-loop-size)))

 (define (make-default-loop)
  (let ((loop (default-loop)))
   (if (eq? loop 0)
    #f
    loop)))

 (define (uv-loop-close loop)
  (let ((res (loop-close loop)))
   (if (= res 0)
    (begin
     (foreign-free loop)
     #t)
    #f)))

 (define loop-init
  (foreign-procedure "uv_loop_init" (uptr) int))

 (define default-loop
  (foreign-procedure "uv_default_loop" () uptr))

 (define loop-close
  (foreign-procedure "uv_loop_close" (uptr) int))

; (define loop-data-set
;  (foreign-procedure "loop_data_set" (uv-loop void*) void))

; (define loop-data
;  (foreign-procedure "loop_data" (uptr) void*))

 (define uv-run-default 0)
 (define uv-run-once 1)
 (define uv-run-nowait 2)

 (define uv-run
  (foreign-procedure "uv_run" (uptr int) int))

 (define uv-loop-alive
  (foreign-procedure "uv_loop_alive" (uptr) boolean))

 (define uv-loop-size
  (foreign-procedure "uv_loop_size" () size_t))

 (define uv-loop-stop
  (foreign-procedure "uv_stop" (uptr) void))

 (define uv-now
  (foreign-procedure "uv_now" (uptr) unsigned-64))

 (define uv-backend-timeout
  (foreign-procedure "uv_backend_timeout" (uptr) int))

 (define uv-update-time
  (foreign-procedure "uv_update_time" (uptr) void))
