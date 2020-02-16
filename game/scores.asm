;
; The score of the current player
;
scores_current:
    defb '000000'

;
; The current high score table
;
scores_table:
    defb 3,23,'GAM',255
    defb 6,23,'00000 ',255
    defb 12,23,'GAM',255
    defb 15,23,'00000 ',255
    defb 21,23,'GAM',255
    defb 24,23,'00000 ',255

;
; Displays the high score table at the bottom of the screen
;
scores_showtable:
    ld hl, scores_table
    call string_print
    ld hl, scores_table+6
    call string_print
    ld hl, scores_table+15
    call string_print
    ld hl, scores_table+21
    call string_print
    ld hl, scores_table+30
    call string_print
    ld hl, scores_table+36
    call string_print
    ret