;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-intermediate-reader.ss" "lang")((modname |Week 11 Set B|) (read-case-sensitive #t) (teachpacks ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp"))) (htdp-settings #(#t constructor repeating-decimal #f #t none #f ((lib "universe.rkt" "teachpack" "2htdp") (lib "image.rkt" "teachpack" "2htdp")) #f)))
(require 2htdp/universe)
(require 2htdp/image)
(require string-sexpr)

;;PROBLEM SET 8C

(define the-server "dictionary.ccs.neu.edu")
(define the-people "champion.j:5631+alcala.a:5936")
(define WIDTH 808)
(define HEIGHT 420)
(define X-OFFSET 2)
(define BG (empty-scene WIDTH HEIGHT))
(define FS 24)
(define URL-1 "http://simpleicon.com/wp-content/uploads/smile.png")
(define URL-2 "http://simpleicon.com/wp-content/uploads/wifi2.png")
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
;;Data Def: A [List-of X] is one of:
;; - empty
;; - (cons X [List-of X])

;;Data Def: A list-of-strings (los) is [List-of String]
;;Examples:
(define LOS-1 empty)
(define LOS-2 (cons "yo"(cons "shrimp"(cons "cup" empty))))
;;Template:
#;(define (los-template los)
    (cond
      [(empty? los)...]
      [else ...(first los)...(los-template(rest los))...]))

;; Data Def: A PD* (short for picture description) is one of:
;; – 'empty-image 
;; – String 
;; – (list 'circle Number String String)
;; – (list 'rectangle Number Number String String)
;; – (list 'beside LPD*)
;; – (list 'above LPD*)
;; Examples:
(define pd1 'empty-image)
(define pd2 "Shrimp")
(define pd3 (list 'circle 30 "solid" "blue"))
(define pd4 (list 'rectangle 100 200 "solid" "red"))
(define pd5 (list 'above (list pd2 pd3)))
(define pd6 (list 'beside (list pd5 pd2)))
;;Data Def: An LPD* is one of: 
;; – '()
;; – (cons PD* LPD*)

;;Data Def: A Command is one of:
;; - String
;; - (list "COLOR" String)
;; - (list "BLACKLIST" String)
;; - (list "WHITELIST" String)
;; - (list "URL" String String)
;; - (list "CODE" PD*)
;;Interpretation: When a client c:
;; connects ... the server broadcasts a join message for c
;; sends (list "COLOR" cs) ... the server sets c's color to cs
;; sends a String s ... the server broadcasts an ordinary message from
;; c with s split into words plus a color string cs
;; sends (list "BLACKLIST" n) ... the server blocks n from sending messages to c
;; disconnects ... the server broadcasts an exit message for c
;; sends (list "WHITELIST" n) ...
;; the server enables n to send emoticon settings to c
;; sends (list "URL" s u) ... broadcasts the message to all clients
;; that have whitelisted c
;; sends (list "CODE" PD*) ...
;; broadcasts a code message to all clients that have whitelisted C.
;;Examples:
(define COMMAND-1 "bruh")
(define COMMAND-2 (list "COLOR" "hello"))
(define COMMAND-3 (list "BLACKLIST" "Miguel"))
(define COMMAND-4 (list "WHITELIST" "shrimp"))
(define COMMAND-5 (list "URL" "family" "cup"))
(define COMMAND-6 (list "CODE" pd5))

;;Data Def: A Chat is one of:
;; - (list "MSG" String List-of-strings String)
;; - (list "JOIN" String)
;; - (list "EXIT" String)
;; - (list "ERROR" String)
;; - (list "EMOTICON" String String String)
;; - (list "ACCEPTED" "String")
;; - (list "CODE" String PD*)
;;Interpretation: When the server sends:
;; (list "MSG" p m cs) ... the client renders it as a
;; text image of the list of words m in color cs indicating that it came from p
;; (list "JOIN" p) ... the client renders it as a text image of p that tells
;; the user about the new participant
;; (list "EXIT" p) ... the client renders it as a text image of p that tells
;; the user about the departure of the participant
;; (list "ERROR" p) ...informs you that the client sent the server a bad message
;; (list "EMOTICON p word url) ... it must interpret all occurrences of word
;; in ordinary messages as the image specified in the link
;; (list "ACCEPTED" p) ... the client notifies the user that the user was
;; added to p's whitelist
;; (list "CODE" String PD*) ... code message
 
;;Examples:
(define CHAT-E
  (list "MSG" "champion.j+hoyt.j" (list "whats" "smile" "up" "wifi") "purple"))
(define CHAT-1
  (list "MSG" "champion.j+hoyt.j" (list "hello" "friends") "purple"))
(define CHAT-2 (list "JOIN" "champion.j+hoyt.j"))
(define CHAT-3 (list "EXIT" "champion.j+hoyt.j"))
(define CHAT-4 (list "ERROR" "invalid"))  
(define CHAT-5 (list "EMOTICON" "username" "word" URL-1))
(define CHAT-6 (list "ACCEPTED" "champion.j+hoyt.j"))
(define CHAT-7 (list "CODE" "username" pd5))

;;Data Def: A list-of-chats (loc) is [List-of Chat]
;;Examples:
(define LOC-1 empty)
(define LOC-2 (list CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E))
;;Template:
#;(define (loc-template loc)
    (cond
      [(empty? loc)...]
      [else ...(chat-temp(first loc))...(loc-template(rest loc))...]))

;;Data Def: A Conversation (convo) is (cons String [List-of Chat])
;;Examples:
(define CONVO-1 (cons "" LOC-1))
(define CONVO-2 (cons "shrimp" LOC-2))

;;Data Def: An Emote is a (list String URL)
;;Interpretation: a URL is a String
;;Examples:
(define EMOTE-1 (list "smile" URL-1))
(define EMOTE-2 (list "wifi" URL-2))

;;Data Def: A list-of-emotes (loe) is [List-of Emote]
;;Examples:
(define LOE-1 empty)
(define LOE-2 (list EMOTE-1 EMOTE-2))

;;Data Def: A Port is one of:
;; - 10001
;; - 10002
;; - 10003
;; - 10004
;; - 10005
;; - 10006
;; - 10007
;; - 10008
;; - 10009
;; - 10010
;;Interpretation: the ports provided by the server
;;Example:
(define PORTARTHUR 10004)

;;Data Def:
(define-struct cr [convo emotes])
;; A Chatroom (cr) is (make-cr convo loe)
;;Interpretation: in (make-cr convo loe)
;;convo is the current conversation and loe is the current list of emotes
;;Example:
(define CR-1 (make-cr CONVO-1 LOE-1))
(define CR-2 (make-cr CONVO-2 LOE-2))
;-------------------------------------------------------------------------------
;;Signature: Port -> Chatroom (World State)
;;Purpose: given a port, client communicates with a chat server by
;;sending/receiving Commands/Chats to/from the chatroom. Client shows
;;the conversation in the chatroom as text and images.

(define (client a-port)
  (big-bang CR-1
    [name       the-people]
    [register   the-server]
    [port       a-port]
    [to-draw    show-cr]
    [on-receive receive-chat]
    [on-key     send-chat]))

;;Signature: Chatroom -> Image
;;Purpose: using assemble-chat, this function mounts the created image
;;of the chat on a white background in the bottom left corner.
(check-expect (show-cr CR-1)BG)

(define (show-cr cr)
  (place-image/align (assemble-cr cr) X-OFFSET HEIGHT "left" "bottom" BG))

(check-expect (show-cr CR-2)(place-image/align
 (above/align "left"
  (beside (text "champion.j+hoyt.j: " FS "purple")
          (text "whats " FS "purple")
          (bitmap/url URL-1)
          (text "up " FS "purple")
          (bitmap/url URL-2))
  (text "word has been set to an emote by username" FS "purple")
  (text "ERROR: invalid" FS "red")
  (text "champion.j+hoyt.j dipped." FS "purple")
  (text "champion.j+hoyt.j came through." FS "purple")
  (text "champion.j+hoyt.j: hello friends" FS "purple")
  (text "shrimp" FS "purple"))
              X-OFFSET HEIGHT "left" "bottom" BG))

;;Signature: Chatroom -> Image
;;Purpose: to show the current chatroom as an image
(check-expect (assemble-cr CR-1)
              (above/align "left" (text "" FS "purple") empty-image))

(define (assemble-cr cr)
  (local[(define (ftge im1 im2) (above/align "left" im1 im2))
         (define (ftge2 chatorstr) (chat-to-text chatorstr (cr-emotes cr)))]
    (foldl ftge empty-image (map ftge2 (cr-convo cr)))))

(check-expect (assemble-cr CR-2)
 (above/align "left"
  (beside (text "champion.j+hoyt.j: " FS "purple")
          (text "whats " FS "purple")
          (bitmap/url URL-1)
          (text "up " FS "purple")
          (bitmap/url URL-2))
  (text "word has been set to an emote by username" FS "purple")
  (text "ERROR: invalid" FS "red")
  (text "champion.j+hoyt.j dipped." FS "purple")
  (text "champion.j+hoyt.j came through." FS "purple")
  (text "champion.j+hoyt.j: hello friends" FS "purple")
  (text "shrimp" FS "purple")))

;;Signature: Chat or String List-of-emotes -> Image
;;Purpose: to convert a chat into a corresponding text/image or
;;displays the given string (editted by the user) as text.
(check-expect(chat-to-text CHAT-1 LOE-2)
             (text "champion.j+hoyt.j: hello friends " FS "purple"))
(check-expect(chat-to-text CHAT-2 LOE-2)
             (text "champion.j+hoyt.j came through." FS "purple"))
(check-expect(chat-to-text CHAT-3 LOE-2)
             (text "champion.j+hoyt.j dipped." FS "purple"))
(check-expect(chat-to-text CHAT-4 LOE-2)
             (text "ERROR: invalid" FS "red"))
(check-expect(chat-to-text CHAT-5 LOE-2)
             (text "word has been set to an emote by username" FS "purple"))
(check-expect(chat-to-text CHAT-6 LOE-2)
             (text "champion.j+hoyt.j whitelisted you." FS "purple"))
(check-expect(chat-to-text "lean" LOE-2)(text "lean" FS "purple"))
(check-expect(chat-to-text CHAT-7 LOE-2)
             (beside(text "username: " FS "purple")(pd*-interpret pd5)))
                                               

(define (chat-to-text chatorstr loe)
  (cond
    [(string? chatorstr)(text chatorstr FS "purple")]
    [(string=? (first chatorstr) "MSG")
     (beside
     (text(string-append (second chatorstr) ": ")FS (last chatorstr))
     (message-with-emotes (third chatorstr) loe))]
    [(string=? (first chatorstr) "JOIN")
     (text(string-append (second chatorstr) " came through.") FS "purple")]
    [(string=? (first chatorstr) "EXIT")
     (text(string-append (second chatorstr) " dipped.") FS "purple")]
    [(string=? (first chatorstr) "ERROR")
     (text(string-append "ERROR: " (second chatorstr)) FS "red")]
    [(string=? (first chatorstr) "EMOTICON")
     (text(string-append (third chatorstr)
           " has been set to an emote by " (second chatorstr)) FS "purple")]
    [(string=? (first chatorstr) "ACCEPTED")
     (text(string-append (second chatorstr) " whitelisted you.") FS "purple")]
    [(string=? (first chatorstr) "CODE")
     (beside (text(string-append (second chatorstr) ": ")FS "purple")
             (pd*-interpret (third chatorstr)))]))

(check-expect(chat-to-text CHAT-E LOE-2)
 (beside (text "champion.j+hoyt.j: " FS "purple")
  (text "whats " FS "purple")
  (bitmap/url URL-1)
  (text "up " FS "purple")
  (bitmap/url URL-2)))

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

;; lpd*-builder: LPD* [Image Image -> Image] -> Image
;; lpd*-builder: Interprets the last two cases of a PD* using a given function

(define (lpd*-builder lpd func)
  (foldr func empty-image (map pd*-interpret lpd)))
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

;;Signature: List-of-strings List-of-emotes -> Image
;;Purpose: to make an image from a MSG chat that accounts for emotes
(check-expect (message-with-emotes '() LOE-2)empty-image)
(check-expect (message-with-emotes(list "whats" "smile" "up" "wifi") LOE-1)
              (text "whats smile up wifi " FS "purple"))

(define (message-with-emotes los loe)
  (local[;Sig: String -> Boolean
         ;Purp: is the given string a url?
         (define (url? str)
         (and(< 5 (string-length str))
             (string=? "http:" (substring str 0 5))))
         ;Sig: String -> Image
         ;Purp: changes given string into corresponding image
         (define (ftge s)
           (if (url? s) (bitmap/url s)
            (text (string-append s " ") FS "purple")))]
  (foldr beside empty-image (map ftge (replace-strings los loe)))))

(check-expect (message-with-emotes(list "whats" "smile" "up" "wifi") LOE-2)
 (beside
  (text "whats " FS "purple")
  (bitmap/url URL-1)
  (text "up " FS "purple")
  (bitmap/url URL-2)))

;;Signature: List-of-strings List-of-emotes -> List-of-strings
;;Purpose: to do the same thing as help-replace, but with a list of emotes
;;instead of a single emote
(check-expect (replace-strings '() LOE-2)'())
(check-expect (replace-strings (list "whats" "smile" "up" "wifi") LOE-1)
              (list "whats" "smile" "up" "wifi"))
(check-expect (replace-strings (list "whats" "smile" "up" "wifi") LOE-2)
              (list "whats" URL-1 "up" URL-2))

(define (replace-strings los loe)
  (local[;Sig: List-of-strings Emote -> List-of-strings
         ;Purp: to replace every word that is related with a given emote 
         ;with the url related to that emote in a given list of strings
         ;Given: '() EMOTE-1 Wanted: '() 
         ;Given: (list "whats" "smile" "up") EMOTE-1
         ;Wanted:(list "whats" URL-1 "up")
         (define (help-replace los emote)
           (local[;Sig: String Emote -> String
                  ;Purp: replaces string with url if necessary
                  ;Given: "wifi" EMOTE-2 Wanted: URL-2
                  (define (change-word str)
                    (if(string=? (first emote) str)(second emote) str))]
           (map change-word los)))]
  (cond[(empty? los)empty]
       [(empty? loe)los]
       [else (replace-strings(help-replace los (first loe)) (rest loe))])))

;;Signature: List-of-strings -> String
;;Purpose: to make a given list of strings into a string with spaces
(check-expect (add-strings LOS-1)"")
(check-expect (add-strings LOS-2)"yo shrimp cup")

(define (add-strings los)
  (cond
    [(empty? los)""]
    [else (if(last? los) (first los)
             (string-append (first los) " "(add-strings (rest los))))]))

;;Signature: Chatroom Chat -> Chatroom
;;Purpose: upon receiving a message from the server, this function
;;adds the received chat to the current conversation in the chatroom.
;;If the chat is an emoticon command, the emote is added to the 
;;current list of emotes at the start of the list.
(check-expect (receive-chat CR-1 CHAT-1)(make-cr (list "" CHAT-1) '()))
(check-expect (receive-chat CR-1 CHAT-2)(make-cr (list "" CHAT-2) '()))
(check-expect (receive-chat CR-1 CHAT-3)(make-cr (list "" CHAT-3) '()))
(check-expect (receive-chat CR-1 CHAT-4)(make-cr (list "" CHAT-4) '()))
(check-expect (receive-chat CR-1 CHAT-5)(make-cr (list "" CHAT-5)
                                                 (list(list "word" URL-1))))
(check-expect (receive-chat CR-1 CHAT-6)(make-cr (list "" CHAT-6) '()))
(check-expect (receive-chat CR-2 CHAT-1)
 (make-cr(list "shrimp" CHAT-1 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))
(check-expect (receive-chat CR-2 CHAT-2)
 (make-cr(list "shrimp" CHAT-2 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))
(check-expect (receive-chat CR-2 CHAT-3)
 (make-cr(list "shrimp" CHAT-3 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))
(check-expect (receive-chat CR-2 CHAT-4)
 (make-cr(list "shrimp" CHAT-4 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))
(check-expect (receive-chat CR-2 CHAT-5)
 (make-cr(list "shrimp" CHAT-5 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)
         (list (list "word" URL-1) EMOTE-1 EMOTE-2)))
(check-expect (receive-chat CR-2 CHAT-6)
 (make-cr(list "shrimp" CHAT-6 CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))

(define (receive-chat cr chat)
  (if(string=? (first chat) "EMOTICON")
           (make-cr(cons(first (cr-convo cr))(cons chat(rest (cr-convo cr))))
                   (cons(list (third chat) (fourth chat))(cr-emotes cr)))
           (make-cr(cons(first (cr-convo cr))(cons chat (rest (cr-convo cr))))
                   (cr-emotes cr))))

;;Signature: Chatroom KeyEvent -> Chatroom or Package
;;Purpose: changes the current chatroom based on the key input
(check-expect (send-chat CR-2 "a")
 (make-cr(list "shrimpa" CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2))
(check-expect (send-chat CR-2 "\b")
 (make-cr(list "shrim" CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E) LOE-2))
(check-expect (send-chat CR-2 "rshift")CR-2)
(check-expect (send-chat CR-2 "\r")
 (make-package(make-cr (list "" CHAT-1 CHAT-2 CHAT-3 CHAT-4 CHAT-5 CHAT-E)LOE-2)
              "shrimp"))

(define (send-chat cr key)
  (local[(define user-str (first (cr-convo cr)))]
  (cond
    [(key=? key "\r")
     (make-package(make-cr(cons ""(rest (cr-convo cr)))(cr-emotes cr))
                  (make-command user-str))]
    [(and (key=? key "\b") (>= (string-length user-str) 1))
     (make-cr (cons(substring user-str 0 (- (string-length user-str) 1))
              (rest (cr-convo cr))) (cr-emotes cr))]
    [(> (string-length key) 1)cr]
    [else (make-cr(cons(string-append user-str key)(rest (cr-convo cr)))
                  (cr-emotes cr))])))

;;Signature: String -> Command
;;Purpose: to change a given string to an appropriate command
(check-expect (make-command "bruh")COMMAND-1)
(check-expect (make-command "*hello")COMMAND-2)
(check-expect (make-command "-Miguel")COMMAND-3)
(check-expect (make-command "^shrimp")COMMAND-4)
(check-expect (make-command "!family cup")COMMAND-5)
;(check-expect (make-command "#(rectangle 20 40 \"solid\" \"blue\")")COMMAND-6)

(define (make-command str)
  (local[;Sig: String String -> Boolean
         ;Purp: is the string a given type of command?
         ;Given: "*hello" "*" Wanted: #t
         (define (command? str id)
           (string=? (substring str 0 1) id))
         ;Sig: String String -> List-of-strings
         ;Purp: makes the string into the type of command
         ;Given: "*hello" "COLOR" Wanted: (list "COLOR" "hello")
         (define (cmd-type str type)
           (list type
           (substring str 1(string-length str))))]
  (cond
    [(command? str "*")(cmd-type str "COLOR")]
    [(command? str "-")(cmd-type str "BLACKLIST")]
    [(command? str "^")(cmd-type str "WHITELIST")]
    [(command? str "!")(cons "URL" (words-to-list(second(cmd-type str ""))))]
    [else str])))

;;Signature: String -> List-of-strings
;;Purpose: to take two words separated by a space
;;and make a list of two words  with no space
(check-expect (words-to-list "shrimp cup")(list "shrimp" "cup"))
(check-expect (words-to-list "")(list ""))
(check-expect (words-to-list "shrimp")(list "shrimp"))

(define (words-to-list str)
  (local[;Sig: List-of-strings -> Number
         ;Purp: to find at what character the space is between two words
         ;Given: (explode"shrimp cup") Wanted: 6
         ;Given: '() Wanted: 0
         (define (find-space los)
           (cond
             [(empty? los)0]
             [else (if(string=? (first los) " ")0
                      (+ 1 (find-space(rest los))))]))
         ;Sig: String -> String
         ;Purp: to give the word before a space of two words
         ;Given: "shrimp cup" Wanted: "shrimp"
         (define (before-space str)
           (substring str 0 (find-space(explode str))))
         ;Sig: String -> String
         ;Purp: to give the word after a space of two words
         ;Given "shrimp cup" Wanted: "cup"
         (define (after-space str)
           (substring str (+ 1 (find-space(explode str))) (string-length str)))]
  (cond
    [(empty?(explode str))(list "")]
    [else(if(> (string-length str) (find-space(explode str)))
            (list (before-space str)(after-space str))
            (list str))])))

;;Signature: [List-of X] -> Boolean
;;Purpose: to check if the first of the list
;;is the same as the last
(check-expect (last? LOS-2)#false)
(check-expect (last? (list "shrimp"))#true)

(define (last? lox)
  (string=? (last lox) (first lox)))

;;Signature: [List-of X] -> X 
;;Purpose: to extract the last element of a list
(check-expect (last LOS-1)empty)
(check-expect (last LOS-2)"cup")
(check-expect (last (list "family" 350 "bucks" #false))#false)

(define (last lox)
  (cond
    [(empty? lox)empty]
    [(= (length lox) 1)(first lox)]
    [else (last(rest lox))]))
;-------------------------------------------------------------------------------