;
; Timer for deciding how fast the trap withdraws
;
thepit_timer:
    defb 0

;
; Ticks for the trap state. Will count to 3 then reset
;
thepit_trapcount:
    defb 0

;
; The horizontal coordinate of the current pit trap
;
thepit_trapcoord:
    defb 8

;
; Initialises the pit
;
thepit_init:
    ld hl,thepit_trapcoord
    ld (hl),8
    ld hl,thepit_trapcount
    ld (hl),0
    ret

;
; Performs per frame processing on the pit room
;
thepit_process:
    ld a,(player_location)
    cp 2                            ; if two, the player is in the pit, so process the trap
    jp nz,thepit_process0
    ld bc,(player)                  ; get the player's coords to check if about to fall
    ld a,8
    add a,c
    ld c,a                          ; look at the square underneath
    call screen_getcharcoordsfromscreencoords ; get the cell coords
    call screen_ischarempty
    cp 1                            ; check if this is 1=empty
    jp z,thepit_process2
    ld a,(thepit_timer)             ; get the timer
    inc a
    ld (thepit_timer),a             ; store
    cp 2                           ; have we reached the trigger?
    jp nz, thepit_process0          ; no need to do anything
    ld a,0
    ld (thepit_timer),a             ; zero the timer and process
    ld a,(thepit_trapcount)         ; get the current count
    inc a
    ld (thepit_trapcount),a         ; reset the trap count
    cp 4                            ; do we need to begin another character?
    jp nz,thepit_process1           ; if not, draw as normal
    ld a,0
    ld (thepit_trapcount),a         ; reset the trap count
    ld a,(thepit_trapcoord)         ; get the trap horiz coord
    cp 2
    jp z,thepit_process0
    ld c,a
    ld b,10
    ld a,70
    call screen_setattr             ; set the attr of the empty square to yellow on black
    ld a,(thepit_trapcoord)         ; get the trap horiz coord
    dec a
    ld (thepit_trapcoord),a         ; store the reduced coord

thepit_process1:                    ; draw the trapdoor in current position
    ld a,(thepit_trapcoord)
    cp 2
    jp z, thepit_process0           ; don't process outside of the pit
    ld c,a    
    ld b,10                         ; vertical coord will always be the same
    ld a,(thepit_trapcount)         ; get the trap count
    ld e,a                          ; store in e
    ld a,22                         ; 21 is full trapdoor
    add a,e    
    call screen_getblock
    call screen_showchar            ; show the char

thepit_process0:
    ret
thepit_process2:
    call player_pitkillplayer
    ret

