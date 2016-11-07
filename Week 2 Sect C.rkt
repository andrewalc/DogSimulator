;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 2 Sect C|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;;Exercise 4

;; DATA DEF:
;; World State = t (time)
;; typewriter : t -> text
;; typewriter - consumes in initial time and produces one character from "qwerty" per second beginning from "" and advancing to "q" and so on.

(define (typewriter t)
  (big-bang t
            [on-tick changest 1]
            [to-draw show]))

;; changest : t -> t
;; changest - takes in the current time and returns the next time (tick) once per second.
(define (changest t)
         (+ t 1))

;; show : t -> text
;; show - takes in the current time and displays a substring of "qwerty" from indexes 0 to t. Should t be greater than 6, "qwerty" is displayed. 
(define (show t)
  (if (> t 6) (overlay (text "qwerty" 22 "black") (empty-scene 1000 200)) (overlay (text (substring "qwerty" 0 t) 22 "black") (empty-scene 1000 200))))


;;TESTS
(check-expect (changest 4) 5)
(check-expect (changest 0) 1)
(check-expect (show 3) (overlay (text "qwe" 22 "black") (empty-scene 1000 200)))
(check-expect (show 999) (overlay (text "qwerty" 22 "black") (empty-scene 1000 200)))
;;*************************************************************************************************************************************************************

;;Exercise 5

;; DATA DEF
;; World State = str (String)
;; backspace : str -> text
;; backspace - consumes a given string and displays it's text, removing one character from the end every second.
(define (backspace str)
  (big-bang str
            [to-draw show2]
            [on-tick minus 1]
            [stop-when iszero]))

;; minus : str -> str
;; minus - consumes a given string and returns a copy of the original string, removing the last chracter of the original string.
(define (minus str)
  (substring str 0 (- (string-length str) 1)))

;; show2 - takes in a given string and displays the string as text.
;; show2 : str -> text
(define (show2 str)
  (overlay (text str 22 "black") (empty-scene 1000 300)))

;; iszero - checks whether the current string has a string length of zero and returns a boolean. Is used to stop big-bang.
;; iszero : str -> boolean
(define (iszero str)
  (= (string-length str) 0))

;;TESTS
(check-expect (backspace "hello") "")
(check-expect (backspace "abcdefghijklmnopqrstuvwxyz") "")
(check-expect (minus "test") "tes")
(check-expect (show2 "test") (overlay (text "test" 22 "black") (empty-scene 1000 300)))
(check-expect (iszero "not zero") #false)
(check-expect (iszero "") #true)
