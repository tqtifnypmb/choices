(library (choice request)
 (export uv-req-size uv-cancel
         make-request release-request)
 (import (chezscheme)
         (choice utility))

 (define (uv-req-size type)
  (request-size (indexed-list-index request-type type)))

 (define reqeust-size
  (foreign-procedure "uv_req_size" (int) size_t))

 (define request-type
  (list->indexed-list '(unknown
                        req
                        connect
                        write
                        shutdown
                        dup-send
                        fs
                        work
                        getaddrinfo
                        getnameinfo
                        req-type-private)))

 (define uv-cancel
  (foreign-procedure "uv_cancel" (uptr) int))

 (define (make-request type)
  (foreign-alloc (uv-req-size type)))

 (define (release-request req)
  (foreign-free req))
)
