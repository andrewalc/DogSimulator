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

(define (string-split str)
  (local (; String -> Boolean
          ; Returns true if str is not " " or "\t"
          (define (letter? str)
            (not (or (string=? str " ")
                     (string=? str "\t"))))
          ; [List-of String] -> [List-of String]
          ; Makes a word given a list of 1strings
          (define (make-word los)
            (cond [(empty? los) '()]
                  [else (if (letter? (first los))
                            (cons (first los) (make-word (rest los)))
                            '())]))
          ; [List-of X] N -> [List-of X]
          ; Remove the first n items from l if possible or everything
          (define (drop l n)
            (cond [(zero? n) l]
                  [(empty? l) l]
                  [else (drop (rest l) (sub1 n))]))
          ;; break-list: [List-of String] -> [List-of [List-of String]]
          ;; break-list: Takes exploded string and breaks it into lists by word
          (define (break-list los)
            (local ((define after-word (drop los (length (make-word los)))))
              (cond [(empty? los) '()]
                    [else (if(letter? (first los))
                             (cons (make-word  los) (break-list after-word))
                             (break-list (rest los)))])))
          (define lolos (break-list (explode str))))
    (map implode lolos)))