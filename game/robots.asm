
;
; Array of robot states
; x,y,state (0 inactive, 1 active), direction (0 left, 1 right), anim offset, automove frames remaining, move direction (0 left, 1 right, 3 up, 4 down)
robots_robots:
    defb 0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0
    defb 0,0,0,0,0,0,0

robots_initcoords:
    defb 24,232

;
; When this reaches zero, spawn a new robot
;
robots_spawntimer:
    defb 250

;
; When this reaches max, change the anim frame
;
robots_animtimer:
    defb 0

;
; When this reaches max, change move the robot
;
robots_movetimer:
    defb 0


;
; The number of robots active
;
robots_numberactive:
    defb 0

;
; Tracks which directions a robot can move
; up,down,left,right
robots_canmovedirections:
    defb 0,0,0,0

;
; The current robot speed
;
robots_robotspeed:
    defb 2

;
; The current max robots
;
robots_robotsmax:
    defb 2

;
; Initialises the robots
;
robots_init:
    ld b,35
    ld ix,robots_robots
robots_init0:
    ld (ix),0                       ; reset robot states back to zero
    inc ix 
    djnz robots_init0
    ld a,0
    ld (robots_numberactive),a
    ld a,250
    ld (robots_spawntimer),a
    ; Self writing code
    ; Robot speed
    ld a,(robots_robotspeed)
    ld (robots_process7+1),a
    inc a
    ld (robots_process6+1),a
    ; Robots max
    ld a,(robots_robotsmax)
    ld (robots_spawn+1),a
    ld (robots_process8+1),a
    ld (robots_process0+1),a
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
    ld de,7
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
robots_process8:
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
    ld a,(robots_movetimer)
robots_process7:                            ; self writing code - the number in the comparison will be ovewritten 
    cp 4
    jp nz,robots_process3                   ; can we move this frame
    call robots_draw                        ; draw over existing
    call robots_move                        ; move the robot
    call robots_draw                        ; draw the new robot
robots_process3:
    pop bc
    ld de,7
    add ix,de
    djnz robots_process2
    ld a,(robots_animtimer)
    inc a
    cp 8
    jp nz,robots_process4
    ld a,0                                  ; reset if we reached max
robots_process4:
    ld (robots_animtimer),a
    ld a,(robots_movetimer)                 ; increment the robot move timer
    inc a
robots_process6:                            ; self writing code - the number in the comparison will be ovewritten 
    cp 5                                    ; there is another reference to this number above
    jp nz,robots_process5
    ld a,0
robots_process5:
    ld (robots_movetimer),a
    
    ret

;
; Moves a robot
; Inputs:
; ix - points to first byte of robot in array
robots_move:
    ld a,(robots_animtimer)                 ; get the anim timer
    cp 7                                    ; compare with 8
    jp nz,robots_move1                       ; if even, don't increment frame
    ld a,(ix+4)                             ; get the anim frame
    ld b,8
    add a,b                                 ; add to anim frame
    cp 32
    jp nz,robots_move0                      ; if not 32, then just store
    ld a,0                                  ; otherwise, reset
robots_move0:
    ld (ix+4),a                             ; store
robots_move1:
    ld a,(ix+5)
    cp 0                                    ; are we automoving
    jp z,robots_move2                       ; if not, keep directions
    call robots_automove
    ret
robots_move2:
    call robots_checkdirectionsandmove
    ret

;
; Processes automove
; Inputs:
; ix - points to the current robot
; a - number of frames left to move
robots_automove:
    dec a
    ld (ix+5),a                         ; store the decreased frames
    ld bc,(ix)                          ; get coords
    ld a,(ix+6)                         ; get the direction
    cp 0                                ; left
    jp nz,robots_automove1
    dec b
    jp robots_automove2                             
robots_automove1:
    inc b                             
robots_automove2:
    ld (ix),bc
    ret

;
; Checks if a robot can move in all directions, then picks one and moves there.
; This looks complicated, but really what it does is:
; 1) Look at the current direction
; 2) Randomly determine which orthoganal direction check first
; 3) If orthogonal can't be moved, keep going in direction we're going
; 4) Otherwise, back the way we came
; Inputs:
; ix - points to the current robot
;
robots_checkdirectionsandmove:
    ld a,(ix+6)                 ; get the direction
    cp 0                        ; left
    jp nz,robots_checkdirectionsandmove0
    ; random check
    call game_getcurrentframe
    and 1                       ; odd or even
    jp z,robots_checkdirectionsandmove3
    call robots_checkupthendown ; prefer up over down
    cp 1
    ret z
    jp robots_checkdirectionsandmove4
robots_checkdirectionsandmove3:
    call robots_checkdownthenup ; prefer down over up
    cp 1
    ret z
robots_checkdirectionsandmove4:
    ; check left
    call robots_checkleftandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check right 
    call robots_checkrightandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; if we're here and haven't moved...     
    ret
robots_checkdirectionsandmove0  
    cp 1                        ; right
    jp nz,robots_checkdirectionsandmove1
    ; ALREADY MOVING RIGHT
    ; random check
    call game_getcurrentframe
    and 1                       ; odd or even
    jp z,robots_checkdirectionsandmove5
    call robots_checkdownthenup ; prefer down over up
    cp 1
    ret z
    jp robots_checkdirectionsandmove6
robots_checkdirectionsandmove5:
    call robots_checkupthendown ; prefer down over up
    cp 1
    ret z
robots_checkdirectionsandmove6:
    ; check right 
    call robots_checkrightandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check left
    call robots_checkleftandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; if we're here and haven't moved...     
    ret
robots_checkdirectionsandmove1
    cp 2                        ; up
    jp nz,robots_checkdirectionsandmove2
    ; ALREADY MOVING UP
    ; random check
    call game_getcurrentframe
    and 1                       ; odd or even
    jp z,robots_checkdirectionsandmove7
    call robots_checkleftthenright ; prefer left over right
    cp 1
    ret z
    jp robots_checkdirectionsandmove8
robots_checkdirectionsandmove7:
    call robots_checkrightthenleft ; prefer right over left
    cp 1
    ret z
robots_checkdirectionsandmove8:
    ; check up
    call robots_checkupandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check down
    call robots_checkdownandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; if we're here and haven't moved...     
    ret
robots_checkdirectionsandmove2
    ; ALREADY MOVING DOWN
    ; random check
    call game_getcurrentframe
    and 1                       ; odd or even
    jp z,robots_checkdirectionsandmove9
    call robots_checkrightthenleft ; prefer right over left
    cp 1
    ret z
    jp robots_checkdirectionsandmove10
robots_checkdirectionsandmove9:
    call robots_checkleftthenright ; prefer left over right
    cp 1
    ret z
robots_checkdirectionsandmove10:
    ; check down
    call robots_checkdownandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check right first
    call robots_checkrightandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check up
    call robots_checkupandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; if we're here and haven't moved...     
    ret

;
; Different orders of checking directions, for pseudo random motion
;
robots_checkdownthenup:
    ; check down
    call robots_checkdownandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check up
    call robots_checkupandmove
    ret

robots_checkupthendown:
    ; check up
    call robots_checkupandmove
    cp 1
    ret z
    ; check down
    call robots_checkdownandmove
    cp 1
    ret
robots_checkrightthenleft:
    ; check right
    call robots_checkrightandmove
    cp 1
    ret z                       ; if we moved, don't check again
    ; check left
    call robots_checkleftandmove
    ret

robots_checkleftthenright:
    ; check left
    call robots_checkleftandmove
    cp 1
    ret z
    ; check right
    call robots_checkrightandmove
    cp 1
    ret

;
; Checks up for movement
; Outputs:
; a - 1 if have moved
robots_checkupandmove:
    ; check above
    ld bc,(ix)                  ; load current coords into bc
    ld a,c
    cp 32
    ret c
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly above (subtract 32)
    ld de,32
    sbc hl,de                       ; memory location of line above now in hl
    ld a,(hl)                       ; get the contents of the line
    cp 0
    jp nz,robots_checkupandmove0    ; can't move here so return
    ld bc,(ix)                  ; load current coords into bc
    dec c                       ; move up
    ld (ix),bc
    ld (ix+6),2
    ld a,1
    ret
robots_checkupandmove0:
    ld a,0
    ret

;
; Checks down for movement
; Outputs:
; a - 1 if have moved
robots_checkdownandmove:
    ; check below
    ld bc,(ix)                  ; load current coords into bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly underneath (add 256)
    inc h                       ; memory location of cell beneath now in hl
    ld a,(hl)                       ; get the contents of the line
    cp 0
    jp nz,robots_checkdownandmove0    ; can't move here so return
    ld bc,(ix)                  ; load current coords into bc
    inc c                       ; move up
    ld (ix),bc
    ld (ix+6),3
    ld a,1
    ret
robots_checkdownandmove0:
    ld a,0
    ret

;
; Checks left for movement
; Outputs:
; a - 1 if have moved
robots_checkleftandmove:
    ; check below
    ld bc,(ix)                  ; load current coords into bc
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    ld a,b
    ld b,8
    sub b                           ; move one cell left
    ld b,a
    dec hl                          ; memory location of cell to the right now in hl
    call movement_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z,robots_checkleftandmove0    ; if zero can't move
    ld bc,(ix)                  ; load current coords into bc
    dec b
    ld (ix),bc
    ld (ix+6),0
    ld (ix+5),7                 ; set the auto move frames
    ld (ix+3),0                 ; set to right
    ld a,1
    ret
robots_checkleftandmove0:
    ld a,0
    ret

;
; Checks right for movement
; Outputs:
; a - 1 if have moved
robots_checkrightandmove:
    ; check below
    ld bc,(ix)                  ; load current coords into bc
    ld a,b
    cp 232
    jp z,robots_checkrightandmove0  ; can't move if at edge
    call sprites_scadd              ; get the memory location of cell into de
    ld hl,de                        ; look at cell directly to the right (add 1)
    ld a,8
    add b                           ; move one cell right
    ld b,a
    inc hl                          ; memory location of cell to the right now in hl
    call movement_spaceisempty       ; check space is empty
    ld a,e                          ; check space empty flag
    cp 0
    jp z,robots_checkrightandmove0    ; if zero can't move
    ld bc,(ix)                  ; load current coords into bc
    inc b
    ld (ix),bc
    ld (ix+6),1
    ld (ix+5),7                 ; set the auto move frames
    ld (ix+3),1                 ; set to right
    ld a,1
    ret
robots_checkrightandmove0:
    ld a,0
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
    ld a,(ix+4)                             ; get the anim frame
    ld de,0
    ld e,a
    add hl,de                               ; add to base
    call sprites_drawsprite
    ret