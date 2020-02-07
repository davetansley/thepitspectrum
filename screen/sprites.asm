;
; This is the sprite routine and expects coordinates in (c ,b) form,
; where c is the vertical coord from the top of the screen (0-176), and
; b is the horizontal coord from the left of the screen (0 to 240).
; Sprite data is stored as you'd expect in its unshifted form as this
; routine takes care of all the shifting itself. This means that sprite
; handling isn't particularly fast but the graphics only take 1/8th of the
; space they would require in pre-shifted form.
; Inputs:
; hl - sprite data
; bc - screen coords
;
sprites_drawsprite7:  
    xor 7               ; complement last 3 bits.
    inc a               ; add one for luck!
sprites_drawsprite3:
    ;rl d                ; rotate left...
    rl c                ; ...into middle byte...
    rl d                ; ...and finally into left character cell.
    dec a               ; count shifts we've done.
    jr nz,sprites_drawsprite3 ; return until all shifts complete.
                        ; Line of sprite image is now in e + c + d, we need it in form c + d + e.
    ld a,c              ; left edge of image is currently in e.
    ld c,d              ; put right edge there instead.
    ld d,a              ; and the left edge back into c.
    jr sprites_drawsprite0   ; we've done the switch so transfer to screen.
sprites_drawsprite: 
    ld (dispx),bc       ; store coords in dispx for now.
    call sprites_scadd  ; calculate screen address.
    ld a,8              ; height of sprite in pixels.
sprites_drawsprite1: 
    ex af,af'           ; store loop counter.
    push de             ; store screen address.
    ld c,(hl)           ; first sprite graphic.
    inc hl              ; increment poiinter to sprite data.
    ;ld d,(hl)           ; next bit of sprite image.
    ;inc hl              ; point to next row of sprite data.
    ld (sprtmp),hl      ; store it for later.
    ld d,0              ; blank right byte for now.
    ld a,b              ; b holds y position.
    and 7               ; how are we straddling character cells?
    jr z,sprites_drawsprite0 ; we're not straddling them, don't bother shifting.
    cp 5                ; 5 or more right shifts needed?
    jr nc,sprites_drawsprite7 ; yes, shift from left as it's quicker.
    and a               ; oops, carry flag is set so clear it.
sprites_drawsprite2:
    rr c                ; rotate left byte right...
    ;rr d                ; ...through middle byte...
    rr d                ; ...into right byte.
    dec a               ; one less shift to do.
    jr nz,sprites_drawsprite2 ; return until all shifts complete.
sprites_drawsprite0:
    pop hl              ; pop screen address from stack.
    ld a,(hl)           ; what's there already.
    xor c               ; merge in image data.
    ld (hl),a           ; place onto screen.
    ;inc l               ; next character cell to right please.
    ;ld a,(hl)           ; what's there already.
    ;xor d               ; merge with middle bit of image.
    ;ld (hl),a           ; put back onto screen.
    inc l               ; next bit of screen area.
    ld a,(hl)           ; what's already there.
    xor d               ; right edge of sprite image data.
    ld (hl),a           ; plonk it on screen.
    ld a,(dispx)        ; vertical coordinate.
    inc a               ; next line down.
    ld (dispx),a        ; store new position.
    and 63              ; are we moving to next third of screen?
    jr z,sprites_drawsprite4 ; yes so find next segment.
    and 7               ; moving into character cell below?
    jr z,sprites_drawsprite5 ; yes, find next row.
    dec l               ; left 2 bytes.
    ;dec l               ; not straddling 256-byte boundary here.
    inc h               ; next row of this character cell.
sprites_drawsprite6: 
    ex de,hl            ; screen address in de.
    ld hl,(sprtmp)      ; restore graphic address.
    ex af,af'           ; restore loop counter.
    dec a               ; decrement it.
    jp nz,sprites_drawsprite1 ; not reached bottom of sprite yet to repeat.
    ret                 ; job done.
sprites_drawsprite4: 
    ld de,31            ; next segment is 30 bytes on.
    add hl,de           ; add to screen address.
    jp sprites_drawsprite6   ; repeat.
sprites_drawsprite5: 
    ld de,63775         ; minus 1762.
    add hl,de           ; subtract 1762 from physical screen address.
    jp sprites_drawsprite6   ; rejoin loop.

;
; This routine returns a screen address for (c, b) in de.
; Inputs:
; de - coords
;
sprites_scadd: 
    ld a,c              ; get vertical position.
    and 7               ; line 0-7 within character square.
    add a,64            ; 64 * 256 = 16384 (Start of screen display)
    ld d,a              ; line * 256.
    ld a,c              ; get vertical again.
    rrca                ; multiply by 32.
    rrca
    rrca
    and 24              ; high byte of segment displacement.
    add a,d             ; add to existing screen high byte.
    ld d,a              ; that's the high byte sorted.
    ld a,c              ; 8 character squares per segment.
    rlca                ; 8 pixels per cell, mulplied by 4 = 32.
    rlca                ; cell x 32 gives position within segment.
    and 224             ; make sure it's a multiple of 32.
    ld e,a              ; vertical coordinate calculation done.
    ld a,b              ; y coordinate.
    rrca                ; only need to divide by 8.
    rrca
    rrca
    and 31              ; squares 0 - 31 across screen.
    add a,e             ; add to total so far.
    ld e,a              ; hl = address of screen.
    ret

dispx   defb 0           ; general-use coordinates.
dispy   defb 0      
sprtmp  defb 0           ; sprite temporary address.

