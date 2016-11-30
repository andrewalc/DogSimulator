;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-lambda-reader.ss" "lang")((modname |Week 13 Set C|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; [NEList-of 1String] -> [NEList-of 1String]
; create a palindrome from s0
(check-expect
  (palindrome (explode "abc")) (explode "abcba"))
(check-expect
 (palindrome (explode "yeet")) (explode "yeeteey"))
(check-expect
 (attempt2 (explode "1234567890")) (explode "1234567890987654321"))
(define (palindrome s0)
  (local ((define (constructor s0 acc func)
            (cond [(= acc -1) '()]
                  [(= acc (- (length s0) 1)) (cons (list-ref s0 (- (length s0) 1)) (constructor s0 (sub1 acc) sub1))]
                  [else (cons (list-ref s0 acc) (constructor s0 (func acc) func))])))
    (constructor s0 0 add1)))

;; [NEList-of 1String] -> [NEList-of 1String]
; create a palindrome from s0
(check-expect
  (attempt2 (explode "abc")) (explode "abcba"))
(check-expect
 (attempt2 (explode "yeet")) (explode "yeeteey"))
(check-expect
 (attempt2 (explode "1234567890")) (explode "1234567890987654321"))
(define (attempt2 s0)
  (local ((define (constructor s0 acc)
            (cond [(= acc 0) `(,(first s0))]
                  [else `(,(first s0) ,@(constructor (rest s0) (sub1 acc)) ,(first s0)) ])))
    (constructor s0 (sub1 (length s0)))))