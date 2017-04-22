(library (choice tcp)
 (export make-tcp-handle make-tcp-handle-ex
         uv-tcp-open uv-tcp-nodelay
         uv-tcp-keepalive uv-tcp-simultaneous-accepts)
 (import (chezscheme)
         (choice handle))

 ;tcp
 (define tcp-init
  (foreign-procedure "uv_tcp_init" (uptr uptr) int))

 (define (make-tcp-handle loop)
  (new-handle loop tcp-init 'tcp))

 (define tcp-init-ex
  (foreign-procedure "uv_tcp_init_ex" (uptr uptr unsigned-int) int))

 (define (make-tcp-handle-ex loop flags)
  (new-handle loop tcp-init-ex 'tcp flags))

 (define tcp-open
  (foreign-procedure "uv_tcp_open" (uptr int) int))

 (define (uv-tcp-open handle sockfd)
  (tcp-open (uv-handle-ptr handle) sockfd))

 (define tcp-nodelay
  (foreign-procedure "uv_tcp_nodelay" (uptr boolean) int))

 (define (uv-tcp-nodelay handle enable)
  (tcp-nodelay (uv-handle-ptr handle) enable))

 (define tcp-keepalive
  (foreign-procedure "uv_tcp_keepalive" (uptr boolean unsigned-int) int))

 (define (uv-tcp-keepalive handle enable d)
  (tcp-keepalive (uv-handle-ptr handle) enable d))

 (define tcp-simultaneous-accepts
  (foreign-procedure "uv_tcp_simultaneous_accepts" (uptr boolean) int))

 (define (uv-tcp-simultaneous-accepts handle enable)
  (tcp-simultaneous-accepts (uv-handle-ptr handle) enable))

 ;helper function needed for tcp bind
)
