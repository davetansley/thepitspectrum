;
; Ship initial position: vert,horiz
;
ship_initpos:
    defb 0,36   
ship_initpos2:
    defb 0,0
ship_frame:
    defb 0
;
; The current memory location
;
ship_current_sprite:
    defb 0,0

ship_current_coords:
    defb 0,0

;
;   Draw and land the ship - first move the ship down, then across, drawing the player in the middle
;
ship_land:
    ld bc,(ship_initpos)
    ld (ship_initpos2),bc        ; save the initial position for later use
    ld e,0                      ; store a flag to track first time round
    ld b,8                      ; move down 8 pixels
ship_land0:
    push bc
    ld a,e
    push de                     ; store de for next time round
    cp 1                        ; check first time flag
    jp nz,ship_land1             ; don't draw over previous one if first time
    call ship_draw_full         ; delete old one
    call ship_change_frame      ; increment the frame
    ld bc,(ship_initpos2) ; get the current coords
    add c,1                     ; move down one pixels
    ld c,a
    ld (ship_initpos2),bc
ship_land1:
    call ship_draw_full         ; draw the ship
    call ship_draw_screen
    pop de
    ld e,1
    pop bc
    djnz ship_land0
    ; done moving down
    ; now move across
    call player_drawplayer      ; draw player
    call ship_draw_full         ; delete old one
    ld e,0                      ; store a flag to track first time round
    ld b,20                      ; move down 8 pixels
ship_land3:
    push bc
    ld a,e
    push de                     ; store de for next time round
    cp 1                        ; check first time flag
    jp nz,ship_land2             ; don't draw over previous one if first time
    call ship_draw_full         ; delete old one
    call ship_change_frame      ; increment the frame
    ld bc,(ship_initpos2)       ; get the current coords
    ld a,b
    sub 1                       ; move back one pixels
    ld b,a
    ld (ship_initpos2),bc
ship_land2:
    call ship_draw_full         ; draw the ship
    call ship_draw_screen
    pop de
    ld e,1
    pop bc
    djnz ship_land3
    ret

;
; Swap the animation frame between 0 and 32. This will be added to the memory location later
;
ship_change_frame:
    push af
    ld a,(ship_frame)
    cp 0
    jp z,ship_change_frame0
    ld a,0                      ; flip to 0
    jp ship_change_frame1
ship_change_frame0:
    ld a,32                      ; flip to 32
ship_change_frame1:
    ld (ship_frame),a            ; save the frame
    pop af
    ret

ship_draw_screen:
    halt 
    di
    call screen_buffertoscreen  ; copy buffer to screen
    ei                          ; enable interupts
    ret

ship_draw_full:
    ld hl,ship_sprite
    ld bc,(ship_initpos2)         ; load bc with the start coords
    ld (ship_current_sprite),hl  ; put into memory
    ld (ship_current_coords),bc  ; put into memory
    call ship_draw
    ex af,af'
    ld a,(ship_frame)            ; get the animation frame
    ld d,0
    ld e,a
    add hl,de
    ld (ship_current_sprite),hl  ; put into memory
    ex af,af'
    ld bc,(ship_initpos2)         ; load bc with the start coords
    add c,8                      ; move one line down
    ld c,a                       
    ld (ship_current_coords),bc  ; put into memory
    call ship_draw    
    ret

;
; Draw the ship
; Inputs:
; None, all in memory
;
ship_draw:
    ld a,4                              ; 4 pieces per half
ship_draw0:
    push af
    ld hl,(ship_current_sprite)
    ld bc,(ship_current_coords)         ; load bc with the start coords
    call sprites_drawsprite 
    ld hl,(ship_current_sprite)
    ld bc,(ship_current_coords)         ; load bc with the start coords
    ld de,8
    add hl,de
    add b,8
    ld b,a
    ld (ship_current_sprite),hl         ; put into memory
    ld (ship_current_coords),bc         ; put into memory
    pop af
    dec a
    cp 0
    jp nz,ship_draw0
    
    ret
