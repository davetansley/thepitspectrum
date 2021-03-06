screen_offset:
    defb 0                      ; offset from top of screen in lines

screen_tmp:
    defb 0,0                      ; temporary memory

screen_setscorecolours:
    ld hl,score_colours
    ld de,22528                     ; attrs here                      
    ld bc,64
    ldir
    ret

screen_sethighscorecolours:
    ld hl,high_score_colours
    ld de,22528+736                 ; attrs here                      
    ld bc,32
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
    ld ix,level_layout               ; point ix at level data
    ld iy,buffer_attr_buffer    ; point iy at attr data
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
    ld hl, screen_tmp
    ld (hl),9                   ; load the block number into memory
    ld ix,(game_current_rocks)  ; current rock memory
    call screen_initobjects     ; draw rocks
    ld hl, screen_tmp
    ld (hl),12                  ; load the block number into memory
    ld ix,level_missiles       ; missile memory
    call screen_initobjects     ; draw missiles
    ld hl, screen_tmp
    ld (hl),08                  ; load the block number into memory
    ld ix,level_diamonds       ; diamond memory
    call screen_initobjects     ; draw diamonds
    ld hl, screen_tmp
    ld (hl),14                  ; load the block number into memory
    ld ix,level_gems           ; gems memory
    call screen_initobjects     ; draw gems
    call screen_setuptext       ; draws text on the screen
    call scores_printscores     ; print the current scores
    ret

;
; Sets up text on the screen
;
screen_setuptext:
    call scores_showtable
    call screen_sethighscorecolours
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
    ld a,(game_currentplayer)
    cp 1
    jp nz,screen_setuptext0
    ld hl, string_player1
    jp screen_setuptext1
screen_setuptext0:
    ld hl, string_player2
screen_setuptext1:
    call string_print
    call screen_setscorecolours
    ret

;
; Sets a line of colours
; Inputs:
; a - colour to set
; b - number to set
; de - start memory location
;
screen_setcolours: 
    ld (de),a
    inc de
    djnz screen_setcolours
    ret

;
; Draw initial object positions
; Inputs:
; ix - memory location of objects
; a - graphic
screen_initobjects:
    ld c,(ix)                   ; get the horiz coord
    ld a,c
    cp 255
    jp z,screen_initobjects2
    inc ix                      ; move to next
    ld b,(ix)                   ; get the vert coord
    inc ix
    call screen_getcellattradress ; get the memory address of b,c attr into de
    push de
    ld a,(screen_tmp)                  ; get the block number back
    call screen_getattr         ; get the memory location for this cell's attr into hl
    pop de
    ld a,(hl)                   ; get the attr value at the address
    ld (de),a                   ; load the attr into memory
    ld a,(screen_tmp)                  ; get the block number back
    call screen_getblock        ; get the block data into hl
    call screen_showchar        ; show this character here
    
screen_initobjects1:
    inc ix                      ; move past state
    inc ix
    inc ix                      ; move past mem
    jp screen_initobjects      
screen_initobjects2:
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
    ld de,buffer_attr_buffer ; memory is at base + horiz (c) + vert*32 (b)
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
; Calculate buffer address offset of attribute for character at (b, c).
; Inputs:
; bc: coords
; Outputs:
; de: memory location
;
screen_getcellattroffset:
    ld l,c      ; x position.
    ld h,0      ; 0 h
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
; Calculate buffer address of attribute for character at (b, c).
; Inputs:
; bc: coords
; Outputs:
; de: memory location
;
screen_getscreenattradress:
    ld de,22528 ; memory is at base + horiz (c) + vert*32 (b)
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
; Gets the attr memory location for a screen coord 
; Will overwrite bc
; Inputs:
; bc - screen coords
; Outputs:
; de - memory location
; bc - character coords
;
screen_getattraddressfromscreencoords:
    ld a,b                          ; get the player block coords of current block
    and 248                         ; find closest multiple of eight
    rrca
    rrca
    rrca                ; divide by 8
    ld b,a
    ld a,c
    ld c,b                         ; swap b and c
    and 248
    rrca
    rrca
    rrca                ; divide by 8
    ld b,a
    call screen_getcellattradress   ; work out memory location of current block attributes, memory in de
    ret


; Gets the nearest cell coords for a screen coord 
; Will overwrite bc
; Inputs:
; bc - screen coords
; Outputs:
; bc - character coords
;
screen_getcharcoordsfromscreencoords:
    ld a,b                          ; get the player block coords of current block
    and 248                         ; find closest multiple of eight
    rrca
    rrca
    rrca                ; divide by 8
    ld b,a
    ld a,c
    ld c,b                         ; swap b and c
    and 248
    rrca
    rrca
    rrca                ; divide by 8
    ld b,a
    ret

; Gets the screen coords for a cell coord 
; Will overwrite bc
; Inputs:
; bc - char coords
; Outputs:
; bc - screen coords
;
screen_getscreencoordsfromcharcoords:
    ld a,b                          ; get the player block coords of current block
    rlca
    rlca
    rlca                ; multiply by 8
    ld b,a
    ld a,c
    ld c,b                         ; swap b and c
    rlca
    rlca
    rlca                ; divide by 8
    ld b,a
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
    ld hl, buffer_buffer    ; first get screen buffer start
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
    ld (origcoords),bc   ; store char coords
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
    ld l,1
    call sprites_marklinesforupdatechar
    
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
; Set a the attr of a coord
; Inputs:
; bc - char coords
; a - attr
;
screen_setattr:
    push ix
    push bc
    ex af, af'
    call screen_getcellattroffset   ; get offset into de
    ld hl,buffer_attr_buffer
    add hl,de                       ; get the memory location    
    ex af, af'                      ; get attr back
    ld (hl),a                         ; set the attr 
    ex af, af'                      ; get attr back
    ld de,(screen_offset)           ; get the offset
    ld a,b                          ; get the vertical
    sub e                           ; subtract the offset
    jp c,screen_setattr0            ; if less than zero, don't update the attr on screen
    cp 21
    jp nc,screen_setattr0           ; if more than 21, don't update the attr on screen
    ld b,a                          ; put the coord back in b
    call screen_getscreenattradress ; screen attr address in de
    ld hl,64                        ; attr memory + two rows for scores
    add hl,de
    ex af, af'                      ; get attr back
    ld (hl),a
    pop bc
    pop ix
    ret
screen_setattr0:
    pop bc
    pop ix
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

;
; Checks whether a character block has anything in it
; Inputs:
; bc - char coords
; Outputs:
; a - 1, empty
screen_ischarempty:
    call screen_getbufferaddress ; get the current screen buffer pointer
    ld b,8                      ; check 8 rows
screen_ischarempty2:
    ld a,(de)                   ; check line
    cp 0
    jp nz,screen_ischarempty1   ; if not zero, jump out with false
    ld hl,32
    add hl,de
    ld de,hl                    ; move to next row
    djnz screen_ischarempty2
screen_ischarempty0:
    ld a,1
    ret
screen_ischarempty1:
    ld a,0
    ret

;
; Copies a block from one place to another directly underneath, leaves the original empty
; Inputs:
; bc - coords of block to copy from
screen_copyblockdown
    call screen_getbufferaddress ; get the current screen buffer pointer for source
    ld b,8                      ; copy 8 rows
screen_copyblock0:
    ld a,(de)                    ; get what we're copying
    ex af,af'
    ld a,0
    ld (de),a                    ; replace with empty
    ex af,af'
    inc d                        ; add 256 to get to the next row
    ld (de),a                    ; copy to the next row
    dec d
    ld hl,32
    add hl,de                       ; return back to source, next row down
    ld de,hl
    djnz screen_copyblock0
    ret

;
; Returns the first byte of a character. Useful for figuring out what's there
; Inputs:
; bc - coords
; Outputs:
; a - first byte
;
screen_getcharfirstbyte:
    call screen_getbufferaddress ; get the current screen buffer pointer for source
    ld a,(de)
    ret
