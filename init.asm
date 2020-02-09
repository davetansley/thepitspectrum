;
; Set up at start up
;
init_start:
; We want a black screen.
    call $0D6B
    ld a,71             ; white ink (7) on black paper (0),
                        ; bright (64).
    ld (23693),a        ; set our screen colours.
    xor a               ; quick way to load accumulator with zero.
    call 8859           ; set permanent border colours.
    call 3503           ; ROM routine - clears screen, opens chan 2.
    
    ret

;
;   Start coord
;   vert c, horiz b 
start_coord:
    defb 24,48
