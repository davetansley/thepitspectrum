buffer_buffer:
    defs 7424                   ; area reserved for screen

buffer_attr_buffer:
    defs 928                    ; attrs buffer area

buffer_tmp:
    defb 0,0                    ; temp area

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
    ld b,21
    ld hl,buffer_updatedlines
buffer_marklineforupdate0:
    ld a,(hl)                       ; get the line stored in updated lines 
    cp e                            ; is this the same as the row number passed in?
    ret z                           ; if so, don't need to do anything 
    cp 255                          ; is this 255, ie the end of the buffer 
    jp nz,buffer_marklineforupdate1 ; if not, move to next
    ld (hl),e                       ; if it is, this spot is empty, so store the row number 
    ret                             ; and finish
buffer_marklineforupdate1:
    inc hl
    djnz buffer_marklineforupdate0
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
; Copies the buffer to the screen. Use stack.
; Inputs: 
; a - row number to display - 0 is first line
;
buffer_bufferlinetoscreen:
    ld c,a                          ; store a
    ld de,(screen_offset)          ; load the screen offset, this is in rows, want it *256
    add a,e                       ; add the row number
    ld de,256
    call utilities_multiply
    ld de,hl
    ld hl,buffer_buffer
    add hl,de                   ; add the offset
    ld a,c                      ; get original row back
    ld (buffer_bufferlinetoscreen1+1),sp ; this is some self-modifying code; stores the stack pointer in an ld sp,nn instruction at the end
    exx
    ld c,0                      ; zero horizontal
    ld b,a                      ; load the row number into vertical coord
    inc b
    inc b                       ; move forward 2 to allow for scores
    call screen_getcelladdress  ; get the memory into de
    ld hl,16                    ; offset by 16 chars to get to the centre, since populating stack from right
    add hl,de
buffer_bufferlinetoscreen0:       
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
    ;pop ix
    exx                         ; hl is now screen
    ex af,af'
    ld e,14
    ld d,0
    add hl,de
    pop af
    pop bc
    pop de
    ;pop iy
    ld sp,hl                    ; sp pointing at screen
    ;push iy
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
    ld e,14
    ld d,0
    sbc hl,de
    inc h
    ld a,h
    and 0x07                    ; check if this is multiple of 8, if so, end of cell line
    jp nz,buffer_bufferlinetoscreen0 ; next line in cell
buffer_bufferlinetoscreen1:        
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
    push bc
    push iy 
    di 
    call buffer_bufferlinetoscreen
    ei
    pop iy  
    pop bc
    inc iy
    djnz buffer_buffertoscreen0
buffer_buffertoscreen1:
    call buffer_buffertoattrsfast
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
    call buffer_bufferlinetoscreen
    ei
    pop af  
    pop bc
    inc a
    djnz buffer_allbuffertoscreen0

    call buffer_buffertoattrsfast
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