;; The first three lines of this file were inserted by DrRacket. They record metadata
;; about the language level of this file in a form that our tools can easily process.
#reader(lib "htdp-beginner-abbr-reader.ss" "lang")((modname |Week 7 Set A FINAL|) (read-case-sensitive #t) (teachpacks ()) (htdp-settings #(#t constructor repeating-decimal #f #t none #f () #f)))
;; Andrew Alcala  alcala.a@husky.neu.edu
;; Rehab Asif     asif.r@husky.neu.edu
(require 2htdp/universe)
(require 2htdp/image)
;;CONSTANTS
(define WIDTH 1000)
(define HEIGHT 1000)
(define CANVAS (rectangle WIDTH HEIGHT "solid" "white"))
(define the-server "dictionary.ccs.neu.edu")
(define the-port   10009)
;;----------------------------------------------
;; World State is a data
;; a data is a (make-data String String Image Chatlist String)
(define-struct data (x y chatlist color loe))


;; INTERPRETATION:
;; (make-data x y im Chatlist color)
;; x is a string you'd like to send.
;; y is a string you are receiving,
;; im is what is on screen as an Image.
;; Chatlist is a list that contains the chat history
;; color is a string of the user's chat color

;;----------------------------------------------
;; a emote is a (make-emote String String)
(define-struct emote [word url])

;; INTERPRETATION:
;; word is a String that holds the emote string
;; url is a String of the url of the emote image.

;; A List-of-emotes is one of:
;;  > '()
;;  > (cons emote List-of-emotes)

;;----------------------------------------------
;; a chatentry is a (make-chatentry String String)
(define-struct chatentry [entry color])

;; INTERPRETATION:
;; entry is a String representation of a message
;; color is a String of a color

;; a Chatlist is one of :
;;   > '()
;;   >  (cons chatentry Chatlist)

;; INTERPRETATION:
;; chatentry represents chat history of messages received from the server
;; Chatlist is a list of chatentrys recieved from the server representing
;; chat history

;;----------------------------------------------
;; A Command is one of:
;;  > String
;;  > (list "COLOR" String)
;;  > (list "BLACKLIST" String)
;;  > (list "WHITELIST" String)
;;  > (list "URL" String String)
 

;;INTERPRETATION:
;; String is any string
;; Color command's string is a string that the server accept as
;; a valid text color option
;; Blacklist command's string is the username of a user you wish to mute.
;;
;;
;;----------------------------------------------
; A Chat is one of:
;; -- (list "MSG" String List-of-strings String)
;; -- (list "JOIN" String)
;; -- (list "EXIT" String)
;; -- (list "EMOTICON" String String String)


;;INTERPRETATION:
;; For MSG chats, the first String is a username and the List-of-Strings
;; is a list of Strings containing the message the user typed.
;; For JOIN EXIT and ERROR chats, the String is a username.
;; For EMOTICON chats, the first String is a username, the second is a word,
;;----------------------------------------------
;; client: String --> data
;; client: communicates with a chat server by sending/recieving Commands/Chats
;; to/from the chat room. Client displays the conversation in the
;; chat room as text.
;;----------------------------------------------
(define dataex1 (make-data "" "" (list (make-chatentry (list "MSG" "alcala.a+asif.r" (list "hello" "world!") "black") "black")
                                       (make-chatentry (list "MSG" "alcala.a+asif.r" (list "Connecting") "black") "black")) "black" '()))
(define dataex2 (make-data "" "" (list (make-chatentry (list "MSG" "friendly.bot" (list "I" "love" "apples" "and" "people") "orange") "orange")
                                       (make-chatentry (list "MSG" "alcala.a+asif.r" (list "hello" "world!") "black") "black")
                                       (make-chatentry (list "MSG" "alcala.a+asif.r" (list "Connecting") "black") "black")) "black"
                                       (list
                                             (make-emote "hello" "https://yt3.ggpht.com/-KrFBZKp7JXk/AAAAAAAAAAI/AAAAAAAAAAA/9L6VJ_fvkZ0/s48-c-k-no-mo-rj-c0xffffff/photo.jpg")
                                             (make-emote "apples" "http://www.waynecountytourism.com/appletastingtour/images/apple.png"))))


(define (client str)
  (big-bang   (crdata str)
            [name       "asif.r:0679+alcala.a:5936"]
            [register   the-server]
            [port       the-port]
            [on-receive receive]
            [to-draw show]
            [on-key keypress]))

;; crdata: String -> data
;; crdata: consumes a string and creates a data with
;;         the string in the x value of the data.
(define (crdata str1)
  (make-data str1 ""  (list (make-chatentry (list "MSG" "Client" (list (string-append "Attempting to connect to " the-server " through port " (number->string the-port))) "red") "red")) "black" '()))
;;Ex.
;;(check-expect (crdata "hi") (make-data "hi" ""  (list (make-chatentry "hi" "black")) "" '() ))


 
;; chat-to-str: Chat -> String
;; chat-to-str: Consumes a Chat and converts it to a string.
(define (chat-to-str c)
  (cond
    [(string=? (first c) "MSG")
     (combine-msg  (insertcolon (rest c)))]
    [(string=? (first c) "JOIN")
     (string-append (combine-chat (rest c)) "has joined the server!")]
    [(string=? (first c) "EXIT")
     (string-append (combine-chat (rest c))"has left the server.")]
    [(string=? (first c) "ERROR")
     (string-append "ERROR: " (combine-chat (rest c)))]
    [(string=? (first c) "EMOTICON")
     (save-emote  c)]
    [else (combine-chat c)]))
(check-expect (chat-to-str
               (list "MSG"  "alcala.a+asif.r" (list "Hello" "world!") "black"))
              "alcala.a+asif.r: Hello world!  ")
(check-expect (chat-to-str
               (list "JOIN" "alcala.a+asif.r"))
              "alcala.a+asif.r has joined the server!")
(check-expect (chat-to-str
               (list "EXIT" "alcala.a+asif.r"))
              "alcala.a+asif.r has left the server.")
(check-expect (chat-to-str
               (list "ERROR" "Invalid username"))
              "ERROR: Invalid username ")

;;save-emote: Chat -> Emote
;; save-emote: creates an emote with a word and a url
(define (save-emote c)
  (make-emote (third c) (fourth c)))
 
;;combine-msg Chat -> String
;;combine-msg: takes a Chat MSG and converts the rest of the list to a
;;             string without including the final String (color) in the Chat
(define (combine-msg c)
  (cond
    [(empty? c) ""]
    [(string? c) c]
    [(= (length  c) 1) ""] 
    [else (string-append (combine-chat (first c)) " " (combine-msg (rest c)))]))
(check-expect (combine-msg '()) "")
(check-expect (combine-msg "Hello") "Hello")
(check-expect (combine-msg (list "blue")) "")
(check-expect (combine-msg
               (list "alcala.a+asif.r:" (list "Hello" "world!") "black"))
              "alcala.a+asif.r: Hello world!  ")

;;combine-chat Chat -> String
;;combine-chat takes a Chat and converts the rest of the list to a string
(define (combine-chat c)
  (cond
    [(empty? c) ""]
    [(string? c) c]
    [else (string-append (combine-msg (first c)) " " (combine-chat (rest c)))]))

(check-expect (combine-chat '()) "")
(check-expect (combine-chat (list "alcala.a+asif.r")) "alcala.a+asif.r ")
(check-expect (combine-chat (list "Invalid username")) "Invalid username ")


;;insertcolon: Chat -> Chat
;;insertcolon: Consumes a chat and returns an identical Chat
;;             with a ":" after the first value in that chat
(define (insertcolon c)
   (cons
    (string-append (substring (first c) 0 (string-length (first c))) ":")
    (rest c)))

(check-expect (insertcolon
               (list "alcala.a+asif.r" (list "Hello" "world!") "black"))
              (list "alcala.a+asif.r:" (list "Hello" "world!") "black"))
(check-expect (insertcolon (list "friendly.bot"
                (list "goodbye") "black"))
              (list "friendly.bot:" (list "goodbye") "black"))



;;receive: data Chat -> data
;;receive:
;; consumes a data and a string received from a chat server and inserts the
;; string into an identical data, keeping the original x value of the data,
;; inserting the string into the y value. It also inserts an image of the chat
;; room with previous messages shifted upwards and places the received string
;; into the first position in the chatlist. 

(define (receive t chat)
  (cond
  [(string=? (first chat) "EMOTICON")
   (make-data (data-x t) (data-y t)
           (data-chatlist t) (getcolor chat) (cons (save-emote chat) (data-loe t)))]
  [else (make-data (data-x t) (chat-to-str chat)       
           (cons (make-chatentry  chat (getcolor chat)) (data-chatlist t))
           (getcolor chat) (data-loe t))]))

;;Ex.
(check-expect (receive
               (make-data "" "" '() "blue" '())
               (list "MSG" "alcala.a+asif.r" (list "Hello" "World!") "red"))
              (make-data "" "alcala.a+asif.r: Hello World!  "
                     (cons (make-chatentry (list  "MSG" "alcala.a+asif.r" (list "Hello" "World!") "red") "red") '()) "red" '()))
(check-expect (receive
               (make-data "hello" "" '() "blue" '())
               (list "JOIN" "alcala.a+asif.r"))
          (make-data "hello" "alcala.a+asif.r has joined the server!" (list (make-chatentry (list "JOIN" "alcala.a+asif.r")  "black")) "black" '()))

(check-expect (receive
               (make-data "" ""  '() "red" '())
               (list "EXIT" "23"))
              (make-data "" "23 has left the server." (list (make-chatentry (list "EXIT" "23") "black")) "black" '()))

(check-expect (receive
               (make-data "" ""  '() "red" '())
               (list "EMOTICON" "alcala.a+asif.r" "apple" "www.google.com"))
              (make-data "" ""
                          '() "black" (list (make-emote "apple" "www.google.com"))))
(check-expect (receive
               (make-data "" "" '() "red" (list (make-emote "apple" "www.google.com")))
               (list "EMOTICON" "friendly.bot" "orange" "www.bing.com"))
              (make-data "" ""
                          '() "black" (list (make-emote "orange" "www.bing.com") (make-emote "apple" "www.google.com"))))

;;getcolor: Chat -> String
;;getcolor: extracts the color String from a Chat
(define (getcolor c)
  (cond
     [(string=? (first c) "MSG") (list-ref c (sub1 (length c)))]
     [else "black"]))
(check-expect (getcolor (list "MSG" "alcala.a+asif.r"
                              (list "Hello" "World!") "red")) "red")
(check-expect (getcolor (list "EXIT" "alcala.a+asif.r")) "black")

;;show: data -> Image
;;show: consumes a data and displays strings as text. show will continue to
;;      show characters being typed in the typing area until keypress finds a
;;      return string. When a string is received from the server, the first
;;      string in the chatlist from receive's outputted data will be displayed.
;;      The im value Image in the data will be displayed and have its y
;;      coordinate shifted upward.
(define (show d)
  (place-image/align (combined-image (data-chatlist d) d)
           (/ WIDTH 2)  (/ HEIGHT 2) "center" "bottom"
            (place-image/align (text (data-x d) 22 "black")
               (/ WIDTH 2)  (+ (/ HEIGHT 2) 60) "center" "center"
                 CANVAS)))

(check-expect (show dataex1)
       (place-image/align (above (text "alcala.a+asif.r: Connecting  " 25 "black") (text "alcala.a+asif.r: hello world!  " 25 "black") )
           (/ WIDTH 2)  (/ HEIGHT 2) "center" "bottom"
            (place-image/align (text (data-x dataex1) 22 "black")
               (/ WIDTH 2)  (+ (/ HEIGHT 2) 60) "center" "center"
                 CANVAS)))

#;(check-expect (show dataex2)
       (place-image/align (combined-image (data-chatlist d) d)
           (/ WIDTH 2)  (/ HEIGHT 2) "center" "bottom"
            (place-image/align (text (data-x d) 22 "black")
               (/ WIDTH 2)  (+ (/ HEIGHT 2) 60) "center" "center"
                 CANVAS)))

;; List-of-chatentrys Data -> Image
;; consumes a List-of-chatentrys and data and returns a visable representation of messages as an Image
(define (combined-image cl d)
  (cond
    [(empty? cl) CANVAS]
    [(contains-emote?  (chat-to-str (chatentry-entry (first cl))) (data-loe d))
     (above (combined-image (rest cl) d) (stack-image-emote  (first cl) (data-loe d) cl d))]
    [(and (> (length cl) 1) (chatentry? (second cl)))
     (above (combined-image (rest cl) d) (stack-image (first cl)))]
    [else (text (chat-to-str (chatentry-entry (first cl))) 25 (chatentry-color (first cl))) ]))

(check-expect (combined-image (data-chatlist dataex1) dataex1)
              (above (text "alcala.a+asif.r: Connecting  " 25 "black") (text "alcala.a+asif.r: hello world!  " 25 "black") ))

(check-expect (combined-image (data-chatlist dataex2) dataex2)
              (above (text "alcala.a+asif.r: Connecting  " 25 "black")
                     (above (beside (text "alcala.a+asif.r: " 25 "black") (bitmap/url "https://yt3.ggpht.com/-KrFBZKp7JXk/AAAAAAAAAAI/AAAAAAAAAAA/9L6VJ_fvkZ0/s48-c-k-no-mo-rj-c0xffffff/photo.jpg") (text "world! " 25 "black"))
                            (beside (text "friendly.bot: I love " 25 "orange") (bitmap/url "http://www.waynecountytourism.com/appletastingtour/images/apple.png") (text "and people " 25 "orange")))))

;; ChatEntry -> Image
;; consumes a chatentry and converts it into a text 
(define (stack-image ce)
    (text (chat-to-str (chatentry-entry ce)) 25 (chatentry-color ce)))
 
;; ChatEntry List-of-emotes List-of-chatentrys Data -> Image
(define (stack-image-emote ce loe cl d)
  (cond
    [(empty? (third (chatentry-entry ce))) (text "" 25 "black")]
    [(and (contains-emote? (chat-to-str (chatentry-entry ce)) loe) (> (length cl) 1))
     (beside (text (string-append (string-append (second (chatentry-entry ce)  ) ": ") (until-emote (third (chatentry-entry ce)) (grab-word  (third (chatentry-entry ce)) loe d)))  25 (chatentry-color ce))
                                 (bitmap/url (grab-url (chatentry-entry ce) loe d))  (stack-image-emote (after-emote ce (grab-word  (third (chatentry-entry ce)) loe d))  loe cl d))]
    [(contains-emote? (chat-to-str (chatentry-entry ce)) loe) (bitmap/url (grab-url (chatentry-entry ce) loe d))]
    [else  (text  (finish-emote (third (chatentry-entry ce))) 25 (chatentry-color ce))]))

(check-expect (stack-image-emote (first (data-chatlist dataex2)) (data-loe dataex2) (data-chatlist dataex2) dataex2)
                (beside (text "friendly.bot: I love " 25 "orange") (bitmap/url "http://www.waynecountytourism.com/appletastingtour/images/apple.png") (text "and people " 25 "orange")))



;;(make-chatentry (list "MSG" "username" (list "I"  "apples" "love") "black") "black")
;;ChatEntry String ChatEntry
(define (after-emote ce str)
  (cond
     [(empty? (third (chatentry-entry ce))) (make-chatentry (list  (first(chatentry-entry ce))  (second(chatentry-entry ce))  '() (chatentry-color ce)) (chatentry-color ce)) ]
     [(string=? (first (third (chatentry-entry ce))) str) (make-chatentry (list  (first (chatentry-entry ce)) (second (chatentry-entry ce)) (rest (third (chatentry-entry ce))) (chatentry-color ce) ) (chatentry-color ce))]
     [else (after-emote  (make-chatentry (list  (first(chatentry-entry ce))  (second(chatentry-entry ce))  (remove (first (third (chatentry-entry ce))) (third (chatentry-entry ce))) (chatentry-color ce)) (chatentry-color ce)) str)]))
;; list-of-strings String -> string
(define (until-emote los str)
  (cond
    [(empty? los) ""]
    [(string=? (first los) str) ""]
    [else (string-append (first los) " " (until-emote (rest los) str))]))

(check-expect (until-emote (third (chatentry-entry(first (data-chatlist dataex2)))) "apples") "I love ")
(check-expect (until-emote (third (chatentry-entry(second (data-chatlist dataex2)))) "hello") "")
(check-expect (until-emote (third (chatentry-entry(third (data-chatlist dataex2)))) "") "Connecting ")

#;(make-data "" "" (list                 (make-chatentry (list "MSG" "friendly.bot" (list "I" "love" "apples" "and" "people") "orange") "orange")
                                       (make-chatentry (list "MSG" "alcala.a+asif.r" (list "hello" "world!") "black") "black")
                                       (make-chatentry (list "MSG" "alcala.a+asif.r" (list "Connecting") "black") "black")) "black"
                                       (list
                                             (make-emote "hello" "https://yt3.ggpht.com/-KrFBZKp7JXk/AAAAAAAAAAI/AAAAAAAAAAA/9L6VJ_fvkZ0/s48-c-k-no-mo-rj-c0xffffff/photo.jpg")
                                             (make-emote "apples" "http://www.waynecountytourism.com/appletastingtour/images/apple.png")))
;;List-of-strings -> String
(define (finish-emote los)
  (cond
    [(empty? los) ""]
    [else (string-append (first los) " " (finish-emote (rest los) ))]))

(check-expect (finish-emote (list "and" "people")) "and people ")
(check-expect (finish-emote (list "")) " ")
(check-expect (finish-emote (list "Connecting")) "Connecting ")

;; Chat  List-of-emotes Data -> String
(define (grab-url chat loe d)
  (cond
    [(empty? loe) ""]
    [(string=? (grab-word (third chat) (data-loe d) d) (emote-word (first loe))) (emote-url (first loe))]
    [else (grab-url chat (rest loe) d)]))
(check-expect (grab-url (chatentry-entry (first (data-chatlist dataex2))) (data-loe dataex2) dataex2) "http://www.waynecountytourism.com/appletastingtour/images/apple.png")
(check-expect (grab-url (chatentry-entry (second (data-chatlist dataex2))) (data-loe dataex2) dataex2) "https://yt3.ggpht.com/-KrFBZKp7JXk/AAAAAAAAAAI/AAAAAAAAAAA/9L6VJ_fvkZ0/s48-c-k-no-mo-rj-c0xffffff/photo.jpg")

;;List-of-strings List-of-emotes -> String
(define (grab-word los loe d)
    (cond
      [(empty? los) ""]
      [(empty? loe) (grab-word (rest los) (data-loe d) d)]
      [(string=?  (first los) (emote-word (first loe))) (first los)]
      [else (grab-word los (rest loe) d)]))

(check-expect (grab-word (third (chatentry-entry (first (data-chatlist dataex2)))) (data-loe dataex2) dataex2) "apples")

(check-expect  (grab-word (list "I" "have" "ten" "fingers")  (list (make-emote "ten" "https://pbs.twimg.com/profile_images/502810310894317568/8Gb68T8p_normal.jpeg"))
                (make-data "" "" (list (list "MSG" "username" (list "I" "have" "ten" "fingers") "black")) "black" (list (make-emote "ten" "https://pbs.twimg.com/profile_images/502810310894317568/8Gb68T8p_normal.jpeg"))))
               "ten")

;; String List-of-emotes -> Boolean

(define (contains-emote? str loe)
  (cond
    [(empty? loe) #false]
    [(string-contains? (emote-word (first loe)) str ) #true]
    [else (contains-emote? str (rest loe))]))


;; str-to-command: String -> Command
;; str-to-command: Consumes a string and converts it into a Command.
;;                 If the string begins with a specific 1String...
;;                 > "-" will blacklist a username | (list "BLACKLIST" String)
;;                 > "+" will whitelist a username |(list "WHITELIST" String)
;;                 > "#" will set your color       |(list "COLOR" String)      
;;                 > "*" will set a string as an emoticon located at a valid url
;;                       the string and url must be separated by a "~"
;;                                                 |(list "URL" String String)

(define (str-to-command str)
  (cond
    [(< (string-length str) 1) str] ;; make AND for all
    [(string=? (substring str 0 1) "-") (list "BLACKLIST" (substring str 1))]
    [(string=? (substring str 0 1) "+") (list "WHITELIST" (substring str 1))]
    [(string=? (substring str 0 1) "#") (list "COLOR" (substring str 1))]
    [(and (> (string-length str) 1) (string=? (substring str 0 1) "*"))
     (list "URL" (substring str 1 (urlifinder str ))
                 (substring str (add1 (urlifinder str ))))]
    [else str]))

(check-expect (str-to-command "") "")
(check-expect (str-to-command "abcdefg") "abcdefg")
(check-expect (str-to-command "-abc") (list "BLACKLIST" "abc"))
(check-expect (str-to-command "+def") (list "WHITELIST" "def"))
(check-expect (str-to-command "#hello") (list "COLOR" "hello"))
(check-expect (str-to-command "*join~www.google.com")
              (list "URL" "join" "www.google.com"))
;; urlifinder: String -> Number
;; urlifinder: Returns the index of the "~" in a string
(define (urlifinder s)
  (cond
    [(string=? (substring s 0 1) "~")  0]
    [else  (+ 1 (urlifinder (substring s 1)))]))

(check-expect (urlifinder "~world") 0)
(check-expect (urlifinder "hello~world") 5)
(check-expect (urlifinder "he~llo~world") 2)

;;keypress: data Key -> data (or Package if Key is "\r")
;;keypress: consumes a data and a one character string inputted from on-key.
;; >If the keypress was enter (return), then a Package will be returned and sent
;; to the server containing a new data with blank strings in the x and y values
;; of the data, an Image of the chat box with previous messages shifted upward
;; and the chatlist thus far. Finally the package will send the server whatever
;; text was in the typing area using the data's x value String.
;; >If the keypress was backspace, an identical data will be created except with
;; the x-value String having the last character cut off.
;; >Otherwise,
;; >If the key is a 1String, a new data will be created where the x value String
;; will continously add on any keys pressed to itself and display it dynamically
;; on screen in a typing area below the main chat.
;;  >Else the original data will be returned as if nothing happened.
(define  (keypress t key)
  (cond
    [(string=? key "\r")
     (make-package
      (make-data "" ""
      (data-chatlist t) (data-color t)(data-loe t)) (str-to-command (data-x t)))]
    [(and (> (string-length (data-x t)) 0) (string=? key "\b"))
     (make-data
      (substring (data-x t) 0 (- (string-length (data-x t)) 1) )
       (data-y t) (data-chatlist t) (data-color t) (data-loe t))]
    [else (if (= (string-length key) 1)
              (make-data
               (string-append (data-x t) key) (data-y t)
               (data-chatlist t) (data-color t) (data-loe t))t)]))

;;Ex. 
(check-expect (keypress (make-data "hello" ""  '() "black"'()) "g")
              (make-data "hellog" ""  '() "black" '()))
(check-expect (keypress (make-data "hello" ""  '() "black" '()) "left")
              (make-data "hello" "" '() "black" '()))
(check-expect (keypress (make-data "hello" ""  '() "black" '()) "g")
              (make-data "hellog" ""  '() "black" '()))
(check-expect (keypress (make-data "hello" ""  '() "black" '()) "\b")
              (make-data "hell" ""  '() "black" '()))
(check-expect (keypress (make-data "hello" ""  '() "black" '()) "\r")
         (make-package
          (make-data "" "" '() "black" '()) "hello"))
(check-expect (keypress (make-data "-Andrew" ""  '() "black" '()) "\r")
  (make-package
   (make-data "" "" '() "black" '()) (list "BLACKLIST" "Andrew")))

(check-expect (keypress (make-data "#blue" ""  '() "black" '()) "\r")
  (make-package
   (make-data "" "" '() "black" '()) (list "COLOR" "blue")))
(check-expect (keypress (make-data "+friendly.bot" ""  '() "black" '()) "\r")
  (make-package
   (make-data "" "" '() "black" '()) (list "WHITELIST" "friendly.bot")))