; ###############################################################
; Data for level 1
; ###############################################################
level01:
    
    defb 0,0,5,5,5,5,5,5,5,5,5,5,5,5,2,1,1,1,1,3,5,5,5,5,5,5,5,5,5,5,5,0
    defb 0,0,5,5,5,5,5,5,5,5,5,5,2,1,1,1,1,1,1,1,1,3,5,5,5,5,5,5,5,5,5,0
    defb 0,0,5,5,5,5,5,5,5,5,2,1,1,1,1,1,1,1,1,1,1,1,1,3,5,5,5,5,5,5,5,0
    defb 0,0,1,1,1,1,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,3,5,5,5,5,5,5,0
    defb 0,0,1,1,4,4,0,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0,1,0
    defb 0,0,1,4,4,4,0,0,0,0,0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,0,0,0,0,0,1,0
    defb 0,0,1,4,4,1,1,1,1,1,4,0,4,4,1,1,1,1,1,1,1,0,0,0,0,0,1,1,1,1,1,0
    defb 0,0,1,4,4,4,4,4,4,1,4,0,4,4,4,4,4,4,0,0,0,0,4,4,4,4,4,4,4,4,1,0
    defb 0,0,1,1,1,4,1,1,1,1,0,0,4,4,4,4,4,4,0,4,4,4,4,4,4,4,4,4,4,4,1,0
    defb 0,0,1,0,0,0,0,0,0,4,0,0,4,4,4,4,4,4,0,4,4,4,4,4,4,4,0,0,0,0,1,0
    defb 0,0,1,7,7,7,7,7,7,1,0,0,4,4,4,4,4,4,0,4,4,4,4,4,4,4,0,4,4,0,1,0
    defb 0,0,1,0,0,0,0,0,0,1,4,0,4,4,4,4,4,4,0,4,4,4,4,4,4,4,0,4,4,0,1,0
    defb 0,0,1,0,0,0,0,0,0,1,4,0,4,4,4,4,4,4,0,4,4,4,4,4,4,4,0,4,4,0,1,0
    defb 0,0,1,6,6,6,6,6,6,1,4,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,4,4,0,1,0
    defb 0,0,1,6,6,6,6,6,6,1,4,0,4,4,4,4,4,4,0,4,4,4,0,4,4,4,4,4,4,0,1,0
    defb 0,0,1,6,6,6,6,6,6,1,4,0,4,4,4,4,4,4,0,4,4,4,0,4,4,4,4,4,4,0,1,0
    defb 0,0,1,6,6,6,6,6,6,1,4,0,4,4,4,4,4,4,0,4,4,4,0,4,4,4,4,4,4,0,1,0
    defb 0,0,1,1,1,1,1,1,1,1,4,0,4,4,4,4,4,4,0,4,4,4,0,4,4,4,4,4,4,0,1,0
    defb 0,0,1,4,4,4,4,4,4,4,4,0,4,4,4,4,4,4,0,4,4,4,0,0,0,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,0,0,0,0,0,4,4,4,4,4,4,0,4,4,4,4,4,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,4,4,4,4,4,4,4,4,0,4,4,4,4,4,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,1,1,1,1,1,1,1,1,1,1,1,1,1,1,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,1,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,1,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,1,0,0,0,0,0,0,0,0,0,0,0,0,1,4,0,4,4,4,4,1,0
    defb 0,0,1,4,4,4,0,4,4,4,4,0,0,0,0,0,0,0,0,0,0,0,0,4,4,4,4,4,4,4,1,0
    defb 0,0,1,4,4,4,4,4,4,4,1,0,0,0,0,0,0,0,0,0,0,0,0,1,4,4,4,4,4,4,1,0
    defb 0,0,1,4,4,4,4,4,4,4,1,0,8,0,1,0,8,0,0,1,0,8,0,1,4,4,4,4,4,4,1,0
    defb 0,0,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,0

; ###############################################################
; Rock data: horiz, vert, state
; ###############################################################   
level01rocks:
    defb 9,4,0
    defb 12,7,0
    defb 16,7,0
    defb 11,9,0  

;
; Score area colours
;
score_colours:
    defb 71,71,71,71,71,71,71,71,71,71,71,66,66,66,67,67,67,67,67,66,66,71,71,71,71,71,71,71,71,71,71,71
    defb 71,71,71,71,71,71,71,71,71,71,71,66,66,66,66,66,66,66,66,66,66,66,66,71,71,71,71,71,71,71,71,71