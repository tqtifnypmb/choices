(library (choice buf)
 (export uv-buf)
 (import (chezscheme))


 ;buf
 (define-ftype uv-buf
  (struct
   (base uptr)
   (len size_t)))

; (define (string->uv-buf str)
; )

; (define (release-uv-buf buf)
; )
)
