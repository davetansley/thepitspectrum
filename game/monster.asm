
;
; Where the monster currently is
;
monster_currentcoords:
    defb 0,0

;
; The start coords of the monster
;
monster_initcoords:
    defb 112,27

;
; Store the memory location of the current jump position
;
monster_jumppos:
    defb 0,0

;
; The jump table for the monster. 
;
monster_jumptable:
    defb 255,3,2,2,2,2,2,2,2,2,1,1,1,1,1,1,255

;
; The vertical direction: 0 up, 1 down
;
monster_jumpdirectionvert:
    defb 0

;
; The horiz direction: 0 right, 1 left
;
monster_jumpdirectionhoriz:
    defb 0

;
; Frame offset, 0 or 32
;
monster_frameoffset:
    defb 0

;
; Monster tick
;
monster_tick:
    defb 0

;
; The colour of the monster
;
monster_colour:
    defb 6

;
; Initialises the pit monster
;
monster_init:
    ld bc,(monster_initcoords)              ; load the initial coords
    ld (monster_currentcoords),bc           ; save in current coords
    ld hl,monster_jumptable+1
    ld (monster_jumppos),hl                 ; store the initial position in the jump table
    ld a,0
    ld (monster_jumpdirectionvert),a        ; going up
    ld (monster_frameoffset),a
    ld (monster_tick),a
    call monster_draw                       ; the monster
    ret

;
; Animate the monster
;
monster_process:
    ld a,(monster_tick)                     ; check if we should draw this frame
    cp 1
    jp z,monster_process6
    inc a
    ld (monster_tick),a                     ; increase the tick and continue
    ret
monster_process6:
    ld a,0
    ld (monster_tick),a                     ; zero the tick
    call monster_draw                       ; overwrite the old sprite
    ld a,(monster_frameoffset)              ; get the anim frame offset
    xor 32                                  ; flip between 0 and 32
    ld (monster_frameoffset),a              ; store
    ld bc,(monster_currentcoords)           ; get the current coords
    ld hl,(monster_jumppos)                 ; get the position in the jump table
    ld d,(hl)                               ; get the jump modifier
    ld a,(monster_jumpdirectionvert)        ; get the vertical direction
    cp 0                                    ; if 0, going up, so dec vert
    jp nz,monster_process0 
    ld a,c
    sub d
    inc hl                                  ; move forward a jump pos
    jp monster_process1
monster_process0:
    ld a,c                                   ; going down so inc c
    add a,d
    dec hl                                  ; move back a jump pos
monster_process1:
    ld c,a                                  ; get the vertical coord back
    ld a,(hl)                               ; check the next jump pos
    cp 255                                  ; if 255 reverse
    jp z,monster_process3
    ld (monster_jumppos),hl                 ; store the new pos
    jp monster_process2                     ; keep going
monster_process3:
    ld a,(monster_jumpdirectionvert)        ; get the direction
    xor 1                                   ; flip it
    ld (monster_jumpdirectionvert),a        ; store it
    cp 1
    jp z,monster_process2
    exx
    call monster_colourchange
    exx
monster_process2:
    ld a,(monster_jumpdirectionhoriz)       ; get the horiz direction
    cp 0                                    ; is it right?
    jp nz,monster_process4
    inc b                                   ; 1 pixel right
    ld a,b
    cp 56                                   ; reached the edge of the pit?
    jp nz,monster_process5
    ld a,(monster_jumpdirectionhoriz)
    xor 1
    ld (monster_jumpdirectionhoriz),a       ; flip direction
    jp monster_process5
monster_process4:
    dec b                                   ; 1 pixel left
    ld a,b
    cp 24                                   ; reached the edge of the pit?
    jp nz,monster_process5
    ld a,(monster_jumpdirectionhoriz)
    xor 1
    ld (monster_jumpdirectionhoriz),a       ; flip direction
monster_process5:
    ld (monster_currentcoords),bc           ; store the new vertical coords
    call monster_draw                       ; finally, draw the monster
    ret

;
; Draw the monster at the current location
;
monster_draw:
    ld bc,(monster_currentcoords)
    ld a,(monster_frameoffset)
    ld de,0
    ld e,a
    ld hl,monster_sprite                    ; load the first frame
    add hl,de
    call sprites_draw2by2sprite 
    ret

;
; Changes the monster colour whenever it reaches the bottom of its jump
;
monster_colourchange:
    ld a,(monster_colour)
    inc a
    cp 7
    jp nz, monster_colourchange0
    ld a,1
monster_colourchange0:
    ld (monster_colour),a                   ; save the monster colour
    ld a,(screen_offset)
    cp 0
    jp z,monster_colourchange1
    ld a,(monster_colour)                   ; get the monster colour
    ld b,6
    ld c,64
    add c                                   ; want this with black background, so add 64
    ld de,22528+163                         ; attrs here 
    call screen_setcolours
    ld a,(monster_colour)                   ; get the monster colour
    ld b,6
    ld c,64
    add c                                   ; want this with black background, so add 64
    ld de,22528+195                         ; attrs here 
    call screen_setcolours
    ld a,(monster_colour)                   ; get the monster colour
    or 96
    ld b,6    
    ld de,22528+227                         ; attrs here 
    call screen_setcolours
    ret
monster_colourchange1:
    ld a,(monster_colour)                   ; get the monster colour
    ld b,6
    ld c,64
    add c                                   ; want this with black background, so add 64
    ld de,22528+419                         ; attrs here 
    call screen_setcolours
    ld a,(monster_colour)                   ; get the monster colour
    ld b,6
    ld c,64
    add c                                   ; want this with black background, so add 64
    ld de,22528+451                         ; attrs here 
    call screen_setcolours
    ld a,(monster_colour)                   ; get the monster colour
    or 96
    ld b,6    
    ld de,22528+483                         ; attrs here 
    call screen_setcolours
    ret