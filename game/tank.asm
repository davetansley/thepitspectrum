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
; The damage countdown
;
tank_currentdamage:
    defb 240

;
; The damage coordinate
;
tank_currentdamagecoord:
    defb 22,2

;
; Controls when the tank shoots
;
tank_count:
    defb 0

;
; Holds the block number of the current damage sprite
;
tank_damageframe:
    defb 0

;
; The current memory location
;
tank_current_sprite:
    defb 0,0

tank_current_coords:
    defb 0,0

;
; Is the missile displayed - will be 19 if so, 0 if not
;
tank_missile_displayed:
    defb 0

;
; Initialise the tank
;
tank_init:
    ld bc,(tank_initpos)
    ld (tank_initpos2),bc       ; save the initial position for later use
    ld hl,tank_frame
    ld (hl),0
    ld hl,tank_anim
    ld (hl),17  
    ld hl,tank_damageframe              ; reset tank
    ld (hl),0
    ld hl,tank_count
    ld (hl),0
    ld hl,tank_currentdamage
    ld (hl),240
    ld hl,tank_currentdamagecoord
    ld (hl),22
    inc hl
    ld (hl),2
    ld hl,tank_missile_displayed
    ld (hl),0

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
    jp nz,tank_process0         ; fire the tank if we've already moved, or jump to movement
    call tank_fire
    ret
tank_process0:
    call game_getcurrentframe   ; get the current frame number into a
    cp 75
    ret c                       ; return if the frame number is below 100
    call tank_move              ; move tank if not
    ld a,(tank_anim)
    dec a
    ld (tank_anim),a            ; decrease the anim count
    ret

;
; Fires the tank
;
tank_fire:
    ld a,(tank_count)            ; if not, don't do anything
    inc a                        ; increment
    cp 25                        ; have we reached fifty
    jp nz,tank_fire0             
    ld a,0                       ; reset if reached fifty
tank_fire0:                      ; DEALING WITH A NEW BLOCK
    ld (tank_count),a            ; store tank count
    cp 0
    jp z,tank_fire7              ; If this is zero, fire
    ld a,(tank_missile_displayed) ; is the missile displaying?
    cp 0
    ret z                       ; don't do anything if not
    call tank_missilegraphic     ; if not, overwrite the previous tank missile
    ld a,0                       ; reset the flag
    ld (tank_missile_displayed),a
    ld a,2
    call buffer_marklineforupdate 
    ret                        ; only shoot if we're on 0
tank_fire7:
    ld a,(tank_currentdamage)    ; get the damage countdown
    and 7                       ; check if multiple of 8 - house keeping when moving onto a new block
    jp nz,tank_fire1            ; not, so just do a normal frame
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    ld a,c
    cp 10
    jp nz, tank_fire6
    call tank_killedbytank      ; we're through, so the player has died. Kill them.
    ret                         ; return if we're through the mountain
tank_fire6:
    ld a,15
    ld (tank_damageframe),a     ; reset the damage frame
    ld hl,sprites               ; location of the empty block
    call screen_showchar        ; show this character here
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    dec b                       ; look one above
    call screen_ischarempty     ; check if it is empty
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc again
    cp 1
    jp nz,tank_fire2             ; block above isn't empty, so can't move on, copy down above blocks
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    dec c 
    ld (tank_currentdamagecoord),bc ; store the coord
tank_fire1:                         ; DEALING WITH NORMAL DAMAGE
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    ld a,(tank_currentdamage)    ; get the damage countdown
    and 7                       ; is it a multiple of 8? only want to do the first line check then
    jp nz, tank_fire5
    call screen_getcharfirstbyte    ; get the first byte to check if this is a slope
    cp 255                      ; if it's a full line, it will be 255 and not a slope
    jp nz,tank_fire3            ; if it's a slope, handle this differently
tank_fire5:
    ld a,(tank_damageframe)
    call screen_getblock        ; get the block data into hl
    call screen_showchar        ; show this character here
    ld a,(tank_damageframe)
    inc a
    ld (tank_damageframe),a     ; increment the damage block and store
    ld a,(tank_currentdamage)    ; get the damage countdown
    dec a
    dec a
    ld (tank_currentdamage),a     ; decrease current damage by 2 and store
    ld a,(tank_missile_displayed) ; is the missile displaying?
    cp 0
    call z, tank_missilegraphic
    jp tank_fire4
tank_fire2:                     ; DEALING WITH COPYING BLOCKS FROM ABOVE
    dec b 
    push bc  
    call screen_copyblockdown       ; copy the block down
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    pop bc                      ; get the coord we just checked back
    ld a,b
    cp 0
    jp z,tank_fire1             ; if we're at the top of the screen, don't check any more
    push bc
    dec b
    call screen_ischarempty     ; check if it is empty
    pop bc
    cp 1                        ; if empty
    jp nz, tank_fire2            ; copy another one down
    jp tank_fire1               ; otherwise, return to main thread
tank_fire3:                      ; dealing with slopes
    ld a,(tank_currentdamage)    ; get the damage countdown
    ld b,8  
    sub b                        ; special case for slopes
    ld (tank_currentdamage),a    ; decrease the damage countdown by 8, so that next time, we get rid of this block without eroding it 
tank_fire4:                     ; TIDY UP
    call buffer_marklineforupdate 
    ld a,1
    call buffer_marklineforupdate 
    ld a,2
    call buffer_marklineforupdate  
    ret

;
; Displays or hides the missile graphic, and changes the gun
;
tank_missilegraphic:
    ld a,(tank_missile_displayed)
    cp 0
    jp nz,tank_missilegraphic0
    ld a,19
    jp tank_missilegraphic1
tank_missilegraphic0:
    ld a,0
tank_missilegraphic1:
    ld (tank_missile_displayed),a ; store the flipped graphic
    ld bc,(tank_currentdamagecoord)
    inc c
    inc c                   ; print the graphic 2 spaces right
    call screen_getblock        ; get the block data into hl
    call screen_showchar        ; show this character here
    ld b,2
    ld c,24                     ; set gunbarrel coords
    ld de,0
    ld hl,tank_sprite           ; set hl to gunbarrel gfx, shooting is +64
    ld a,(tank_missile_displayed)
    cp 0
    jp z,tank_missilegraphic2
    ld de,64
tank_missilegraphic2:
    add hl,de                   ; work out missile graphic
    call screen_showchar        ; show this character here
    ret

;
; Deal with the player being killed by the tank
;
tank_killedbytank:
    ld bc,(tank_currentdamagecoord) ; get the current damage coord into bc
    ld hl,sprites                   ; empty sprite
    call screen_showchar            ; hide the last piece of dirt
    call player_tankkillplayer
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
