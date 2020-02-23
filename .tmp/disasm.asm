; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0008:       equ  0008h	; 8. Restart. Called by: L00FC[0114h].
L00DA:       equ  00DAh
L00E1:       equ  00E1h
L0164:       equ  0164h
L4942:       equ  4942h	; 18754. Subroutine. Called by: L00FC[00FCh].
L4C46:       equ  4C46h	; 19526. Subroutine. Called by: L00FC[015Ah].
L4E41:       equ  4E41h	; 20033. Subroutine. Called by: L00FC[0101h].
L4F46:       equ  4F46h	; 20294. Subroutine. Called by: L00FC[0121h].
L4F4D:       equ  4F4Dh	; 20301. Subroutine. Called by: L00FC[0127h].
LBD3C:       equ  BD3Ch	; 48444. Subroutine. Called by: L00FC[0104h].


             org 00FCh ; 00FCh


; Subroutine: Size=100, CC=14.
; Called by: -
; Calls: L0008, L4942, L4C46, L4E41, L4F46, L4F4D, LBD3C.
00FC L00FC:
00FC D4 42 49     CALL NC,L4942 	; 4942h
00FF CE 4F        ADC  A,4Fh  	; 79, 'O'
0101 D2 41 4E     JP   NC,L4E41 	; 4E41h
0104 C4 3C BD     CALL NZ,LBD3C 	; BD3Ch
0107 3E BD        LD   A,BDh  	; 189,  -67
0109 3C           INC  A      
010A BE           CP   (HL)   
010B 4C           LD   C,H    
010C 49           LD   C,C    
010D 4E           LD   C,(HL) 
010E C5           PUSH BC     
010F 54           LD   D,H    
0110 48           LD   C,B    
0111 45           LD   B,L    
0112 CE 54        ADC  A,54h  	; 84, 'T'
0114 CF 53        RST  08h,53h 	; Custom opcode
0116 54           LD   D,H    
0117 45           LD   B,L    
0118 D0           RET  NC     
0119 44           LD   B,H    
011A 45           LD   B,L    
011B 46           LD   B,(HL) 
011C 20 46        JR   NZ,L0164 	; 0164h
011E CE 43        ADC  A,43h  	; 67, 'C'
0120 41           LD   B,C    
0121 D4 46 4F     CALL NC,L4F46 	; 4F46h
0124 52           LD   D,D    
0125 4D           LD   C,L    
0126 41           LD   B,C    
0127 D4 4D 4F     CALL NC,L4F4D 	; 4F4Dh
012A 56           LD   D,(HL) 
012B C5           PUSH BC     
012C 45           LD   B,L    
012D 52           LD   D,D    
012E 41           LD   B,C    
012F 53           LD   D,E    
0130 C5           PUSH BC     
0131 4F           LD   C,A    
0132 50           LD   D,B    
0133 45           LD   B,L    
0134 4E           LD   C,(HL) 
0135 20 A3        JR   NZ,L00DA 	; 00DAh
0137 43           LD   B,E    
0138 4C           LD   C,H    
0139 4F           LD   C,A    
013A 53           LD   D,E    
013B 45           LD   B,L    
013C 20 A3        JR   NZ,L00E1 	; 00E1h
013E 4D           LD   C,L    
013F 45           LD   B,L    
0140 52           LD   D,D    
0141 47           LD   B,A    
0142 C5           PUSH BC     
0143 56           LD   D,(HL) 
0144 45           LD   B,L    
0145 52           LD   D,D    
0146 49           LD   C,C    
0147 46           LD   B,(HL) 
0148 D9           EXX         
0149 42           LD   B,D    
014A 45           LD   B,L    
014B 45           LD   B,L    
014C D0           RET  NC     
014D 43           LD   B,E    
014E 49           LD   C,C    
014F 52           LD   D,D    
0150 43           LD   B,E    
0151 4C           LD   C,H    
0152 C5           PUSH BC     
0153 49           LD   C,C    
0154 4E           LD   C,(HL) 
0155 CB 50        BIT  2,B    
0157 41           LD   B,C    
0158 50           LD   D,B    
0159 45           LD   B,L    
015A D2 46 4C     JP   NC,L4C46 	; 4C46h
015D 41           LD   B,C    
015E 53           LD   D,E    
015F C8           RET  Z      
; ...
; ...
; ...