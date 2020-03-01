;
; Draws the title screen
;
titlescreen_show:
    call titlescreen_init
    call titlescreen_drawtitle
    ld b,50
    call utilities_pauseforframes         ; pause for a second

    ld a,250                              ; wait for 200 frames
    call utilities_waitforkey_forframes   ; wait for keypress
    ld a,e
    cp 1                                  ; was anything pressed?
    ret z                                 ; end titlescreen if so

    call titlescreen_alt_init             ; otherwise, draw alt screen
    call titlescreen_alt_drawtitle
    ld b,50
    call utilities_pauseforframes         ; pause for a second

    ld a,250                              ; wait for 200 frames
    call utilities_waitforkey_forframes   ; wait for keypress
    ld a,e
    cp 1                                  ; was anything pressed?
    jp nz,titlescreen_show                ; start again if not
    ret

;
; Draws the iconic logo
; 
titlescreen_drawtitle:
    ld b,103              ; number of points
    ld ix,titlescreen_logo_data
titlescreen_drawtitle0:
    push bc
    ld c,(ix)                   ; got horiz
    inc ix
    ld b,(ix)                   ; got vert
    inc ix
    call screen_getscreenattradress ; memory in de
    inc de                      ; slide one to the right, since I'm too lazy to change the data
    ld a,19
    ld (de),a
    pop bc
    djnz titlescreen_drawtitle0 ; loop if we're not at the end
    ret

;
; Draws the alternate title screen
;
titlescreen_alt_drawtitle:
    ld hl,string_alttitlescreen_1
    call string_print
    ld hl,string_alttitlescreen_2
    call string_print
    ld hl,string_alttitlescreen_3
    call string_print
    ld b,32
    ld a,67
    ld de,22528                         ; top row attrs here 
    call screen_setcolours
    ld b,32
    ld a,70
    ld de,22528+416                     ; 13th row attrs here 
    call screen_setcolours
    ld b,32
    ld a,67
    ld de,22528+544                         ; 17th row attrs here 
    call screen_setcolours
    ld b,32
    ld a,66
    ld de,22528+672                         ; 21st row attrs here 
    call screen_setcolours
    ret

;
; Initialises the screen
;
titlescreen_init:
; We want a black screen.
    ld a,11             ; magenta ink (7) on blue paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,1              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    
    ld hl,string_titlescreen_copyright
    call string_print
    
    ret

;
; Initialises the screen
;
titlescreen_alt_init:
; We want a black screen.
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    call utilities_clearscreen
    ld (23693),a        ; set our screen colours.
    ld a,0              ; 2 is the code for red.
    out (254),a         ; write to port 254.
    
    ret

;
; Horiz, vert
;
titlescreen_logo_data:
    defb 8,0,9,0,10,0,12,0,15,0,17,0,18,0,19,0
    defb 9,1,12,1,15,1,17,1
    defb 9,2,12,2,13,2,14,2,15,2,17,2,18,2,19,2
    defb 9,3,12,3,15,3,17,3
    defb 9,4,12,4,15,4,17,4,18,4,19,4
    defb 0,6,1,6,2,6,3,6,4,6,5,6,6,6,7,6,8,6,9,6,10,6,11,6
    defb 16,6,17,6,18,6,19,6,20,6,21,6,22,6,23,6,24,6,25,6,26,6,27,6
    defb 2,7,2,8,2,9,2,10,2,11,2,12,2,13,2,14,2,15,2,16,2,17,2,18,2,19,2,20,2,21
    defb 25,7,25,8,25,9,25,10,25,11,25,12,25,13,25,14,25,15,25,16,25,17,25,18,25,19,25,20,25,21
    defb 3,11,4,11,5,11,6,11,7,11,8,11,9,11,10,11,11,11
    defb 11,7,11,8,11,9,11,10
    defb 16,13,16,15,16,16,16,17,16,18,16,19
    