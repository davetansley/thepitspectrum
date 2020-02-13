;
;   Data for current player
;   horiz,vert,dir (0 up, 1 left, 2 right, 3 down), frame, frame transition count,move remaining, is digging (0 no), digging count, pixels to dig
player:
    defb    0,0,2,0,1,0,0,0,0
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