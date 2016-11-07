;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 4 Set A|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;; Constants
(define WIDTH 100)
(define HEIGHT 100)
(define CANVAS (empty-scene WIDTH HEIGHT))
(define the-code "abbccd")

(define (guess int)
  (big-bang int
            [on-key]
            [to-draw]



(define (on-key im str)
  (