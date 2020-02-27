diamonds_tmp: 
    defb 0

diamonds_tmp2:
    defb 0

;
; Holds the number of thousands for the current gem type
;
diamonds_score:
    defb 0

;
; Changes the attribute of gem and diamond cells based on the frame count
; Inputs:
; hl - memory location of gem type
diamonds_twinkle_type:
    call game_getcurrentframe       ; get current frame number
    and 7                           ; want a number from 0-7
    add 64                          ; add to 60 to get attr colour
    ld (diamonds_tmp2),a             ; store the colour
diamonds_twinkle_type0:
    ld bc,(hl)                      ; get coords into bc
    ld a,c                          ; load c into a
    cp 255                          ; is this the end?
    jp z,diamonds_twinkle_type1           ; step out if so
    inc hl
    inc hl
    ld a,(hl)                       ; check the state, don't process if collected
    cp 1
    jp z,diamonds_twinkle_type2           ; step out if so
    call diamonds_checkforplayer    ; check to see if we've collided with player
    call c,diamonds_collect     ; we collided
    inc hl 
    push hl
    ld ix,hl
    ld bc,(ix-3)                    ; get coords again
    ld a,(diamonds_tmp2)
    call screen_setattr
    pop hl
    inc hl
    inc hl                          ; move to next diamond 
    jp diamonds_twinkle_type0
diamonds_twinkle_type1:
    ret
diamonds_twinkle_type2:
    inc hl                          ; do stuff the we would have done anyway to get to next gem
    inc hl
    inc hl
    ex af,af'
    jp diamonds_twinkle_type0       ; rejoin main loop

;
; Collect the diamond we collided with
; Inputs:
; hl - memory location of current diamond, currently on state
; Output:
; a - 70 - for yellow on black
diamonds_collect:
    ld (hl),1                       ; collected
    push hl
    dec hl
    dec hl
    ld bc,(hl)                      ; get the coords
    call screen_getscreencoordsfromcharcoords ; get the screen coords into bc
    ld de,(diamonds_tmp)            ; tmp stores the offset for this type of gem
    ld d,0
    ld hl,sprites
    add hl,de
    call sprites_drawsprite     ; call the routine to draw the sprite
    pop hl
    ld a,70                     ; pass this back to overwrite the attr
    ld (diamonds_tmp2),a
    exx
    ld a,(diamonds_score)
    ld b,a
    call scores_addthousands
    ld a,(diamonds_tmp)
    cp 64                       ; check the gem type offset, if its 64 this is a diamond, so mark the level as completable
    jp nz,diamonds_collect0      
    ld hl,player+13
    ld (hl),1                   ; mark the player as able to complete the level
diamonds_collect0:  
    call sound_gemcollected
    exx
    ret

;
; Checks to see if the gem is hitting a player
; Inputs:
; bc - coords of diamond we're checking
diamonds_checkforplayer:
    ld a,b               ; multiply b by 8
    rlca 
    rlca 
    rlca
    ld b,a
    ld de,(player)       ; get the player coords
    ld a,e               ; get the vert coord first 
    sub b                ; subtract the diamond vertical coord from players 
    add 4                ; add the max distance
    cp 9                ; compare to max*2+1? if carry flag set, they've hit
    ret nc               ; if not, hasn't hit
    ld a,c               ; multiply c by 8
    rlca 
    rlca 
    rlca
    ld c,a
    ld a,d               ; get the player horiz coord 
    sub c                ; subtract rock coord 
    add 4                ; add max distance
    cp 9                ; compare to max*2+1? if carry flag set, they've hit
    ret nc
    ld a,0
    ret


;
; Initialise diamonds and gems
; 
diamonds_twinkle
    ld hl,diamonds_score
    ld (hl),2         ; store the score we'll add   
    ld hl,diamonds_tmp
    ld (hl),64         ; store the location the diamond sprite
    ld hl, level01diamonds
    call diamonds_twinkle_type
    ld hl,diamonds_score
    ld (hl),1         ; store the score we'll add
    ld hl,diamonds_tmp
    ld (hl),112         ; store the location the gem sprite
    ld hl, level01gems
    call diamonds_twinkle_type
    ret

;
; Initialise diamonds and gems
; 
diamonds_init:
    ld hl, level01diamonds
    call diamonds_init_type
    ld hl, level01gems
    call diamonds_init_type
    ret

;
; Initialise diamonds or gems, get memory addresses
; Inputs:
; hl - memory location
diamonds_init_type:
    ld c,(hl)                      ; get coords into c
    ld a,c                          ; load c into add
    cp 255                          ; is this the end?
    jp z,diamonds_init_type1             ; step out if so
    inc hl
    ld b,(hl)                       ; get coords into b
    push hl
    call screen_getcellattroffset ; get memory of attr for this diamond into de 
    pop hl
    inc hl                          ; move to state 
    ld (hl),0
    inc hl                          ; move to memory
    ld (hl),de                      ; store the memory location 
    inc hl                          ; move to next diamond 
    inc hl
    jp diamonds_init_type
diamonds_init_type1:
    ret