screen_buffer:
    defs 7424                   ; area reserved for screen

screen_attr_buffer:
    defs 928                    ; attrs buffer area

screen_offset:
    defb 0                      ; offset from top of screen in lines

;
; Copies the buffer to the screen. Use stack.
; Inputs: none
;
screen_buffertoscreen:
    ld a,(screen_offset)          ; load the screen offset, this is in rows, want it *256
    ld de,256
    call utilities_multiply
    ld de,hl
    ld hl,screen_buffer
    add hl,de                   ; add the offset
    ld (screen_buffertoscreen1+1),sp ; this is some self-modifying code; stores the stack pointer in an ld sp,nn instruction at the end
    exx
    ld hl,16384+80              ; where the actual screen is, but as we're using the stack it's the right hand side of the buffer (16+32+32)
screen_buffertoscreen0:       
    exx                         ; hl is now buffer
    ld sp,hl                    ; do first sixteen for left hand side
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    pop af
    pop bc
    pop de
    pop iy
    ld sp,hl
    push iy
    push de
    push bc
    push af
    ex af,af'
    exx                         ; hl is now buffer
    push ix
    push de
    push bc
    push af
    ld e,16                    ; do another sixteen for right hand side
    ld d,0
    add hl,de
    ld sp,hl    
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    ld e,16
    ld d,0
    add hl,de
    pop af
    pop bc
    pop de
    pop iy
    ld sp,hl
    push iy
    push de
    push bc
    push af
    ex af,af'
    exx                         ; hl is now buffer
    push ix
    push de
    push bc
    push af
    ld e,16
    ld d,0
    add hl,de
    exx                         ; hl is now screen
    ld e,16
    ld d,0
    sbc hl,de
    inc h
    ld a,h
    and 0x07                    ; check if this is multiple of 8, if so, end of cell line
    jr nz,screen_buffertoscreen0 ; next line in cell
    ld a,h
    sub 8
    ld h,a
    ld a,l
    add a,32
    ld l,a
    jr nc,screen_buffertoscreen0
    ld a,h
    add a,8
    ld h,a
    cp 0x58
    jr nz,screen_buffertoscreen0
screen_buffertoscreen1:        
    ld sp,0
    exx
    call screen_buffertoattrs
    ret

screen_buffertoattrs:
    ld a,(screen_offset)            ; get the screen offset in rows, so want *32
    ld de,32
    call utilities_multiply
    ld de,hl
    ld hl,screen_attr_buffer
    add hl,de                       ; add the offset
    ld de,22528+64                  ; add 32x2 to the attr memory address to account for the top two rows                      
    ld bc,928
    ldir
    ret

screen_setscorecolours:
    ld hl,score_colours
    ld de,22528                     ; attrs here                      
    ld bc,64
    ldir
    ret


; Draw the screen
; Inputs:
; none
; Notes:
; The value held at screen_offset tells the screen how many rows to scroll down. Set to five to bottom out.
screen_draw:
    ;call clear_screen
    ld c,0                      ; horiz
    ld b,0                      ; vert, 0 at top
    ld ix,level01               ; point ix at level data
    ld iy,screen_attr_buffer    ; point iy at attr data
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
    cp 29                       ; check if at bottom
    jp nz,screen_draw0          ; if not, loop
    call screen_initrocks       ; draw rocks

    ld hl,player_sprite       ; load hl with the location of the player sprite data
    ld bc,(start_coord)         ; load bc with the start coords
    call sprites_drawsprite     ; call the routine to draw the sprite
    call screen_setuptext       ; draws text on the screen
    ret

;
; Sets up text on the screen
;
screen_setuptext:
    ld hl, string_score1
    call string_print
    ld hl, string_scorenumbers1
    call string_print
    ld hl, string_company
    call string_print
    ld hl, string_score2
    call string_print
    ld hl, string_scorenumbers2
    call string_print
    call screen_setscorecolours
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
    ld c,(ix)                   ; get the horiz coord
    inc ix                      ; move to next
    ld b,(ix)                   ; get the vert coord
    inc ix
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
; Return character cell address offset of block at (b, c) ready for addition to screen  memory.
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
; Calculate buffer address of attribute for character at (b, c).
; Inputs:
; bc: coords
; Outputs:
; de: memory location
;
screen_getcellattradress:
    ld de,screen_attr_buffer ; memory is at base + horiz (c) + vert*32 (b)
    ld l,c      ; x position.
    ld h,0      ; 0 h
    add hl,de
    ld de,hl    ; horiz done
    ld a,b      ; do vert  
    push de
    push bc
    ld de,32  
    call utilities_multiply
    pop bc
    pop de
    add hl,de
    ld de,hl    ; vert done
    ret

;
; Get buffer address for a character at b,c - b vert
; Buffer memory is stored as sequential block
; Char at 0,0 is stored 0,32,64...; 0,1 is stored at 1,33,65 
; Inputs:
; bc - coords
; Outputs:
; de - memory location of first byte
screen_getbufferaddress:
    ld hl, screen_buffer    ; first get screen buffer start
    ld d,b                  ; then work out vertical offset 
    ld e,0                  ; mult by 256, low byte becomes high byte, de now holds result
    add hl,de               ; add to base
    ld e,c                  ; then add horizontal offset (c)
    ld d,0
    add hl,de               ; add to base
    ld de,hl
    ret


;
; Display character hl at (b, c) to buffer.
; Stored sequentially
; Inputs:
; hl: block address
; bc: coords
;
screen_showchar: 
    ld a,0
    push hl
    call screen_getbufferaddress ; get the current screen buffer pointer
    pop hl
    ld b,8              ; number of pixels high.
screen_showchar0:
    ld a,(hl)           ; source graphic.
    ld (de),a           ; transfer to screen.
    inc hl              ; next piece of data.              
    push hl             ; store hl
    ld hl,de            ; put de in hl
    ld e,32            ; inc memory by 32, so load 32 into de
    ld d,0
    add hl,de              ; add de to hl
    ld de,hl            ; load back to de
    pop hl              ; restore hl
    
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
