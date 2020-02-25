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
; Zeroes the state of each missile
;
missiles_init:
    ld b,12
    ld hl,level01missiles
missiles_init0:
    inc hl
    inc hl
    ld (hl),0               ; set the state to zero
    inc hl
    inc hl
    inc hl
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
    cp 75                                   ; have we reached the count yet
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
    call screen_getattraddressfromscreencoords ; get the attr address into de
    ld hl,de
    ld (hl),67          ; load this square with the magenta colour
    ld bc,(ix)
    ld a,c              ; get vertical
    sub 8               ; look up one square
    ld c,a              ; put a back in c
    call screen_getattraddressfromscreencoords ; get the attr address into de
    ld hl,de
    ld (hl),70          ; load this square with the yellow colour
missiles_fall1:         ; hl at state
    inc ix
    inc ix
    inc ix              ; get to next missile
    pop bc
    djnz missiles_fall0
    ret
missiles_fall2:
    ld (ix+2),0
    jp missiles_fall1   ; rejoin the loop

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
    ld a,1
    ld (de),a           ; set the state to falling
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