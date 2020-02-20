;
;   Data for current player
;   
player:
    defb    0,0                 ; horiz,vert (+0,+1)
    defb    2,0,1               ; dir (0 up, 1 left, 2 right, 3 down), frame, frame transition count (+2,+3,+4)
    defb    0                   ; auto move remaining (+5)
    defb    0,0,0               ; is digging (0 no), digging count, pixels to di (+6,+7,+8)
    defb    0                   ; lives remaining (+9)
    defb    0                   ; died this life (+10)

;
; Score for the current player
;
player_score:
    defb '000000'
;
; Initializes a player at start of game
; Copy initial coords, copy lives, copy score
;
player_init_gamestart:
    ld a,(game_numberlives)
    ld (player1_lives),a
    ld (player2_lives),a                        ; set the initial number of lives at game start
    ret

;
; Initializes a player at start of a life
; Copy initial coords, copy lives, copy score
;
player_init_lifestart:
    ld bc,(init_coord)
    ld (player),bc
    ld bc,player+9
    ld a,(player1_lives)
    ld (bc),a
    ld bc,player+10
    ld a,0
    ld (bc),a
    ret

;
; Finalises a player at end of a life
; Copy lives, copy score
;
player_lifeend:
    ld bc,player+9
    ld a,(bc)
    ld bc,player1_lives
    ld (bc),a
    ret

;
; Player just died, subtract a life
;
player_died:
    ld bc,player+9
    ld a,(bc)
    dec a
    ld (bc),a
    call player_lifeend
    ret

;
; Player lives
;
player1_lives:
    defb 3
player2_lives:
    defb 3

;
; Player scores
;
player1_score:
    defb '000000'
player2_score:
    defb '000000'

;
; Kills a player this life
;
player_killplayer:
    ld hl,player+10
    ld (hl),1
    ret

;
; Draws the player at the current position or deletes them
;
player_drawplayer:
    ld a,(player+2)             ; get the current direction
    cp 3
    jp nz,player_drawplayer0
    ld a,0                      ; if 3, then down, so set the direction to 0 since the sprite is the same as up
player_drawplayer0:
    ld e,a                      ; store in e
    ld a,(player+6)             ; get the dig flag
    cp 1
    jp z,player_drawplayer1    ; get dig frame
    ld a,(player+3)             ; this is normal movement so get the current frame
    add a,e
    jp player_drawplayer2
player_drawplayer1
    ld a,(player+2)             ; get the current direction again, because want all four
    add a,6                     ; add direction to 6 to get frame    
player_drawplayer2
    rlca
    rlca
    rlca                        ; multiply by eight
    ld l,a
    ld h,0  
    ld de,player_sprite
    add hl,de                   ; load hl with the location of the player sprite data
    ld bc,(player)              ; load bc with the start coords
    call sprites_drawsprite     ; call the routine to draw the sprite
    call player_storeupdatedlines ; log updated rows
    ret


;
; Runs after the player just moved. Changes animation frame if required
;
player_justmoved:
    exx
    ld a,(player+4)             ; get the transition count
    cp 0
    jp z, player_justmoved2     ; if zero reset and change the frame
    jp player_justmoved1       ; otherwise decrease and continue
player_justmoved2:
    ; reset and change frame in here
    ld a,1
    ld (player+4),a            ; reset back to whatever
    ld a,(player+3)             ; load the frame
    cp 3                       ; flip between 3 and 0
    jp nz, player_justmoved4
    ld a,0
    jp player_justmoved5
player_justmoved4:
    ld a,3
player_justmoved5:
    ld (player+3),a           ; save back
    jp player_justmoved3
player_justmoved1:
    ; decrease count
    dec a
    ld (player+4),a
player_justmoved3:
    exx;
    ret

;
; Stores the updated rows associated with the player
;
player_storeupdatedlines:
    ld bc,(player)          ; get the screen coords into bc 
    ld a,c                  ; get the player block coords of current block
    and 248                 ; find closest multiple of eight
    rrca
    rrca
    rrca                    ; divide by 8
    ld de,(screen_offset)          ; load the screen offset, this is in rows
    sub e
    push af
    call buffer_marklineforupdate  ; store current row in updated lines 
    pop af
    dec a 
    push af
    call buffer_marklineforupdate  ; store line above 
    pop af
    inc a 
    inc a 
    call buffer_marklineforupdate  ; store line beneath   
    ret