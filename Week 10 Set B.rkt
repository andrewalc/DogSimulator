;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 10 Set B|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
; Andrew Alcala alcala.a@husky.neu.edu
; Jeffrey Champion champion.j@husky.neu.edu
;-------------------------------------------------------------------------------
; PROBLEM SET 10 B
;-------------------------------------------------------------------------------
; DATA DEFINITIONS:
;-------------------------------------------------------------------------------
; A [List of X] is one of:
; '()
; (cons X [List-of X])
;-------------------------------------------------------------------------------
; FUNCTIONS:
;-------------------------------------------------------------------------------

;; string-split: String -> [List-of String]
;; string-split: Consumes a String and produces the list of its words
(check-expect (string-split "") '())
(check-expect (string-split "Hello World")
              (list "Hello" "World"))
(check-expect (string-split " Hello      to       Everyone ")
              (list "Hello" "to" "Everyone"))
(check-expect (string-split "  Hello      to       Everyone")
              (list "Hello" "to" "Everyone"))
(check-expect (string-split "  Hello      to       Ever\tyone")
              (list "Hello" "to" "Ever" "yone"))
(check-expect (string-split "  Hello     fj   \t\t\t to       Ever\tyone")
              (list "Hello" "fj" "to" "Ever" "yone"))
(check-expect (string-split "burn somethin', female dog.")
              (list "burn" "somethin'," "female" "dog."))

;; string-split:
;; string-split:
(define (string-split str)
  (map implode (break-list (explode str) #t)))


(define (break-list los veryfirst?)
  (local (; String -> Boolean
          ; Returns true if str is not " " or "\t"
          (define (letter? str)
            (not (or (string=? str " ")
                     (string=? str "\t"))))
          ; [List-of String] -> [List-of String]
          ; Makes a word given a list of 1strings
          (define (make-word los)
            (cond
              [(empty? los) '()]
              [else (if (letter? (first los))
                        (cons (first los) (make-word (rest los)))
                        '())])))
    (cond [(empty? los) '()]
          [else (if(and (letter? (first los)) veryfirst?)
                   (cons (make-word  los) (break-list (rest los) #f))
                    (if(and (> (length los) 1) (not (letter? (first los))) (letter? (second los)))
                       (cons (make-word (rest los)) (break-list (rest los) #f))
                           (break-list (rest los) #f)))])))
