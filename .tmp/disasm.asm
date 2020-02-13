; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0008:       equ  0008h	; 8. Restart. Called by: L2886[288Bh].
L0018:       equ  0018h	; 24. Restart. Called by: L2886[2886h].
L0020:       equ  0020h	; 32. Restart. Called by: L2886[289Ah], L2886[289Bh], L2886[28A7h].
L24FB:       equ  24FBh	; 9467. Subroutine. Called by: L2886[289Ch].
L2712:       equ  2712h	; 10002. Subroutine. Called by: L2886[28A8h].
L5C0B:       equ  5C0Bh	; 23563. Data accessed by: 2892h(in L2886), 2896h(in L2886), 28A4h(in L2886)
L5C5D:       equ  5C5Dh	; 23645. Data accessed by: 288Fh(in L2886), 28A0h(in L2886)


             org 2886h ; 2886h


; Label not accessed.
2886 L2886:
2886 DF           RST  18h    
2887 FE 29        CP   29h    	; 41, ')'
2889 28 02        JR   Z,L288D 	; 288Dh
288B CF 19        RST  08h,19h 	; Custom opcode
288D L288D:
288D D1           POP  DE     
288E EB           EX   DE,HL  
288F 22 5D 5C     LD   (L5C5D),HL 	; 5C5Dh
2892 2A 0B 5C     LD   HL,(L5C0B) 	; 5C0Bh
2895 E3           EX   (SP),HL 
2896 22 0B 5C     LD   (L5C0B),HL 	; 5C0Bh
2899 D5           PUSH DE     
289A E7           RST  20h    
289B E7           RST  20h    
289C CD FB 24     CALL L24FB  	; 24FBh
289F E1           POP  HL     
28A0 22 5D 5C     LD   (L5C5D),HL 	; 5C5Dh
28A3 E1           POP  HL     
28A4 22 0B 5C     LD   (L5C0B),HL 	; 5C0Bh
28A7 E7           RST  20h    
28A8 C3 12 27     JP   L2712  	; 2712h


28AB 23           defb 23h    	; 35, '#'
28AC 7E           defb 7Eh    	; 126, '~'
28AD FE           defb FEh    	; 254,   -2
28AE 21           defb 21h    	; 33, '!'
28AF 38           defb 38h    	; 56, '8'
28B0 FA           defb FAh    	; 250,   -6
28B1 C9           defb C9h    	; 201,  -55
28B2 FD           defb FDh    	; 253,   -3
28B3 CB           defb CBh    	; 203,  -53
28B4 01           defb 01h    	; 1
28B5 F6           defb F6h    	; 246,  -10
28B6 DF           defb DFh    	; 223,  -33
28B7 CD           defb CDh    	; 205,  -51
28B8 8D           defb 8Dh    	; 141, -115
28B9 2C           defb 2Ch    	; 44, ','
28BA D2           defb D2h    	; 210,  -46
28BB 8A           defb 8Ah    	; 138, -118
28BC 1C           defb 1Ch    	; 28
28BD E5           defb E5h    	; 229,  -27
28BE E6           defb E6h    	; 230,  -26
28BF 1F           defb 1Fh    	; 31
28C0 4F           defb 4Fh    	; 79, 'O'
28C1 E7           defb E7h    	; 231,  -25
28C2 E5           defb E5h    	; 229,  -27
28C3 FE           defb FEh    	; 254,   -2
28C4 28           defb 28h    	; 40, '('
28C5 28           defb 28h    	; 40, '('
28C6 28           defb 28h    	; 40, '('
28C7 CB           defb CBh    	; 203,  -53
28C8 F1           defb F1h    	; 241,  -15
28C9 FE           defb FEh    	; 254,   -2
28CA 24           defb 24h    	; 36, '$'
28CB 28           defb 28h    	; 40, '('
28CC 11           defb 11h    	; 17
28CD CB           defb CBh    	; 203,  -53
28CE E9           defb E9h    	; 233,  -23
28CF CD           defb CDh    	; 205,  -51
28D0 88           defb 88h    	; 136, -120
28D1 2C           defb 2Ch    	; 44, ','
28D2 30           defb 30h    	; 48, '0'
28D3 0F           defb 0Fh    	; 15
28D4 CD           defb CDh    	; 205,  -51
28D5 88           defb 88h    	; 136, -120
28D6 2C           defb 2Ch    	; 44, ','
28D7 30           defb 30h    	; 48, '0'
28D8 16           defb 16h    	; 22
28D9 CB           defb CBh    	; 203,  -53
28DA B1           defb B1h    	; 177,  -79
28DB E7           defb E7h    	; 231,  -25
28DC 18           defb 18h    	; 24
28DD F6           defb F6h    	; 246,  -10
28DE E7           defb E7h    	; 231,  -25
28DF FD           defb FDh    	; 253,   -3
28E0 CB           defb CBh    	; 203,  -53
28E1 01           defb 01h    	; 1
28E2 B6           defb B6h    	; 182,  -74
28E3 3A           defb 3Ah    	; 58, ':'
28E4 0C           defb 0Ch    	; 12
28E5 5C           defb 5Ch    	; 92, '\'
28E6 A7           defb A7h    	; 167,  -89
28E7 28           defb 28h    	; 40, '('
28E8 06           defb 06h    	; 6
28E9 CD           defb CDh    	; 205,  -51
; ...
; ...
; ...