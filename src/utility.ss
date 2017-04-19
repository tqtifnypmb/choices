(library (choice utility)
 (export list->indexed-list indexed-list-index
         new)
 (import (chezscheme))

 (define-syntax new
  (syntax-rules ()
   ((_ init size) (let* ((obj (foreign-alloc size))
                        (res (init obj)))
                    (if (= res 0)
                     obj
                     (begin (foreign-free obj)
                            #f))))
   ((_ loop init size) (let* ((obj (foreign-alloc size))
                         (res (init loop obj)))
                    (if (= res 0)
                     obj
                     (begin (foreign-free obj)
                            #f))))
   ((_ loop init size arg ...) (let* ((obj (foreign-alloc size))
                                 (res (init loop obj arg ...)))
                            (if (= res 0)
                             obj
                             (begin (foreign-free obj)
                                    #f))))))

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
    (raise (make-violation))
    (cdar match))))
)
