;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 10 Set A|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
; Andrew Alcala: alcala.a@husky.neu.edu
; Jeff Champion: champion.j@husky.neu.edu
;-------------------------------------------------------------------------------
; PROBLEM SET 10 A
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

; A PD* (short for picture description) is one of:
; – 'empty-image 
; – String 
; – (list 'circle Number String String)
; – (list 'rectangle Number Number String String)
; – (list 'beside LPD*)
; – (list 'above LPD*)
;

; Template:
#;(define (pd*-temp pd)
    (cond
      [(empty-image? pd) ...]
      [(string? pd) ...]
      [(circle? pd) ...]
      [(rectangle? pd) ...]
      [(beside? pd) (lpd*-temp pd)]
      [(above? pd) (lpd*-temp pd)]))

; Examples:
(define pd1 'empty-image)
(define pd2 "Shrimp")
(define pd3 (list 'circle 30 "solid" "blue"))
(define pd4 (list 'rectangle 100 200 "solid" "red"))
(define pd5 (list 'above (list pd2 pd3)))
(define pd6 (list 'beside (list pd5 pd2)))


; An LPD* is one of: 
; – '()
; – (cons PD* LPD*)

; Template:
#; (define (lpd*-temp lpd)
     (cond [(empty? lpd) ...]
           [else ... (first lpd) ... (rest lpd) ...]))
;-------------------------------------------------------------------------------
; FUNCTIONS
;-------------------------------------------------------------------------------

;; pd*-interpret: PD* -> Image
;; pd*-interpret: Consumes a PD* and produces the corresponding image

(check-expect (pd*-interpret pd1 ) empty-image)
(check-expect (pd*-interpret pd2) (text "Shrimp" 12 "blue"))
(check-expect (pd*-interpret pd3) (circle 30 "solid" "blue"))
(check-expect (pd*-interpret pd4) (rectangle 100 200 "solid" "red"))

(define (pd*-interpret pd)
  (cond [(empty-image? pd) empty-image]
        [(string? pd) (text pd 12 "blue")]
        [(circle? pd)
         (circle (circle-radius pd) (circle-mode pd) (circle-color pd))]
        [(rectangle? pd)
         (rectangle (rectangle-width pd) (rectangle-height pd)
                    (rectangle-mode pd) (rectangle-color pd))]
        [(beside? pd) (lpd*-builder (second pd) beside)]
        [(above? pd) (lpd*-builder (second pd) above)]))

(check-expect (pd*-interpret
               (list 'beside
                     (cons pd2
                           (cons pd3
                                 (cons pd4 '())))))
              (beside (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))

(check-expect (pd*-interpret
               (list 'above
                     (cons pd2
                           (cons pd3
                                 (cons pd4 '())))))
              (above  (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))

;; lpd*-builder: LPD* Beside or Above -> Image
;; lpd*-builder: Interprets the last two cases of a PD* using a given function

(define (lpd*-builder lpd func)
  (cond [(empty? lpd) empty-image]
        [else (func (pd*-interpret (first lpd))
                    (lpd*-builder (rest lpd) func))]))
(check-expect (lpd*-builder '() above) empty-image)
(check-expect (lpd*-builder '() beside) empty-image)
(check-expect (lpd*-builder (cons pd2
                            (cons pd3
                            (cons pd4 '()))) above)
              (above  (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))
(check-expect (lpd*-builder (cons pd2
                            (cons pd3
                            (cons pd4 '()))) beside)
              (beside  (text "Shrimp" 12 "blue")
                      (circle 30 "solid" "blue")
                      (rectangle 100 200 "solid" "red")))

;-------------------------------------------------------------------------------