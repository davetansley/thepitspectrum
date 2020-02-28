
;
; Where the monster currently is
;
monster_currentcoords:
    defb 0,0

;
; The start coords of the monster
;
monster_initcoords:
    defb 112,32

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
; Initialises the pit monster
;
monster_init:
    ld bc,(monster_initcoords)              ; load the initial coords
    ld (monster_currentcoords),bc           ; save in current coords
    ld hl,monster_jumptable+1
    ld (monster_jumppos),hl                 ; store the initial position in the jump table
    ld a,0
    ld (monster_jumpdirectionvert),a        ; going up
    call monster_draw                       ; the monster
    ret

;
; Animate the monster
;
monster_process:
    call monster_draw                       ; overwrite the old sprite
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
    ld (monster_currentcoords),bc           ; store the new vertical coords
    ld a,(hl)                               ; check the next jump pos
    cp 255                                  ; if 255 reverse
    jp z,monster_process3
    ld (monster_jumppos),hl                 ; store the new pos
    jp monster_process2                     ; keep going
monster_process3:
    ld a,(monster_jumpdirectionvert)        ; get the direction
    xor 1                                   ; flip it
    ld (monster_jumpdirectionvert),a        ; store it
monster_process2:
    call monster_draw                       ; finally, draw the monster
    ret

;
; Draw the monster at the current location
;
monster_draw:
    ld bc,(monster_currentcoords)
    ld hl,monster_sprite                    ; load the first frame
    call sprites_draw2by2sprite 
    ret