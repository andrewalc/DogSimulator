;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 10 Set C|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; Andrew Alcala alcala.a@husky.neu.edu
; Jeffrey Champion champion.j@husky.neu.edu
;-------------------------------------------------------------------------------
; PROBLEM SET 10 C
;-------------------------------------------------------------------------------
; CONSTANTS:
;-------------------------------------------------------------------------------
(define MAX 500)
;-------------------------------------------------------------------------------
; FUNCTIONS:
;-------------------------------------------------------------------------------
; Posn -> Posn 
; Returns a random Posn not equal to the given Posn
(check-satisfied (food-create (make-posn 1 1))
                 not-equal-1-1?)
(define (food-create p)
  (local (; Posn Posn -> Posn 
          ; If the candidate Posn is equal to the given Posn, generate a new one
          ; Otherwise, return the candidate Posn
          (define (food-check-create p candidate)
            (if (equal? p candidate) (food-create p) candidate)))
    (food-check-create p (make-posn (random MAX) (random MAX)))))

; Posn -> Boolean
; use for testing only 
(define (not-equal-1-1? p)
  (not (and (= (posn-x p) 1) (= (posn-y p) 1))))
;-------------------------------------------------------------------------------
; JUSTIFICATION:
;-------------------------------------------------------------------------------
#|
Data: The programmer chose to use Posns as his primary data type as it perfectly
represents the location of the worm's food in cartesian coordinates in 2D space.
Signature/Purpose: The programmer wanted to build a function that produces a
randomly generated Posn that was unique in relation to the given Posn.
Tests: Since the function will use randomization, the programmer uses
check-satisfied to test that food-create function works for every case.
The programmer creates a boolean function not-equal-1-1? to use in
check-satisfied as an example case to test around.
Code: The programmer wants to return a new Posn so a helper function
food-check-create is made. The given posn and a randomly generated function is
sent to the helper function and is compared. To get a unique Posn, the
programmer checks the two using equal? and only returns the unique Posn if it is
not equal to the given Posn, otherwise it will call food-create again and
generate a new Posn. Thus the function keeps generating new
Posns until a unique Posn is generated.
|#