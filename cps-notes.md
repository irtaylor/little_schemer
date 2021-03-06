*Chapter 8: Lambda The Ultimate* addresses the concept of [Continuation-Passing Style](https://en.wikipedia.org/wiki/Continuation-passing_style). I really struggled with these concepts, so here are some notes on the subject. 

Specifically these are my idiosyncratic notes on `multiinsertLR&co`, which is a really challenging exercise.

The definition provided by the book for `multiinsertLR&co` is:
```scheme
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)
    (cond
      ((null? lat) (col (quote ()) 0 0))
      ((eq? (car lat) oldL)
        (multiinsertLR&co new oldL oldR
          (cdr lat)
          (lambda (newlat L R)
            (col (cons new (cons oldL newlat))
                 (add1 L) R))))
      ((eq? (car lat) oldR)
        (multiinsertLR&co new oldL oldR
          (cdr lat)
          (lambda (newlat L R)
            (col (cons oldR (cons new newlat))
                 L (add1 R)))))
    (else
      (multiinsertLR&co new oldL oldR
        (cdr lat)
        (lambda (newlat L R)
          (col (cons (car lat) newlat)
               L R)))))))
```




The signature for multiinsertLR&co is:

```scheme
(define multiinsertLR&co
  (lambda (new oldL oldR lat col)...)...)
```

Recall that with all recursive functions, we recur until we hit our base case.
For this function, the base case is:

```scheme
((null? lat) (col (quote ()) 0 0))
```

By the time we hit the null case, however, we have  repeatedly passed new lambdas
for col, such that the col function is recursively built up.


Say, for example, that we run multiinsertLR&co as follows:

```scheme
(define lat (quote (bread chips and fish or steam and chips)))
(define col
  (lambda (lat L R)
    lat))
(multiinsertLR&co 'salty 'fish 'chips lat col)  ; => '(bread chips salty and salty fish or steam and chips salty)
```


By the time we hit the null case, col has been defined as follows:

```scheme
((lambda (newlat L R)
   ((lambda (newlat L R)
      ((lambda (newlat L R)
         ((lambda (newlat L R)
            ((lambda (newlat L R)
               ((lambda (newlat L R)
                  ((lambda (newlat L R)
                     ((lambda (newlat L R)
                        ((lambda (lat L R) lat)
                         (cons
                          (car
                           (list
                            'bread
                            'chips
                            'and
                            'fish
                            'or
                            'steam
                            'and
                            'chips))
                          newlat)
                         L
                         R))
                      (cons 'chips (cons 'salty newlat))
                      L
                      (add1 R)))
                   (cons
                    (car
                     (list 'and 'fish 'or 'steam 'and 'chips))
                    newlat)
                   L
                   R))
                (cons 'salty (cons 'fish newlat))
                (add1 L)
                R))
             (cons (car (list 'or 'steam 'and 'chips)) newlat)
             L
             R))
          (cons (car (list 'steam 'and 'chips)) newlat)
          L
          R))
       (cons (car (list 'and 'chips)) newlat)
       L
       R))
    (cons 'chips (cons 'salty newlat))
    L
    (add1 R)))
 '()
 0
 0)
```

... which is straight-up crazy. Anyways, the last three lines of this chunk are the parameters passed to outermost lambda.
The lambdas will begin to evaluate from the outermost to the innermost. Each evaluation will pass new parameters for `newlat`, `L`, and `R`. `newlat` will be `cons`'ed up from `'()`, while `L` and `R` will both be added up from `0`. Note that the inner lambdas are all going to `cons` elements onto `newlat`, depending on which branch of `multiinsertLR&co` we followed. Additionally, the inner lambdas are going to call `add1` on either `L` or `R`, again depending on which branch we followed. 

Eventually, as the outer lambdas evaluate and collapse inwards, we reach:

```scheme
((lambda (newlat L R)
   ((lambda (lat L R) lat) (cons (car (list 'bread 'chips 'and 'fish 'or 'steam 'and 'chips)) newlat) L R))
 (list 'chips 'salty 'and 'salty 'fish 'or 'steam 'and 'chips 'salty)
 1
 2)
```

It's easier to see here how the innermost lambda is in fact the original definition of `col` that we passed when first calling `multiinserLR&co`. When this penultimate lambda collapses, we'll have:

```scheme
((lambda (lat L R) lat) (list 'bread 'chips 'salty 'and 'salty 'fish 'or 'steam 'and 'chips 'salty) 1 2)
```
... which, based on our original definition for `col`, simply returns the list that we've built up. 

Of course, we could do other things with col:

```scheme
(define col
  (lambda (lat L R)
    (+ L R)))
```
... which would return a sum of the left insertions and right insertions, i.e. it would return the total number of insertions. 

I think I now understand what people mean when they speak about 'Callback Hell'.
