;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 3 Set B|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;;Andrew Alcala  Rehab Asif

;; posn- : Posn Posn -> Posn
;; posn- - consumes two Posns and creates a new Posn whose x-coor is the difference between the first Posn's x-coor and second Posn's x-coor
;;         and whose y-coor is the difference between the first Posn's y-coor and second Posn's y-coor.

(define (posn- p q)
  (make-posn (- (posn-x p) (posn-x q)) (- (posn-y p) (posn-y q))))


;; posn-up-x : Posn Number -> Posn
;; posn-up-x - consumes a Posn and a number to create a new Posn whose x-coor is the consumed Number and whose y-coor is the consumed Posn's y-coor.

(define (posn-up-x p n)
  (make-posn n (posn-y p)))



;; TESTS

(check-expect (posn- (make-posn 3 4) (make-posn 9 1)) (make-posn -6 3))
(check-expect (posn-up-x (make-posn 7 3) 23) (make-posn 23 3))