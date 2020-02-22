;
; Draws the level transition screen
;
endlevel_draw:
    call endlevel_init
    call endlevel_commontext

    ld hl,string_highscore_congratulations
    call string_print

    ld a,(game_currentplayer)
    cp 1
    ld hl,string_highscore_player1
    jp endlevel_init1
endlevel_init0:
    ld hl,string_highscore_player2
endlevel_init1:
    call string_print

    ld hl,string_endlevel_youhaveearned
    call string_print
    ld hl, string_endlevel_bonus1
    call string_print
    ld hl, string_endlevel_points1
    call string_print
    ld hl, string_endlevel_anothergo
    call string_print

    ld b,32
    ld a,99
    ld de,22528+352                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,101
    ld de,22528+416                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,99
    ld de,22528+480                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,98
    ld de,22528+576                         ; attrs here 
    call screen_setcolours

    call utilities_waitforkey   ; wait for keypress

    ret

;
; Draws text shared by the game over and high score screens
;
endlevel_commontext:
    call screen_setuptext       ; show scores
    call scores_printscores     ; print the current scores
    
    ld hl,string_gameoverscreen_bestscores
    call string_print

    ld b,32
    ld a,69
    ld de,22528+704                         ; attrs here 
    call screen_setcolours

    ret

;
; Initialises the screen
;
endlevel_init:
; We want a green screen.
    ld a,97             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,0              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    ret