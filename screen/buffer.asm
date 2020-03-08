buffer_buffer:
    defs 7424                   ; area reserved for screen

buffer_attr_buffer:
    defs 928                    ; attrs buffer area

buffer_tmp:
    defb 0,0                    ; temp area

;
; If this is set to one, three lines will be refreshed for the screen coord redraw
; This is used when digging to make sure that the above/below dug block gets redrawn
; 1 - above
; 2 - below
;
buffer_threelinerefresh:
    defb 0

;
; This list stores lines to be updated by the buffer.
; This is done by half line. Lines are encded with.
; 00hlllll
; Where h is the half of the screen (0 or 1), lllll is the line number
buffer_updatedlines:
    defs 21,255

buffer_updateall:
    defb 0

;
; Stores a line number in the update list
; Inputs:
; a - row number
buffer_marklineforupdate:
    cp 21
    ret nc                          ; dont store lines that we shouldn't draw
    ld e,a                          ; store in e
    ld bc,(origcoords)              ; this should hold the coords of what was drawn
    ld a,c                          ; get the horiz coord
    cp 15
    jp z,buffer_marklineforupdate3  ; if 15 or 16, store both halves
    cp 16                           ; if this is 15 or less, the first half of screen
    jp z,buffer_marklineforupdate3  ; if 15 or 16, store both halves
    jp c,buffer_marklineforupdate4  ; if first half, nothing to do
    ld a,b                          ; get the vertical
    ld a,32                         ; set the 6th bit by adding 32
    add a,e
    ld e,a                          ; store this value
    jp buffer_marklineforupdate2
buffer_marklineforupdate4:
    ld a,b
    jp buffer_marklineforupdate2    ; just get the vertical
buffer_marklineforupdate3:          ; special case for 15,16 - need to render both halves, since might be between
    call buffer_storelineforupdate  ; call store update for e
    ld a,32
    add a,e
    ld e,a
buffer_marklineforupdate2:
    call buffer_storelineforupdate  ; call store update for e
    ret
    

;
; Stores the calculated line and half if needed
; Inputs:
; e - half/row
;
buffer_storelineforupdate:
    ld b,21
    ld hl,buffer_updatedlines
buffer_storelineforupdate0:
    ld a,(hl)                       ; get the line stored in updated lines 
    cp e                            ; is this the same as the row number passed in?
    ret z                           ; if so, don't need to do anything 
    cp 255                          ; is this 255, ie the end of the buffer 
    jp nz,buffer_storelineforupdate1 ; if not, move to next
    ld (hl),e
    ret
buffer_storelineforupdate1:
    inc hl
    djnz buffer_storelineforupdate0
    ret

;
; Zeroes the updated lines list
;
buffer_clearlist:
    ld b,21
    ld hl,buffer_updatedlines
buffer_clearlist0:
    ld (hl),255 
    inc hl
    djnz buffer_clearlist0
    ret 

;
; Which half are we displaying? 0 left 1 right
;
buffer_bufferhalf:
    defb 0

;
; Copies the buffer to the screen. Use stack.
; Inputs: 
; hl - half/line number to display - 0 is first half, 0 is first line
;
buffer_bufferlinetoscreen:
    ld a,h
    ld (buffer_bufferhalf),a        ; store the half
    ld a,l
    ld c,a                          ; store a
    ld de,(screen_offset)          ; load the screen offset, this is in rows, want it *256
    add a,e                       ; add the row number
    ld de,256
    call utilities_multiply
    ld de,hl
    ld hl,buffer_buffer
    add hl,de                   ; add the offset
    ld a,c                      ; get original row back
    ld (buffer_bufferlinetoscreen3+1),sp ; this is some self-modifying code; stores the stack pointer in an ld sp,nn instruction at the end
    exx
    ld c,0                      ; zero horizontal
    ld b,a                      ; load the row number into vertical coord
    inc b
    inc b                       ; move forward 2 to allow for scores
    call screen_getcelladdress  ; get the memory into de
    ld hl,16                    ; offset by 16 chars to get to the centre, since populating stack from right
    add hl,de
    ld a,(buffer_bufferhalf)    ; get the half
    cp 1
    jp z,buffer_bufferlinetoscreen4
buffer_bufferlinetoscreen0:     ; PROCESS THE LEFT HALF      
    exx                         ; hl is now buffer
    inc hl 
    inc hl                      ; move hl forward 2 to skip first two blocks
    ld sp,hl                    ; do first fourteen for left hand side, sp pointing at buffer
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    pop af
    pop bc
    pop de
    ld sp,hl                    ; sp pointing at screen
    push de
    push bc
    push af
    ex af,af'
    exx                         ; hl is now buffer
    push ix
    push de
    push bc
    push af
    ld de,30                    ; add thirty to get to next line
    add hl,de
    ld sp,hl                    ; sp pointing at buffer
    exx                         ; hl is now screen
    ex af,af'
    inc h
    ld a,h
    and 0x07                    ; check if this is multiple of 8, if so, end of cell line
    jp nz,buffer_bufferlinetoscreen0 ; next line in cell
buffer_bufferlinetoscreen1:        
    jp buffer_bufferlinetoscreen3
buffer_bufferlinetoscreen4:     ; PROCESS THE RIGHT HALF
    exx                         ; hl is buffer
    ld de,16
    add hl,de                   ; move halfway across
    exx                         ; hl is screen
    ld de,14 
    add hl,de
buffer_bufferlinetoscreen2:       
    exx                         ; hl is now buffer
    ld sp,hl                    ; do first fourteen for right hand side, sp pointing at buffer
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    pop af
    pop bc
    pop de
    ld sp,hl                    ; sp pointing at screen
    push de
    push bc
    push af
    ex af,af'
    exx                         ; hl is now buffer
    push ix
    push de
    push bc
    push af
    ld de,32                    ; add thirty two to get to next line
    add hl,de
    ld sp,hl                    ; sp pointing at buffer
    exx                         ; hl is now screen
    ex af,af'
    inc h
    ld a,h
    and 0x07                    ; check if this is multiple of 8, if so, end of cell line
    jp nz,buffer_bufferlinetoscreen2 ; next line in cell
buffer_bufferlinetoscreen3:        
    ld sp,0
    exx
    ret

;
; Copies the buffer to the screen for updated lines. Use stack.
; Inputs: none
;
buffer_buffertoscreen:
    ld a,(buffer_updateall)      ; get the all update flag
    cp 0
    jp z,buffer_buffertoscreen2  ; if not set, draw only updated
    call buffer_allbuffertoscreen ; otherwise, draw whole screen
    ld hl,buffer_updateall
    ld (hl),0                    ; reset flag
    ret
buffer_buffertoscreen2:
    ld b,21
    ld iy,buffer_updatedlines    ; the location of the updated lines
buffer_buffertoscreen0:
    ld a,(iy)
    cp 255
    jp z,buffer_buffertoscreen1                       ; if this is 255, then we're at the end of the updated list
    ld l,a
    ld h,0
    and 32                      ; and with 32 to see if 6th bit is set
    cp 32                       ; if so, second half of screen
    jp nz,buffer_buffertoscreen3
    ld h,1                      ; store half in h
    ld a,(iy)
    sub 32                      ; remove 32
    ld l,a                      ; stor in line number
buffer_buffertoscreen3:
    push bc
    push iy 
    di 
    call buffer_bufferlinetoscreen      ; hl has h=half (0 or 1), l=line
    ei
    pop iy  
    pop bc
    inc iy
    djnz buffer_buffertoscreen0
buffer_buffertoscreen1:
    ;call buffer_buffertoattrsfast
    ret

;
; Copies the buffer to the screen. Use stack.
; Inputs: none
;
buffer_allbuffertoscreen:
    ld b,21
    ld a,0 
buffer_allbuffertoscreen0:
    push bc
    push af 
    di
    ld h,0
    ld l,a
    call buffer_bufferlinetoscreen
    ei
    pop af
    push af 
    di
    ld h,1
    ld l,a
    call buffer_bufferlinetoscreen
    ei
    pop af  
    pop bc
    inc a
    djnz buffer_allbuffertoscreen0
    di
    call buffer_buffertoattrsfast
    ei
    ret

;
; Copies the attrs buffer to screen with the stack
;
buffer_buffertoattrsfast:
    ld (buffer_buffertoattrsfast1+1),sp ; this is some self-modifying code; stores the stack pointer in an ld sp,nn instruction at the end
    ld a,(screen_offset)            ; get the screen offset in rows, so want *32
    ld de,32
    call utilities_multiply
    ld de,hl
    ld hl,buffer_attr_buffer
    add hl,de                       ; add the offset, start of attr buffer now in hl
    exx
    ld hl,22528+80                  ; start of attr memory + 2 lines for score + 16 to start at right side
    ld iy,buffer_tmp
    ld (iy),21              ; number of times to loop
buffer_buffertoattrsfast0:
    exx                         ; hl is now buffer
    inc hl 
    inc hl                      ; move hl forward 2 to skip first two blocks
    ld sp,hl                    ; do first fourteen for left hand side, sp pointing at buffer
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    pop af
    pop bc
    pop de
    ld sp,hl                    ; sp pointing at screen
    push de
    push bc
    push af
    ex af,af'
    exx                         ; hl is now buffer
    push ix
    push de
    push bc
    push af
    ld e,14                    ; do another fourteen for right hand side
    ld d,0
    add hl,de
    ld sp,hl                    ; sp pointing at buffer
    pop af
    pop bc
    pop de
    pop ix
    exx                         ; hl is now screen
    ex af,af'
    ld e,14
    ld d,0
    add hl,de
    pop af
    pop bc
    pop de
    ld sp,hl                    ; sp pointing at screen
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
    ld de,18
    add hl,de
    ld a,(iy)
    dec a
    cp 0
    ld (iy),a
    jp nz,buffer_buffertoattrsfast0 ; do another row 
buffer_buffertoattrsfast1:        
    ld sp,0
    exx
    ret