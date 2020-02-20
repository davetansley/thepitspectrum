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
    cp 49
    jp nz,lifescreen_draw0
    ld hl,string_lifescreen_lastman 

    ld b,8
    ld a,10                                ; set red
    ld de,22528+108                        ; attrs here 
    call screen_setcolours

    jp lifescreen_draw1
lifescreen_draw0:
    ld hl,string_lifescreen_lives+2       ; not last man, so use the normal view
    ld (hl),a                             ; load this to the string we're about to show
    ld hl,string_lifescreen_lives
lifescreen_draw1:
    call string_print

    ld a,134
    ld de, 22528+11     ; get the colour for the top text
    ld b,10
    call screen_setcolours

    ld a,100                              ; wait for 200 frames
    call utilities_waitforkey_forframes   ; wait for keypress

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