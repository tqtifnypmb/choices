(library (choice handle)
 (export uv-is-active uv-is-closing uv-ref
         uv-unref uv-had-ref make-check-handle
         uv-check-start uv-check-stop make-idle-handle
         uv-idle-start uv-idle-stop make-prepare-handle
         uv-prepare-start uv-prepare-stop make-timer-handle
         uv-timer-start uv-timer-stop uv-timer-again
         uv-timer-set-repeat uv-timer-get-repeat
         make-async-handle uv-async-send)
 (import (chezscheme)
         (choice utility))

 (define-record-type uv-handle 
  (fields (immutable ptr) (mutable cb)))

 (define (replace-cb h cb)
  (let ((old (uv-handle-cb h)))
   (if (= old 0)
    (uv-handle-cb-set! cb)
    (begin
     (unlock-object old)
     (uv-handle-cb-set! cb)))))

 (define (release-cb h)
  (let ((cb (uv-handle-cb h)))
   (if (not (= cb 0))
    (begin (unlock-object cb)
           (uv-handle-cb-set! 0))
    (uv-handle-cb-set! 0))))

 ;common
 (define uv-is-active
  (foreign-procedure "uv_is_active" (uptr) boolean))

 (define uv-is-closing
  (foreign-procedure "uv_is_closing" (uptr) boolean))

 (define uv-ref
  (foreign-procedure "uv_ref" (uptr) void))

 (define uv-unref
  (foreign-procedure "uv_unref" (uptr) void))

 (define uv-had-ref
  (foreign-procedure "uv_has_ref" (uptr) boolean))

 (define (uv-handle-size type)
  (handle-size (indexed-list-index handle-type 
                                   type)))

 (define handle-size
  (foreign-procedure "uv_handle_size" (int) size_t))

 (define handle-type
  (list->indexed-list '(unknown
                        async
                        check
                        fs-event
                        fs-poll
                        handle
                        idle
                        named-piple
                        poll
                        prepare
                        process
                        stream
                        tcp
                        timer
                        tty
                        udp
                        signal
                        file)))

 (define-syntax new-handle
  (syntax-rules ()
   ((_ loop init type) (let ((p (new loop init (handle-size type))))
                         (if (boolean? p)
                         (raise (make-violation))
                         (make-uv-handle p 0))))
   ((_ loop init type arg ...) (let ((p (new loop init (handle-size type) arg ...)))
                                 (if (boolean? p)
                                 (raise (make-violation))
                                 (make-uv-handle p 0))))))
 
 (define-syntax handle-start
  (syntax-rules ()
   ((_ start handle cb) (let ((fcb (foreign-callable cb (uptr) void)))
                          (lock-object fcb)
                          (replace-cb handle fcb)
                          (start (uv-handle-ptr handle) fcb)))
   ((_ start handle cb arg ...) (let ((fcb (foreign-callable cb (uptr) void)))
                                  (lock-object fcb)
                                  (replace-cb handle fcb)
                                  (start (uv-handle-ptr handle) fcb arg ...)))))


 (define-syntax handle-stop
  (syntax-rules ()
   ((_ stop handle) (begin (release-cb handle)
                           (stop (uv-handle-ptr handle))))))

  ;check
 (define check-init
  (foreign-procedure "uv_check_init" (uptr uptr) int))

 (define check-start
  (foreign-procedure "uv_check_start" (uptr uptr) int))

 (define check-stop
  (foreign-procedure "uv_check_stop" (uptr) int))

 (define (make-check-handle loop)
  (new-handle loop check-init 'check))

 (define (uv-check-start handle cb)
  (handle-start check-start handle cb))

 (define (uv-check-stop handle)
  (handle-stop check-stop handle))

 ;idle
 (define idle-init
  (foreign-procedure "uv_idle_init" (uptr uptr) int))

 (define idle-start
  (foreign-procedure "uv_idle_start" (uptr uptr) int))

 (define idle-stop
  (foreign-procedure "uv_idle_stop" (uptr) int))

 (define (make-idle-handle loop)
  (new-handle loop idle-init 'idle))

 (define (uv-idle-start handle cb)
  (handle-start idle-start handle cb))

 (define (uv-idle-stop handle)
  (handle-stop idle-stop handle))

 ;prepare
 (define prepare-init
  (foreign-procedure "uv_prepare_init" (uptr uptr) int))

 (define prepare-start
  (foreign-procedure "uv_prepare_start" (uptr uptr) int))

 (define prepare-stop
  (foreign-procedure "uv_prepare_stop" (uptr) int))

 (define (make-prepare-handle loop)
  (new-handle loop prepare-init 'prepare))

 (define (uv-prepare-start handle cb)
  (handle-start prepare-start handle cb))

 (define (uv-prepare-stop handle)
  (handle-stop prepare-stop handle))

 ;timer
 (define timer-init
  (foreign-procedure "uv_timer_init" (uptr uptr) int))

 (define timer-start
  (foreign-procedure "uv_timer_start" (uptr uptr unsigned-64 unsigned-64) int))

 (define timer-stop
  (foreign-procedure "uv_timer_stop" (uptr) int))

 (define (make-timer-handle loop)
  (new-handle loop timer-init 'timer))

 (define (uv-timer-start handle cb timeout repeat)
  (handle-start timer-start handle cb timeout repeat))

 (define (uv-timer-stop handle)
  (handle-stop timer-stop handle))

 (define uv-timer-again
  (foreign-procedure "uv_timer_again" (uptr) int))

 (define uv-timer-set-repeat
  (foreign-procedure "uv_timer_set_repeat" (uptr unsigned-64) int))

 (define uv-timer-get-repeat
  (foreign-procedure "uv_timer_get_repeat" (uptr) unsigned-64))

 ;async
 (define async-init
  (foreign-procedure "uv_async_init" (uptr uptr uptr) int))

 (define (make-async-handle loop cb)
  (new-handle loop async-init 'async cb))

 (define uv-async-send
  (foreign-procedure "uv_async_send" (uptr) int))
)
