;
; Draws the game over screen
;
gameover_draw:
    call gameover_init
    call screen_setuptext       ; show scores
    
    ld hl,string_gameoverscreen_gameover
    call string_print

    ld hl,string_gameoverscreen_copyright
    call string_print

    ld hl,string_gameover_credits
    call string_print

    ld hl,string_gameoverscreen_bestscores
    call string_print

    ld b,32
    ld a,69
    ld de,22528+704                         ; attrs here 
    call screen_setcolours

    ld b,11
    ld a,66
    ld de,22528+43                         ; attrs here 
    call screen_setcolours

    call utilities_waitforkey   ; wait for keypress

    ret

;
; Initialises the screen
;
gameover_init:
; We want a black screen.
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,0              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    ret