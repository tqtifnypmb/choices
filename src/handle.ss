(library (choice handle)
 (export haha)
 (import (chezscheme)
         (choice utility))

 (define-ftype uv-handle void*)

 (define uv-is-active
  (foreign-procedure "uv_is_active" (uv-handle) boolean))

 (define uv-is-closing
  (foreign-procedure "uv_is_closing" (uv-handle) boolean))

 (define uv-ref
  (foreign-procedure "uv_ref" (uv-handle) void))

 (define uv-unref
  (foreign-procedure "uv_unref" (uv-handle) void))

 (define uv-had-ref
  (foreign-procedure "uv_has_ref" (uv-handle) boolean))

 (define (uv-handle-size type)
  (let ((i (indexed-list-index handle-type type)))
   (handle-size i)))

 (define handle-size
  (foreign-procedure "uv_handle_size" (int) size_t))

 (define handle-type
  (list->indexed-list '('unknown
                         'async
                         'check
                         'fs-event
                         'fs-poll
                         'handle
                         'idle
                         'named-piple
                         'poll
                         'prepare
                         'process
                         'stream
                         'tcp
                         'timer
                         'tty
                         'udp
                         'signal
                         'file)))
)
