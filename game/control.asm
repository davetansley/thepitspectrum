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
    jp control_dig2
control_dig1:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    inc hl              ; move one left
    jp control_dig2
control_dig4:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    ld de,256
    sbc hl,de             ; move one up
    jp control_dig2
control_dig5:
    call sprites_scadd  ; get the current coord 
    ld hl,de 
    inc h              ; move one down
    jp control_dig2
control_dig2:
    pop bc
    push hl
    call control_spaceisdiggable ; check again if the row is diggable
    ld a,(player+6)      ; next, check if the player is digging
    cp 1
    ret nz              ; return if we're not supposed to be digging
    pop hl
    ld a,(player+8)     ; get the number of rows we need to overwrite
    ld b,a              ; rows to copy over
control_dig3:
    ld (hl),0           ; load empty into row
    ld de,32
    add hl,de           ; move to next row
    djnz control_dig3
    ld hl,player+6
    ld (hl),0           ; turn off digging
    ld hl,player+5      ; automove into this space
    ld a,4
    ld (hl),a
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
    call c, control_scroll_up
    call control_checkcanmove_up ; check we can move up, e will be 1 if we can
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
    cp 144
    call nc, control_scroll_down
    call control_checkcanmove_down ; check we can move down, e will be 1 if we can
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
    call control_checkcanmove_left ; check we can move down, e will be 1 if we can
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
    call control_checkcanmove_right ; check we can move down, e will be 1 if we can
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
    ld a,7
    ld (screen_offset),a
    pop af
    ret

;
; Scrolls the screen up
;
control_scroll_up:
    push af
    ld a,0
    ld (screen_offset),a
    pop af
    ret

;
; Checks the contents of a cell are empty - ie, all pixel rows are zero
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; e - 0 if not empty, 1 if empty
;
control_spaceisempty:
    ld a,8                          ; 8 rows to check
control_spaceisempty0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, control_spaceisempty1    ; row is not empty, can't move here
    ld a,c                          ; load the vertical coord 
    inc a                           ; next row down
    ld de,32
    add hl,de                       ; otherwise, just go one down for hl, which means add 32, because of course
    ld c,a                          ; copy vert coord back to c
    ex af,af'                       ; get loop counter back
    dec a                           ; decrease loop counter
    jp nz, control_spaceisempty0
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
control_spaceisempty1:
    ld d,0
    ld e,0                          ; returning false, ie space not empty
    ret

;
; Checks the line of a cell below is empty - ie, first pixel rows is zero
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; e - 0 if not empty, 1 if empty
;
control_linebelowisempty:
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, control_linebelowisempty1    ; row is not empty, can't move here
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
control_linebelowisempty1:
    ld d,0
    ld e,0                          ; returning false, ie space not empty
    ret

;
; Checks the line of a cell above is empty - ie, last pixel rows are zero
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; e - 0 if not empty, 1 if empty
;
control_lineaboveisempty:
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, control_lineaboveisempty1    ; row is not empty, can't move here
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
control_lineaboveisempty1:
    ld d,0
    ld e,0                          ; returning false, ie space not empty
    ret

;
; Checks the contents of a cell are diggable - ie, all pixel rows are dirt or empty
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; none - puts player into digging mode
;
control_spaceisdiggable:
    ld a,8                          ; 8 rows to check
control_spaceisdiggable0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp z, control_spaceisdiggable2  ; row is empty, can dig here
    cp 85
    jp z, control_spaceisdiggable2  ; row is dirt, can dig here
    cp 170
    jp z, control_spaceisdiggable2  ; row is dirt, can dig here
    jp control_spaceisdiggable1     ; otherwise, stop checking
control_spaceisdiggable2:
    ld a,c                          ; load the vertical coord 
    inc a                           ; next row down
    ld de,32
    add hl,de                       ; otherwise, just go one down for hl, which means add 32, because of course
    ld c,a                          ; copy vert coord back to c
    ex af,af'                       ; get loop counter back
    dec a                           ; decrease loop counter
    jp nz, control_spaceisdiggable0
    ld hl,player+6                  
    ld (hl),1                       ; set the player into digging mode
    inc hl
    ld (hl),50                      ; set the number of frame to dig for
    inc hl
    ld (hl),8                       ; set the number of pixels to dig
    ret
control_spaceisdiggable1:
    ld hl,player+6                  
    ld (hl),0                       ; set the player out of digging mode
    ret


;
; Checks if the player can move down
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
control_checkcanmove_down:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    inc h                       ; memory location of cell beneath now in hl
    call control_linebelowisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, control_checkcanmove_down1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
control_checkcanmove_down1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    inc h 
    push bc
    call control_spaceisdiggable    ; can't move here, but can we dig
    ld de,0
    pop bc
    pop af
    ret

;
; Checks if the player can move up
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
control_checkcanmove_up:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    ld de,32
    sbc hl,de                       ; memory location of line above now in hl
    call control_lineaboveisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, control_checkcanmove_up1 ; can't move
    ld e,1
    call player_justmoved
    pop bc
    pop af
    ret
control_checkcanmove_up1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    dec h                        ; look at cell directly above (sub 256)
    push bc
    call control_spaceisdiggable    ; can't move here, but can we dig
    ld de,0
    pop bc
    pop af
    ret

;
; Checks if the player can move right
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
control_checkcanmove_right:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    inc hl                          ; memory location of cell to the right now in hl
    call control_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, control_checkcanmove_right1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
control_checkcanmove_right1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de
    inc hl                          ; memory location of cell to the right now in hl
    push bc
    call control_spaceisdiggable    ; can't move here, but can we dig
    ld de,0
    pop bc
    pop af
    ret

;
; Checks if the player can move left
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
control_checkcanmove_left:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    dec hl                          ; memory location of cell to the right now in hl
    call control_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, control_checkcanmove_left1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
control_checkcanmove_left1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de
    dec hl                          ; memory location of cell to the right now in hl
    push bc
    call control_spaceisdiggable    ; can't move here, but can we dig
    ld de,0
    pop bc
    pop af
    ret

    