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
    push hl
    call sprites_scadd  ; calculate screen address.
    pop hl
    ld a,8              ; height of sprite in pixels.
sprites_drawsprite1: 
    ex af,af'           ; store loop counter.
    push de             ; store screen address.
    ld c,(hl)           ; first sprite graphic.
    inc hl              ; increment poiinter to sprite data.
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
    rr d                ; ...into right byte.
    dec a               ; one less shift to do.
    jr nz,sprites_drawsprite2 ; return until all shifts complete.
sprites_drawsprite0:
    pop hl              ; pop screen address from stack.
    ld a,(hl)           ; what's there already.
    xor c               ; merge in image data.
    ld (hl),a           ; place onto screen.
    inc hl
    ld a,(hl)           ; what's already there.
    xor d               ; right edge of sprite image data.
    ld (hl),a           ; plonk it on screen.
    ld a,(dispx)        ; vertical coordinate.
    inc a               ; next line down.
    ld (dispx),a        ; store new position.
    dec hl               
    ld de,32            ; add 32 to get to the next row
    add hl,de           ; add 32
sprites_drawsprite6: 
    ex de,hl            ; screen address in de.
    ld hl,(sprtmp)      ; restore graphic address.
    ex af,af'           ; restore loop counter.
    dec a               ; decrement it.
    jp nz,sprites_drawsprite1 ; not reached bottom of sprite yet to repeat.
    ret                 ; job done.

; Inputs:
; hl - sprite data
; bc - screen coords
;
sprites_draw2by2sprite7 
    xor 7               ; complement last 3 bits.
    inc a               ; add one for luck!
sprites_draw2by2sprite3 
    rl d                ; rotate left...
    rl c                ; ...into middle byte...
    rl e                ; ...and finally into left character cell.
    dec a               ; count shifts we've done.
    jr nz,sprites_draw2by2sprite3 ; return until all shifts complete.
                        ; Line of sprite image is now in e + c + d, we need it in form c + d + e.
    ld a,e              ; left edge of image is currently in e.
    ld e,d              ; put right edge there instead.
    ld d,c              ; middle bit goes in d.
    ld c,a              ; and the left edge back into c.
    jr sprites_draw2by2sprite0 ; we've done the switch so transfer to screen.
sprites_draw2by2sprite 
    ld (dispx),bc       ; store coords in dispx for now.
    ld a,c
    ld (sprtmp0),a         ; store vertical.
    push hl
    call sprites_scadd          ; calculate screen address.
    pop hl
    ld a,16             ; height of sprite in pixels.
sprites_draw2by2sprite1 
    ex af,af'           ; store loop counter.
    push de             ; store screen address.
    ld c,(hl)           ; first sprite graphic.
    inc hl              ; increment poiinter to sprite data.
    ld d,(hl)           ; next bit of sprite image.
    inc hl              ; point to next row of sprite data.
    ld (sprtmp),hl        ; store in tmp0 for later.
    ld e,0              ; blank right byte for now.
    ld a,b              ; b holds y position.
    and 7               ; how are we straddling character cells?
    jr z,sprites_draw2by2sprite0 ; we're not straddling them, don't bother shifting.
    cp 5                ; 5 or more right shifts needed?
    jr nc,sprites_draw2by2sprite7 ; yes, shift from left as it's quicker.
    and a               ; oops, carry flag is set so clear it.
sprites_draw2by2sprite2 
    rr c                ; rotate left byte right...
    rr d                ; ...through middle byte...
    rr e                ; ...into right byte.
    dec a               ; one less shift to do.
    jr nz,sprites_draw2by2sprite2 ; return until all shifts complete.
sprites_draw2by2sprite0 
    pop hl              ; pop screen address from stack.
    ld a,(hl)           ; what's there already.
    xor c               ; merge in image data.
    ld (hl),a           ; place onto screen.
    inc hl               ; next character cell to right please.
    ld a,(hl)           ; what's there already.
    xor d               ; merge with middle bit of image.
    ld (hl),a           ; put back onto screen.
    inc hl              ; next bit of screen area.
    ld a,(hl)           ; what's already there.
    xor e               ; right edge of sprite image data.
    ld (hl),a           ; plonk it on screen.
    ld a,(sprtmp0)         ; temporary vertical coordinate.
    inc a               ; next line down.
    ld (sprtmp0),a         ; store new position.
    dec hl 
    dec hl              
    ld de,32            ; add 32 to get to the next row
    add hl,de           ; add 32
sprites_draw2by2sprite6 
    ex de,hl            ; screen address in de.
    ld hl,(sprtmp)        ; restore graphic address.
    ex af,af'           ; restore loop counter.
    dec a               ; decrement it.
    jp nz,sprites_draw2by2sprite1 ; not reached bottom of sprite yet to repeat.
    ret                 ; job done.


;
; This routine returns a buffer address for (c, b) in de (c vert).
; For example: 0,0 will be at memory offset 0
; 1,0 (1 down) will be at memory offset 1
; 0,7 will be at memory offset 0
; 9,1 will be at memory offset 8+1
; 8,0 will be at memory offset 256
; 9,0 will be at memory offset 257   
; Outputs:
; de - coords
;
sprites_scadd: 
    ld a,c               ; calculate vertical offset 
    and 248             ;  to get nearest multiple of 8
    rrca
    rrca
    rrca                ; divide by 8
    ld h,a
    ld a,b               ; calculate horizontal offset 
    and 248             ;  to get nearest multiple of 8
    rrca
    rrca
    rrca                ; divide by 8
    ld l,a
    push bc             ; store the screen coords
    ld bc,hl            ; load bc with the character coords
    call screen_getbufferaddress
    pop bc              ; get back screen coords, de is now memory of character
    ld a,c              ; now add the vertical within the cell 
    and 7
    rrca                ; multiply by 32.
    rrca
    rrca
    ld l,a 
    ld h,0
    add hl,de
    ld de,hl
    ret

dispx   defb 0           ; general-use coordinates.
dispy   defb 0      
sprtmp  defb 0,0           ; sprite temporary address.
sprtmp0  defb 0,0           ; sprite temporary address.

