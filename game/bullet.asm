;
; Current state: x & y coords (screen), direction (0 left, 1 right), state 
;
bullet_state:
    defb 0,0,0,0

;
; Initialise a the bullet
;
bullet_init:
    ld ix,bullet_state
    ld (ix),0
    ld (ix+1),0
    ld (ix+2),0
    ld (ix+3),0
    ret

;
; Shoots the bullet
;
bullet_shoot:
    ld ix,bullet_state
    ld bc,(player)              ; get the player coords
    ld a,(player+2)             ; get the player direction
    cp 1                        ; going left?
    jp z,bullet_shoot0
    ld a,8
    add a,b                     ; going right so add eight to start coords
    ld b,a
    ld (ix+2),1                 ; set right
    jp bullet_shoot1
bullet_shoot0:
    ld a,b
    ld b,8
    sub b
    ld b,a                      ; going left so subtract eight to start coords
    ld (ix+2),0                 ; set right
bullet_shoot1:   
    ld (ix),bc        ; store coords
    ld (ix+3),1       ; set state to 1
    call bullet_draw ; draw the initial frame
    ret

;
; Performs bullet processing
;
bullet_process:
    ld a,(bullet_state+3)       ; get the state
    cp 0
    ret z                       ; don't draw if this has become inactive
    call bullet_draw            ; delete current frame
    call bullet_move            ; move the bullet
    ld a,(bullet_state+3)       ; get the state
    cp 0
    ret z                       ; don't draw if this has become inactive             
    call bullet_draw            ; draw new frame
    ret

;
; Moves the bullet, checking for collisions
;
bullet_move:
    ld ix,bullet_state
    ld bc,(ix)
    ld a,(ix+2)                 ; get the direction
    cp 0                        ; going left?
    jp z,bullet_move0
    ld a,8
    add b
    ld b,a                      ; add 8 since going right
    jp bullet_move1
bullet_move0:
    ld a,b
    ld b,8
    sub b
    ld b,a                      ; subtract 8 since going left
bullet_move1:
    ld (ix),bc                  ; store new coords
    push bc
    call bullets_checkforrobot
    pop bc
    cp 1                        ; if we hit a robot, keep moving
    ret z
    call sprites_scadd          ; get memory loc of this block into de
    ld hl,96
    add hl,de
    ld a,(hl)                   ; get the content
    cp 0
    ret z                       ; if empty, continue
    ld (ix+3),0                 ; otherwise, mark bullet as inactive
    ret

;
; Draw the bullet
;
bullet_draw:
    ld bc,(bullet_state)        ; get coords
    ld a,27
    call screen_getblock        ; get the block address
    call sprites_drawsprite     ; draw the sprite
    ret

;
; Checks to see if the robot is hitting a bullet
; Outputs: 
; a = 0 if not robot hit
; a = 1 if robot not hit
bullets_checkforrobot:
    ld a,0
    ld (bullets_tmp),a
    ld a,(robots_robotsmax) ; robots to check
    ld b,a
    ld iy,robots_robots   ; start of robot array
bullets_checkforrobot0:
    push bc
    ld a,(iy+2)             ; get the state
    cp 1
    jp nz,bullets_checkforrobot1 ; if not active, don't check
    ld de,(iy)              ; get robot coords
    ld a,d
    and 248                 ; get nearest multiple of 8
    ld d,a
    ld bc,(bullet_state)    ; get bullet coords
    ld a,d               ; get the player horiz coord 
    sub b                ; subtract robot coord 
    cp 0                ; should be the same
    jp nz,bullets_checkforrobot1 ; if not, haven't hit
    ld a,e               ; get the vert coord  
    sub c                ; subtract the bullet vertical coord from robots
    add 4                ; add the max distance
    cp 9                ; compare to max*2+1? if carry flag set, they've hit
    jp nc,bullets_checkforrobot1   ; if not, hasn't hit
    ld (iy+2),2             ; mark the robot as killed
    ld (iy+5),0             ; mark the anim frames as zero
    ld a,1
    ld (bullets_tmp),a      ; hit the flag to say we killed a robot
bullets_checkforrobot1:
    ld de,7
    add iy,de              ; move to next robot
    pop bc
    djnz bullets_checkforrobot0
    ld a,(bullets_tmp)
    ret

bullets_tmp:
    defb 0
    