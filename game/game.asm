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
    defb 1

;
; Control method: 0 for keyboard, 1 for kempston
;
game_control:
    defb 0

;
; The current rocks used
;
game_current_rocks:
    defb 0,0


game_tankdifficulty:
    defb 70,65,60,55,50,45,40,35,30,25,20,12
game_pitdifficulty:
    defb 7,7,5,5,4,4,2,2,2,2,2,2
game_robotdifficulty:
    defb 6,6,4,4,3,3,2,2,0,0,0,0
game_digdifficulty:
    defb 20,20,10,10,8,8,8,8,6,6,6,4
game_rockdifficulty:
    defb 40,40,20,20,18,18,18,18,18,18,18,18
game_missiledifficulty:
    defb 70,70,60,60,50,50,40,40,30,30,25,20
;
; Moves to the next player
;
game_changeplayer:
    ld a,(game_numberplayers)
    cp 1
    ret z                       ; if just one player, no need to change
    ld a,(game_currentplayer)   ; get current player
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
; Starts a game
;
game_init:
    ld a,1
    ld (game_currentplayer),a
    ret
    
;
; Sets the current rock layout. Odd gets 1, even gets 2
;
game_setcurrentrocks:
    ld a,(game_difficulty)
    and 1
    cp 0
    jp z,game_setcurrentrocks0
    ld de,level_rocks
    ld hl,game_current_rocks
    ld (hl),de
    ret
game_setcurrentrocks0:
    ld de,level_rocks_alt
    ld hl,game_current_rocks
    ld (hl),de
    ret

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

;
; Sets the various difficulties
;
game_setdifficulty:
    ld a,(game_difficulty)
    cp 13
    jp nz,game_setdifficulty0
    ld a,12                         ; limit difficulty to twelve
game_setdifficulty0:
    ld de,0
    ld e,a                          ; keep the difficulty in de
    ; Set the tank difficulty
    ld hl,game_tankdifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (tank_speed),a               ; set the tank speed
    ; Set the pit difficulty
    ld hl,game_pitdifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (thepit_speed),a               ; set the pit speed
    ; Set the robot difficulty
    ld hl,game_robotdifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (robots_robotspeed),a        ; set the robot speed
    ; Set the dig difficulty
    ld hl,game_digdifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (movement_numberdigframes),a ; set the dig frames
    ; Set the rock difficulty
    ld hl,game_rockdifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (rocks_numberofframestowobble),a ; set the wobble frames
    ; Set the missile difficulty
    ld hl,game_missiledifficulty
    dec hl
    add hl,de                       ; add the difficulty
    ld a,(hl)                       ; get the value
    ld (missiles_speed),a           ; set the missile difficulty
    ret