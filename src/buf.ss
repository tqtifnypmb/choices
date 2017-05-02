 ;buf
 (define-ftype uv-buf
  (struct
   (base (* char))
   (len size_t)))

 (define (uv-buf-fill buf size)
  (let ((region (make-ftype-pointer char
                 (foreign-alloc size))))
   (ftype-set! uv-buf (base) buf region)
   (ftype-set! uv-buf (len) buf size)))

 (define (uv-buf->list buf)
  (let ((size (ftype-ref uv-buf (len) buf)))
   (let loop ((ret '())
              (idx 0))
    (if (< idx size)
     (loop (append ret (cons (ftype-ref uv-buf (base idx) buf) '())) (+ idx 1))
     ret))))

 (define (list->uv-buf lst)
  (let* ((len (length lst))
         (region (make-ftype-pointer char (foreign-alloc (* len (ftype-sizeof char)))))
         (buf (make-ftype-pointer uv-buf (foreign-alloc (ftype-sizeof uv-buf)))))
   (ftype-set! uv-buf (base) buf region)
   (ftype-set! uv-buf (len) buf len)

   ;; assign content to region
   (let loop ((idx 0)
              (l lst))
    (if (< idx len)
     (begin
      (ftype-set! char () region idx (car l))
      (loop (+ idx 1) (cdr l)))
     buf))))

 (define (uv-buf->string buf)
  (list->string (uv-buf->list buf)))

 (define (string->uv-buf str)
  (list->uv-buf (string->list str)))

 (define (release-uv-buf buf)
  (foreign-free buf))

 ;sockaddr
 (define-ftype sockaddr
  (struct 
   (sa-len unsigned-8)
   (sa-family unsigned-8)
   (_ (array 14 char))))

 (define-ftype in-addr
  (struct
   (s-addr unsigned-32)))

 (define-ftype sockaddr-in
  (struct 
   (sin-len unsigned-8)
   (sin-family unsigned-8)
   (sin-port unsigned-16)
   (sin-addr in-addr)
   (zero (array 8 char))))

 (define (make-sockaddr-in)
  (let ((ptr (make-ftype-pointer sockaddr-in
              (foreign-alloc
               (ftype-sizeof sockaddr-in)))))
   ptr))

 (define (release-sockaddr-in addr) 
  (foreign-free addr))

 (define-syntax cast
  (syntax-rules ()
   ((_ type ptr) (make-ftype-pointer type 
                    (ftype-pointer-address ptr)))))
