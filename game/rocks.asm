;
; A structure of falling rocks
; Assume we'll never have more than 4 falling at any one time
; (1,2 - 16 bit memory location for rock graphic),state (0 fell, 1 falling, 2 wobbling), countdown
; 
rocks_falling:
    defb 0,0,0,0
    defb 0,0,0,0
    defb 0,0,0,0
    defb 0,0,0,0

rocks_tmp:
    defb 0

;
; Checks for a rock that needs to start falling. Takes a memory location of the first line at the bottom of the space.
; Checks to see if the pixel row in that location is a rock bottom. If it is, mark this rock as ready to fall.
; If the pixel row is not the rock bottom, stop checking.
; Inputs:
; hl- memory location
;
rocks_checkforfalling:
    ld a,(hl)           ; get the pixel row in this memory location
    cp 126              ; check against the bottom pixel row of the rock graphic
    jp nz,rocks_checkforfalling2 ; not a rock, stop
    call rocks_addrocktofalling ; mark the rock as falling
rocks_checkforfalling2:
    ret

;
; Adds the rock to the structure that tracks falling rocks 
; Inputs:
; hl - memory location of falling rock graphic
; bc - coords of rock, c vert
rocks_addrocktofalling:
    push bc             ; store the coords
    ld de,rocks_falling
    ld b,4              ; number of possible falling rocks
rocks_addrocktofalling0:
    inc de
    inc de
    inc de              ; move three along to get the state
    ld a,(de)           ; load the state
    cp 0                ; check if this is not falling
    jp nz,rocks_addrocktofalling1 ; continue the loop if not 0
    ld a,10             ; load the number of frames to wobble
    ld (de),a
    dec de              ; move de back to state
    ld a,2
    ld (de),a           ; set the state to wobbling
    dec de              ; move back coords
    pop bc              ; get back coords
    ld a,b
    ld (de),a           ; store the vertical
    dec de
    ld a,c              
    ld (de),a           ; store the horizontal
    push bc
    jp rocks_addrocktofalling2 ; done
rocks_addrocktofalling1:
    inc de              ; move memory along to next rock
    djnz rocks_addrocktofalling0 ; try the next rock
rocks_addrocktofalling2: ; done, return
    pop bc              ; to tidy up
    ret

;
; Processes any falling rocks
;
rocks_processrocks:
    ld ix,rocks_falling
    ld b,4              ; the number of rocks to check
rocks_processrocks0:
    push bc             ; store loop count
    ld bc,(ix)          ; load the coords for this rock into bc
    inc ix
    inc ix              ; move to the state
    ld a,(ix)           ; load the state into a
    cp 0
    jp z,rocks_processrocks1 ; if not falling, check next
    cp 2
    jp nz, rocks_processrocks2
    ; we're wobbling
    inc ix              ; get frame number for wobble
    ld a,(ix)           ; get wobble frame into a
    call rocks_wobble
    inc ix              ; increment for next
    jp rocks_processrocks1  ; do next rock
    ; we're falling
    inc ix
    inc ix              ; inc de to get to next 
rocks_processrocks2:
rocks_processrocks1: 
    pop bc              ; get loop count back         
    djnz rocks_processrocks0
    ret

;
; Wobbles a rocks
; Inputs:
; bc - coord of current rock graphic on screen
; ix - memory location of current rock in rock list, currently at the 4th position (wobble count)
; a - wobble frame
rocks_wobble:
    ld a,(rocks_tmp)    ; get the frame toggle
    ld e,9              ; this is the rock frame
    add a,e             ; add the frame toggle
    push bc
    call screen_getblock     ; get the memory into hl
    call sprites_drawsprite  ; draw the sprite - over the top of the current one
    ld a,(rocks_tmp)    ; get the frame toggle against
    xor 1               ; flip to other state
    ld (rocks_tmp),a    ; store
    ld e,9              ; this is the rock frame
    add a,e             ; add the frame toggle
    call screen_getblock     ; get the memory into hl
    pop bc
    call sprites_drawsprite  ; draw the sprite again with the new frame - next time it will do the opposite
    ld a,(ix)           ; get the wobble count back
    dec a               ; decrease
    ld (ix),a           ; store
    cp 0
    ret nz              ; if we're not at zero, return
    dec ix              ; otherwise look to state location
    ld a,1              ; set the state to falling
    ld (ix),a           ; store the falling state
    inc ix              ; set ix back to location of wobble count, and we're done
    ret
