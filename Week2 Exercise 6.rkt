;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week2 Exercise 6|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "htdp")) #f)))
(define (ticket sp lim)
  (cond
    ((< sp lim) "fine")
    ((<= (- sp lim) 5) "danger")
    ((> sp (+ lim 5)) (string-append "you drove " (number->string sp) " mph"))))
