;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-reader.ss" "lang")((modname |Week 4 Set B|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
;; Andrew Alcala Rehab Asif

;; decode: str --> Posn
;; decode: Consumes a string and produces Posn whose x coordinate is the first 1String of s and whose y coordinate is the rest of the string.
;;         If the given string is "", decode signals the error "decode: bad string given".

(define (decode s)
  (if (string=? s "")
      (error 'decode "bad string given") (make-posn (substring s 0 1) (substring s 1 (string-length s)))))


;;TESTS
(check-expect (decode "hello") (make-posn "h" "ello"))
(check-expect (decode "a") (make-posn "a" ""))
(check-expect (decode "") (error 'decode "bad string given"))