(library (choice tcp)
 (export make-tcp-handle make-tcp-handle-ex
         uv-tcp-open uv-tcp-nodelay
         uv-tcp-keepalive uv-tcp-simultaneous-accepts
         uv-tcp-bind uv-tcp-getsockname uv-tcp-getpeername
         uv-tcp-connect)
 (import (chezscheme)
         (choice handle)
         (choice buf))

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

 (define tcp-bind
  (foreign-procedure "uv_tcp_bind" (utpr (* sockaddr) unsigned-int) int))

 (define (uv-tcp-bind handle addr flags)
  (tcp-bind (uv-handle-ptr handle) addr flags))

 (define tcp-getsockname
  (foreign-procedure "uv_tcp_getsockname" (uptr uptr (* int)) int))

 (define (uv-tcp-getsockname handle addr len)
  (tcp-getsockname (uv-handle-ptr handle) addr len))

 (define tcp-connect
  (foreign-procedure "uv_tcp_connect" (uptr uptr (* sockaddr) uptr) int))

 (define (uv-tcp-connect req handle addr cb)
  (let ((fcb (cb->fcb handle 'tcp-connect cb (uptr int) void)))
   (tcp-connect req (uv-handle-ptr handle) addr (code->addr fcb))))
)
