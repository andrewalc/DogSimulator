;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname DogSimulator) (read-case-sensitive #t) (teachpacks ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "image.rkt" "teachpack" "2htdp") (lib "universe.rkt" "teachpack" "2htdp")) #f)))
;; Andrew Alcala

;;------------------------------------------------------------------------------
;; DATA DEFINTIONS:
;;------------------------------------------------------------------------------
;; A Dog is a (make-dog Number String State Number)
(define-struct Dog (age name state hp hunger))
;; INTERPRETATION:
;; - age is the Dog's age
;; - name is the Dog's name
;; - state is the current State the Dog is in
;; - hp is the Dog's current health
;; - hunger is the Dog's current hunger

;; a State is a member of:
(define LoStates
  (list
   "Sleeping"
   "Idle"
   "Eating"
   "Sitting"
   "Running"
   "Barking"
   "Listening"
   "Dead"))
;;------------------------------------------------------------------------------
;; CONSTANTS:
;;------------------------------------------------------------------------------
(define WIDTH 700)
(define HEIGHT 400)
(define randvar 4)
(define maxhp 10)
(define maxhunger 10)
(define CANVAS (empty-scene WIDTH HEIGHT))

;;IMAGES
(define d-sleeping (bitmap/file "resources/sleeping.png"))
(define d-idle (bitmap/file "resources/idle.png"))
(define d-dead (bitmap/file "resources/dead.png"))
(define d-eating (bitmap/file "resources/eating.png"))

;;------------------------------------------------------------------------------
;; FUNCTIONS:
;;------------------------------------------------------------------------------

;; DogSimulator: Number String -> Dog
;; DogSimulator: Simulates the life of a Dog.

(define (DogSimulator age name)
  (big-bang (make-Dog age name "Sleeping" maxhp maxhunger)
            [on-key active]
            [to-draw render]))

;; render: Dog -> Image
;; render: Produces an Image of the Dog
(define (render d)
  
  (local ((define age (Dog-age d))
          (define name (Dog-name d))
          (define state (Dog-state d))
          (define hp (Dog-hp d))
          (define hunger (Dog-hunger d))
          (define Name-is-currently-State
            (string-append name " is currently " state))
          (define hp/maxhp
            (string-append "HP: "
                           (number->string hp)
                           "/"
                           (number->string maxhp )))
          (define hg/maxhg
            (string-append "Hunger: "
                           (number->string hunger)
                           "/"
                           (number->string maxhunger ))))
    
  (above (text "Welcome to Dog Simulator!" 35  "black" )
         (above
          (place-image (state-image d) (/ WIDTH 2) (/ HEIGHT 2) CANVAS)
          (above (text Name-is-currently-State 25 (state-color-assc state))
                (beside
                 (text hp/maxhp 25  "red" )
                 (text "     " 25  "black")
                 (text hg/maxhg 25  "blue" )))))))


;; state-color-assc: State -> Color
;; state-color-assc: Returns a Color string depending on the Dog's state
(define (state-color-assc s)
  (cond
    [(dead? s) "red"]
    [else "black"]))


;; state-image: Dog -> Image
;; state-image: Uses a Dog's state to determine what image to return
(define (state-image d)
  
 (local ((define state (Dog-state d)))
   
  (cond
    [(sleeping? state) d-sleeping]
    [(idle? state) d-idle]
    [(dead? state) d-dead]
    [(eating? state) d-eating])))

;; active: Dog -> Dog
;; active: Randomly selects the Dog's next State lower's the on keypress and
;;         lowers the Dog's hp by one every keypress.
(define (active d key)
  
  (local ( (define age (Dog-age d))
           (define name (Dog-name d))
           (define state (Dog-state d))
           (define hp (Dog-hp d))
           (define hunger (Dog-hunger d))
           (define random-state (random-state-select (random randvar))))
    
  (cond
  [(and (<= hp 1) (not (sleeping? state)))
   (make-Dog age name "Dead" 0 0)]
  [(and (sleeping? state) (< hp maxhp) (>= hunger (/ maxhunger 2)))
   (make-Dog age name random-state (add1 hp) hunger)]
  [(and (idle? state) (> hunger 0))
   (make-Dog age name random-state hp (sub1 hunger))]
  [(and (eating? state) (< hunger maxhunger))
   (make-Dog age name random-state hp (add1 hunger))]
  [(< hunger 1)
   (make-Dog age name random-state (sub1 hp) hunger)]

  [else
   (make-Dog age name random-state hp hunger)])))


;; isState?: State State -> Boolean
;; isState?: Is the given State this State?
(define (isState? given wanted)
  (string=? given wanted))

(define (idle? state)
  (isState? state "Idle"))

(define (sleeping? state)
  (isState? state "Sleeping"))

(define (eating? state)
  (isState? state "Eating"))

(define (dead? state)
  (isState? state "Dead"))



;; random-state-select: Number -> State
;; random-state-select: Selects a State given a random number.
(define (random-state-select n)
  (cond
    [(or (= n 0) (= n 1)) "Sleeping"]
    [(or (= n 2) (= n 4)) "Idle"]
    [(= n 3) "Eating"]))

