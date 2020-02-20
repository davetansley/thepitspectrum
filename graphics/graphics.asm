; Tiles graphics.
sprites:
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 0, space
    defb    255,255,255,255,255,255,255,255   ; 1, cyan block
    defb	  1,  3,  7, 15, 31, 63,127,255   ; 2, slope left
    defb    128,192,224,240,248,252,254,255   ; 3, slope right
    defb    85,170, 85,170, 85,170, 85,170    ; 4, dirt
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 5, sky block
    defb    255,255,255,255,255,255,255,255   ; 6, slime block
    defb    255,255,  0,  0,  0,  0,  0,  0   ; 7, trapdoor
    defb    24, 44, 78,143,241,114, 52,  24    ; 8, diamond
    defb    60,126,255,127,254,254,255,126    ; 9, rock	
	defb	126,255,127,127,254,255,126, 60    ; 10, rock 2
    defb    0  ,  0,  0,  0,  0,  0,255,255   ; 11, sky block, pixel trapdoor
	defb    153,219,126, 36,255,126, 60, 24   ; 12, missile
    defb    0  ,  0,  0,  0,  0,  0,  0,  0   ; 13, sky block, tank background
	defb    0,  0,  0,  0,  0, 60, 90, 52     ; 14, gem
    
sprite_attrs:
    defb    070 ; 0, space
    defb    101 ; 1, cyan block
    defb    077 ; 2, slope left
    defb    077 ; 3, slope right
    defb    070 ; 4, dirt
    defb    078 ; 5, sky
    defb    076 ; 6, slime
    defb    066 ; 7, trapdoor
    defb    070 ; 8, diamond
    defb    066 ; 9, rock
    defb    066 ; 10, rock 2
	defb    073 ; 11, sky, trapdoor
	defb    067 ; 12, missile
    defb    074 ; 13, sky, red ink (tank)
    defb    070 ; 14, gem

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
	defb	  0,  0,  0, 31, 31,  0,  0,  0