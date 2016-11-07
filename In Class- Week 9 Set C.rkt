;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |In Class- Week 9 Set C|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
; An Sexpr is one  of:
; - Symbol
; - Lexpr

;;An Lexpr is one of:
; - '()
; - (cons Sexpr Lexpr)

; Path is [Listof N]
; Interpretation: a path navigates to a particular part of an S-expression

(define s1 '((b) ((a)) c))
(define p1 '(1 0 0))

(define s2 '((b) ((e a)) c))
(define p2 '(1 0 1))

;; Sexpr Symbol -> [Maybe Path]
;; determine a path from the 'root' of Sexpr to the leftmost (outermost)
;; occurence of n in s0; return #false if n does not occur in s0
(check-expect (find-path 'a 'a) '())
(check-expect (find-path s1 'a) p1)

(define (find-path s0 n)
  (local (;; Sexpr -> [Maybe Path]
          ;; find a path to n within an Sexpr
          (define (secpr-find s)
            (cond [(symbol? s) (if (symbol=? n s) '() #false)]
                  [else (lexpr-fins s)]))
          ;;Lexpr -> [Maybe Path]
          ;; find a path to n within an Lexpr
          (define (lexpr-find l)
            (cond [(empty? l) #false]
                  [else (... (sexpr-find (first l)) (lexpr-find (rest l)) ... )]))))
  (sexpr-find s0))

;; pick-answer: [Maybe Path] [Maybe Path] -> [Maybe Path]
;; select the first good answerand add the missing path info
(check-expect (pick-answer #false #false) #false)
(check-expect (pick-answer '() '()) '(0))
(check-expect (pick-answer '(1) #false) #false)
;; lexpr-find must return [Maybe [NEList N]]
 