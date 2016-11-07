;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 4 Set C|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
(define red (rectangle 600 300 "solid" "red"))
(define green (rectangle 600 300 "solid" "green"))
(define blue (rectangle 600 300 "solid" "blue"))
(define yellow (rectangle 600 300 "solid" "yellow"))
(define (du alos)
  (cond
    [(empty? alos) 0]
    [else (+ (du (rest alos)) (string-length (first alos)))]))

(define (assemble aloi)
  (cond
    [(empty? aloi) (empty-scene 0 0)]
    [else (above (first aloi) (assemble (rest aloi)))]))



;;TESTS

(define names
  (cons "Fagan"
    (cons "Findler"
      (cons "Fisler"
        (cons "Flanagan"
          (cons "Flatt"
            (cons "Felleisen"
              (cons "Friedman" '()))))))))

(define images
  (cons red
    (cons green
      (cons blue
        (cons yellow '())))))

