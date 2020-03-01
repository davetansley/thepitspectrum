;
; The current frame count, incremented each frame
;
game_framenumber:
    defb    0

;
; The number of players
; 
game_numberplayers:
    defb 1

;
; The current player
;
game_currentplayer:
    defb 1

;
; The default number of lives
;
game_numberlives:
    defb 4

;
; The current difficulty
;
game_difficulty:
    defb 0

;
; Control method: 0 for keyboard, 1 for kempston
;
game_control:
    defb 0

;
; Moves to the next player
;
game_changeplayer:
    ld a,(game_currentplayer)
    cp 1
    ret z                       ; if just one player, no need to change
    dec a                       ; otherwise decrease by one 
    xor 1                       ; xor with one to flip 
    inc a                       ; increment 
    ld hl,game_currentplayer
    ld (hl),a                   ; store
    ret

;
; Sets the number of players at the start of the game
; Inputs:
; a - number of players
game_setnumberofplayers:
    ld hl,game_numberplayers
    ld (hl),a

;
; Increment frame number by 1
;
game_incrementframe:
    ld a,(game_framenumber)
    cp 255
    jp nz,game_incrementframe0
    ld a,0
game_incrementframe0:
    inc a
    ld (game_framenumber),a
    ret

;
; Returns current frame
; Outputs:
; a - current frame
;
game_getcurrentframe:
    ld a,(game_framenumber)
    ret

;
; Resets current frame
;
game_resetcurrentframe:
    ld hl,game_framenumber
    ld (hl),0
    ret

;
; Increases the current difficulty
;
game_increasedifficulty:
    ld a,(game_difficulty)
    inc a
    ld (game_difficulty),a