
;
; Array of robot states
; x,y,state (0 inactive, 1 active), direction (0 left, 1 right), anim offset
robots_robots:
    defb 0,0,0,0,0
    defb 0,0,0,0,0
    defb 0,0,0,0,0

robots_initcoords:
    defb 24,232

;
; When this reaches zero, spawn a new robot
;
robots_spawntimer:
    defb 250

;
; The number of robots active
;
robots_numberactive:
    defb 0

;
; Initialises the robots
;
robots_init:
    ld b,15
    ld ix,robots_robots
robots_init0:
    ld (ix),0                       ; reset robot states back to zero
    inc ix 
    djnz robots_init0
    ld a,0
    ld (robots_numberactive),a
    ld a,250
    ld (robots_spawntimer),a
    ret

;
; Spawns a new robot
; Inputs:
; ix - pointer to start of robot array entry
;
robots_spawn:
    ld b,3
    ld ix,robots_robots
robots_spawn0: 
    ld a,(ix+2)                 ; get the state
    cp 0
    jp nz,robots_spawn1         ; if already active, move on
    ld bc,(robots_initcoords)
    ld (ix),bc
    ld (ix+2),1
    ld a,(robots_numberactive)
    inc a
    ld (robots_numberactive),a  ; increase the number active
    call robots_draw            ; draw initial frame
    ret
robots_spawn1:
    ld de,5
    add ix,de
    djnz robots_spawn0
    ret
;
; Kills robot
; Inputs:
; ix - pointer to start of robot array entry
;
robots_kill:
    ld a,(robots_numberactive)
    dec a
    ld (robots_numberactive),a
    ld (ix+2),0                     ; set to inactive
    ret

;
; Processes the robots
;
robots_process:
    ld a,(robots_numberactive)              ; first, check if we need to spawn a new robot
    cp 3                                    ; 3 is the maximum
    jp z,robots_process0                    ; if already three, nothing to do
    ld a,(robots_spawntimer)                ; now check the spawn timer
    cp 0
    jp nz,robots_process1                   ; if it hasn't reached zero yet, just decrease
    ld a,250
    ld (robots_spawntimer),a                ; reset the spawn timer
    call robots_spawn                       ; spawn a robot
    jp robots_process0                      ; carry on
robots_process1:
    dec a
    ld (robots_spawntimer),a                ; decrease the spawn timer and store
robots_process0:
    ld b,3                                  ; max number of robots
    ld ix, robots_robots                    ; point ix at the robot array
robots_process2:
    push bc
    ld a,(ix+2)                             ; check the state
    cp 0 
    jp z,robots_process3                    ; if not active, move on
    call robots_draw                        ; draw over existing
    call robots_move                        ; move the robot
    call robots_draw                        ; draw the new robot
robots_process3:
    pop bc
    ld de,5
    add ix,de
    djnz robots_process2
    ret

;
; Moves a robot
; Inputs:
; ix - points to first byte of robot in array
robots_move:
    ret

;
; Draws a robot
; Inputs:
; ix - points to first byte of robot in array
robots_draw:
    ld bc,(ix)
    ld hl,robot_sprite                      ; set to the robot sprite
    ld a,(ix+3)                             ; get the direction
    cp 0
    jp z,robots_draw0                       ; if left, nothing to do
    ld de,32
    add hl,de                               ; add four frames to sprite
robots_draw0:
    call sprites_drawsprite
    ret