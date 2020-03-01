; Tiles graphics.
sprites:
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 0, space
    defb    255,255,255,255,255,255,255,255   ; 1, cyan block
    defb	  1,  3,  7, 15, 31, 63,127,255   ; 2, slope left
    defb    128,192,224,240,248,252,254,255   ; 3, slope right
    defb    85,170, 85,170, 85,170, 85,170    ; 4, dirt
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 5, sky block
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 6, slime block
    defb    0  ,0  ,  0,  0,  0,  0,  0,  0   ; 7, for reuse
    defb    24, 44, 78,143,241,114, 52,  24    ; 8, diamond
    defb    60,126,255,127,254,254,255,126    ; 9, rock	
	defb	126,255,127,127,254,255,126, 60    ; 10, rock 2
    defb    0  ,  0,  0,  0,  0,  0,255,255   ; 11, sky block, pixel trapdoor
	defb    153,219,126, 36,255, 66, 36, 24   ; 12, missile
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 13, sky block, tank background
	defb    0,  0,  0,  0,  0, 60, 90, 52     ; 14, gem
	defb	253,254,253,254,253,254,253,254   ; 15, damaged mountain
	defb	244,248,244,248,244,248,244,248   ; 16, damaged mountain 2
	defb	208,224,208,224,208,224,208,224   ; 17, damaged mountain 3
	defb	 64,128, 64,128, 64,128, 64,128   ; 18, damaged mountain 4
	defb	0,  0,  0,237,237,  0,  0,  0	  ; 19, tank missile
	defb    153,219,126, 36,255,126, 60, 24   ; 20, missile active
    defb	255,255,  0,  0,  0,  0,  0,  0	  ; 21, the pit 1
	defb	252,252,  0,  0,  0,  0,  0,  0	  ; 22, the pit 2
	defb	240,240,  0,  0,  0,  0,  0,  0	  ; 23, the pit 3
	defb	192,192,  0,  0,  0,  0,  0,  0	  ; 24, the pit 4
	defb	0,0,  0,  0,  0,  0,  0,  0	  	  ; 25, the pit 5
    defb    255,255,255,255,255,255,255,255   ; 26, slime block, green on green
	defb    0,  0,  0,102,  0,  0,  0,  0     ; 27, bullet

    
sprite_attrs:
    defb    070 ; 0, space
    defb    077 ; 1, cyan block
    defb    077 ; 2, slope left
    defb    077 ; 3, slope right
    defb    070 ; 4, dirt
    defb    078 ; 5, sky
    defb    102 ; 6, slime
    defb    066 ; 7, trapdoor
    defb    070 ; 8, diamond
    defb    066 ; 9, rock
    defb    066 ; 10, rock 2
	defb    073 ; 11, sky, trapdoor
	defb    067 ; 12, missile
    defb    074 ; 13, sky, red ink (tank)
    defb    070 ; 14, gem
    defb    077 ; 15, damaged mountain
    defb    077 ; 16, damaged mountain 2
    defb    077 ; 17, damaged mountain 3
    defb    077 ; 18, damaged mountain 4
	defb 	000 ; 19, tank missile (not used
	defb    067 ; 20, missile active
	defb	066	; 21, the pit 1
	defb	066	; 22, the pit 2
	defb	066	; 23, the pit 3
	defb	066	; 24, the pit 4
	defb	066	; 25, the pit 5
	defb    100 ; 26, slime, green on green
	defb 	070 ; 27, bullet
    

player_sprite:
	defb	 16, 57,146,252, 56, 61,195,128 ; 0 up/down 1
	defb	  8, 28,  8,252, 60, 28, 22, 50 ; 1 left 1
    defb   	 16, 56, 16, 63, 60, 56,104, 76 ; 2 right 1  
	defb	  8,156, 73, 63, 28,188,195,  1 ; 3 up/down 2    
	defb	  8, 28,  8,252, 60, 60,100, 12; 4 left 2
	defb	 16, 56, 16, 63, 60, 60, 38, 48 ; 5 right 2  
	defb	 84, 40, 16, 18, 30, 92,253, 95 ; 6 shoot up
	defb	 2,135, 66,191, 79,143, 25,  3  ; 7 shoot left
	defb	 64,225, 66,253,242,241,152,192 ; 8 shoot right
	defb	 250,191, 58,120, 72,  8, 20, 42 ; 9 shoot down
	defb 	 146,186,148,120, 56,120, 68,195 ; 10 crushed 1
	defb	  73, 93, 41, 30, 28, 30, 34,195 ; 11 crushed 2
	defb	114, 87,114,103,111, 69,225,155  ; 12 fight 1
	defb	 78,234, 78,230,246,162,135,217  ; 13 fight 2

;
; First 4 top half, next 4 bottom 1, next 4 bottom 2
;
ship_sprite:
	defb	  0,  0,  0,  1,  3, 31,127,255
	defb	 31,  1,127,255,255,255,255,255
	defb	248,128,254,255,255,255,255,255
	defb	  0,  0,  0,128,192,248,254,255
	defb	179,179,127, 31,  3,  3,  2,  7
	defb	143,143,255,255,255, 15,  7,131
	defb	 15, 15,255,255,255, 16, 32,193
	defb	 25, 25,254,248,192,192, 64,224
	defb	152,152,127, 31,  3,  3,  2,  7
	defb	240,240,255,255,255,  8,  4,131
	defb	241,241,255,255,255,240,224,193
	defb	205,205,254,248,192,192, 64,224

;
;  First 8 frames are tank, last frame is the gun barrel
;
tank_sprite:
	defb	  0,  0,  0,127,127,  0,  0,  0
	defb	  1,  3,254,252,254,255,127, 64
	defb	255,255,  3,249,  3,255,255,  1
	defb	  0,  0,192,224,224,192,  0,  0
	defb	 63,127,225,251,247,225,127, 63
	defb	255,255, 22, 82, 84, 22,255,255
	defb	255,255,168,169,155,168,255,255
	defb	252,254,143,175,159,175,254,252
	defb	  0,  0,  0, 31, 31,  0,  0,  0 ; +64

monster_sprite:
	defb	  2, 64,  6, 96, 11,208, 22,104
	defb	 25,152, 23,232, 53,172,127,254
	defb	254,127,236, 55,143,241,143,241
	defb	  8, 16,  8, 16, 24, 24,  0,  0		; frame 1
	defb	  2, 64,  6, 96, 11,208, 22,104
	defb	 25,152, 23,232,245,175,255,255
	defb	188, 61, 14,112, 15,240, 15,240
	defb	 16,  8, 48, 12,  0,  0,  0,  0		; frame 2

robot_sprite:
	defb	 14, 10,206, 62,206, 18, 34,102		; left 1
	defb	 14, 10, 78,254, 78, 18, 36,108		; 2
	defb	 14, 10, 78,254, 78, 50, 99,  3		; 3
	defb	 14, 10,206, 62,206, 10,  9, 27		; 4
	defb	112, 80,115,124,115, 72, 68,102		; right 1
	defb	112, 80,114,127,114, 72, 36, 54		; 2
	defb	112, 80,114,127,114, 76,198,192		; 3
	defb	112, 80,115,124,115, 80,144,216		; 4
	defb     56,169,186,124, 56, 42, 38, 96     ; dead 1
	defb	 28,149, 93, 62, 28, 84,100,  6		; dead 2