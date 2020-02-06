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