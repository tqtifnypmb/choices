 (define timer-init
  (foreign-procedure "uv_timer_init" (uptr uptr) int))

 (define (make-timer-handle loop)
  (new-handle loop timer-init 'timer))
 
 (define timer-start
  (foreign-procedure "uv_timer_start" (uptr uptr unsigned-64 unsigned-64) int))

 (define (uv-timer-start handle cb timeout repeat)
  (handle-start timer-start handle cb timeout repeat))

 (define timer-stop
  (foreign-procedure "uv_timer_stop" (uptr) int))

 (define (uv-timer-stop handle)
  (handle-stop timer-stop handle))

 (define timer-again
  (foreign-procedure "uv_timer_again" (uptr) int))

 (define (uv-timer-again handle)
  (timer-again (uv-handle-ptr handle)))

 (define timer-set-repeat
  (foreign-procedure "uv_timer_set_repeat" (uptr unsigned-64) int))

 (define (uv-timer-set-repeat handle repeat)
  (timer-set-repeat (uv-handle-ptr handle) repeat))

 (define timer-get-repeat
  (foreign-procedure "uv_timer_get_repeat" (uptr) unsigned-64))

 (define (uv-timer-get-repeat handle)
  (timer-get-repeat (uv-handle-ptr handle)))
