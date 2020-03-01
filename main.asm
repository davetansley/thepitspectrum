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
    include "screen\lifescreen.asm"
    include "screen\gameover.asm"
    include "screen\endlevel.asm"
    include "screen\options.asm"

    include "sound\sound.asm"

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
    include "game\missiles.asm"
    include "game\thepit.asm"
    include "game\monster.asm"
    include "game\robots.asm"
    include "game\bullet.asm"

;===========================================================================
; main routine - the code execution starts here.
; Sets up the new interrupt routine, the memory
; banks and jumps to the start loop.
;===========================================================================
main:
    call options_show

    ; Draw the title screen
main_titlescreen:
    call titlescreen_show
    call player_init_gamestart

main_lifestart:

    call player_init_lifestart
    
    call lifescreen_draw        ; show the lives remaining screen
    
    call init_start
    call screen_draw
    call buffer_allbuffertoscreen
    
    call missiles_init
    call ship_land              ; land the ship
    call tank_init
    call diamonds_init  
    call thepit_init
    call monster_init
    call robots_init
    call bullet_init

mloop:    
    ;halt 
    call main_loop_processing

    ;
    ; Check if the player died
    ;
    ld hl,player+10
    ld a,(hl)                   ; check if the player died this frame
    cp 1
    jp nz,mloop0
    call player_died        ; do end of life housekeeping
    ld b,40
    call utilities_pauseforframes
    ld hl,player+9        ; check lives remaining
    ld a,(hl)
    cp 0
    jp z,main_gameover   ; leave the loop if we're done
    jp main_lifestart    ; otherwise, start a new life
mloop0:
    ;
    ; Check if the player completed the level
    ;
    ld hl,player+13
    ld a,(hl)
    cp 1 
    jp nz,mloop
    call player_checkforexit
    cp 1                        ; look at return, if 1, level has been completed
    jp z,main_endlevel          ; jump to level transition screen
    jp mloop                ; start the loop again


main_loop_processing:

    call buffer_buffertoscreen  ; copy buffer to screen
    call buffer_clearlist       ; zero the updated lines list
    call player_getlocation     ; figure out where the player is
    call player_drawplayer      ; delete player
    call control_input          ; check input
    call player_drawplayer      ; draw player
    call tank_process           ; prcoess the tank
    call ship_process           ; proces the ship
    call rocks_processrocks     ; process falling rocks
    call thepit_process         ; process the pit trap
    call missiles_process       ; process missiles
    call monster_process        ; process monster
    call robots_process         ; process robots
    call bullet_process         ; process the bullet
    call diamonds_twinkle       ; make the diamonds twinkle
    call scores_printscore      ; update the score on screen
    call game_incrementframe    ; increment the game frame
    
    ret

main_gameover:
    call gameover_draw          ; show the game over screen
    jp main_titlescreen         ; go back to title

main_endlevel:
    call player_recordcurrentstate
    call endlevel_draw          ; show the end level screen
    jp main_lifestart           ; start a new life

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