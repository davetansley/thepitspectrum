;
; Draws the life remaining screen
;
lifescreen_draw:
    call lifescreen_init
    
    ld a,(game_currentplayer)             ; get the current player
    add 48                                ; add 48 to get char
    ld hl,string_lifescreen_player+10
    ld (hl),a                             ; load this to the string we're about to show
    
    ld hl,string_lifescreen_player
    call string_print

    ld a,(player+9)                       ; get the current player lives
    add 48                                ; add 48 to get the character
    ld hl,string_lifescreen_lives+2
    ld (hl),a                             ; load this to the string we're about to show
    

    ld hl,string_lifescreen_lives
    call string_print

    ld a,134
    ld de, 22528+11     ; get the colour for the top text
    call lifescreen_alt_setcolours

    ld a,100                              ; wait for 200 frames
    call utilities_waitforkey_forframes   ; wait for keypress

    ret

lifescreen_alt_setcolours:
    ld b,10                     
lifescreen_alt_setcolours0:
    ld (de),a
    inc de
    djnz lifescreen_alt_setcolours0
    ret

;
; Initialises the screen
;
lifescreen_init:
; We want a blue screen.
    ;call $0D6B
    ld a,14             ; yellow ink (6) on blue paper (1),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,1              ; 1 is the code for blue.
    out (254),a         ; write to port 254.
    ;call 3503           ; ROM routine - clears screen, opens chan 2.
    
    ret