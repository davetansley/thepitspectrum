; ##########################################################################
; Print a character
; Inputs:
; b - x coord
; c - y coord
; d - character
; e - colour
; ##########################################################################
utilities_print_char:
    ld a,e
    ld (23695),a        ; set our temporary screen colours.
    ld a,22
    rst 16              ; Calls the Sinclair PRINT AT routine
    ld a,b              ; Gets the X co-ordinate
    dec a
    rst 16
    ld a,c              ; and the Y co-ordinate
    rst 16              ; So, essentially PRINT AT X,Y; like in BASIC
    ld a,d              ; ASCII code for udg.
    rst 16              ; draw block.
    ret


;Inputs:
;     DE and A are factors
;Outputs:
;     A is not changed
;     B is 0
;     C is not changed
;     DE is not changed
;     HL is the product
;Time:
;     342+6x
;
utilities_multiply:
    ld b,8          ;7           7
    ld hl,0         ;10         10
    add hl,hl     ;11*8       88
    rlca          ;4*8        32
    jr nc,$+3     ;(12|18)*8  96+6x
        add hl,de   ;--         --
    djnz $-5      ;13*7+8     99
    ret             ;10         10

utilities_waitforkey:
    ld hl,23560         ; LAST K system variable.
    ld (hl),0           ; put null value there.
utilities_waitforkey0: 
    ld a,(hl)           ; new value of LAST K.
    cp 0                ; is it still zero?
    jr z,utilities_waitforkey0           ; yes, so no key pressed.
    ret                 ; key was pressed.

;
; Waits number of frames for keypress. If got, returns 1, if not 0
; Inputs:
; a - number of frames to waits
; Ouputs:
; e - 0 not pressed, 1 pressed
utilities_waitforkey_forframes:
    ld hl,23560         ; LAST K system variable.
    ld (hl),0           ; put null value there.
    ld b,a              ; number of frames to wait
utilities_waitforkey_forframes0: 
    ld a,(hl)           ; new value of LAST K.
    cp 0                ; is it still zero?
    jr z,utilities_waitforkey_forframes1           ; yes, so no key pressed.
    ld e,1              ; set the pressed flag
    ret                 ; key was pressed.
utilities_waitforkey_forframes1:
    halt                ; wait for frame
    halt                ; wait for frame
    djnz utilities_waitforkey_forframes0 ; loop again
    ld e,0              ; nothing pressed in time
    ret


