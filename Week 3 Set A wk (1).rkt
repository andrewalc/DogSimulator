;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 3 Set A wk (1)|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;;Andrew Alcala Rehab Asif

;; Constants
(define WIDTH 600)
(define HEIGHT 50)
(define canvas (rectangle WIDTH HEIGHT "solid" "white"))

;; DATA DEF
;; World State = OST (On Screen Text)

;; stacked : str -> OST
;; stacked - consumes a SINGLE alphabetical or numeric character string and will display it as text. Any key presses after initialization will add the respective character pressed as text
;;           to the front of the on-screen text. After 5 inputted characters, the furthest text character is dropped.

(define (stacked str)
  (big-bang (textcv str)
            [to-draw show]
            [on-key keypress]))

;; notan : str -> boolean
;; notan - checks whether a string is not alphabetical or numeric through various cases.

(define (notan str)
      (or (string=? str "shift") (string=? str "rshift") (string=? str "control") (string=? str "rcontrol") (string=? str "menu") (string=? str "escape") (string=? str "insert") (string=? str "home") (string=? str "prior")
         (string=? str "next") (string=? str "next") (string=? str "end") (string=? str "up") (string=? str "down") (string=? str "left") (string=? str "right") (string=? str "numlock") (string=? str "add")
         (string=? str "subtract") (string=? str "multiply") (string=? str "divide") (string=? str "pause") (string=? str "scroll") (string=? str "clear") (string=? str "decimal")))


;; textcv : str -> OST
;; textsv - consumes the stacked function's inputting string and converts to a text image. If given a non-numeric or alphabetic character, resulting OST represents a blank space. 

(define (textcv str)
  (cond
    [(notan str) (text " " 50 "black")]
    [(or (string-numeric? str)(string-alphabetic? str)) (text str 50 "black")]
    [else (text " " 50 "black")]))

;; show : OST -> OST
;; show - consumes the current Screen Text and places a cut-off rectangle to limit on-screen visibility to 5 characters. 

(define (show OST)
  (overlay (place-image/align (rectangle 126 50 "solid" "white") 545 25 "center" "center" OST) canvas))

;; keypress: : OST -> OST
;; keypress - creates a new text image of the respective key pressed. The new text image is placed in the center of the canvas and shifts any previous On Screen Text 40 pixels
;; to the right. 
(define (keypress OST str)
      (place-image/align (textcv str) (/ WIDTH 2) (/ HEIGHT 2) "center" "center"
                         (place-image/align OST (+ (/ WIDTH 2) 40) (/ HEIGHT 2) "center" "center" canvas)))


;;Tests
(check-expect (textcv "s") (text "s" 50 "black"))

(check-expect (textcv "") (text "" 50 "black"))

(check-expect (show (text "s" 50 "black"))  (overlay (place-image/align (rectangle 126 50 "solid" "white") 545 25 "center" "center" (text "s" 50 "black")) canvas))

(check-expect (keypress (overlay (place-image/align (rectangle 126 50 "solid" "white") 545 25 "center" "center" (text "s" 50 "black")) canvas) "k")
              (place-image/align (textcv "k") (/ WIDTH 2) (/ HEIGHT 2) "center" "center"
                     (place-image/align (overlay (place-image/align (rectangle 126 50 "solid" "white") 545 25 "center" "center" (text "s" 50 "black")) canvas)
                                        (+ (/ WIDTH 2) 40) (/ HEIGHT 2) "center" "center" canvas)))