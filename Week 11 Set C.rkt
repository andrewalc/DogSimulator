;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Week 11 Set C|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Andrew Alcala alcala.a@husky.neu.edu
;; Jeffrey Champion champion.j@husky.neu.edu
;; Problem Set 11 C 

;A Z is an Integer

; Number Z Number -> Z
; Given a base number n, integer exponent z and edge number: 
; Finds z such that (expt n (- z 1)) or (expt n (+ z 1))
; equals or approximates to the edge number 
(check-expect (ex-before #i10.0 0 #i+inf.0)308)
(check-expect (ex-before #i10.0 0 #i+0.0)-323)
(check-expect (ex-before 2 0 4096)11)
(check-expect (ex-before 2 0 .0625)-3)

(define (ex-before n ex edge)
  (local[(define op (if(> edge n)+ -))]
    (cond [(= edge (expt n (op ex 1))) ex]
          [else (ex-before n (op ex 1) edge)])))

; Number -> Z
; Given a Number n, returns the integer z such that (expt n (+ z 1))
; approximates to infinity
(check-expect (ex-before-inf #i10.0) 308)

(define (ex-before-inf n)
  (ex-before n 0 #i+inf.0))

; Number -> Z
; Given a Number n, returns the integer z such that (expt n (- z 1))
; approximates to zero
(check-expect (ex-before-zero #i10.0) -323)

(define (ex-before-zero n)
  (ex-before n 0 #i+0.0))
