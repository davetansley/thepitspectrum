;
; tank initial position: vert,horiz
;
tank_initpos:
    defb 16,208   
tank_initpos2:
    defb 0,0
tank_frame:
    defb 0
tank_anim:
    defb 17
;
; The current memory location
;
tank_current_sprite:
    defb 0,0

tank_current_coords:
    defb 0,0

;
; Initialise the tank
;
tank_init:
    ld bc,(tank_initpos)
    ld (tank_initpos2),bc       ; save the initial position for later use
    ld hl,tank_frame
    ld (hl),0
    ld hl,tank_anim
    ld (hl),17                  ; reset tank
    ret

;
;   Draw and move the tank
;   Start processing at frame 200
;   Don't move if anim is zero
;   Decrement frame if moved
;
tank_process:
    ld a,(tank_anim)
    cp 0
    ret z                       ; return if we've already moved
    call game_getcurrentframe   ; get the current frame number into a
    cp 75
    ret c                       ; return if the frame number is below 100
    call tank_move              ; move tank if not
    ld a,(tank_anim)
    dec a
    ld (tank_anim),a            ; decrease the anim count
    ret

tank_move:
    ld bc,(tank_initpos2)
    push bc
    ld a,(tank_anim)
    cp 17                       ; check first time flag
    jp z,tank_move1             ; don't draw over previous one if first time
    call tank_draw_full         ; delete old one
    ld bc,(tank_initpos2)       ; get the current coords
    ld a,b
    sub 1                       ; move back one pixels
    ld b,a
    ld (tank_initpos2),bc
tank_move1:
    call tank_draw_full         ; draw the tank
    pop bc
    ret

tank_draw_full:
    ld hl,tank_sprite
    ld bc,(tank_initpos2)         ; load bc with the start coords
    ld (tank_current_sprite),hl  ; put into memory
    ld (tank_current_coords),bc  ; put into memory
    call tank_draw
    ex af,af'
    ld a,(tank_frame)            ; get the animation frame
    ld d,0
    ld e,a
    add hl,de
    ld (tank_current_sprite),hl  ; put into memory
    ex af,af'
    ld bc,(tank_initpos2)         ; load bc with the start coords
    add c,8                      ; move one line down
    ld c,a                       
    ld (tank_current_coords),bc  ; put into memory
    call tank_draw   
    ld a,2
    call buffer_marklineforupdate  
    ld a,3
    call buffer_marklineforupdate   ; mark the first two rows for update 
    ret

;
; Draw the tank
; Inputs:
; None, all in memory
;
tank_draw:
    ld a,4                              ; 4 pieces per half
tank_draw0:
    push af
    ld hl,(tank_current_sprite)
    ld bc,(tank_current_coords)         ; load bc with the start coords
    call sprites_drawsprite 
    ld hl,(tank_current_sprite)
    ld bc,(tank_current_coords)         ; load bc with the start coords
    ld de,8
    add hl,de
    add b,8
    ld b,a
    ld (tank_current_sprite),hl         ; put into memory
    ld (tank_current_coords),bc         ; put into memory
    pop af
    dec a
    cp 0
    jp nz,tank_draw0
    
    ret
