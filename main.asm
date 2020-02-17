    DEVICE ZXSPECTRUM48

    ORG $8000    

;===========================================================================
; Persistent watchpoint.
; Change WPMEMx (remove the 'x' from WPMEMx) below to activate.
; If you do so the program will hit a breakpoint when it tries to
; write to the first byte of the 3rd line.
; When program breaks in the fill_memory sub routine please hover over hl
; to see that it contains 0x5804 or COLOR_SCREEN+64.
;===========================================================================

; WPMEMx 0x5840, 1, w


;===========================================================================
; Include modules
;===========================================================================
    include "init.asm"
    include "utilities.asm"
    include "strings.asm"
    include "screen\buffer.asm"
    include "screen\screen.asm"
    include "screen\sprites.asm"
    include "screen\titlescreen.asm"

    include "leveldata\level01.asm"
    include "graphics\graphics.asm"

    include "game\control.asm"
    include "game\movement.asm"
    include "game\game.asm"
    include "game\player.asm"
    include "game\ship.asm"
    include "game\tank.asm"
    include "game\rocks.asm"
    include "game\scores.asm"
    include "game\diamonds.asm"

;===========================================================================
; main routine - the code execution starts here.
; Sets up the new interrupt routine, the memory
; banks and jumps to the start loop.
;===========================================================================
main:
    
    ; Setup stack
    ld sp,stack_top

    ; Draw the title screen
    call titlescreen_show

    call init_start
    call screen_draw
    call buffer_allbuffertoscreen
    call player_init
    call ship_land              ; land the ship
    call tank_init
    call diamonds_init
    
mloop:    
    halt 
    call main_loop_processing
    jp mloop

main_loop_processing:
    call buffer_buffertoscreen  ; copy buffer to screen
    call buffer_clearlist       ; zero the updated lines list
    call player_drawplayer      ; delete player
    call control_keyboard       ; check keyboard
    call player_drawplayer      ; draw player
    call tank_process           ; prcoess the tank
    call rocks_processrocks     ; process falling rocks
    call diamonds_twinkle       ; make the diamonds twinkle

    call game_incrementframe    ; increment the game frame
    
    ret

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