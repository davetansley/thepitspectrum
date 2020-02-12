;
; Check the keyboard then move
;
control_keyboard:
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
; Moves the player up
;
control_pl_moveup:
    push bc
    ld bc,(player)          ; get the current coords, b horiz, c vert
    ld a,c                  ; load c into the acc
    cp 0
    jp z,control_pl_moveup0 ; are we at the edge of the screen
    cp 98
    call z, control_scroll_up
    call control_checkcanmove_up ; check we can move up, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_moveup1 ; don't move if we can't
    pop af
    sub 1                   ; subtract 2
    sub 1
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
    cp 130
    call z, control_scroll_down
    call control_checkcanmove_down ; check we can move down, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_movedown1 ; don't move if we can't
    pop af
    inc a                   ; add 2
    inc a
    ld c,a                  ; load back to c
    ld (player),bc          ; load back to player
    jp control_pl_movedown0
control_pl_movedown1:
    pop af                  ; restore af if needed
control_pl_movedown0:
    ld a,0
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
    jp z,control_pl_moveleft0 ; are we at the edge of the screen
    call control_checkcanmove_left ; check we can move down, e will be 1 if we can
    push af
    ld a,e                  ; put e in a
    cp 0
    jp z,control_pl_moveright1 ; don't move if we can't
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
; Checks if the player can move down
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
control_checkcanmove_down:
    push af
    push bc
    call screen_getattraddressfromscreencoords ; get the memory location of cell into de
    ld hl,32                        ; look at cell directly underneath (add 32)
    add hl,de                       ; memory location of cell beneath now in hl
    ld e,0                          ; zero de
    ld d,0
    ld a,(hl)                       ; get attr of cell below
    cp 71
    jp nz, control_checkcanmove_down1 ; don't set flag if not black
    pop bc                          ; get bc back briefly
    ld a,b                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0    
    jp z, control_checkcanmove_down0   ; is multiple of 8 so no need to check next block
    inc hl                          ; check the next cell across if stradling a block - if b/horiz not multiple of 8
    ld a,(hl)                       ; get attr of cell below
    cp 71
    jp nz, control_checkcanmove_down1 ; don't set flag if not black
control_checkcanmove_down0:
    ld e,1
    call player_justmoved
control_checkcanmove_down1:
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
    call screen_getattraddressfromscreencoords ; get the memory location of cell into de
    ld hl,de
    pop bc                          ; get bc back briefly
    ld a,c                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0                            ; need to check if the vert coord is multiple of 8, if it is, subtract 32 from memory address
    jp nz,control_checkcanmove_up2                                  
    ld de,32                        ; look at cell directly above (sub 32)
    sbc hl,de                       ; memory location of cell above now in hl
control_checkcanmove_up2:
    ld e,0                          ; zero de
    ld d,0
    ld a,(hl)                       ; get attr of cell above
    cp 71
    jp nz, control_checkcanmove_up1 ; don't set flag if not black
    pop bc                          ; get bc back briefly
    ld a,b                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0    
    jp z, control_checkcanmove_up0   ; is multiple of 8 so no need to check next block
    inc hl                          ; check the next cell across if stradling a block - if b/horiz not multiple of 8
    ld a,(hl)                       ; get attr of cell below
    cp 71
    jp nz, control_checkcanmove_up1 ; don't set flag if not black
control_checkcanmove_up0:
    ld e,1
    call player_justmoved
control_checkcanmove_up1:
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
    call screen_getattraddressfromscreencoords ; get the memory location of cell into de
    inc hl                        ; look at cell directly to the right (add 1) 
    ld e,0                          ; zero de
    ld d,0
    ld a,(hl)                       ; get attr of cell to the right
    cp 71
    jp nz, control_checkcanmove_right1 ; don't set flag if not black
    pop bc                          ; get bc back briefly
    ld a,c                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0    
    jp z, control_checkcanmove_right0   ; is multiple of 8 so no need to check next block
    ld de,32                          ; check the next cell down if stradling a block - if c/vert not multiple of 8
    add hl,de
    ld e,0
    ld d,0                          ; zero de again
    ld a,(hl)                       ; get attr of cell below
    cp 71
    jp nz, control_checkcanmove_right1 ; don't set flag if not black
control_checkcanmove_right0:
    ld e,1
    call player_justmoved
control_checkcanmove_right1:
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
    call screen_getattraddressfromscreencoords ; get the memory location of cell into de
    ld hl,de
    pop bc                          ; get bc back briefly
    ld a,b                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0                            ; need to check if the horiz coord is multiple of 8, if it is, subtract 32 from memory address
    jp nz,control_checkcanmove_left2                                  
    dec hl                       ; memory location of cell left now in hl
control_checkcanmove_left2:
    ld e,0                          ; zero de
    ld d,0
    ld a,(hl)                       ; get attr of cell to the right
    cp 71
    jp nz, control_checkcanmove_left1 ; don't set flag if not black
    pop bc                          ; get bc back briefly
    ld a,c                         ; screen coord
    push bc                         ; put it back for later
    and 7                           ; and with 7
    cp 0    
    jp z, control_checkcanmove_left0   ; is multiple of 8 so no need to check next block
    ld de,32                          ; check the next cell down if stradling a block - if c/vert not multiple of 8
    add hl,de
    ld e,0
    ld d,0                          ; zero de again
    ld a,(hl)                       ; get attr of cell below
    cp 71
    jp nz, control_checkcanmove_left1 ; don't set flag if not black
control_checkcanmove_left0:
    ld e,1
    call player_justmoved
control_checkcanmove_left1:
    pop bc
    pop af
    ret

    