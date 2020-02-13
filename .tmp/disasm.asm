; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0008:       equ  0008h	; 8. Restart. Called by: L00FC[0114h].
L00DA:       equ  00DAh
L00E1:       equ  00E1h
L0164:       equ  0164h
L1BEE:       equ  1BEEh	; 7150. Subroutine. Called by: L1C52[1C52h].
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


             org 1C52h ; 1C52h


; Subroutine: Size=4, CC=1.
; Called by: -
; Calls: L1BEE.
1C52 L1C52:
1C52 CD EE 1B     CALL L1BEE  	; 1BEEh
1C55 C9           RET         


1C56 3A           defb 3Ah    	; 58, ':'
1C57 3B           defb 3Bh    	; 59, ';'
1C58 5C           defb 5Ch    	; 92, '\'
1C59 F5           defb F5h    	; 245,  -11
1C5A CD           defb CDh    	; 205,  -51
1C5B FB           defb FBh    	; 251,   -5
1C5C 24           defb 24h    	; 36, '$'
1C5D F1           defb F1h    	; 241,  -15
1C5E FD           defb FDh    	; 253,   -3
1C5F 56           defb 56h    	; 86, 'V'
1C60 01           defb 01h    	; 1
1C61 AA           defb AAh    	; 170,  -86
1C62 E6           defb E6h    	; 230,  -26
1C63 40           defb 40h    	; 64, '@'
1C64 20           defb 20h    	; 32, ' '
1C65 24           defb 24h    	; 36, '$'
1C66 CB           defb CBh    	; 203,  -53
1C67 7A           defb 7Ah    	; 122, 'z'
1C68 C2           defb C2h    	; 194,  -62
1C69 FF           defb FFh    	; 255,   -1
1C6A 2A           defb 2Ah    	; 42, '*'
1C6B C9           defb C9h    	; 201,  -55
1C6C CD           defb CDh    	; 205,  -51
1C6D B2           defb B2h    	; 178,  -78
1C6E 28           defb 28h    	; 40, '('
1C6F F5           defb F5h    	; 245,  -11
1C70 79           defb 79h    	; 121, 'y'
1C71 F6           defb F6h    	; 246,  -10
1C72 9F           defb 9Fh    	; 159,  -97
1C73 3C           defb 3Ch    	; 60, '<'
1C74 20           defb 20h    	; 32, ' '
1C75 14           defb 14h    	; 20
1C76 F1           defb F1h    	; 241,  -15
1C77 18           defb 18h    	; 24
1C78 A9           defb A9h    	; 169,  -87
1C79 E7           defb E7h    	; 231,  -25
1C7A CD           defb CDh    	; 205,  -51
1C7B 82           defb 82h    	; 130, -126
1C7C 1C           defb 1Ch    	; 28
1C7D FE           defb FEh    	; 254,   -2
1C7E 2C           defb 2Ch    	; 44, ','
1C7F 20           defb 20h    	; 32, ' '
1C80 09           defb 09h    	; 9
1C81 E7           defb E7h    	; 231,  -25
1C82 CD           defb CDh    	; 205,  -51
1C83 FB           defb FBh    	; 251,   -5
1C84 24           defb 24h    	; 36, '$'
1C85 FD           defb FDh    	; 253,   -3
1C86 CB           defb CBh    	; 203,  -53
1C87 01           defb 01h    	; 1
1C88 76           defb 76h    	; 118, 'v'
1C89 C0           defb C0h    	; 192,  -64
1C8A CF           defb CFh    	; 207,  -49
1C8B 0B           defb 0Bh    	; 11
1C8C CD           defb CDh    	; 205,  -51
1C8D FB           defb FBh    	; 251,   -5
1C8E 24           defb 24h    	; 36, '$'
1C8F FD           defb FDh    	; 253,   -3
1C90 CB           defb CBh    	; 203,  -53
1C91 01           defb 01h    	; 1
1C92 76           defb 76h    	; 118, 'v'
1C93 C8           defb C8h    	; 200,  -56
1C94 18           defb 18h    	; 24
1C95 F4           defb F4h    	; 244,  -12
1C96 FD           defb FDh    	; 253,   -3
1C97 CB           defb CBh    	; 203,  -53
1C98 01           defb 01h    	; 1
1C99 7E           defb 7Eh    	; 126, '~'
1C9A FD           defb FDh    	; 253,   -3
1C9B CB           defb CBh    	; 203,  -53
1C9C 02           defb 02h    	; 2
1C9D 86           defb 86h    	; 134, -122
1C9E C4           defb C4h    	; 196,  -60
1C9F 4D           defb 4Dh    	; 77, 'M'
1CA0 0D           defb 0Dh    	; 13
1CA1 F1           defb F1h    	; 241,  -15
1CA2 3A           defb 3Ah    	; 58, ':'
1CA3 74           defb 74h    	; 116, 't'
1CA4 5C           defb 5Ch    	; 92, '\'
1CA5 D6           defb D6h    	; 214,  -42
1CA6 13           defb 13h    	; 19
1CA7 CD           defb CDh    	; 205,  -51
1CA8 FC           defb FCh    	; 252,   -4
1CA9 21           defb 21h    	; 33, '!'
1CAA CD           defb CDh    	; 205,  -51
1CAB EE           defb EEh    	; 238,  -18
1CAC 1B           defb 1Bh    	; 27
1CAD 2A           defb 2Ah    	; 42, '*'
1CAE 8F           defb 8Fh    	; 143, -113
1CAF 5C           defb 5Ch    	; 92, '\'
1CB0 22           defb 22h    	; 34, '"'
1CB1 8D           defb 8Dh    	; 141, -115
1CB2 5C           defb 5Ch    	; 92, '\'
1CB3 21           defb 21h    	; 33, '!'
1CB4 91           defb 91h    	; 145, -111
1CB5 5C           defb 5Ch    	; 92, '\'
; ...
; ...
; ...