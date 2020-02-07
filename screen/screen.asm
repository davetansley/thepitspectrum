screen_offset:
    defb 0                      ; the number of rows to offset the screen

;
; Draw the screen
; Inputs:
; none
; Notes:
; The value held at screen_offset tells the screen how many rows to scroll down. Set to five to bottom out.
screen_draw:
    ld c,0                      ; horiz
    ld b,0                      ; vert, 0 at top
    ld ix,level01               ; point ix at level data
    ld a,(screen_offset)        ; load offset, will be in blocks, we want multiples of 32, so x32
    rrca
    rrca
    rrca
    ld e,a
    ld d,0
    add ix,de                   ; add the offset
    ld iy,22528                 ; point iy at attr data
    ;add iy,de                   ; add the offset
screen_draw0:
    ld a,(ix)                   ; load the block number
    push bc                     ; store bc, contains loop count
    call screen_getattr         ; get the memory location for this cell's attr into hl
    ld a,(hl)                   ; get the attr value at the address
    ld (iy),a                   ; load the attr into memory
    ld a,(ix)                   ; load the block number
    call screen_getblock        ; get the block data into hl
    call screen_showchar        ; show this character here
    pop bc                      ; get the loop counter back
    inc ix                      ; increment level location
    inc iy                      ; increment attr location
    inc c                       ; increment horiz
    ld a,c                      
    cp 32                       ; check if horiz has reach edge of screen
    jp nz,screen_draw0          ; if not, loop
    ld c,0                      ; if so, reset horiz
    inc b                       ; increment vertical
    ld a,b                  
    cp 24                       ; check if at bottom
    jp nz,screen_draw0          ; if not, loop
    call screen_initrocks       ; draw rocks
    ld hl,player_sprite       ; load hl with the location of the player sprite data
    ld bc,(start_coord)         ; load bc with the start coords
    call sprites_drawsprite     ; call the routine to draw the sprite
    ret

;
; Draw initial rock positions
; Inputs:
;
screen_initrocks:
    ld ix,level01rocks          ; load the location of the rock into ix
    ld b,4                      ; length of data
screen_initrocks0:
    push bc
    ld a,(screen_offset)        ; load the offset
    ld b,a
    ld c,(ix)                   ; get the horiz coord
    inc ix                      ; move to next
    ld a,(ix)                   ; get the vert coord
    inc ix
    cp b
    jp c, screen_initrocks1     ; if the carry flag is not set, a>b, so don't draw rock
    sub b                       ; subtract offset from vert coord
    ld b,a                      ; load a back to b for use as the coord
    call screen_getcellattradress ; get the memory address of b,c attr into de
    ld a,9                      ; load the block number for rock
    push de
    call screen_getattr         ; get the memory location for this cell's attr into hl
    pop de
    ld a,(hl)                   ; get the attr value at the address
    ld (de),a                   ; load the attr into memory
    ld a,9                      ; load the block number for rock
    call screen_getblock        ; get the block data into hl
    call screen_showchar        ; show this character here
screen_initrocks1:
    inc ix                      ; move past state
    pop bc
    djnz screen_initrocks0      ; decrease b and check if zero
    ret


;
; Return character cell address offset of block at (b, c) ready for addition to buffer memory.
; Inputs:
; bc: coords
; Outputs:
; de: memory location
;
screen_getcelladdress: 
    ld a,b      ; vertical position.
    and 24      ; which segment, 0, 1 or 2?
    add a,64    ; 64*256 = 16384, Spectrum's screen memory.
    ld d,a      ; this is our high byte.
    ld a,b      ; what was that vertical position again?
    and 7       ; which row within segment?
    rrca        ; multiply row by 32.
    rrca
    rrca
    ld e,a      ; low byte.
    ld a,c      ; add on y coordinate.
    add a,e     ; mix with low byte.
    ld e,a      ; address of screen position in de.
    ret

;
; Calculate address of attribute for character at (b, c).
; Inputs:
; bc: coords
; Outputs:
; de: memory location
;
screen_getcellattradress:
    ld a,b      ; x position.
    rrca        ; multiply by 32.
    rrca
    rrca
    ld e,a      ; store away in l.
    and 3       ; mask bits for high byte.
    add a,88    ; 88*256=22528, start of attributes.
    ld d,a      ; high byte done.
    ld a,e      ; get x*32 again.
    and 224     ; mask low byte.
    ld e,a      ; put in l.
    ld a,c      ; get y displacement.
    add a,e     ; add to low byte.
    ld e,a      ; hl=address of attributes.
    ret

;
; ; Display character hl at (b, c).
; Inputs:
; hl: block address
; bc: coords
;
screen_showchar: 
    call screen_getcelladdress ; find screen address offset for char.
    ld b,8              ; number of pixels high.
screen_showchar0:
    ld a,(hl)           ; source graphic.
    ld (de),a           ; transfer to screen.
    inc hl              ; next piece of data.
    inc d               ; next pixel line.
    djnz screen_showchar0 ; repeat
    ret


;
; Get cell graphic.
; Inputs:
; a: block
; Outputs:
; hl: memory
;
screen_getblock:
    rlca                        ; multiply block number by eight.
    rlca
    rlca
    ld e,a                      ; displacement to graphic address.
    ld d,0                      ; no high byte.
    ld hl,sprites               ; address of character blocks.
    add hl,de                   ; point to block.
    ret

;
; Get cell attribute.
; Inputs:
; a: block
; Outputs:
; hl: memory
;
screen_getattr:
    ld e,a                      ; displacement to attribute address.
    ld d,0                      ; no high byte.
    ld hl,sprite_attrs          ; address of block attributes.
    add hl,de                   ; point to attribute.
    ret
