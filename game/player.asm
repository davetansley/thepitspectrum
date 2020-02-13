;
;   Data for current player
;   horiz,vert,dir (0 up/down, 1 left, 2 right), frame, frame transition count,move remaining, is digging (0 no), digging count
player:
    defb    0,0,2,0,1,0,0,0
;
; Initializes a player
;
player_init:
    ld bc,(start_coord)
    ld (player),bc
    ret

;
; Draws the player at the current position or deletes them
;
player_drawplayer:
    ld a,(player+2)             ; get the current direction
    ld e,a                      ; store in e
    ld a,(player+3)             ; get the current frame
    add a,e
    rlca
    rlca
    rlca                        ; multiply by eight
    ld l,a
    ld h,0              
    ld de,player_sprite
    add hl,de                   ; load hl with the location of the player sprite data
player_drawplayer0:
    ld bc,(player)         ; load bc with the start coords
    call sprites_drawsprite     ; call the routine to draw the sprite
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