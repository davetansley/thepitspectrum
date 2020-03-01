;
; The score of the current player
;
scores_current:
    defb 4,1,'000000',255       ;+2

scores_defaultname:
    defb '---'

;
; The current high score table
;
scores_table:
    defb 03,23,'GAM000000',255         ;+0, +2, +5
    defb 12,23,'GAM000000',255        ;+12, +14, +17
    defb 21,23,'GAM000000',255        ;+24, +26, +29
    
;
; Add thousands to the score
; Inputs:
; b - number to add
;
scores_addthousands:
    ld hl,scores_current+4  
    call scores_update
    ret

;
; Add hundreds to the score
; Inputs:
; b - number to add
;
scores_addhundreds:
    ld hl,scores_current+5  
    call scores_update
    ret

;
; Prints the score to screen
;
scores_printscore:
    ld a,(game_currentplayer)   ; get current player
    ld hl,scores_current
    cp 1
    jp nz, score_printscore0    ; if not player 1
    ld (hl),4       ; set position for player 1
    jp score_printscore1
score_printscore0:
    ld (hl),22       ; set position for player 2
score_printscore1:
    ld hl,scores_current
    call string_print
    ret

;
; Prints both scores to screen
;
scores_printscores:
    ld hl,player1_score
    call string_print
    ld hl,player2_score
    call string_print
    ret

;
; Updates the current score. 
; Inputs:
; hl - memory location of the score column
; b - number to add
;
scores_update:
    ld a,(hl)           ; current value of digit.
    add a,b             ; add points to this digit.
    ld (hl),a           ; place new digit back in string.
    cp 58               ; more than ASCII value '9'?
    ret c               ; no - relax.
    sub 10              ; subtract 10.
    ld (hl),a           ; put new character back in string.
scores_update0: 
    dec hl              ; previous character in string.
    inc (hl)            ; up this by one.
    ld a,(hl)           ; what's the new value?
    cp 58               ; gone past ASCII nine?
    ret c               ; no, scoring done.
    sub 10              ; down by ten.
    ld (hl),a           ; put it back
    jp scores_update0   ; go round again.


;
; Displays the high score table at the bottom of the screen
;
scores_showtable:
    ld hl, scores_table
    call string_print
    ld hl, scores_table+12
    call string_print
    ld hl, scores_table+24
    call string_print
    ret

;
; Place to store the current position we're checking
;
scores_highscoretmp:
    defb 0

;
; Updates the highscore table. Start at bottom score. Work way from left. Compare each digit. If current is higher than one we're checking, 
; copy checking one down (or erase) then copy current over that one. Then move up one and do the same
;
scores_processhighscores:
    ld hl,scores_highscoretmp
    ld (hl),0  ; load up the tracking byte with 0 (ie, not on the table)
    ld a,29
scores_processhighscores3:
    ld hl,scores_table          ; position of first score column
    ld e,a
    ld d,0
    add hl,de
    ex af,af'                   ; store a for later
    ld de,scores_current+2      ; position of current score column
    ld b,6                      ; times to loop
scores_processhighscores0:
    ld a,(hl)
    ld c,a                      ; get first score column
    ld a,(de)                   ; get first current column
    cp c                        ; compare current with first
    jp c,scores_processhighscores4  ; if c is bigger, then this is not a higher score, so end
    inc hl 
    inc de                      ; move to next column
    djnz scores_processhighscores0 ; loop
    ex af,af'                     ; still here, so must be bigger
    ld (scores_highscoretmp),a  ; store the position indicator in the tracking byte
    ld c,12
    sub c
    jp nc,scores_processhighscores3 ; if the place we're looking is less than zero, we've gone to far, so continue, otherwise go again
scores_processhighscores4
    call scores_updatehighscores
    ret
    
;
; Update score table
;
scores_updatehighscores:
    ld a,(scores_highscoretmp)  ; get the place we want to overwrite
    cp 0
    ret z                       ; if this is 0, didn't get a high score
    cp 29                       ; check against 29... if it's equal, we don't want to copy the current score down one
    jp z, scores_updatehighscores3
                                ; copy old score over one below, if not first
    ld hl,scores_table          
    ld de,17                    ; start at second score, because this is the first one we'd ever need to copy...
    add hl,de                   ; position of first column
    dec hl 
    dec hl 
    dec hl
    push hl
    ld de,12
    add hl,de                   ; get position of next score
    ld de,hl
    pop hl                      ; get hl back
    ld bc,9
    ldir
    cp 17                       ; see if we're copying into the second place slot (17 memory offset). If so, stop copying back the scores
    jp z,scores_updatehighscores3
    ld hl,scores_table          
    ld de,2                    ; ... otherwise, copy back the first score
    add hl,de                   ; position of first column
    push hl
    ld de,12
    add hl,de                   ; get position of next score
    ld de,hl
    pop hl                      ; get hl back
    ld bc,9
    ldir
scores_updatehighscores3:                               
    ld b,6                      ; now overwrite
    ld hl,scores_table          
    ld d,0
    ld e,a
    add hl,de                   ; position of first column
    ex af,af'
    ld de,scores_current+2      ; position of current score column
scores_updatehighscores2:
    ld a,(de)
    ld (hl),a
    inc hl
    inc de
    djnz scores_updatehighscores2
    ld de,9
    sbc hl,de
    ld de,hl                    ; get back to start of entry
    ld hl,scores_defaultname    ; still need to overwrite the name
    ld bc,3                      ; 3 chars to copy
    ldir 
    ret