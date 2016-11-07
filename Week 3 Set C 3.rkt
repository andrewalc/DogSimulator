;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 3 Set C 3|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
(define WIDTH 1000)
(define HEIGHT 1000)
(define CANVAS (rectangle WIDTH HEIGHT "solid" "white"))
(define the-server "dictionary.ccs.neu.edu")
(define the-port   10008)

;;DATA DEF
;; World State -> quads
;;

;; (make-posn x y str)
  



(define (client str)
  (big-bang   (crpos str)
            [name       "asif.r:0679+alcala.a:5936"]
            [register   the-server]
            [port       the-port]
            [on-receive receive]
            [to-draw show]
            [on-key keypress]
            ))

(define (crpos str1)
  (make-posn str1 "" ))

(define (receive p str2)
  (make-posn (posn-x p) str2 ))

(define (show f)
  (place-image/align (text (posn-y f) 22 "black") (/ WIDTH 2)  (/ HEIGHT 2) "center" "center"
                      (place-image/align (text (posn-x f) 22 "black") (/ WIDTH 2)  (+ (/ HEIGHT 2) 40) "center" "center"
                     CANVAS)))

(define  (keypress p key)
  (cond
    [(string=? key "\r") (make-package (make-posn "" (posn-x p)) (posn-x p))]
    [else (make-posn (string-append (posn-x p) key) (posn-y p))]))

#;(or (string=? key "shift") (string=? key "rshift") (string=? key "control") (string=? key "rcontrol") (string=? key "menu") (string=? key "escape") (string=? key "insert") (string=? key "home") (string=? key "prior")
         (string=? key "next") (string=? key "next") (string=? key "end") (string=? key "up") (string=? key "down") (string=? key "left") (string=? key "right") (string=? key "numlock") (string=? key "add")
         (string=? key "subtract") (string=? key "multiply") (string=? key "divide") (string=? key "pause") (string=? key "scroll") (string=? key "clear") (string=? key "decimal"))