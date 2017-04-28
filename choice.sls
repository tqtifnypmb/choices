(library (choice)
 (export 
         ;; buf
         uv-buf sockaddr-in sockaddr
         make-sockaddr-in release-sockaddr-in
         release-uv-buf fill-uv-buf
         uv-buf->bytevector uv-buf->string
         
         ;; utility
         uv-version uv-version-string
         uv-strerror uv-err-name uv-translate-sys-error
         
         ;; loop
         make-loop make-default-loop uv-loop-close
         uv-run uv-loop-alive uv-loop-stop
         uv-now uv-backend-timeout uv-update-time
         uv-run-default uv-run-once uv-run-nowait

         ;; handle
         uv-handle release-handle 
         uv-is-active uv-is-closing uv-ref
         uv-unref uv-had-ref uv-close 
                  
         ;; async
         make-async-handle uv-async-send

         ;; pipe
         make-pipe-handle uv-pipe-open
         uv-pipe-bind uv-pipe-connect
         uv-pipe-getsockname uv-pipe-getpeername
         uv-pipe-pending-count
         
         ;; check
         make-check-handle uv-check-start
         uv-check-stop
         
         ;; idle
         make-idle-handle uv-idle-start
         uv-idle-stop
         
         ;; prepare
         make-prepare-handle uv-prepare-start
         uv-prepare-stop
         
         ;; request
         uv-req-size uv-cancel
         make-request release-request
         
         ;; stream
         uv-shutdown uv-listen uv-accept
         uv-read-start uv-read-stop
         uv-write uv-try-write
         uv-is-readable uv-is-writable
         uv-stream-set-blocking
         
         ;; tcp
         make-tcp-handle make-tcp-handle-ex
         uv-tcp-open uv-tcp-nodelay
         uv-tcp-keepalive uv-tcp-simultaneous-accepts
         uv-tcp-bind uv-tcp-getsockname uv-tcp-getpeername
         uv-tcp-connect
         
         ;; udp
         make-udp-handle make-udp-handle-ex
         uv-udp-open uv-join-group
         uv-leave-group uv-udp-set-membership
         uv-udp-set-multicast-ttl uv-udp-set-multicast-interface
         uv-udp-set-broadcast uv-udp-set-ttl uv-udp-bind
         uv-udp-send uv-udp-try-send uv-udp-recv-start
         uv-udp-recv-stop
         
         ;; timer
         make-timer-handle uv-timer-start
         uv-timer-stop uv-timer-again
         uv-timer-set-repeat uv-timer-get-repeat)

 (import (chezscheme))

 (include "src/buf.ss")
 (include "src/utility.ss")
 (include "src/loop.ss")
 (include "src/handle.ss")
 (include "src/async.ss")
 (include "src/pipe.ss")
 (include "src/check.ss")
 (include "src/idle.ss")
 (include "src/prepare.ss")
 (include "src/request.ss")
 (include "src/stream.ss")
 (include "src/tcp.ss")
 (include "src/udp.ss")
 (include "src/timer.ss")
)
