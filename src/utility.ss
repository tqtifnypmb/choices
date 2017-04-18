(library (choice utility)
 (export list->indexed-list
         indexed-list-index)
 (import (chezscheme))

 ;FIXME - disorder
 (define (list->indexed-list lst)
  (let ((idx 0))
   (map (lambda (x) 
         (let ((i (cons x idx)))
          (set! idx (+ idx 1))
          i))
        lst)))

 (define (indexed-list-index lst type)
  (let ((match (filter 
                (lambda (e) (symbol=? (car e) type)) 
                lst)))
   (if (null? match)
    (raise (make-violation))
    (cdar match))))
)
