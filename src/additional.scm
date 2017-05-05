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

; Chapter 7
; Test
(set? '(apples peaches pears plums))           ; => #t
(set? '(apples peaches pears apples plums))    ; => #f
(makeset '(apples peaches pears apples plums))
(makeset-multi '(apple peach pear peach plum apple lemon peach))
(makeset-multi '(apple 3 pear 4 9 apple 3 4))

(define set1 '(stewed tomatoes and macaroni))
(define set2 '(macaroni and cheese))
(fun? '((8 3) (4 2) (7 6) (6 2) (3 4)))
(revrel '((a b) (c d) (e g)))
(revrel2 '((a b) (c d) (e g)))

(equal? (revrel '((a b) (c d) (e g)))
        (revrel2 '((a b) (c d) (e g))))

(fun? '((grape raisin) (plum prune) (stewed grape))) ; => #t

(fullfun? '((grape raisin) (plum prune) (stewed prune))) ; => #f
(fullfun? '((grape raisin) (plum prune) (stewed grape))) ; => #t

(one-to-one? '((chocolate chip) (doughy cookie))) ; => #t


; Chapter 8
; Example: Name of the function returned by
; (rember-f test?), where test? is eq?
(define test? eq?)
(define rember-eq? (rember-f test?))
