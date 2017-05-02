; Ian Taylor's Additional Notes:

; Chapter 5
; thinking more about lists:
(define l '(((tomato sauce)) ((bean) sauce) (and ((flying)) sauce)))
(car (car (car l)))        ; returns 'tomato
(car (car (car (cdr l))))  ; returns 'bean


; Chapter 5
; Definition of an S-Expression (p 92):
;   An S-expression is either an atom or a
;   (possibly empty) list of S-expressions.
