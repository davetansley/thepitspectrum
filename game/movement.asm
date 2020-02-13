;
; Checks the contents of a cell are empty - ie, all pixel rows are zero
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; e - 0 if not empty, 1 if empty
;
movement_spaceisempty:
    ld a,8                          ; 8 rows to check
movement_spaceisempty0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, movement_spaceisempty1    ; row is not empty, can't move here
    ld a,c                          ; load the vertical coord 
    inc a                           ; next row down
    ld de,32
    add hl,de                       ; otherwise, just go one down for hl, which means add 32, because of course
    ld c,a                          ; copy vert coord back to c
    ex af,af'                       ; get loop counter back
    dec a                           ; decrease loop counter
    jp nz, movement_spaceisempty0
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
movement_spaceisempty1:
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
movement_linebelowisempty:
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, movement_linebelowisempty1    ; row is not empty, can't move here
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
movement_linebelowisempty1:
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
movement_lineaboveisempty:
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp nz, movement_lineaboveisempty1    ; row is not empty, can't move here
    ld d,0
    ld e,1                          ; got to end, so space is empty
    ret
movement_lineaboveisempty1:
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
movement_spaceisdiggable:
    ld a,8                          ; 8 rows to check
movement_spaceisdiggable0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 0
    jp z, movement_spaceisdiggable2  ; row is empty, can dig here
    cp 85
    jp z, movement_spaceisdiggable2  ; row is dirt, can dig here
    cp 170
    jp z, movement_spaceisdiggable2  ; row is dirt, can dig here
    jp movement_spaceisdiggable1     ; otherwise, stop checking
movement_spaceisdiggable2:
    ld a,c                          ; load the vertical coord 
    inc a                           ; next row down
    ld de,32
    add hl,de                       ; otherwise, just go one down for hl, which means add 32, because of course
    ld c,a                          ; copy vert coord back to c
    ex af,af'                       ; get loop counter back
    dec a                           ; decrease loop counter
    jp nz, movement_spaceisdiggable0
    ld hl,player+6                  
    ld (hl),1                       ; set the player into digging mode
    inc hl
    ld (hl),5                      ; set the number of frame to dig for
    inc hl
    ld (hl),8                       ; set the number of pixels to dig
    ret
movement_spaceisdiggable1:
    ld hl,player+6                  
    ld (hl),0                       ; set the player out of digging mode
    ret

;
; Checks the contents of a cell below are diggable - ie, at least one pixel row has dirt. If the first one isn't dirt, stop
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; none - puts player into digging mode
;
movement_spacebelowisdiggable:
    ld a,(hl)                       ; get first pixel row
    cp 85
    jp z, movement_spacebelowisdiggable3  ; row is dirt, can dig here
    cp 170
    jp z, movement_spacebelowisdiggable3  ; row is dirt, can dig here
    jp movement_spaceisdiggable1    ; the first row is not dirt, so don't bother checking the rest, can't dig
movement_spacebelowisdiggable3:
    ld a,8                          ; rows to check
    ld e,0                          ; count of rows to dig
movement_spacebelowisdiggable0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 85
    jp z, movement_spacebelowisdiggable4  ; row is dirt, can dig here
    cp 170
    jp z, movement_spacebelowisdiggable4  ; row is dirt, can dig here
    jp movement_spacebelowisdiggable5     ; don't count this row and stop counting
movement_spacebelowisdiggable4:
    inc e                           ; inc count of rows to dig
movement_spacebelowisdiggable2:
    ld a,c                          ; load the vertical coord 
    inc a                           ; next row down
    push de                         ; need e for later
    ld de,32
    add hl,de                       ; otherwise, just go one down for hl, which means add 32, because of course
    ld c,a                          ; copy vert coord back to c
    pop de                          ; get e back
    ex af,af'                       ; get loop counter back
    dec a                           ; incease loop counter
    jp nz, movement_spacebelowisdiggable0
movement_spacebelowisdiggable5:
    ld hl,player+6                  
    ld (hl),1                       ; set the player into digging mode
    inc hl
    ld (hl),5                      ; set the number of frame to dig for
    inc hl
    ld (hl),e                       ; set the number of pixels to dig
    ret
movement_spacebelowisdiggable1:
    ld hl,player+6                  
    ld (hl),0                       ; set the player out of digging mode
    ret

;
; Checks the contents of a cell above are diggable - ie, at least one pixel row has dirt. If the first one isn't dirt, stop
; Inputs: 
; hl - memory location of top pixel row
; bc - screen coords, b horiz, c vert
; Outputs:
; none - puts player into digging mode
;
movement_spaceaboveisdiggable:
    ld a,(hl)                       ; get first pixel row
    cp 85
    jp z, movement_spaceaboveisdiggable3  ; row is dirt, can dig here
    cp 170
    jp z, movement_spaceaboveisdiggable3  ; row is dirt, can dig here
    jp movement_spaceisdiggable1    ; the first row is not dirt, so don't bother checking the rest, can't dig
movement_spaceaboveisdiggable3:
    ld a,8                          ; rows to check
    ld e,0                          ; count of rows to dig
movement_spaceaboveisdiggable0:
    ex af,af'                       ; store the loop counter
    ld a,(hl)                       ; get current pixel row
    cp 85
    jp z, movement_spaceaboveisdiggable4  ; row is dirt, can dig here
    cp 170
    jp z, movement_spaceaboveisdiggable4  ; row is dirt, can dig here
    jp movement_spaceaboveisdiggable5     ; don't count this row and stop counting
movement_spaceaboveisdiggable4:
    inc e                           ; inc count of rows to dig
movement_spaceaboveisdiggable2:
    ld a,c                          ; load the vertical coord 
    dec a                           ; next row up
    push de                         ; need e for later
    ld de,32
    sbc hl,de                       ; otherwise, just go one up for hl, which means sub 32, because of course
    ld c,a                          ; copy vert coord back to c
    pop de                          ; get e back
    ex af,af'                       ; get loop counter back
    dec a                           ; incease loop counter
    jp nz, movement_spaceaboveisdiggable0
movement_spaceaboveisdiggable5:
    ld hl,player+6                  
    ld (hl),1                       ; set the player into digging mode
    inc hl
    ld (hl),5                       ; set the number of frame to dig for
    inc hl
    ld (hl),e                       ; set the number of pixels to dig
    ret
movement_spaceaboveisdiggable1:
    ld hl,player+6                  
    ld (hl),0                       ; set the player out of digging mode
    ret

;
; Checks if the player can move down
; Inputs:
; bc - player coords, b horiz, c vert
; Outputs:
; de - 1 can move
movement_checkcanmove_down:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    inc h                       ; memory location of cell beneath now in hl
    call movement_linebelowisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, movement_checkcanmove_down1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
movement_checkcanmove_down1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    inc h 
    push bc
    call movement_spacebelowisdiggable    ; can't move here, but can we dig
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
movement_checkcanmove_up:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly above (subtract 32)
    ld de,32
    sbc hl,de                       ; memory location of line above now in hl
    call movement_lineaboveisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, movement_checkcanmove_up1 ; can't move
    ld e,1
    call player_justmoved
    pop bc
    pop af
    ret
movement_checkcanmove_up1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly above (subtract 32)
    ld de,32
    sbc hl,de                       ; memory location of line above now in hl
    push bc
    call movement_spaceaboveisdiggable    ; can't move here, but can we dig
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
movement_checkcanmove_right:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    inc hl                          ; memory location of cell to the right now in hl
    call movement_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, movement_checkcanmove_right1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
movement_checkcanmove_right1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de
    inc hl                          ; memory location of cell to the right now in hl
    push bc
    call movement_spaceisdiggable    ; can't move here, but can we dig
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
movement_checkcanmove_left:
    push af
    push bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    dec hl                          ; memory location of cell to the right now in hl
    call movement_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z, movement_checkcanmove_left1 ; can't move
    call player_justmoved
    pop bc
    pop af
    ret
movement_checkcanmove_left1:
    pop bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de
    dec hl                          ; memory location of cell to the right now in hl
    push bc
    call movement_spaceisdiggable    ; can't move here, but can we dig
    ld de,0
    pop bc
    pop af
    ret