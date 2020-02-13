; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L02BF:       equ  02BFh	; 703. Subroutine. Called by: L0038[004Ah].
L5C78:       equ  5C78h	; 23672. Data accessed by: 003Ah(in L0038), 003Eh(in L0038)


             org 0038h ; 0038h


; Subroutine: Size=27, CC=2.
; Called by: -
; Calls: L02BF.
0038 L0038:
0038 F5           PUSH AF     
0039 E5           PUSH HL     
003A 2A 78 5C     LD   HL,(L5C78) 	; 5C78h
003D 23           INC  HL     
003E 22 78 5C     LD   (L5C78),HL 	; 5C78h
0041 7C           LD   A,H    
0042 B5           OR   L      
0043 20 03        JR   NZ,L0048 	; 0048h
0045 FD 34 40     INC  (IY+64) 
0048 L0048:
0048 C5           PUSH BC     
0049 D5           PUSH DE     
004A CD BF 02     CALL L02BF  	; 02BFh
004D D1           POP  DE     
004E C1           POP  BC     
004F E1           POP  HL     
0050 F1           POP  AF     
0051 FB           EI          
0052 C9           RET         


0053 E1           defb E1h    	; 225,  -31
0054 6E           defb 6Eh    	; 110, 'n'
0055 FD           defb FDh    	; 253,   -3
0056 75           defb 75h    	; 117, 'u'
0057 00           defb 00h    	; 0
0058 ED           defb EDh    	; 237,  -19
0059 7B           defb 7Bh    	; 123, '{'
005A 3D           defb 3Dh    	; 61, '='
005B 5C           defb 5Ch    	; 92, '\'
005C C3           defb C3h    	; 195,  -61
005D C5           defb C5h    	; 197,  -59
005E 16           defb 16h    	; 22
005F FF           defb FFh    	; 255,   -1
0060 FF           defb FFh    	; 255,   -1
0061 FF           defb FFh    	; 255,   -1
0062 FF           defb FFh    	; 255,   -1
0063 FF           defb FFh    	; 255,   -1
0064 FF           defb FFh    	; 255,   -1
0065 FF           defb FFh    	; 255,   -1
0066 F5           defb F5h    	; 245,  -11
0067 E5           defb E5h    	; 229,  -27
0068 2A           defb 2Ah    	; 42, '*'
0069 B0           defb B0h    	; 176,  -80
006A 5C           defb 5Ch    	; 92, '\'
006B 7C           defb 7Ch    	; 124, '|'
006C B5           defb B5h    	; 181,  -75
006D 20           defb 20h    	; 32, ' '
006E 01           defb 01h    	; 1
006F E9           defb E9h    	; 233,  -23
0070 E1           defb E1h    	; 225,  -31
0071 F1           defb F1h    	; 241,  -15
0072 ED           defb EDh    	; 237,  -19
0073 45           defb 45h    	; 69, 'E'
0074 2A           defb 2Ah    	; 42, '*'
0075 5D           defb 5Dh    	; 93, ']'
0076 5C           defb 5Ch    	; 92, '\'
0077 23           defb 23h    	; 35, '#'
0078 22           defb 22h    	; 34, '"'
0079 5D           defb 5Dh    	; 93, ']'
007A 5C           defb 5Ch    	; 92, '\'
007B 7E           defb 7Eh    	; 126, '~'
007C C9           defb C9h    	; 201,  -55
007D FE           defb FEh    	; 254,   -2
007E 21           defb 21h    	; 33, '!'
007F D0           defb D0h    	; 208,  -48
0080 FE           defb FEh    	; 254,   -2
0081 0D           defb 0Dh    	; 13
0082 C8           defb C8h    	; 200,  -56
0083 FE           defb FEh    	; 254,   -2
0084 10           defb 10h    	; 16
0085 D8           defb D8h    	; 216,  -40
0086 FE           defb FEh    	; 254,   -2
0087 18           defb 18h    	; 24
0088 3F           defb 3Fh    	; 63, '?'
0089 D8           defb D8h    	; 216,  -40
008A 23           defb 23h    	; 35, '#'
008B FE           defb FEh    	; 254,   -2
008C 16           defb 16h    	; 22
008D 38           defb 38h    	; 56, '8'
008E 01           defb 01h    	; 1
008F 23           defb 23h    	; 35, '#'
0090 37           defb 37h    	; 55, '7'
0091 22           defb 22h    	; 34, '"'
0092 5D           defb 5Dh    	; 93, ']'
0093 5C           defb 5Ch    	; 92, '\'
0094 C9           defb C9h    	; 201,  -55
0095 BF           defb BFh    	; 191,  -65
0096 52           defb 52h    	; 82, 'R'
0097 4E           defb 4Eh    	; 78, 'N'
0098 C4           defb C4h    	; 196,  -60
0099 49           defb 49h    	; 73, 'I'
009A 4E           defb 4Eh    	; 78, 'N'
009B 4B           defb 4Bh    	; 75, 'K'
; ...
; ...
; ...