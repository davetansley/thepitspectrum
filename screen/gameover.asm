;
; Draws the game over screen
;
gameover_draw:
    ld a,0
    ld (gameover_soundplayed),a
    ld a,1
    ld (game_currentplayer),a               ; do the first player first    
    call player_init_lifestart              ; get the player config
    call gameover_enterhighscores

    ld a,(game_numberplayers)               ; check if we need to do player 2
    cp 2
    jp nz,gameover_draw0
    ld a,2
    ld (game_currentplayer),a               ; do the second player 
    call player_init_lifestart              ; get the player config
    call gameover_enterhighscores
gameover_draw0:
    call gameover_init
    
    ld hl,string_gameoverscreen_gameover
    call string_print

    ld hl,string_gameoverscreen_copyright
    call string_print

    call gameover_commontext
    call gameover_playsound
    ld b,11
    ld a,66
    ld de,22528+43                         ; attrs here 
    call screen_setcolours
    call utilities_waitforkey   ; wait for keypress

    ret

;
; Draws text shared by the game over and high score screens
;
gameover_commontext:
    call screen_setuptext       ; show scores
    call scores_printscores     ; print the current scores
    
    ld hl,string_gameover_credits
    call string_print

    ld hl,string_gameoverscreen_bestscores
    call string_print

    ld b,32
    ld a,69
    ld de,22528+704                         ; attrs here 
    call screen_setcolours

    ret

;
; If required, enter highscore
;
gameover_enterhighscores:
    ; check if we need to enter initial
    call scores_processhighscores
    
    ld a,(scores_highscoretmp)
    cp 0
    ret z
    call gameover_enterhighscores_init
    call gameover_playsound
    ; Set the flash
    ld a,(scores_highscoretmp)              ; scoretmp has the memory offset of the start of the number
    ld e,5
    sub e                                   ; get the score position back to coords
    ld de,0
    ld e,a                                  ; load into de
    ld hl,scores_table
    add hl,de                               ; get the memory location
    ld bc,(hl)                              ; get the coords
    call screen_getscreenattradress         ; get the memory location of the cell attr into de
    ld a,(de)                               ; get the current attr
    or 128                                  ; make it flash
    ld (de),a
    inc de
    ld (de),a
    inc de
    ld (de),a                               ; make all three flash
    ld a,(scores_highscoretmp)              ; get the score back again
    dec a
    dec a
    dec a                                   ; get high score location back to position of name
    ld d,0
    ld e,a
    ld hl,scores_table
    add hl,de                               ; load memory into hl
    ex af,af'
    ld b,15
    call utilities_pauseforframes           ; pause for a little bit
    ld b,3                                  ; collect three chars
gameover_enterhighscores2:
    push bc
    push hl
gameover_enterhighscores3:
    call utilities_readkey               ; get key into a
    cp 65
    jp c,gameover_enterhighscores3
    cp 91
    jp nc,gameover_enterhighscores3      ; if not a letter, get another
    pop hl
    ld (hl),a 
    inc hl
    push hl
    call sound_gemcollected
    call scores_showtable
    pop hl
    ld b,15
    call utilities_pauseforframes
    pop bc
    djnz gameover_enterhighscores2
    ret

;
; Displays the screen text for high score entry
;
gameover_enterhighscores_init:
    
    call gameover_init
    call gameover_commontext

    ld hl,string_highscore_congratulations
    call string_print

    ld a,(game_currentplayer)
    cp 1
    ld hl,string_highscore_player1
    jp z, gameover_enterhighscores_init1
gameover_enterhighscores_init0:
    ld hl,string_highscore_player2
gameover_enterhighscores_init1:
    call string_print
    ld b,96
    ld a,67
    ld de,22528+160                         ; attrs here 
    call screen_setcolours

    ld hl,string_highscore_youhaveearned
    call string_print

    ld a,(scores_highscoretmp)
    cp 5
    jp z, gameover_enterhighscores_init2    ; first place
    cp 17
    jp z, gameover_enterhighscores_init3    ; 2nd place
    ld hl,string_highscore_place3           ; 3rd place           
    jp gameover_enterhighscores_init4
gameover_enterhighscores_init2
    ld hl,string_highscore_place1           
    jp gameover_enterhighscores_init4
gameover_enterhighscores_init3
    ld hl,string_highscore_place2           
    jp gameover_enterhighscores_init4
gameover_enterhighscores_init4
    call string_print

    ld b,96
    ld a,66
    ld de,22528+320                         ; attrs here 
    call screen_setcolours

    ld hl,string_highscore_pleaseenter
    call string_print

    ld b,96
    ld a,70
    ld de,22528+480                         ; attrs here 
    call screen_setcolours
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

gameover_soundplayed:
    defb 0

;
; Plays the sound if it hasn't already been played
;
gameover_playsound:
    ld a,(gameover_soundplayed)  
    cp 1           
    ret z
    call sound_gameover
    ld a,1
    ld (gameover_soundplayed),a
    ret