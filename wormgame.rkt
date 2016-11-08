;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname wormgame) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
(require 2htdp/image)
(require 2htdp/universe)
; Andrew Alcala alcala.a@husky.neu.edu
;-------------------------------------------------------------------------------
; Worm Game
;-------------------------------------------------------------------------------
; CONSTANTS:
;-------------------------------------------------------------------------------
(define HEIGHT 500)
(define WIDTH 500)
(define w-unit 10)
(define w-seg (rectangle w-unit w-unit "solid" "red"))
(define scene (empty-scene HEIGHT WIDTH))

;-------------------------------------------------------------------------------
; DATA DEFINITIONS:
;-------------------------------------------------------------------------------

; A [List of X] is one of:
; '()
; (cons X [List-of X])

;; A Worm is a (make-worm Number Posn Direction)
(define-struct worm [tail pos dir])
;; tail is a Number representing the number of worm units the worm is made of
;; pos is a posn where the x-val and y-val
;; are numbers representing the x-coord and y-ccord respectively
;; dir is a Direction representing the worms movement direction

;; Initial Worm:
(define init-worm (make-worm 0 (make-posn (/ HEIGHT 2) (/ WIDTH 2)) "right"))

;; A Direction is a member of:
(define directions '("up" "down" "left" "right"))

;-------------------------------------------------------------------------------
; FUNCTIONS:
;-------------------------------------------------------------------------------
;; worm-game: Number -> Worm
;; worm-game: Worm: a game based on the game Snake
(define (worm-game t)
  (big-bang init-worm
            [to-draw render]
            [on-key keypress]
            [on-tick move t]
            [stop-when gameover lose]))

;; render: Worm -> Image
;; render: Renders a worm on the screen
(define (render w)
  (local ((define w-tail         (worm-tail wm))
          (define x-pos          (posn-x (worm-pos wm)))
          (define y-pos          (posn-y (worm-pos wm)))
          (define w-dir          (worm-dir w))
          (define (create-worm wm)
             (place-image w-seg x-pos y-pos scene))
    (create-worm w))))

;; move: Worm -> Worm
;; move: Changes the worm's position everytick, depending on Worm's direction
(define (move w)
  (local ((define w-tail         (worm-tail w))
          (define x-pos          (posn-x (worm-pos w)))
          (define y-pos          (posn-y (worm-pos w)))
          (define w-dir          (worm-dir w))
          (define (dir? str dir) (string=? str dir))
          (define (up? str)      (dir? str "up"))
          (define (down? str)    (dir? str "down"))
          (define (left? str)    (dir? str "left"))
          (define (right? str)   (dir? str "right")))
    (cond [(up? w-dir)
           (make-worm w-tail (make-posn x-pos (- y-pos w-unit)) w-dir)]
          [(down? w-dir)
           (make-worm w-tail (make-posn x-pos (+ y-pos w-unit)) w-dir)]
          [(left? w-dir)
           (make-worm w-tail (make-posn (- x-pos w-unit) y-pos) w-dir)]
          [(right? w-dir)
           (make-worm w-tail (make-posn (+ x-pos w-unit) y-pos) w-dir)])))

;; keypress: Worm KeyEvent -> Worm
;; keypress: Changes given Worm's direction to the respective arrow key pressed
(define (keypress w key)
  (local ((define x-pos (posn-x (worm-pos w)))
          (define y-pos (posn-y (worm-pos w)))  )
    (cond [(member? key directions)
           (make-worm (worm-tail w) (make-posn x-pos y-pos) key)])))

(define (gameover w)
  (local ((define x-pos          (posn-x (worm-pos w)))
          (define y-pos          (posn-y (worm-pos w))))
    (or (or (> x-pos WIDTH) (< x-pos 0)) (or (> y-pos HEIGHT) (< y-pos 0)))))

(define (lose w)
  (overlay (text "You Lose" 20 "red") scene))


;-------------------------------------------------------------------------------
