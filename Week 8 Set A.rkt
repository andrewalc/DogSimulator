;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 8 Set A|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Andrew Alcala:   alcala.a@husky.neu.edu
;; Jeff Champion:   champion.j@husky.neu.edu

(require 2htdp/image)
(require 2htdp/universe)
;;------------------------------------------------------------------------------
; PROBLEM SET 8A: EXERCISE 2
;;------------------------------------------------------------------------------
; CONSTANTS
;;------------------------------------------------------------------------------
(define dot (circle 15 "solid" "red"))
(define WIDTH 700)
(define HEIGHT 400)
(define CANVAS (empty-scene WIDTH HEIGHT))
(define y-val (/ HEIGHT 2))
;;------------------------------------------------------------------------------
; DATA DEFINITION
;;------------------------------------------------------------------------------
; a x0 is a Number
; a delta is a Number >0
; a x-limit is a Number greater than x0
;; INTERPRETATION:
; - x0 represents the x coordinate of the dot’s position
; - delta represents the number of pixels the dot moves per tick
; - x-limit represents the end boundary for x0
;;------------------------------------------------------------------------------
; FUCNTIONS
;;------------------------------------------------------------------------------
; reddot: x0 delta x-limit -> x0 (World State)
; reddot: Shows the horizontal, rightward movement of a red dot
;         based on start and end specification.
 
(define (reddot x0 delta x-limit)
  (local (; Number -> Boolean
          ; Is x0 at it's limit?
          ; given 10 -> wanted (= 10 x-limit)
          (define (islimit? x0) (= x0 x-limit))
          ; Number -> Number
          ; Moves x0 by delta pixels.
          ; given 10 -> wanted 10+delta
          (define (adddelta x0) (+ x0 delta)))
    (big-bang x0
              [to-draw render]
              [on-tick adddelta] 
              [stop-when islimit?])))

; render: x0 -> Image
; render: Renders an image of a red dot at the given x coordinate.
(check-expect (render 0) (place-image dot 0 y-val CANVAS))
(check-expect (render 300) (place-image dot 300 y-val CANVAS))
(check-expect (render 500) (place-image dot 500 y-val CANVAS))

(define (render x0)
  (place-image dot x0 y-val CANVAS))

;;------------------------------------------------------------------------------
; PROBLEM SET 8A: EXERCISE 3
;;------------------------------------------------------------------------------
; DATA DEFINITIONS
;;------------------------------------------------------------------------------
; a [List-of X] is one of:
; - '()
; - (cons X [List-of X])
;;------------------------------------------------------------------------------
; replace: [List-of Number] Number -> [List-of Number]
; replace: Replaces all 0s in the list with two occurrences of n.
;          Keeps non-zero entries the same.
(check-expect (replace '( 4 2 0) 1) '(4 2 1 1))
(check-expect (replace '( 4 2 0 6) 6) '(4 2 6 6 6))
(check-expect (replace '( 0 0 0) 0) '(0 0 0 0 0 0)) 

(define (replace lon n)
  (local ((define num n)
          ; [List-of Number] -> [List-of Number]
          ; Every zero entry becomes two zero entries.
          ; given (list 1 2 3 0 5) -> want (list 1 2 3 0 0 5)
          (define (change-list lon)
            (cond
             [(empty? lon)'()]
             [else
              (if (zero? (first lon))
                  (cons (first lon) (cons (first lon) (change-list (rest lon))))
                  (cons(first lon)(change-list (rest lon))))]))
          (define new-list (change-list lon))
          ; Number -> Number
          ; Changes a zero to a given number. If the number is not
          ; zero, it returns the original number.
          ; given 0 -> wanted num
          ; given 1 -> wanted 1
          (define  (helpreplace n)
                   (if (zero? n) num n)))
  (map helpreplace new-list)))
;;------------------------------------------------------------------------------