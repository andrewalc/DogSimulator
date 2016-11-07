;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Week 7 Set B|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require web-io)

;;------------------------------------------------------------------------------
; DATA DEFINITIONS:
;;------------------------------------------------------------------------------
; a [List-of X] is one of:
; - '()
; - (cons X [List-of X])


; a Ranking is one of:
; -(list Number String)
; INTERPRETATION:
; > Number represents a song's rank
; > String represents a song's artist/title


; a HTMLCell is a:
; `(td ,String)
; INTERPRETATION:
; > String represents a rank or song artist/title


; a HTMLRow is a:
; (cons 'tr [List-of HTMLCell])


; a HTMLRows is a:
; [List-of HTMLRow]


; a HTMLTable is a:
; (cons 'table(cons '((border String)) HTMLRows))
; INTERPRETATION:
; > String represents a numerical value for the table's border in html.


;;------------------------------------------------------------------------------
; CONSTANTS
;;------------------------------------------------------------------------------
(define one-list
  '("Asia: Heat of the Moment"
    "U2: One"
    "The White Stripes: Seven Nation Army"))

(define two-list
  '("50 Cent: In Da Club"
    "Beck: Dreams"
    "Slim Thug: Still Tipping"
    "D4NNY: Goodbye"
    "Slim Jesus: Drill Time"))

;;------------------------------------------------------------------------------
; FUNCTIONS:
;;------------------------------------------------------------------------------


; ranking: [List-of String] -> [List-of Ranking]
; ranking: Creates a list of rankings in numbered order.
(check-expect (ranking  '()) '())
(check-expect (ranking  one-list)
              '((1 "Asia: Heat of the Moment")
                (2 "U2: One")
                (3 "The White Stripes: Seven Nation Army")))
(check-expect (ranking  two-list)
              '((1 "50 Cent: In Da Club")
                (2 "Beck: Dreams")
                (3 "Slim Thug: Still Tipping")
                (4 "D4NNY: Goodbye")
                (5 "Slim Jesus: Drill Time")))

(define (ranking los)
  (reverse (add-ranks (reverse los))))


; add-ranks: [List-of String] -> [List-of Ranking]
; add-ranks: Adds ranks alongside Strings in the list
(check-expect (add-ranks one-list)
              '(( 3 "Asia: Heat of the Moment")
                ( 2 "U2: One")
                ( 1 "The White Stripes: Seven Nation Army")))
(check-expect (add-ranks two-list)
              '(( 5 "50 Cent: In Da Club")
                ( 4 "Beck: Dreams")
                ( 3 "Slim Thug: Still Tipping")
                ( 2 "D4NNY: Goodbye")
                ( 1 "Slim Jesus: Drill Time")))

(define (add-ranks los)
  (cond
    [(empty? los) '()]
    [else (cons (list (length los) (first los))
                (add-ranks (rest los)))]))

; make-cell: String -> HTMLCell
; make-cell: Creates a cell for an HTML table from a String.
(check-expect (make-cell "") `(td ""))
(check-expect (make-cell "hello") `(td "hello"))
(check-expect (make-cell "family") `(td "family"))


(define (make-cell str)
  `(td ,str))

; make-row: Ranking -> [List-of HTMLCell]
; make-row: Creates a row for an HTML table from a Ranking.
(check-expect (make-row (list 5 "50 Cent: In Da Club"))
              '((td "5") (td "50 Cent: In Da Club")))
(check-expect (make-row (list 2 "D4NNY: Goodbye"))
              `((td "2") (td "D4NNY: Goodbye")))

(define (make-row r)
  (cond
    [(empty? r) '()]
    [else (if (number? (first r))
              (cons (make-cell (number->string (first r))) (make-row (rest r)))
              (cons (make-cell (first r)) (make-row (rest r))))]))
 
; make-the-rows: [List-of Rankings] -> HTMLRows
; make-the-rows: Creates multiple rows for a table in html
(check-expect (make-the-rows (ranking one-list))
             `(( tr (td ,"1") (td ,"Asia: Heat of the Moment"))
               ( tr (td ,"2") (td "U2: One"))
               ( tr (td ,"3") (td "The White Stripes: Seven Nation Army"))))
(check-expect (make-the-rows (ranking two-list))
             `(( tr (td ,"1") (td "50 Cent: In Da Club"))
               ( tr (td ,"2") (td "Beck: Dreams"))
               ( tr (td ,"3") (td "Slim Thug: Still Tipping"))
               ( tr (td ,"4") (td "D4NNY: Goodbye"))
               ( tr (td ,"5") (td "Slim Jesus: Drill Time"))))

(define (make-the-rows lor)
    (cond
      [(empty?  lor) '()]
      [else (cons `(tr ,@(make-row (first lor))) (make-the-rows (rest lor)))]))


; make-ranking: [List-of Strings] -> HTMLTable
; make-ranking: Produces a html table of ranked Strings.
;               Each row represents a different ranking.
(define (make-ranking los)
`(table ((border "1"))
          ,@(make-the-rows (ranking los))))


(check-expect (make-ranking one-list)
`(table ((border "1"))
                   (tr (td "1") (td "Asia: Heat of the Moment"))
                   (tr (td "2") (td "U2: One"))
                   (tr (td "3") (td "The White Stripes: Seven Nation Army"))))
(check-expect (make-ranking two-list)
`(table ((border "1"))
                   ( tr (td "1") (td "50 Cent: In Da Club"))
                   ( tr (td "2") (td "Beck: Dreams"))
                   ( tr (td "3") (td "Slim Thug: Still Tipping"))
                   ( tr (td "4") (td "D4NNY: Goodbye"))
                   ( tr (td "5") (td "Slim Jesus: Drill Time"))))

;;------------------------------------------------------------------------------