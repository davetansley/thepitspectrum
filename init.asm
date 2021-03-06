;
; Set up at start up
;
init_start:
; We want a black screen.
    
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    xor a               ; quick way to load accumulator with zero.
    call 8859           ; set permanent border colours.
    
    ld hl,screen_offset ; reset some temp variables
    ld (hl),0
    ld hl,screen_tmp
    ld (hl),0
    ld hl,buffer_tmp
    ld (hl),0
    inc hl
    ld (hl),0

    call game_resetcurrentframe ; reset current frame

    ret

;
;   Start coord
;   vert c, horiz b 
init_coord:
    defb 24,48

;
; Number of lives to start
;
init_lives:
    defb 3

;
; Score to start
;
init_score:
    defb '000000'