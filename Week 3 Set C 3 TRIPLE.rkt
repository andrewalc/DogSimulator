;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 3 Set C 3 TRIPLE|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
(define WIDTH 1000)
(define HEIGHT 1000)
(define CANVAS (rectangle WIDTH HEIGHT "solid" "white"))
(define the-server "dictionary.ccs.neu.edu")
(define the-port   10008)

;;DATA DEF
;; World State -> quads
;;

;; (make-triple x y str)
  


(define-struct triple (x y im))
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
  (make-triple str1 "" CANVAS))

(define (receive t str2)
  (make-triple (triple-x t) str2 (triple-im t )))

(define (show f)
  (place-image/align (text (triple-y f) 22 "black") (/ WIDTH 2)  (/ HEIGHT 2) "center" "center"
                      (place-image/align (text (triple-x f) 22 "black") (/ WIDTH 2)  (+ (/ HEIGHT 2) 60) "center" "center"
                                         (place-image/align (triple-im f) (/ WIDTH 2)  (- (/ HEIGHT 2) 40) "center" "center" CANVAS))))

(define  (keypress t key)
  (cond
    [(string=? key "\r") (make-package (make-triple "" (triple-x t) (place-image/align (text (triple-y t) 22 "black") (/ WIDTH 2)  (/ HEIGHT 2) "center" "center"
                      (place-image/align (triple-im t) (/ WIDTH 2)  (- (/ HEIGHT 2) 40) "center" "center"
                     CANVAS))) (triple-x t))]
    [else (make-triple (string-append (triple-x t) key) (triple-y t) (triple-im t))]))