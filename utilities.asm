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
    jr nz,utilities_waitforkey1           ; yes, so no key pressed.
    ld bc,31                        ; Kempston joystick port.
    in a,(c)                        ; read input.
    and 16
    jp z,utilities_waitforkey0
utilities_waitforkey1:
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
    push bc
    ld bc,31                        ; Kempston joystick port.
    in a,(c)                        ; read input.
    pop bc
    and 16
    jp z,utilities_waitforkey_forframes2
    ld e,1              ; set the pressed flag
    ret                 ; key was pressed.
utilities_waitforkey_forframes2:
    halt                ; wait for frame
    halt                ; wait for frame
    djnz utilities_waitforkey_forframes0 ; loop again
    ld e,0              ; nothing pressed in time
    ret

;
; Clears the screen
; Inputs:
; a - attribute colour
utilities_clearscreen:
    halt
    ld hl,22528         ; attr
    ld de,22529         ; attr+1
    ld bc,767
    ld (hl),a 
    ldir 
    
    ld hl, 16384        ;pixels 
    ld de, 16385        ;pixels + 1
    ld bc, 6143         ;pixels area length - 1
    ld (hl), 0          ;set first byte to '0'
    ldir                ;copy bytes

    ret

;
; Wait for a number of frames
; Inputs:
; b - number of frames
utilities_pauseforframes:
    halt
    djnz utilities_pauseforframes
    ret

utilities_readkey:          
    LD HL,utilties_keymap              ; Point HL at the keyboard list
    LD D,8                                  ; This is the number of ports (rows) to check
    LD C,$FE                            ; C is always FEh for reading keyboard ports
utilities_readkey_0:        
    LD B,(HL)                               ; Get the keyboard port address from table
    INC HL                                  ; Increment to list of keys
    IN A,(C)                                ; Read the row of keys in
    AND $1F                                     ; We are only interested in the first five bits
    LD E,5                                  ; This is the number of keys in the row
utilities_readkey_1:        
    SRL A                                   ; Shift A right; bit 0 sets carry bit
    JR NC,utilities_readkey_2   ; If the bit is 0, we've found our key
    INC HL                                  ; Go to next table address
    DEC E                                   ; Decrement key loop counter
    JR NZ,utilities_readkey_1   ; Loop around until this row finished
    DEC D                                   ; Decrement row loop counter
    JR NZ,utilities_readkey_0   ; Loop around until we are done
    AND A                                   ; Clear A (no key found)
    jp utilities_readkey
utilities_readkey_2:        
    LD A,(HL)                               ; We've found a key at this point; fetch the character code!
    RET
 
utilties_keymap:           
    defb $FE,"#","Z","X","C","V"
    defb $FD,"A","S","D","F","G"
    defb $FB,"Q","W","E","R","T"
    defb $F7,"1","2","3","4","5"
    defb $EF,"0","9","8","7","6"
    defb $DF,"P","O","I","U","Y"
    defb $BF,"#","L","K","J","H"
    defb $7F," ","#","M","N","B"


;
; Generates a randomish number in the range 0 to e
; Inputs:
; e - upper value
; Outputs:
; a - random number
utilities_randomupper
    ld a,(game_framenumber)
    ld l,a
    ld h,0
    ld d,0
    ld bc,de
utilities_randomupper0:
    or a
    sbc hl,bc
    jp p,utilities_randomupper0
    add hl,bc
    ld bc,0
    add hl,bc
    ld a,l
    ret

;
; A pointer to somewhere in the first 8k of ram
;
utilities_rampointer:
    defb 64,31

utilities_randomfromram:
    ld hl,(utilities_rampointer)
    dec hl
    ld a,h
    cp 0
    jp nz,utilities_randomfromram0
    ld hl,8000                        ; check if pointer high byte has reached zero, if so, set to 8000 
utilities_randomfromram0:
    ld (utilities_rampointer),hl
    ld a,(hl)                         ; get a byte from here
    ret 
