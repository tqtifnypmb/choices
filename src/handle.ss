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
  (let ((fcb (cb->fcb handle 'close cb (uptr) void)))
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
                        named-pipe
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
 (define-syntax new
  (syntax-rules ()
   ((_ init size) (let* ((obj (foreign-alloc size))
                        (res (init obj)))
                    (if (= res 0)
                     obj
                     (begin (foreign-free obj)
                            #f))))
   ((_ loop init size) (let* ((obj (foreign-alloc size))
                         (res (init loop obj)))
                    (if (= res 0)
                     obj
                     (begin (foreign-free obj)
                            #f))))
   ((_ loop init size arg ...) (let* ((obj (foreign-alloc size))
                                 (res (init loop obj arg ...)))
                            (if (= res 0)
                             obj
                             (begin (foreign-free obj)
                                    #f))))))
 (define-syntax new-handle
  (syntax-rules ()
   ((_ loop init type) (let ((p (new loop init (uv-handle-size type))))
                         (if (boolean? p)
                          (raise (make-message-condition "can't alloc new handle"))
                          (make-uv-handle p '()))))
   ((_ loop init type arg ...) (let ((p (new loop init (uv-handle-size type) arg ...)))
                                 (if (boolean? p)
                                  (raise (make-message-condition "can't alloc new handle"))
                                  (make-uv-handle p '()))))))
 
 (define-syntax handle-start
  (syntax-rules ()
   ((_ start handle cb) (let ((fcb (cb->fcb handle 'start cb (uptr) void)))
                          (start (uv-handle-ptr handle) (code->address fcb))))
   ((_ start handle cb arg ...) (let ((fcb (cb->fcb handle 'start cb (uptr) void)))
                                  (start (uv-handle-ptr handle) (code->address fcb) arg ...)))))


 (define-syntax handle-stop
  (syntax-rules ()
   ((_ stop handle) (begin (release-cb handle 'start)
                           (stop (uv-handle-ptr handle))))))

 (define-syntax cb->fcb
  (syntax-rules ()
   ((_ handle type cb sig ...) (let ((fcb (foreign-callable cb sig ...)))
                          (replace-cb handle type fcb)
                          (lock-object fcb)
                          fcb))))
