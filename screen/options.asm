;
; Show the options screen
;
options_show:
    call options_init

    ld hl,string_options_title
    call string_print
    ld hl,string_options_1player
    call string_print
    ld hl,string_options_2player
    call string_print
    ld hl,string_options_keyboard
    call string_print
    ld hl,string_options_joystick
    call string_print
    ld hl,string_options_start
    call string_print
    ld hl,string_options_vanity
    call string_print

    ld a,(game_numberplayers)
    cp 1
    jp nz,options_show0
    ld de,22528+202                         ; top row attrs here 
    jp options_show1
options_show0:
    ld de,22528+234                         ; top row attrs here 
options_show1:
    ld b,13
    ld a,199
    call screen_setcolours                  ; highlight current player

    ld a,(game_control)
    cp 0
    jp nz,options_show6
    ld de,22528+266                         ; top row attrs here 
    jp options_show7
options_show6:
    ld de,22528+298                         ; top row attrs here 
options_show7:
    ld b,13
    ld a,199
    call screen_setcolours                  ; highlight current control
options_show8:
    call utilities_readkey
    cp 49                                   ; was 1 pressed
    jp nz,options_show2
    ld hl,game_numberplayers
    ld (hl),1
    jp options_show
options_show2:
    cp 50                                   ; was 2 pressed
    jp nz,options_show3
    ld hl,game_numberplayers
    ld (hl),2
    jp options_show
options_show3:
    cp 51                                   ; was 3 pressed
    jp nz,options_show4
    ld hl,game_control
    ld (hl),0
    jp options_show
options_show4:
    cp 52                                   ; was 4 pressed
    jp nz,options_show5
    ld hl,game_control
    ld (hl),1
    jp options_show
options_show5:
    cp 53                                   ; was 5 pressed
    ret z                                   ; exit if so
    jp options_show8                         ; otherwise, jump to top
    ret

;
; Initialise the options screen
;
options_init:
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,0              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    
    ret
    ret