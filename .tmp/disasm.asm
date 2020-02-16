; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L4156:       equ  4156h	; 16726. Subroutine. Called by: L00A7[00B7h].
L4353:       equ  4353h	; 17235. Subroutine. Called by: L00A7[00A7h].
L454C:       equ  454Ch	; 17740. Subroutine. Called by: L00A7[00C2h].
L4753:       equ  4753h	; 18259. Subroutine. Called by: L00A7[00E2h].
L4942:       equ  4942h	; 18754. Subroutine. Called by: L00A7[00FCh].
L4E41:       equ  4E41h	; 20033. Subroutine. Called by: L00A7[0101h].
L5153:       equ  5153h	; 20819. Subroutine. Called by: L00A7[00DFh].
L5453:       equ  5453h	; 21587. Subroutine. Called by: L00A7[00F1h].
LBD3C:       equ  BD3Ch	; 48444. Subroutine. Called by: L00A7[0104h].
LD441:       equ  D441h	; 54337. Subroutine. Called by: L00A7[00B2h].


             org 00A7h ; 00A7h


; Subroutine: Size=100, CC=12.
; Called by: -
; Calls: L4156, L4353, L454C, L4753, L4942, L4E41, L5153, L5453, LBD3C, LD441.
00A7 L00A7:
00A7 D4 53 43     CALL NC,L4353 	; 4353h
00AA 52           LD   D,D    
00AB 45           LD   B,L    
00AC 45           LD   B,L    
00AD 4E           LD   C,(HL) 
00AE A4           AND  H      
00AF 41           LD   B,C    
00B0 54           LD   D,H    
00B1 54           LD   D,H    
00B2 D2 41 D4     JP   NC,LD441 	; D441h
00B5 54           LD   D,H    
00B6 41           LD   B,C    
00B7 C2 56 41     JP   NZ,L4156 	; 4156h
00BA 4C           LD   C,H    
00BB A4           AND  H      
00BC 43           LD   B,E    
00BD 4F           LD   C,A    
00BE 44           LD   B,H    
00BF C5           PUSH BC     
00C0 56           LD   D,(HL) 
00C1 41           LD   B,C    
00C2 CC 4C 45     CALL Z,L454C 	; 454Ch
00C5 CE 53        ADC  A,53h  	; 83, 'S'
00C7 49           LD   C,C    
00C8 CE 43        ADC  A,43h  	; 67, 'C'
00CA 4F           LD   C,A    
00CB D3 54        OUT  (0054h),A 	; 84
00CD 41           LD   B,C    
00CE CE 41        ADC  A,41h  	; 65, 'A'
00D0 53           LD   D,E    
00D1 CE 41        ADC  A,41h  	; 65, 'A'
00D3 43           LD   B,E    
00D4 D3 41        OUT  (0041h),A 	; 65
00D6 54           LD   D,H    
00D7 CE 4C        ADC  A,4Ch  	; 76, 'L'
00D9 CE 45        ADC  A,45h  	; 69, 'E'
00DB 58           LD   E,B    
00DC D0           RET  NC     
00DD 49           LD   C,C    
00DE 4E           LD   C,(HL) 
00DF D4 53 51     CALL NC,L5153 	; 5153h
00E2 D2 53 47     JP   NC,L4753 	; 4753h
00E5 CE 41        ADC  A,41h  	; 65, 'A'
00E7 42           LD   B,D    
00E8 D3 50        OUT  (0050h),A 	; 80
00EA 45           LD   B,L    
00EB 45           LD   B,L    
00EC CB 49        BIT  1,C    
00EE CE 55        ADC  A,55h  	; 85, 'U'
00F0 53           LD   D,E    
00F1 D2 53 54     JP   NC,L5453 	; 5453h
00F4 52           LD   D,D    
00F5 A4           AND  H      
00F6 43           LD   B,E    
00F7 48           LD   C,B    
00F8 52           LD   D,D    
00F9 A4           AND  H      
00FA 4E           LD   C,(HL) 
00FB 4F           LD   C,A    
00FC D4 42 49     CALL NC,L4942 	; 4942h
00FF CE 4F        ADC  A,4Fh  	; 79, 'O'
0101 D2 41 4E     JP   NC,L4E41 	; 4E41h
0104 C4 3C BD     CALL NZ,LBD3C 	; BD3Ch
0107 3E BD        LD   A,BDh  	; 189,  -67
0109 3C           INC  A      
010A BE           CP   (HL)   
; ...
; ...
; ...