 ;buf
 (define-ftype uv-buf
  (struct
   (base (* char))
   (len size_t)))

 (define (fill-uv-buf buf size)
  (let ((region (make-ftype-pointer char
                 (foreign-alloc size))))
   (ftype-set! uv-buf (base) buf region)
   (ftype-set! uv-buf (len) buf size)))

 (define (uv-buf->bytevector buf)
  (let ((len (ftype-ref uv-buf (len) buf)))
   (let loop ((vec (make-bytevector len))
              (idx 0))
    (if (< idx len)
     (begin
      (bytevector-u8-set! vec idx (ftype-ref uv-buf (base) buf idx))
      (loop vec (+ idx 1)))
     vec))))

 (define (uv-buf->string buf)
  (let ((tx (make-transcoder (utf-8-codec)))
        (vec (uv-buf->bytevector buf)))
   (bytevector->string vec tx)))

; (define (string->uv-buf str)
; )

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
