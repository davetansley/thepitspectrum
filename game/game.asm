;
; The current frame count, incremented each frame
;
game_framenumber:
    defb    0

;
; Increment frame number by 1
;
game_incrementframe:
    ld a,(game_framenumber)
    inc a
    ld (game_framenumber),a
    ret

;
; Returns current frame
; Outputs:
; a - current frame
;
game_getcurrentframe:
    ld a,(game_framenumber)
    ret