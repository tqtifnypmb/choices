(library (choice buf)
 (export uv-buf sockaddr-in sockaddr
         make-sockaddr-in release-sockaddr-in
         release-uv-buf cast)
 (import (chezscheme))


 ;buf
 (define-ftype uv-buf
  (struct
   (base (* char))
   (len size_t)))

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
              (foreign-aloc
               (ftype-sizeof sockaddr-in)))))
   ptr))

 (define (release-sockaddr-in addr) 
  (foreign-free addr))

 (define-syntax cast
  (syntax-rules ()
   ((_ type ptr) (make-ftype-pointer type 
                    (ftype-pointer-address ptr)))))
)
