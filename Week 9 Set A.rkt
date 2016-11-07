;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 9 Set A|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; Andrew Alcala: alcala.a@husky.neu.edu
; Jeff Champion: champion.j@husky.neu.edu
;-------------------------------------------------------------------------------
; PROBLEM SET 9 A
;-------------------------------------------------------------------------------
; SUPPLIED HELPER FUNCTIONS
;-------------------------------------------------------------------------------
 
(define circle-radius second)
(define circle-mode third)
(define circle-color fourth)
 
(define rectangle-width second)
(define rectangle-height third)
(define rectangle-mode fourth)
(define rectangle-color fifth)
 
(define above-top second)
(define above-bot third)
 
(define beside-left second)
(define beside-right third)

(define (empty-image? i) (symbol? i))
(define (circle? i) (and (cons? i) (symbol=? (first i) 'circle)))
(define (rectangle? i) (and (cons? i) (symbol=? (first i) 'rectangle)))
(define (above? i) (and (cons? i) (symbol=? (first i) 'above)))
(define (beside? i) (and (cons? i) (symbol=? (first i) 'beside)))

;-------------------------------------------------------------------------------
; DATA DEFINITIONS
;-------------------------------------------------------------------------------

; A PD (short for picture description) is one of:
; – 'empty-image 
; – String 
; – (list 'circle Number String String)
; – (list 'rectangle Number Number String String)
; – (list 'beside PD PD)
; – (list 'above PD PD)

; Examples:
(define pd1 'empty-image)
(define pd2 "Shrimp")
(define pd3 (list 'circle 30 "solid" "blue"))
(define pd4 (list 'rectangle 100 200 "solid" "red"))

;-------------------------------------------------------------------------------
; FUNCTION
;-------------------------------------------------------------------------------

;; pd-interpret: PD -> Image
;; pd-interpret: Consumes a PD and produces the corresponding image

(check-expect (pd-interpret pd1 ) empty-image)
(check-expect (pd-interpret pd2) (text "Shrimp" 12 "blue"))
(check-expect (pd-interpret pd3) (circle 30 "solid" "blue"))
(check-expect (pd-interpret pd4) (rectangle 100 200 "solid" "red"))

(define (pd-interpret pd)
  (cond
    [(empty-image? pd) empty-image]
    [(string? pd) (text pd 12 "blue")]
    [(circle? pd) (circle
                   (circle-radius pd) (circle-mode pd) (circle-color pd))]
    [(rectangle? pd) (rectangle
                      (rectangle-width pd) (rectangle-height pd)
                      (rectangle-mode pd) (rectangle-color pd))]
    [(beside? pd) (beside (pd-interpret (beside-left pd))
                          (pd-interpret (beside-right pd)))]
    [(above? pd) (above (pd-interpret (above-top pd))
                        (pd-interpret (above-bot pd)))]))


(check-expect (pd-interpret (list 'beside pd2 (list 'beside pd3 pd4)))
              (beside (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))
(check-expect (pd-interpret (list 'above pd2 (list 'above pd3 pd4)))
              (above  (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))

;-------------------------------------------------------------------------------