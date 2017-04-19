(library (choice request)
 (export uv-req-size)
 (import (chezscheme)
         (choice utility))

 (define-ftype uv-req uptr)

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
)
