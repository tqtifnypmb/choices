 (define (list->indexed-list lst)
  (let loop ((lst lst) (res '()) (idx 0))
   (if (null? lst)
    res
    (loop (cdr lst) (append res (cons (cons (car lst) idx) '())) (+ idx 1)))))

 (define (indexed-list-index lst type)
  (let ((match (filter 
                (lambda (e) (symbol=? (car e) type)) 
                lst)))
   (if (null? match)
    (raise (make-message-condition "unknown type"))
    (cdar match))))

 ;code object
 (define address->code foreign-callable-code-object)
 (define code->address foreign-callable-entry-point)

 ;version
 (define uv-version
  (foreign-procedure "uv_version" () unsigned-32))

 (define uv-version-string
  (foreign-procedure "uv_version_string" () string))

 ;error
 (define uv-strerror
  (foreign-procedure "uv_strerror" (int) string))

 (define uv-err-name
  (foreign-procedure "uv_err_name" (int) string))

 (define uv-translate-sys-error
  (foreign-procedure "uv_translate_sys_error" (int) int))
