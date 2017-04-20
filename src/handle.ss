(library (choice handle)
 (export uv-is-active uv-is-closing uv-ref
         uv-unref uv-had-ref make-check-handle
         uv-check-start uv-check-stop make-idle-handle
         uv-idle-start uv-idle-stop make-prepare-handle
         uv-prepare-start uv-prepare-stop make-timer-handle
         uv-timer-start uv-timer-stop uv-timer-again
         uv-timer-set-repeat uv-timer-get-repeat
         make-async-handle uv-async-send release-handle)
 (import (chezscheme)
         (choice utility))

 ;buf
 (define-ftype uv-buf
  (struct
   (base u8*)
   (len size_t)))

 ;handle
 (define-record-type uv-handle 
  (fields (immutable ptr) (mutable cbs)))

 (define (replace-cb handle type cb)
  (let-values (((old remain)
                (partition (lambda (x) (eq? (car x) type)) (uv-handle-cbs handle))))
   (unless (null? old)
    (unlock-object (address->code (cdar old))))

   (if (eq? #f cb)
    (uv-handle-cbs-set! handle remain)
    (uv-handle-cbs-set! handle (append remain 
                                       (list (cons type 
                                                   (code->address cb))))))))

 (define (release-cb handle type)
  (replace-cb handle type #f))

 (define (uv-handle-type-cb handle type)
  (cadar (filter (lambda (x) (eq? (car x) type)) (uv-handle-cbs handle))))

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

 (define uv-close-f
  (foreign-procedure "uv_close" (uptr uptr) void))

 (define (uv-close handle cb)
  (let ((fcb (foreign-callable cb (uptr) void)))
   (lock-object fcb)
   (replace-cb handle 'close fcb)
   (uv-close-f (uv-handle-ptr handle) (code->address fcb))))

 (define (uv-handle-size type)
  (handle-size (indexed-list-index handle-type 
                                   type)))

 (define (release-handle handle)
  (for-each (lambda (cb) (unlock-object (address->code (cdr cb))))
            (uv-handle-cbs handle))
  (foreign-free (uv-handle-ptr handle)))

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
   ((_ loop init type) (let ((p (new loop init (uv-handle-size type))))
                         (if (boolean? p)
                         (raise (make-violation))
                         (make-uv-handle p '()))))
   ((_ loop init type arg ...) (let ((p (new loop init (uv-handle-size type) arg ...)))
                                 (if (boolean? p)
                                 (raise (make-violation))
                                 (make-uv-handle p '()))))))
 
 (define-syntax handle-start
  (syntax-rules ()
   ((_ start handle cb) (let ((fcb (foreign-callable cb (uptr) void)))
                          (lock-object fcb)
                          (replace-cb handle 'start fcb)
                          (start (uv-handle-ptr handle) (code->address fcb))))
   ((_ start handle cb arg ...) (let ((fcb (foreign-callable cb (uptr) void)))
                                  (lock-object fcb)
                                  (replace-cb handle 'start fcb)
                                  (start (uv-handle-ptr handle) (code->address fcb) arg ...)))))


 (define-syntax handle-stop
  (syntax-rules ()
   ((_ stop handle) (begin (release-cb handle 'start)
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

 ;async
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

 ;stream
 (define shutdown
  (foreign-procedure "uv_shutdown" (uptr uptr uptr) int))

 (define (uv-shutdown req handle cb)
  (let ((fcb (foreign-callable cb (uptr int) void)))
   (replace-cb handle 'shutdown fcb)
   (lock-object fcb)
   (shutdown req (uv-handle-ptr handle) (code->address fcb))))

 (define listen
  (foreign-procedure "uv_listen" (uptr int uptr) int))

 (define (uv-listen handle backlog cb)
  (let ((fcb (foreign-callable cb (uptr int) void)))
   (replace-cb handle 'listen cb)
   (lock-object fcb)
   (listen (uv-handle-ptr handle) backlog (code->address fcb))))

 (define accept
  (foreign-procedure "uv_accept" (uptr uptr) int))

 (define (uv-accept serv cli)
  (accept (uv-handle-ptr serv)
          (uv-handle-ptr cli)))

 (define read-start
  (foreign-procedure "uv_read_start" (uptr uptr uptr) int))

 (define (uv-read-start handle alloc-cb read-cb)
  (let ((afcb (foreign-callable alloc-cb (uptr size_t (* uv-buf)) void))
        (rfcb (foreign-callable read-cb (uptr size_t (* uv-buf)) void)))
   (replace-cb handle 'alloc afcb)
   (lock-object afcb)

   (replace-cb handle 'read rfcb)
   (lock-object rfcb)
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

 ;FIXME: 
 (define (uv-write req handle bufs nbufs cb)
  (let ((fcb (foreign-callable cb (uptr int) void)))
   (replace-cb handle 'write fcb)
   (lock-object fcb)
   (write-f req (uv-handle-ptr handle) bufs nbufs (code->address fcb))))

 (define try-write
  (foreign-procedure (uptr (* uv-buf) int) int))

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

