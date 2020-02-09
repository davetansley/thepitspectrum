;
; Draws the title screen
;
titlescreen_show:
    call titlescreen_init
    call titlescreen_drawtitle
    call utilities_waitforkey   ; wait for keypress
    ret

;
; Draws the iconic logo
; 
titlescreen_drawtitle:
    ld b,105              ; number of points
    ld ix,titlescreen_logo_data
titlescreen_drawtitle0:
    push bc
    ld c,(ix)                   ; got horiz
    inc ix
    ld b,(ix)                   ; got vert
    inc ix
    call screen_getscreenattradress ; memory in de
    ld a,19
    ld (de),a
    pop bc
    djnz titlescreen_drawtitle0 ; loop if we're not at the end
    ret

;
; Initialises the screen
;
titlescreen_init:
; We want a black screen.
    call $0D6B
    ld a,11             ; magenta ink (7) on blue paper (0),
                        ; bright (64).
    ld (23693),a        ; set our screen colours.
    ld a,1              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    call 3503           ; ROM routine - clears screen, opens chan 2.

    ld hl,string_titlescreen_copyright
    call string_print
    
    ret

;
; Horiz, vert
;
titlescreen_logo_data:
    defb 8,0,9,0,10,0,12,0,15,0,17,0,18,0,19,0,20,0
    defb 9,1,12,1,15,1,17,1
    defb 9,2,12,2,13,2,14,2,15,2,17,2,18,2,19,2,20,2
    defb 9,3,12,3,15,3,17,3
    defb 9,4,12,4,15,4,17,4,18,4,19,4,20,4
    defb 0,6,1,6,2,6,3,6,4,6,5,6,6,6,7,6,8,6,9,6,10,6,11,6
    defb 16,6,17,6,18,6,19,6,20,6,21,6,22,6,23,6,24,6,25,6,26,6,27,6
    defb 2,7,2,8,2,9,2,10,2,11,2,12,2,13,2,14,2,15,2,16,2,17,2,18,2,19,2,20
    defb 25,7,25,8,25,9,25,10,25,11,25,12,25,13,25,14,25,15,25,16,25,17,25,18,25,19,25,20
    defb 3,11,4,11,5,11,6,11,7,11,8,11,9,11,10,11,11,11
    defb 11,7,11,8,11,9,11,10
    defb 16,13,16,15,16,16,16,17,16,18,16,19,16,20
    