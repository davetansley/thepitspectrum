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
    defb    0,0                 ; crushed (+11), frames (+12)
    defb    0                   ; can finish level, whether can finish level or not (+13)

player_location:
    defb 0                      ; 0 normal, 1 diamond cavern, 2 the pit

;
; Works out which part of the screen the player is in
; Pit is between 3,9 and 8,9
; Diamond cavern is between 11,22 and 22,28
;
player_getlocation:
    ld bc,(player)              ; get screen coords
    call screen_getcharcoordsfromscreencoords ; get char coords, c horiz
    ld a,b                      ; check for pit first
    cp 9                        ; if not on this row, not in the pit
    jp nz,player_getlocation0
    ld a,c                      ; check horizontal
    cp 8
    jp nc, player_getlocation0  ; if more than 8, not in the pit
    ld hl,player_location
    ld (hl),2                   ; load location with 2, the pit
    ret                         ; done
player_getlocation0:            ; check for diamond cavern
    ld a,b                      ; first check vertical
    cp 22                       ; if above row 22, then not in cavern
    jp c,player_getlocation1
    ld a,c                      ; get the horizontal next
    cp 11
    jp c,player_getlocation1    ; if less than 11 not in diamond cave
    cp 22
    jp nc,player_getlocation1    ; if less than 11 not in diamond cave
    ld hl,player_location
    ld (hl),1                   ; load location with 1, the cavern
    ret  
player_getlocation1:   
    ld hl,player_location
    ld (hl),0                   ; load location with 2, the pit
    ret                         ; done
    

;
; Initializes a player at start of game
; Copy initial coords, copy lives, copy score
;
player_init_gamestart:
    ld a,(game_numberlives)
    ld (player1_lives),a
    ld (player2_lives),a                        ; set the initial number of lives at game start

    ld hl,player1_score+2
    ld b,6
player_init_gamestart0:
    ld (hl),48
    inc hl
    djnz player_init_gamestart0                 ; zero out player 1 score
    ld hl,player2_score+2
    ld b,6
player_init_gamestart1:
    ld (hl),48
    inc hl
    djnz player_init_gamestart1                 ; zero out player 2 score
    ret

;
; Initializes a player at start of a life
; Copy initial coords, copy lives, copy score
;
player_init_lifestart:
    ld hl,player+5
    ld b,9                      ; initialise 9 properties
player_init_lifestart2:
    ld (hl),0
    inc hl
    djnz player_init_lifestart2

    ld hl,player+2              ; initialise some properties
    ld (hl),2
    inc hl 
    ld (hl),0
    inc hl
    ld (hl),1

    ld bc,(init_coord)
    ld (player),bc
    ld bc,player+9
    ld a,(player1_lives)
    ld (bc),a
    
    call diamonds_init      ; initialise gems

    ld bc,6
    ld de,scores_current+2
    ld a,(game_currentplayer)
    cp 1
    jp nz,player_init_lifestart0
    ld hl,player1_score+2
    jp player_init_lifestart1
player_init_lifestart0:
    ld hl,player2_score+2
player_init_lifestart1:
    ldir
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
    call player_recordcurrentscore
    ret

;
; Copies the current score in the current
;
player_recordcurrentscore:
    ld bc,6                  ; copy current score back to correct player
    ld hl,scores_current+2
    ld a,(game_currentplayer)
    cp 1
    jp nz,player_lifeend0
    ld de,player1_score+2
    jp player_lifeend1
player_lifeend0:
    ld de,player2_score+2
player_lifeend1:
    ldir
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
    defb 4,1,'000000',255
player2_score:
    defb 22,1,'000000',255

;
; Kills a player this life
;
player_killplayer:
    ld hl,player+10
    ld (hl),1
    ret

;
; Crush a player this life
;
player_crushplayer:
    ld hl,player+11             ; mark as crushed
    ld (hl),1
    ret

player_tankkillplayer
    ld hl,player+11             ; mark as tanked
    ld (hl),2
    ret

player_zonkplayer
    ld hl,player+11             ; mark as zonked (missile)
    ld (hl),3
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
    ld a,(player+11)             ; get the dying flag
    cp 1
    jp z,player_drawplayer3     ; if it's one, we're being crushed
player_drawplayer4:
    ld a,(player+6)             ; get the dig flag
    cp 1
    jp z,player_drawplayer1    ; get dig frame
    ld a,(player+3)             ; this is normal movement so get the current frame
    add a,e
    jp player_drawplayer2
player_drawplayer3:
    ld hl,player+12
    ld a,(hl)                  ; crushing, so get the current anim flag
    cp 0
    jp nz,player_drawplayer5    ; if this isn't zero, then this isn't the first time round, so do the crush anim
    ld a,100
    ld (hl),a                   ; otherwise, load up the anim frames 
    jp player_drawplayer4       ; and return to the main loop to remove the current frame
player_drawplayer5:
    dec a 
    ld (hl),a
    cp 0
    call z,player_killplayer     ; final animation, so kill the player
    cp 10                         ; play the sound
    call z, sound_rockfell
    cp 20                        ; check if we should move the rock
    jp nz,player_drawplayer8
    exx 
    push af
    ld bc,(rocks_killerrock)    ; get the coords of the rock that killed us
    ld hl,sprites+72
    call sprites_drawsprite     ; draw a rock over current 
    pop af
    exx
    jp player_drawplayer6       ; continue drawing player
player_drawplayer8:
    cp 20
    jp nc,player_drawplayer6    ; if not in last 10 frames, draw as normal
    ld bc,(player)
    call screen_getcharcoordsfromscreencoords ; get the char coords into bc
    ld a,66             ; load red
    call screen_setattr
    ld hl,sprites+72            ; otherwise, player is rock
    jp player_drawplayer7
player_drawplayer6:
    and 1                       ; check for odd
    add 10                      ; add 10, to get either 10 or 11
    jp player_drawplayer2
player_drawplayer1:
    ld a,(player+2)             ; digging, get the current direction again, because want all four
    add a,6                     ; add direction to 6 to get frame    
player_drawplayer2:
    rlca
    rlca
    rlca                        ; multiply by eight
    ld l,a
    ld h,0  
    ld de,player_sprite
    add hl,de                   ; load hl with the location of the player sprite data
player_drawplayer7:
    ld bc,(player)              ; load bc with the start coords
    call sprites_drawsprite     ; call the routine to draw the sprite
    ;call player_storeupdatedlines ; log updated rows
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
; Called if the player has collected a diamond. Checks the current coord. If it is the start coord, then return complete
; Outputs:
; a - 1 for completed level
player_checkforexit:
    ld bc,(player)                 ; get player coords
    ld de,(init_coord)             ; get start coords
    ld a,b
    cp d                         ; compare horiz
    jp nz,player_checkforexit1
    ld a,c
    cp e                        ; compare vert
    jp nz,player_checkforexit1
player_checkforexit0:
    ld a,1                       ; hasn't completed
    ret
player_checkforexit1:
    ld a,0                       ; has completed
    ret