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
; Temporary area for printing scores
;
scores_printscore_tmp:
    defb 0,0,0,0,0,0,0,0,255

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
    call score_printscoreformatted
    ret

;
; Formats a score and prints to the top screen
; Inputs:
; hl - where is the score
score_printscoreformatted:
    ld bc,8
    ld de,scores_printscore_tmp
    ldir                        ; copy to temp
    ld hl,scores_printscore_tmp
    ld ix,hl
    ld a,(ix+2)
    cp 48                   ; is it a leading zero?
    jp nz,score_printscore2
    ld (ix+2),32              ; load it with a space
    ld a,(ix+3)
    cp 48                   ; is it a leading zero?
    jp nz,score_printscore2
    ld (ix+3),32              ; load it with a space
score_printscore2:
    call string_print
    ret

;
; Prints both scores to screen
;
scores_printscores:
    ld hl,player1_score
    call score_printscoreformatted
    ld hl,player2_score
    call score_printscoreformatted
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
; Temporary area to store score
;
scores_showtable_tmp:
    defb 0,0,0,0,0,0,0,0,0,0,0,255

;
; Processes a score 
; Inputs:
; hl - location on table
;
scores_showtable_process:
    ld bc,11                     ; copy this many
    ld de,scores_showtable_tmp
    ldir
    ld ix,scores_showtable_tmp   ; decide whether to show five or six numbers
    ld a,(ix+5)
    cp 48                        ; is this a zero? 
    jp nz,scores_showtable_process0 ; if not, show the whole thing
    ld bc,5                      ; copy this many
    ld hl,ix
    ld de,6
    add hl,de                    ; move to second digit
    ld de,hl
    dec de
    ldir
    ld (ix+10),32                ; stick a space at the end
scores_showtable_process0:
    ld hl,scores_showtable_tmp
    call string_print
    ret

;
; Displays the high score table at the bottom of the screen
;
scores_showtable:
    ld hl, scores_table
    call scores_showtable_process
    ld hl, scores_table+12
    call scores_showtable_process
    ld hl, scores_table+24
    call scores_showtable_process
    ret

;
; Place to store the current position we're checking
;
scores_highscoretmp:
    defb 0

;
; Place to store the equal indicator
;
scores_highscoretmp2:
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
    ld a,1
    ld (scores_highscoretmp2),a ; set the equal indicator to 1 - this will be set to zero if a different number is found
    ld b,6                      ; times to loop
scores_processhighscores0:
    ld a,(hl)
    ld c,a                      ; get first score column
    ld a,(de)                   ; get first current column
    cp c                        ; compare current with first
    jp c,scores_processhighscores4  ; if c is bigger, then this is not a higher score, so end
    jp z,scores_processhighscores5  ; if c is equal, then this is not a higher score, so end
    ld a,0
    ld (scores_highscoretmp2),a ; zero the equality indicator
scores_processhighscores5:
    inc hl 
    inc de                      ; move to next column
    djnz scores_processhighscores0 ; loop
    ld a,(scores_highscoretmp2)   ; get the equality indicator
    cp 1
    jp z,scores_processhighscores4 ; if it is equal, not a highscore
    or a                            ; clear the carry flag
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