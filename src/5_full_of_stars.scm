; Chapter 5: Full Of Stars

; 08/19/2017
; irtaylor's Notes, since this chapter is hard(er):
; *-functions work on lists of S-expressions. Their distinguishing feature,
; is that they recur down both the car AND the cdr of a list. This defines
; a recurrence relation, as in T(n) = 2T(n/2) + n ... well, not that equation
; exactly, but something like it. This is best visualized as a tree structure:
; One branch proceeds down the car of the list, and the other branch proceeds
; down the cdr of the list.

; use for these exercises:
(define l '((banana) (split ((((banana ice))) (cream (banana)) sherbet)) (banana) (bread) (banana brandy)))
(define new 'orange)
(define old 'banana)

; rember* vs rember
; test using (define l '((coffee) cup ((tea) cup) (and (hick)) cup))
(define rember*
  (lambda (a l)
    (cond
      ((null? l) (quote ()))             ; is first element of l null? if so, return null
      ((atom? (car l))                   ; is first element of l an atom?
        (cond
          ((eq? (car l) a)                  ; if so, is it eqal to a?
            (rember* a (cdr l)))            ; then recur on the remainder of l, removing a
        (else (cons (car l)               ; otherwise, begin building new list
            (rember* a (cdr l))))))
    (else (cons (rember* a (car l))     ; if first element of l is neither null nor an atom...
        (rember* a (cdr l)))))))        ; then build new list...

; regarding the above:
; rember* can work on lists of lists, because it treats each element
; of the list as a list. of each element, it asks: "is this null?", "is this an atom?"
; see the first commandment!

; ... carry on...
(define insertR*
  (lambda (new old l)
    (cond
      ((null? l) (quote ()))
      ((atom? (car l))
        (cond
          ((eq? (car l) old)
            (cons old (cons new (insertR* new old (cdr l)))))
        (else (cons (car l) (insertR* new old (cdr l))))))
    (else (cons (insertR* new old (car l))          ; notice how the recursion splits into two branches:
                (insertR* new old (cdr l)))))))     ; 1) recurring down (car l) and 2) recurring down (cdr l)

; occur* counts occurences of a in l
(define occur*
  (lambda (a l)
    (cond
      ((null? l) 0)
      ((atom? (car l))
        (cond
          ((eq? (car l) a)
            (add1 (occur* a (cdr l))))
        (else (occur* a (cdr l)))))
    (else (o+ (occur* a (car l))
              (occur* a (cdr l)))))))

; try occur* with l below

; N.B. *-functions still only hunt for atoms. So we couldn't do:
; (occur* '(banana brandy) l)

(define subst*
  (lambda (new old l)
    (cond
      ((null? l) (quote ()))
      ((atom? (car l))
        (cond
          ((eq? (car l) old)
            (cons new (subst* new old (cdr l))))
        (else (cons (car l) (subst* new old (cdr l))))))
    (else
      (cons (subst* new old (car l))
            (subst* new old (cdr l)))))))

(define insertL*
  (lambda (new old l)
    (cond
      ((null? l) (quote ()))
      ((atom? (car l))
        (cond
          ((eq? (car l) old)
            (cons new (cons old                 ; cons both new AND old, so that we can recur down the
              (insertL* new old (cdr l)))))     ; remaining elements of l
        (else (cons (car l) (insertL* new old (cdr l))))))
    (else (cons (insertL* new old (car l))
                (insertL* new old (cdr l)))))))

; return true/false if a is/is not an atom in l
(define member*
  (lambda (a l)
    (cond
      ((null? l) #f)
      ((atom? (car l))              ; if (car l) is an atom...
        (or (eq? a (car l))         ; ...then return the answer to the question:...
            (member* a (cdr l))))   ; ...is a equal to  (car l) or is a an atom of (cdr l)?
    (else (or (member* a (car l))
              (member* a (cdr l)))))))


; leftmost is not a true *-function, since it only recurs down
; the list's car; it does not recur down the cdr.
(define leftmost
  (lambda (l)
    (cond
      ((atom? (car l)) (car l))
    (else (leftmost (car l))))))

; eqlist v2
(define eqlist?
  (lambda (l1 l2)
    (cond
      ((and (null? l1) (null? l2)) #t)            ; are both null? if so, they are equal.
      ((or (null? l1) (null? l2)) #f)             ; if we get here, we know they are not both null, so is one null but not the other?
      ((and (atom? (car l1)) (atom? (car l2)))    ; are the cars of l1 and l2 both atoms?
        (and (eqan? (car l1) (car l2))            ; also, are they the same atom? (see ch 4)
          (eqlist? (cdr l1) (cdr l2))))           ; also, are the cdrs of l1 and l2 the same?
      ((or (atom? (car l1)) (atom? (car l2))) #f) ; if the cars of l1 and l2 are not both atoms, then is one an atom, but not the other?
    (else
      (and (eqlist? (car l1) (car l2))            ; if none of the above, then the cars are not atoms and we must see if the cars are the same list...
      (eqlist? (cdr l1) (cdr l2)))))))            ; and if the cdrs of l1 and l2 are the same list


; check if two S-Expressions are equal
(define equal?
  (lambda (s1 s2)
    (cond
      ((and (atom? s1) (atom? s2))        ; if s1 and s2 are both atoms...
        (eqan? s1 s2))                    ; then are they the same atom?
      ((or (atom? s1) (atom? s2)) #f)     ; or, if one is an atom but not the other, then they're not equal
    (else (eqlist? s1 s2)))))             ; if s1 and s2 are not atoms, then check equality using eqlist? (see definition of S-Expression)

; eqlist v3
(define eqlist?
  (lambda (l1 l2)
    (cond
      ((and (null? l1) (null? l2)) #t)
      ((or (null? l1) (null? l2)) #f)
    (else
      (and (equal? (car l1) (car l2))     ; equal? eliminates the need to explicitly check whether car l1 and l2 are atoms
        (eqlist? (cdr l1) (cdr l2)))))))  ; this version is slightly more straightforward: are car l1 and l2 equal? if so, check the cdrs...

; rember final version (not same as rember*)
(define rember
  (lambda (s l)
    (cond
      ((null? l) (quote ()))
      ((equal? (car l) s) (cdr l))
    (else (cons (car l) (rember s (cdr l)))))))   ; rember only recurs on the cdr... not on the car.
