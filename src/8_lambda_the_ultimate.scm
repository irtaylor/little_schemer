; Chapter 8: Lambda the Ultimate!!
; I'm so excited!

; -f functions are all about taking other functions as arguments
; Thus, the power of the Lambda is the use of functions as data

; Up to this point, there are three versions of rember:
;   - rember using =
;   - rember using eq?
;   - rember using equal?

; rember-f can be whichever version we want, since we tell it which
; equality-checking function to use:

(define rember-f
  (lambda (test? a l)                      ; test? is whatever function we pass to rember-f
    (cond
      ((null? l) (quote ()))
      ((test? (car l) a) (cdr l))          ; if test? compares (car l) and 'a truthfully, then return the cdr of l
    (else
      (cons (car l)
        (rember-f test? a (cdr l)))))))
