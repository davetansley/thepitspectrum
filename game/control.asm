;
; Check the keyboard then move
;
control_keyboard:
    ld a,(player+5)      ; first, check if the player has pixels left to move
    cp 0
    jp z, control_keyboard1
    call control_automove
    ret
control_keyboard1:
    ld a,(player+6)      ; next, check if the player is digging
    cp 0
    jp z, control_keyboard0
    call control_dig
    ret
control_keyboard0:
    ld bc,64510         ; port for keyboard row q-t.
    in a,(c)            ; read keyboard.
    ld b,a              ; store result in b register.
    rr b                ; check outermost key (q).
    call nc,control_pl_moveup         ; player up.
    ld bc,65022         ; port for keyboard row a-f.
    in a,(c)            ; read keyboard.
    ld b,a              ; store result in b register.
    rr b                ; check outermost key (a).
    call nc,control_pl_movedown       ; player down.
    ld bc,57342         ; port for keyboard row y-p.
    in a,(c)            ; read keyboard.
    ld b,a              ; store result in b register.
    rr b                ; check outermost key (p).
    call nc,control_pl_moveright       ; player left.
    rr b                ; check next key.
    call nc,control_pl_moveleft       ; player right.
    ret

;
; Performs a dig if the counter has reset, otherwise, messes with the graphics
;
control_dig:
    ld bc,(player)      ; load the current coords into bc
    push bc
    ld a,(player+2)     ; get the direction    
    cp 1                ; left
    jp z,control_dig0 
    cp 2                ; right
    jp z,control_dig1
    cp 3                ; down
    jp z,control_dig5
    cp 0                ; up
    jp z,control_dig4
    ld hl,player+6
    ld (hl),0           ; turn off digging
    ret                 ; return
control_dig0:           ; going left
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    dec hl              ; move one left
    pop bc              ; get the coords back, subtract 8 from horiz, 8 from vert, store (will be coords of space above dug dirt)
    ld a,b
    ld b,8
    sub b
    ld b,a
    ld a,c
    ld c,8
    sub c
    ld c,a
    push bc
    jp control_dig2
control_dig1:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    inc hl              ; move one right
    pop bc              ; get the coords back, add 8 to horiz, subtract 8 from vert store (will be coords of space above dug dirt)
    ld a,8
    add a,b
    ld b,a
    ld a,c
    ld c,8
    sub c
    ld c,a
    push bc
    jp control_dig2
control_dig4:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    ld de,32
    sbc hl,de             ; move one up
    pop bc              ; get the coords back, 1 from vert, store, then we'll sub 1 from c for each row later
    dec c
    push bc
    jp control_dig6
control_dig5:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    inc h              ; move one down
                       ; not bothered about working out bc here, since rock will never fall if digging down
    jp control_dig2
; Normal (not up) digging    
control_dig2:
    ld a,(player+8)     ; get the number of rows we need to overwrite
    ld b,a              ; rows to copy over
    push hl             ; store the memory location of the first row for later
control_dig3:
    call control_getpixelrow
    ld (hl),a           ; load contents into row
    ld de,32
    add hl,de           ; move to next row
    djnz control_dig3
    pop hl              ; get the original memory location back
    ld de,32
    sbc hl,de           ; move to above row, ready for checking for rock
    jp control_dig10
; Special case for going up
control_dig6:           
    ld a,(player+8)     ; get the number of rows we need to overwrite
    ld b,a              ; rows to copy over
control_dig7:
    call control_getpixelrow
control_dig12:
    ld (hl),a           ; load empty into row
    ld de,32
    sbc hl,de           ; move up to next row
    dec c               ; decrease c to track rows
    djnz control_dig7
    ld a,c
    sub 7
    pop bc
    ld c,a
    push bc             ; store the decreased c coord
control_dig10:
    ld ix,player+7
    ld a,(ix)     ; get the dig frame number 
    dec a
    ld (ix),a
    ; call the check for rocks above the removed dirt
    ld ix,player+6
    ld a,(ix)     ; get the dig state
    cp 0
    pop bc
    call z, rocks_checkforfalling ; make the check if we're no longer digging 
    ret

;
; Gets a modified pixel row to overwrite dirt - if this is the last dig, overwrite with nothing, otherwise xor to flip the dirt
; Inputs:
; hl - memory of pixel row
; Outputs:
; a - modified row to write
;
control_getpixelrow:
    ld a,(player+7)     ; get the dig frame number 
    cp 0                ; is this the last dig
    jp z,control_getpixelrow1   
    ld a,(hl)           ; if not, xor with 255 to flip it
    xor 255
    ret
control_getpixelrow1:
    ld ix,player+6
    ld (ix),0           ; turn off digging
    ld a,0              ; if it is, load with empty
    ret

;
; Auto move the player until pixels is zero
;
control_automove:
    ld e,a              ; store the number of pixels left to move in e
    ld bc,(player)      ; load the current coords into bc
    ld hl,player+2      ; get the direction
    ld a,(hl)
    cp 3                ; down
    jp z,control_automove3  ; don't need to do anything
    cp 0                ; going up
    jp z,control_automove2
    cp 1                ; going left?
    jp z,control_automove0
    ld a,b
    inc a               ; if we're going right, increment a twice for two pixels
    inc a
    ld b,a 
    jp control_automove1
control_automove3:
    ld a,c
    inc a 
    inc a               ; if we're going down, increment twice
    ld c,a
    cp 144
    call z, control_scroll_down
    jp control_automove1
control_automove2:
    ld a,c
    dec a 
    dec a               ; if we're going up, decrement twice
    ld c,a
    cp 96
    call z, control_scroll_up
    jp control_automove1
control_automove0:
    ld a,b
    dec a               ; if we're going left, decrement a twice
    dec a
    ld b,a 
control_automove1:
    ld (player),bc      ; and back to player
    ld a,e              ; now get the pixel count back
    dec a               ; decrease by one
    ld hl,player+5
    ld (hl),a           ; copy back
    call player_justmoved
    ret

;
; Moves the player up
;
control_pl_moveup:
    push bc
    ld bc,(player)          ; get the current coords, b horiz, c vert
    ld a,c                  ; load c into the acc
    cp 24
    jp z,control_pl_moveup0 ; are we at the edge of the screen
    cp 96
    call z, control_scroll_up
    call movement_checkcanmove_up ; check we can move up, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_moveup1 ; don't move if we can't
    pop af
    sub 1                   ; subtract 1
    sub 1                   ; subtract 1
    ld c,a                  ; load back to c
    ld (player),bc          ; load back to player
    jp control_pl_moveup0
control_pl_moveup1:
    pop af                  ; restore af if needed
control_pl_moveup0:
    ld a,0
    ld (player+2),a        ; set direction to up
    pop bc
    ret
;
; Moves the player down
;
control_pl_movedown:
    push bc
    ld bc,(player)          ; get the current coords, b horiz, c vert
    ld a,c                  ; load c into the acc
    cp 224
    jp z,control_pl_movedown0 ; are we at the edge of the screen
    cp 128
    call z, control_scroll_down
    call movement_checkcanmove_down ; check we can move down, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_movedown1 ; don't move if we can't
    pop af
    inc a                   ; add 1
    inc a                   ; add 1
    ld c,a                  ; load back to c
    ld (player),bc          ; load back to player
    jp control_pl_movedown0
control_pl_movedown1:
    pop af                  ; restore af if needed
control_pl_movedown0:
    ld a,3
    ld (player+2),a        ; set direction to down
    pop bc
    ret
;
; Moves the player left
;
control_pl_moveleft:
    push bc
    ld bc,(player)          ; get the current coords, b horiz, c vert
    ld a,b                  ; load b into the acc
    cp 16
    jp z,control_pl_moveleft0 ; are we at the edge of the screen
    call movement_checkcanmove_left ; check we can move down, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_moveleft1 ; don't move if we can't
    ld hl,player+5          ; need to store the amount of pixels still left to move in the player status
    ld a,3
    ld (hl),a   
    pop af
    sub 1                    ; subtract 2
    sub 1
    ld b,a                  ; load back to c
    ld (player),bc          ; load back to player
    jp control_pl_moveleft0
control_pl_moveleft1:
    pop af      
control_pl_moveleft0:
    ld a,1
    ld (player+2),a        ; set direction to left
    pop bc
    ret
;
; Moves the player right
;
control_pl_moveright:
    push bc
    ld bc,(player)          ; get the current coords, b horiz, c vert
    ld a,b                  ; load b into the acc
    cp 240
    jp z,control_pl_moveright0 ; are we at the edge of the screen
    call movement_checkcanmove_right ; check we can move down, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_moveright1 ; don't move if we can't
    ld hl,player+5          ; need to store the amount of pixels still left to move in the player status
    ld a,3
    ld (hl),a
    pop af
    inc a                   ; add 2
    inc a
    ld b,a                  ; load back to b
    ld (player),bc          ; load back to player
    jp control_pl_moveright0
control_pl_moveright1:
    pop af                  ; restore af if needed
control_pl_moveright0:
    ld a,2
    ld (player+2),a        ; set direction to right
    pop bc
    ret

;
; Scrolls the screen down
;
control_scroll_down:
    push af
    ld a,8
    ld (screen_offset),a
    pop af
    ld hl,buffer_updateall
    ld (hl),1         ; flag as screen needing update
    ret

;
; Scrolls the screen up
;
control_scroll_up:
    push af
    ld a,0
    ld (screen_offset),a
    pop af    
    ld hl,buffer_updateall
    ld (hl),1         ; flag as screen needing update
    ret



    