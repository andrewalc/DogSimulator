;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Week 6 Set C|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))

(require 2htdp/universe)
(require 2htdp/image)
;;------------------------------------------------------------------------------
;; Data Definitions
;;------------------------------------------------------------------------------

;; A SimulationState is a structure: 
;; (make-fs FSM FSM-State)
   (define-struct fs [fsm current])
;; INTERPRETATION: fsm is an FSM.
;;                 current is the current FSM-State.


;; A Transition is a structure:
;; (make-transition FSM-State FSM-State)
   (define-struct transition [current next])
;; INTERPRETATION: current is the current FSM-State.
;;                 next is what will be the next FSM-State.

;; FSM-State is a Color.

;; A Color is one of:
;; — "white"
;; — "yellow"
;; — "orange"
;; — "green"
;; — "red"
;; — "blue"
;; — "black"
;; — ...
;; Note: DrRacket recognizes many more strings as colors.

;; A FSM is one of:
;;   – '()
;;   – (cons Transition FSM)

;; INTERPRETATION: A FSM represents the transitions that a finite
;;                 state machine  can take from one state to another
;;                 in reaction to key strokes.

(define fsm-traffic
  (list (make-transition "red" "green")
        (make-transition "green" "yellow")
        (make-transition "yellow" "red")))

;;------------------------------------------------------------------------------
;; Functions
;;------------------------------------------------------------------------------
;; Exercise 227

;; simulate: FSM FSM-State -> SimulationState 
;; simulate: Match the keys pressed with the given FSM 
(define (simulate a-fsm s0)
  (big-bang (make-fs a-fsm s0)
    [to-draw state-as-colored-square]
    [on-key find-next-state]))


;; state-as-colored-square: SimulationState -> Image 
;; state-as-colored-square: Renders current world state as a colored square.
(define (state-as-colored-square a-fs)
  (square 100 "solid" (fs-current a-fs)))

(check-expect (state-as-colored-square
                (make-fs fsm-traffic "red"))
              (square 100 "solid" "red"))
(check-expect (state-as-colored-square
                (make-fs fsm-traffic "yellow"))
              (square 100 "solid" "yellow"))
(check-expect (state-as-colored-square
                (make-fs fsm-traffic "green"))
              (square 100 "solid" "green"))


;; find-next-state: SimulationState KeyEvent -> SimulationState
;; find-next-state: Finds the next state from ke and a-fs.
(define (find-next-state a-fs ke)
  (make-fs
    (fs-fsm a-fs)
    (find (fs-fsm a-fs) (fs-current a-fs))))

(check-expect
  (find-next-state (make-fs fsm-traffic "red") "n")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "red") "a")
  (make-fs fsm-traffic "green"))
(check-expect
  (find-next-state (make-fs fsm-traffic "green") "q")
  (make-fs fsm-traffic "yellow"))


;; find: FSM FSM-State -> FSM-State
;; find: Finds the state matching current in the table.
(define (find transitions current)
  (cond
    [(empty? transitions) (error "not found: " current)]
    [(state=? current (transition-current (first transitions)))
     (transition-next (first transitions))]
    [else (find (rest transitions) current)]))

(check-expect (find fsm-traffic "red") "green")
(check-expect (find fsm-traffic "green") "yellow")
(check-expect (find fsm-traffic "yellow") "red")
(check-error (find fsm-traffic "black") "not found: black")
;;------------------------------------------------------------------------------
;; Exercise 226

;; state?: FSM-State FSM-State -> Boolean
;; state?: Check whether two given FSM-States are the same
(define (state=? s1 s2)
  (cond
    [(string=? s1 s2) #true]
    [else #false]))

(check-expect (state=? "red" "red") #true)
(check-expect (state=? "green" "red") #false)
(check-expect (state=? "yellow" "red") #false)
;;------------------------------------------------------------------------------