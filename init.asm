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
;   vert, horiz
start_coord:
    defb 24,48  

;
;   Data for players
;   horiz,vert,dir (0 up, 1 down, 2 left, 3 right), frame
player_one:
    defb    0,0,0,0