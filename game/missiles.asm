;
; Controls when missiles fall
;
missiles_count:
    defb 0

;
; A structure of falling missiles
; Assume we'll never have more than 4 falling at any one time
; (1,2 - 16 bit memory location for missile graphic),state (0 fell, 1 falling)
; 
missiles_falling:
    defb 0,0,0
    defb 0,0,0
    defb 0,0,0
    defb 0,0,0

;
; The coords of the missile that killed us
;
missiles_killermissile:
    defb 0,0

;
; Zeroes the state of each missile
;
missiles_init:
    ld b,12
    ld ix,level01missiles
missiles_init0:
    ld (ix+2),0               ; set the state to zero
    ld de,5
    add ix,de
    ld (ix+2),0
    add ix,de
    djnz missiles_init0
    ld b,4                  ; reset four falling missiles
    ld hl,missiles_falling
missiles_init1:
    ld (hl),0
    inc hl
    ld (hl),0
    inc hl
    ld (hl),0
    inc hl
    djnz missiles_init1
    ret

;
; Runs each frame and checks if a missile can fall, then selects one at random and adds to the falling missiles
; Processes any already falling missiles
;
missiles_process:
    ld a,(player+11)                        ; check if the player was hit by a missile previously
    cp 3
    jp nz,missiles_process3                 ; if not, continue
    call missiles_zonkplayer
    ret
missiles_process3:
    ld a,(player_location)
    cp 1
    jp nz, missiles_process0                ; if not 1 we're not in the cavern so no need to make any more fall
    ld hl,player+13
    ld a,(hl)                               ; check if player has collected a diamond
    cp 1
    jp nz, missiles_process0                ; don't activate if not
    ld hl,missiles_count
    ld a,(hl)                   ; get the missiles count
    inc a
    cp 50                                   ; have we reached the count yet
    jp z,missiles_process2                 ; if not, don't activate a new one
    ld (hl),a                               ; store the updated count, and continue without activating
    jp missiles_process0
missiles_process2:
    ld (hl),0                               ; zero the counter
    ld e,12
    call utilities_randomupper              ; get random number from 0 to 11
    ld de,10
    call utilities_multiply                 ; multiple random number by 10
    ld de,hl                                ; this is the offset for the random missile
    ld ix,level01missiles                   ; load the location of the missile definitions
    add ix,de                               ; get to location of missile
    ld a,(ix+2)
    cp 0
    jp z,missiles_process1                  ; if this missile isn't active, activate it
    ld de,5                                 ; otherwise, check the missile above
    add ix,de 
    ld a,(ix+2)
    cp 0
    jp nz,missiles_process0                 ; if this is active as well, the player got lucky 
missiles_process1:                          ; activate a missile
    ld (ix+2),1                               ; mark this missile as active
    ld bc,(ix)                              ; get char coords from the missile
    ld a,b
    ld de,(screen_offset)          ; load the screen offset, this is in rows
    sub e
    push bc
    call buffer_marklineforupdate
    pop bc
    call screen_getscreencoordsfromcharcoords ; get screen coords into bc
    push bc
    ld a,12                                 ; inactive missile sprite
    call screen_getblock 
    call sprites_drawsprite                 ; draw the sprite over the old one
    pop bc
    push bc
    ld a,20                                 ; active missile sprite
    call screen_getblock 
    call sprites_drawsprite                 ; draw the sprite over the old one
    pop bc
    call missiles_addmissiletofalling
missiles_process0:
    call missiles_fall
    ret

;
; Processes falling missiles
;
missiles_fall:
    ld b,4              ; number of possible falling missiles
    ld ix,missiles_falling
missiles_fall0:
    push bc
    ld a,(ix+2)
    cp 0
    jp z,missiles_fall1 ; not falling move to next
    cp 1                ; is this ready to fall
    jp z, missiles_fall3
    jp missiles_fall4   ; if not, decrease the countdown
missiles_fall3:
    ld bc,(ix)          ; load coords into bc
    call sprites_scadd  ; get the memory of the coords into de 
    inc d               ; add 256 to get next row
    ld a,(de)           ; get the contents of the next row
    cp 0
    jp nz,missiles_fall2 ; if this is not empty, stop this missile falling
    ld a,20                                 ; active missile sprite
    call screen_getblock 
    call sprites_drawsprite                 ; draw the sprite over the old one
    ld bc,(ix)          ; load coords into bc
    call missiles_storeupdatedlines
    ld bc,(ix)          ; load coords into bc
    inc c               ; move down one pixel
    ld (ix),bc          ; store the new coords
    ld a,20                                 ; active missile sprite
    call screen_getblock 
    call sprites_drawsprite                 ; draw the sprite
    ld bc,(ix)          ; load coords into bc
    ld a,c              ; get the vertical coord into a
    and 7               ; divisible by 8?
    cp 0
    jp nz,missiles_fall1   ; if not, carry on
    call screen_getcharcoordsfromscreencoords ; get the char coords into bc
    ld a,67             ; load magenta
    call screen_setattr
    ld bc,(ix)
    ld a,c              ; get vertical
    sub 8               ; look up one square
    ld c,a              ; put a back in c
    call screen_getattraddressfromscreencoords ; get the attr address into de
    ld hl,de
    ld (hl),70          ; load this square with the yellow colour
missiles_fall1:         ; hl at state
    ld bc,(ix)          ; get coords back
    call missiles_checkforplayer ; check for player
    inc ix
    inc ix
    inc ix              ; get to next missile
    pop bc
    djnz missiles_fall0
    ret
missiles_fall2:
    ld (ix+2),0
    jp missiles_fall1   ; rejoin the loop
missiles_fall4:
    dec a               ; decrease the countdown
    ld (ix+2),a         ; store back
    jp missiles_fall1   ; do next missile

;
; Stores the updated rows associated with the missiles
; Inputs:
; bc - coords
;
missiles_storeupdatedlines:
    ld a,c                  ; get the missile block coords of current block
    and 248                 ; find closest multiple of eight
    rrca
    rrca
    rrca                    ; divide by 8
    ld de,(screen_offset)          ; load the screen offset, this is in rows
    sub e
    push af
    call buffer_marklineforupdate  ; store current row in updated lines 
    pop af 
    inc a 
    call buffer_marklineforupdate  ; store line beneath   
    ret

;
; Adds the missile to the structure that tracks falling missile 
; Inputs:
; bc - coords of missile, c vert
missiles_addmissiletofalling:
    push bc             ; store the coords
    ld de,missiles_falling
    ld b,4              ; number of possible falling missiles
missiles_addmissiletofalling0:
    inc de
    inc de              ; move three along to get the state
    ld a,(de)           ; load the state
    cp 0                ; check if this is not falling
    jp nz,missiles_addmissiletofalling1 ; continue the loop if not 0
    ld a,25
    ld (de),a           ; set the state to pre-falling
    dec de              ; move back coords
    pop bc              ; get back coords
    ld a,b
    ld (de),a           ; store the vertical
    dec de
    ld a,c              
    ld (de),a           ; store the horizontal
    push bc
    jp missiles_addmissiletofalling2 ; done
missiles_addmissiletofalling1:
    inc de              ; move memory along to next rock
    djnz missiles_addmissiletofalling0 ; try the next missile
missiles_addmissiletofalling2: ; done, return
    pop bc              ; to tidy up
    ret

;
; Checks to see if the missile is hitting a player
; Inputs:
; bc - coords of missile we're checking
missiles_checkforplayer:
    ld de,(player)       ; get the player coords
    ld a,e               ; get the vert coord first 
    sub c                ; subtract the missile vertical coord from players 
    cp 8                 ; the missile will only hit a player if the player is directly underneath, so this must be 8
    ret nz               ; if not, hasn't hit
    ld a,d               ; get the player horiz coord 
    sub b                ; subtract missile coord 
    add 7                ; add max distance
    cp 13                ; compare to 13? if carry flag set, they've hit
    jp c,missiles_checkforplayer0
    ret
missiles_checkforplayer0:
    ld (missiles_killermissile),bc; store the coords of the killer missile
    call player_zonkplayer ; if so, jump out
    ret

;
; Player has been hit, so draw text over them and mark as dead
;
missiles_zonkplayer:
    call player_killplayer      ; mark as dead
    ld bc,(player)              ; get player coords
    call screen_getcharcoordsfromscreencoords ; get char coords
    dec c
    dec c
    push bc
    call screen_getcellattradress ; attrs here
    ld b,5
    ld a,66
    call screen_setcolours
    call buffer_buffertoscreen  ; copy buffer to screen
    pop bc
    ld de,(screen_offset)
    ld a,b
    sub e
    ld b,a                      ; subtract the offset
    inc b
    inc b                       ; add two for the score rows
    ld (string_zonk),bc         ; set coords of string
    ld hl,string_zonk
    call string_print
    ld b,20
    call utilities_pauseforframes ; pause
    ret
