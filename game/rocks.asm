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

rocks_tmp2:
    defb 0,0

;
; The number of frames to wobble for
; Must always be 10 more than the number of frames a player digs
;
rocks_numberofframestowobble:
    defb 20

;
; Coords of the rock that killed us
;
rocks_killerrock:
    defb 0,0

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
    ;inc de
    inc de              ; move three along to get the state
    ld a,(de)           ; load the state
    cp 0                ; check if this is not falling
    jp nz,rocks_addrocktofalling1 ; continue the loop if not 0
    inc de              ; move to frame
    ld a,(rocks_numberofframestowobble) ; load the number of frames to wobble
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
    inc de
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
    jp z,rocks_processrocks3 ; if not falling, check next
    cp 2
    jp nz, rocks_processrocks2
    ; we're wobbling
    inc ix              ; get frame number for wobble
    ld a,(ix)           ; get wobble frame into a
    call rocks_wobble
    inc ix              ; increment for next
    jp rocks_processrocks1  ; do next rock
rocks_processrocks2:
    ; we're falling
    push bc
    call rocks_fall
    pop bc
    inc ix
    inc ix              ; inc ix to get to next
    jp rocks_processrocks1 
rocks_processrocks3:
    inc ix 
    inc ix
rocks_processrocks1: 
    pop bc              ; get loop count back         
    djnz rocks_processrocks0
    ret

;
; Falls a rock one pixel, checks the next square down to see if it is empty, if not, stop falling
; bc - coord of current rock graphic on screen
; ix - memory location of current rock in rock list, currently at the 3rd position (rock state)
;
rocks_fall:
    dec ix
    dec ix              ; decrease ix back to coords
    ld (rocks_tmp2),bc  ; store original coords
    ld a,3              ; move this number of pixels
rocks_fall1:
    ld (rocks_tmp),a    ; store loop counter
    ld bc,(ix)          ; get current coords
    call sprites_scadd  ; get the memory of the coords into de 
    inc d               ; add 256 to get next row
    ld a,(de)           ; get the contents of the next row
    cp 0
    jp nz,rocks_fall3    ; move the rock if the row is empty
    inc c               ; increment the vertical
    ld (ix),bc          ; store the new coords
    ld a,c              ; get the vertical coord into a
    and 7               ; divisible by 8?
    cp 0
    jp nz,rocks_fall4   ; if not, carry on
    call screen_getcharcoordsfromscreencoords ; get the char coords into bc
    ld a,66             ; load red
    call screen_setattr
    ld bc,(ix)
    ld a,c              ; get vertical
    sub 8               ; look up one square
    ld c,a              ; put a back in c
    call screen_getcharcoordsfromscreencoords ; get the char coords into bc
    ld a,70             ; load yellow
    call screen_setattr
rocks_fall4:
    ld a,(rocks_tmp)    ; get the loop counter
    dec a
    cp 0
    jp nz,rocks_fall1   ; do another pixel if needed
rocks_fall2:
    ld a,9              ; rock graphic
    ld bc,(rocks_tmp2)  ; get the original coords
    call screen_getblock     ; get the memory into hl
    call sprites_drawsprite  ; draw the sprite - over the top of the current one
    ld a,9
    ld bc,(ix)          ; get the new coords
    call screen_getblock     ; get the memory into hl
    call sprites_drawsprite  ; draw the sprite - over the top of the current one
    ld bc,(ix)          ; get the coords again
    call rocks_checkforplayer ; check to see if we hit a player
    inc ix
    inc ix                  ; get ix back to state
    call rocks_makesound
    ret
rocks_fall3:
    ld a,0              ; set the state to fell
    ld (ix+2),a           ; store the falling state
    ld bc,(ix)          ; get the coords
    call screen_getcharcoordsfromscreencoords ; get the char coords into bc
    ld a,66             ; load magenta
    call screen_setattr
    jp rocks_fall2      ; rejoin main loop

;
; Makes the rock sound if we're no longer falling, and if we didn't hit a player
;
rocks_makesound:
    ld a,(ix)           ; get the state
    cp 0
    ret nz              ; if we haven't fallen, don't do anything
    ld hl,player+11
    ld a,(hl)
    cp 1
    call nz, sound_rockfell ; only make sound if didn't kill player
    ret

;
; Checks to see if the rock is hitting a player
; Inputs:
; bc - coords of rock we're checking
rocks_checkforplayer:
    ld de,(player)       ; get the player coords
    ld a,e               ; get the vert coord first 
    sub c                ; subtract the rock vertical coord from players 
    cp 8                 ; the rock will only hit a player if the player is directly underneath, so this must be 8
    ret nz               ; if not, hasn't hit
    ld a,d               ; get the player horiz coord 
    sub b                ; subtract rock coord 
    add 7                ; add max distance
    cp 13                ; compare to 13? if carry flag set, they've hit
    jp c,rocks_checkforplayer0
    ret
rocks_checkforplayer0:
    ld (rocks_killerrock),bc; store the coords of the killer rock
    call player_crushplayer ; if so, jump out
    ret

;
; Wobbles a rocks
; Inputs:
; bc - coord of current rock graphic on screen
; ix - memory location of current rock in rock list, currently at the 4th position (wobble count)
; a - wobble frame
rocks_wobble:
    ld a,(ix)           ; get the wobble count, which we'll use as frame toggle
    and 1               ; is it odd or even, gets 1 or 0
    ld e,9              ; this is the rock frame
    add a,e             ; add the frame toggle
    push bc
    call screen_getblock     ; get the memory into hl
    call sprites_drawsprite  ; draw the sprite - over the top of the current one
    ld a,(ix)           ; get the frame toggle again
    dec a               ; decrease
    ld (ix),a           ; store
    and 1
    ld e,9              ; this is the rock frame
    add a,e             ; add the frame toggle
    call screen_getblock     ; get the memory into hl
    pop bc
    call sprites_drawsprite  ; draw the sprite again with the new frame - next time it will do the opposite
    ld a,(ix)           ; get the wobble count back
    cp 0
    ret nz              ; if we're not at zero, return
    dec ix              ; otherwise look to state location
    ld a,1              ; set the state to falling
    ld (ix),a           ; store the falling state
    inc ix              ; set ix back to location of wobble count, and we're done
    ret
