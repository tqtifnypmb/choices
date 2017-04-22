(library (choice udp)
 (export make-udp-handle make-udp-handle-ex
         uv-udp-open uv-udp-join-group
         uv-udp-leave-group uv-udp-set-membership
         uv-udp-set-multicast-ttl uv-udp-set-multicast-interface
         uv-udp-set-broadcast uv-udp-set-ttl)
 (import (chezscheme)
         (choice buf)
         (choice handle))

 (define udp-init
  (foreign-procedure "uv_udp_init" (uptr uptr) int))

 (define (make-udp-handle loop)
  (new-handle loop udp-init 'udp))

 (define udp-init-ex
  (foreign-procedure "uv_udp_init_ex" (uptr uptr unsigned-int) int))

 (define (make-udp-handle-ex loop flags)
  (new-handle loop udp-init-ex 'udp flags))

 (define udp-open
  (foreign-procedure "uv_udp_open" (uptr int) int))

 (define (uv-udp-open handle sockfd)
  (udp-open (uv-handle-ptr handle) sockfd))

 (define uv-join-group 1)
 (define uv-leave-group 0)

 (define udp-set-membership
  (foreign-procedure "uv_udp_set_membership" (uptr string string int) int))

 (define (uv-udp-set-membership handle maddr iaddr opt)
  (udp-set-membership (uv-handle-ptr handle) maddr iaddr opt))

 (define udp-set-multicast-loop
  (foreign-procedure "uv_udp_set_multicast_loop" (uptr boolean) int))

 (define (uv-udp-set-multicast-loop handle on)
  (udp-set-multicast-loop (uv-handle-ptr handle) on))

 (define udp-set-multicast-ttl
  (foreign-procedure "uv_udp_set_multicast_ttl" (uptr int)))

 (define (uv-udp-set-multicast-ttl handle ttl)
  (udp-set-multicast-ttl (uv-handle-ptr handle) ttl))

 (define udp-set-multicast-interface
  (foreign-procedure "uv_udp_set_multicast_interface" (uptr string) int))

 (define (uv-udp-set-multicast-interface handle addr)
  (udp-set-multicast-interface (uv-handle-ptr handle) addr))

 (define udp-set-broadcast
  (foreign-procedure "uv_udp_set_broadcast" (uptr boolean) int))

 (define (uv-udp-set-broadcast handle on)
  (udp-set-broadcast (uv-handle-ptr handle) on))

 (define udp-set-ttl
  (foreign-procedure (uptr int) int))

 (define (uv-udp-set-ttl handle ttl)
  (udp-set-ttl (uv-handle-ptr handle) ttl))

)
