;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 3 set A|) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
(define WIDTH 600)
(define HEIGHT 50)
(define (stacked str)
  (big-bang (textcv str)
            [to-draw show]
             [on-key keypress]))

(define (textcv str)
     (text str 50 "black") )

(define (show im)
  (overlay im (empty-scene 600 50)))

(define (keypress im str)
   (place-image/align im
                     100 0 "left" "top"
                      (overlay (textcv str)(empty-scene WIDTH HEIGHT) )))
            
