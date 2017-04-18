(library (choice loop)
 (export make-loop
         make-default-loop
         uv-loop-close
         uv-loop-stop)
 (import (chezscheme))

 (define-ftype uv-loop void*)

 (define (make-loop)
  (let* ((loop (make-ftype-pointer uv-loop (foreign-alloc (uv-loop-size))))
         (res (loop-init loop)))
   (if (= res 0)
    loop
    (begin
     (foreign-free loop)
     #f))))

 (define (make-default-loop)
  (let ((loop (default-loop)))
   (if (eq? loop 0)
    #f
    loop)))

 (define (uv-loop-close loop)
  (let (res (uv-loop-close loop))
   (if (= res 0)
    (begin
     (foreign-free loop)
     #t)
    #f)))

 (define loop-init
  (foreign-procedure "uv_loop_init" (uv-loop) int))

 (define default-loop
  (foreign-procedure "uv_default_loop" () uv-loop))

 (define loop-close
  (foreign-procedure "uv_loop_close" (uv-loop) int))

 (define loop-data-set
  (foreign-procedure "loop_data_set" (uv-loop void*) void))

 (define loop-data
  (foreign-procedure "loop_data" (uv-loop) void*))

 (define uv-run
  (foreign-procedure "uv_run" (uv-loop int) int))

 (define uv-loop-alive
  (foreign-procedure "uv_loop_alive" (uv-loop) boolean))

 (define uv-loop-size
  (foreign-procedure "uv_loop_size" () size_t))

 (define uv-loop-stop
  (foreign-procedure "uv_loop_stop" (uv-loop) void))

 (define uv-now
  (foreign-procedure "uv_now" (uv-loop) unsigned-64))

 (define uv-backend-timeout
  (foreign-procedure "uv_backend_timeout" (uv-loop) int))

 (define uv-update-time
  (foreign-procedure "uv_update_time" (uv-loop) void))
)
