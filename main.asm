    DEVICE ZXSPECTRUM48

    org $8000

    ; We want a black screen.
main:
    call $0D6B
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    ld (23693),a        ; set our screen colours.
    xor a               ; quick way to load accumulator with zero.
    call 8859           ; set permanent border colours.
    call 3503           ; ROM routine - clears screen, opens chan 2.


    include "utilities.asm"

    include "leveldata\level01.asm"
    include "graphics\udgs.asm"

;===========================================================================
; Stack. 
;===========================================================================

; Stack: this area is reserved for the stack
STACK_SIZE: equ 100    ; in words

; Reserve stack space
    defw 0  ; WPMEM, 2
stack_bottom:
    defs    STACK_SIZE*2, 0
stack_top:  
    defw 0  ; WPMEM, 2

       SAVESNA "ThePit.sna", main