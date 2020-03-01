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

    call endlevel_workoutbonus
    push de
    ex af,af'                               ; store the a value for later
    call string_print
    pop de
    ld hl,de                                ; get the points text into de
    call string_print
    
    ld hl, string_endlevel_anothergo
    call string_print

    ld b,32
    ld a,35
    ld de,22528+352                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,37
    ld de,22528+416                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,35
    ld de,22528+480                         ; attrs here 
    call screen_setcolours

    ld b,32
    ld a,34
    ld de,22528+576                         ; attrs here 
    call screen_setcolours

    ex af,af'                               ; get back a value with bonus type
    ld b,20
    call utilities_pauseforframes
    
    ld b,a                      ; put the bonus count in b
endlevel_init2:
    push bc
    ld b,1
    call scores_addthousands
    call player_recordcurrentscore
    call scores_printscores     ; print the current scores
    ld b,10
    call utilities_pauseforframes
    pop bc
    djnz endlevel_init2

    call utilities_waitforkey   ; wait for keypress

    ret

;
; Works out the bonus
; Outputs:
; a = 15 (all seven)
; a = 10 (3 large or 4 small)
; a = 5 (1 large diamond)
; hl - pointer to bonus text
; de - pointer to points text
;
endlevel_workoutbonus:
    ld hl,level01diamonds+2     ; location of state of first diamond
    ld b,3                      ; number to check
    ld d,0                      ; zero diamond count
endlevel_workoutbonus0:
    ld a,(hl)                   ; get state
    cp 1
    jp nz,endlevel_workoutbonus1 ; if not, move on
    inc d                       ; increment diamond count
endlevel_workoutbonus1:
    inc hl
    inc hl
    inc hl
    inc hl
    inc hl                      ; get to next state
    djnz endlevel_workoutbonus0

    ld hl,level01gems+2     ; location of state of first gem
    ld b,4                      ; number to check
    ld e,0                      ; zero gem count
endlevel_workoutbonus2:
    ld a,(hl)                   ; get state
    cp 1
    jp nz,endlevel_workoutbonus3 ; if not, move on
    inc e                       ; increment diamond count
endlevel_workoutbonus3:
    inc hl
    inc hl
    inc hl
    inc hl 
    inc hl                     ; get to next state
    djnz endlevel_workoutbonus2

    ld a,d
    add e
    cp 7                        ; check for max bonus
    jp nz,endlevel_workoutbonus4 ; 
    ld a,15
    ld hl, string_endlevel_bonus3
    ld de, string_endlevel_points3
    ret                         ; return with bonus of 15
endlevel_workoutbonus4:
    ld a,d                      ; check for for diamonds
    cp 3 
    jp nz,endlevel_workoutbonus5
    ld a,10     
    ld hl, string_endlevel_bonus2
    ld de, string_endlevel_points2        
    ret                         ; return with bonus of ten
endlevel_workoutbonus5:
    ld a,e                      ; check for four gems
    cp 4
    jp nz,endlevel_workoutbonus6
    ld a,10 
    ld hl, string_endlevel_bonus2
    ld de, string_endlevel_points2
    ret                         ; return with bonus of 10
endlevel_workoutbonus6:
    ld a,5                      ; otherwise, bonus is 5
    ld hl, string_endlevel_bonus1
    ld de, string_endlevel_points1
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
    ld a,33             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,0              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    ret