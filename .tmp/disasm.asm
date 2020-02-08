; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0038:       equ  0038h	; 56. Restart. Called by: L88AB[88ABh], L88AB[88ACh], L88AB[88ADh], L88AB[88AEh], L88AB[88AFh], L88AB[88B0h], L88AB[88B1h], L88AB[88B2h], L88AB[88B3h], L88AB[88B4h], L88AB[88B5h], L88AB[88B6h], L88AB[88B7h], L88AB[88B8h], L88AB[88B9h], L88AB[88BAh], L88AB[88BBh], L88AB[88BCh], L88AB[88BDh], L88AB[88BEh], L88AB[88BFh], L88AB[88C0h], L88AB[88C1h], L88AB[88C2h], L88AB[88C3h], L88AB[88C4h], L88AB[88C5h], L88AB[88C6h], L88AB[88C7h], L88AB[88C8h], L88AB[88C9h], L88AB[88CAh], L88AB[88CBh], L88AB[88CCh], L88AB[88CDh], L88AB[88CEh], L88AB[88CFh], L88AB[88D0h], L88AB[88D1h], L88AB[88D2h], L88AB[88D3h], L88AB[88D4h], L88AB[88D5h], L88AB[88D6h], L88AB[88D7h], L88AB[88D8h], L88AB[88D9h], L88AB[88DAh], L88AB[88DBh], L88AB[88DCh], L88AB[88DDh], L88AB[88DEh], L88AB[88DFh], L88AB[88E0h], L88AB[88E1h], L88AB[88E2h], L88AB[88E3h], L88AB[88E4h], L88AB[88E5h], L88AB[88E6h], L88AB[88E7h], L88AB[88E8h], L88AB[88E9h], L88AB[88EAh], L88AB[88EBh], L88AB[88ECh], L88AB[88EDh], L88AB[88EEh], L88AB[88EFh], L88AB[88F0h], L88AB[88F1h], L88AB[88F2h], L88AB[88F3h], L88AB[88F4h], L88AB[88F5h], L88AB[88F6h], L88AB[88F7h], L88AB[88F8h], L88AB[88F9h], L88AB[88FAh], L88AB[88FBh], L88AB[88FCh], L88AB[88FDh], L88AB[88FEh], L88AB[88FFh], L88AB[8900h], L88AB[8901h], L88AB[8902h], L88AB[8903h], L88AB[8904h], L88AB[8905h], L88AB[8906h], L88AB[8907h], L88AB[8908h], L88AB[8909h], L88AB[890Ah], L88AB[890Bh], L88AB[890Ch], L88AB[890Dh], L88AB[890Eh].
L02BF:       equ  02BFh	; 703. Subroutine. Called by: L004A[004Ah].
L034F:       equ  034Fh	; 847. Subroutine. Called by: L0333[0339h].
L0367:       equ  0367h
L5C08:       equ  5C08h	; 23560. Data accessed by: 0308h(in L02D8)
L5C09:       equ  5C09h	; 23561. Data accessed by: 02F7h(in L02D8)
L5C0A:       equ  5C0Ah	; 23562. Data accessed by: 0316h(in L02D8)


             org 004Ah ; 004Ah


; Subroutine: Size=9, CC=1.
; Called by: -
; Calls: L02BF.
004A L004A:
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
009C 45           defb 45h    	; 69, 'E'
009D 59           defb 59h    	; 89, 'Y'
009E A4           defb A4h    	; 164,  -92
009F 50           defb 50h    	; 80, 'P'
00A0 C9           defb C9h    	; 201,  -55
00A1 46           defb 46h    	; 70, 'F'
00A2 CE           defb CEh    	; 206,  -50
00A3 50           defb 50h    	; 80, 'P'
00A4 4F           defb 4Fh    	; 79, 'O'
00A5 49           defb 49h    	; 73, 'I'
00A6 4E           defb 4Eh    	; 78, 'N'
00A7 D4           defb D4h    	; 212,  -44
00A8 53           defb 53h    	; 83, 'S'
00A9 43           defb 43h    	; 67, 'C'
00AA 52           defb 52h    	; 82, 'R'
00AB 45           defb 45h    	; 69, 'E'
00AC 45           defb 45h    	; 69, 'E'
00AD 4E           defb 4Eh    	; 78, 'N'
; ...
; ...
; ...


             org 02D8h ; 02D8h


; Subroutine: Size=70, CC=7.
; Called by: -
; Calls: L031E, L0333.
02D8 L02D8:
02D8 CD 1E 03     CALL L031E  	; 031Eh
02DB D0           RET  NC     
02DC 21 00 5C     LD   HL,5C00h 	; 23552
02DF BE           CP   (HL)   
02E0 28 2E        JR   Z,L0310 	; 0310h
02E2 EB           EX   DE,HL  
02E3 21 04 5C     LD   HL,5C04h 	; 23556
02E6 BE           CP   (HL)   
02E7 28 27        JR   Z,L0310 	; 0310h
02E9 CB 7E        BIT  7,(HL) 
02EB 20 04        JR   NZ,L02F1 	; 02F1h
02ED EB           EX   DE,HL  
02EE CB 7E        BIT  7,(HL) 
02F0 C8           RET  Z      
02F1 L02F1:
02F1 5F           LD   E,A    
02F2 77           LD   (HL),A 
02F3 23           INC  HL     
02F4 36 05        LD   (HL),05h 	; 5
02F6 23           INC  HL     
02F7 3A 09 5C     LD   A,(L5C09) 	; 5C09h
02FA 77           LD   (HL),A 
02FB 23           INC  HL     
02FC FD 4E 07     LD   C,(IY+7) 
02FF FD 56 01     LD   D,(IY+1) 
0302 E5           PUSH HL     
0303 CD 33 03     CALL L0333  	; 0333h
0306 E1           POP  HL     
0307 77           LD   (HL),A 
0308 L0308:
0308 32 08 5C     LD   (L5C08),A 	; 5C08h
030B FD CB 01 EE  SET  5,(IY+1) 
030F C9           RET         
0310 L0310:
0310 23           INC  HL     
0311 36 05        LD   (HL),05h 	; 5
0313 23           INC  HL     
0314 35           DEC  (HL)   
0315 C0           RET  NZ     
0316 3A 0A 5C     LD   A,(L5C0A) 	; 5C0Ah
0319 77           LD   (HL),A 
031A 23           INC  HL     
031B 7E           LD   A,(HL) 
031C 18 EA        JR   L0308  	; 0308h


; Subroutine: Size=21, CC=4.
; Called by: L02D8[02D8h].
; Calls: -
031E L031E:
031E 42           LD   B,D    
031F 16 00        LD   D,00h  	; 0
0321 7B           LD   A,E    
0322 FE 27        CP   27h    	; 39, '''
0324 D0           RET  NC     
0325 FE 18        CP   18h    	; 24
0327 20 03        JR   NZ,L032C 	; 032Ch
0329 CB 78        BIT  7,B    
032B C0           RET  NZ     
032C L032C:
032C 21 05 02     LD   HL,0205h 	; 517
032F 19           ADD  HL,DE  
0330 7E           LD   A,(HL) 
0331 37           SCF         
0332 C9           RET         


; Subroutine: Size=9, CC=3.
; Called by: L02D8[0303h].
; Calls: L034F.
0333 L0333:
0333 7B           LD   A,E    
0334 FE 3A        CP   3Ah    	; 58, ':'
0336 38 2F        JR   C,L0367 	; 0367h
0338 0D           DEC  C      
0339 FA 4F 03     JP   M,L034F 	; 034Fh
; ...
; ...
; ...


             org 33B1h ; 33B1h


; Subroutine: Size=3, CC=1.
; Called by: -
; Calls: -
33B1 L33B1:
33B1 E1           POP  HL     
33B2 D1           POP  DE     
33B3 C9           RET         


33B4 ED           defb EDh    	; 237,  -19
33B5 5B           defb 5Bh    	; 91, '['
33B6 65           defb 65h    	; 101, 'e'
33B7 5C           defb 5Ch    	; 92, '\'
33B8 CD           defb CDh    	; 205,  -51
33B9 C0           defb C0h    	; 192,  -64
33BA 33           defb 33h    	; 51, '3'
33BB ED           defb EDh    	; 237,  -19
33BC 53           defb 53h    	; 83, 'S'
33BD 65           defb 65h    	; 101, 'e'
33BE 5C           defb 5Ch    	; 92, '\'
33BF C9           defb C9h    	; 201,  -55
33C0 CD           defb CDh    	; 205,  -51
33C1 A9           defb A9h    	; 169,  -87
33C2 33           defb 33h    	; 51, '3'
33C3 ED           defb EDh    	; 237,  -19
33C4 B0           defb B0h    	; 176,  -80
33C5 C9           defb C9h    	; 201,  -55
33C6 62           defb 62h    	; 98, 'b'
33C7 6B           defb 6Bh    	; 107, 'k'
33C8 CD           defb CDh    	; 205,  -51
33C9 A9           defb A9h    	; 169,  -87
33CA 33           defb 33h    	; 51, '3'
33CB D9           defb D9h    	; 217,  -39
33CC E5           defb E5h    	; 229,  -27
33CD D9           defb D9h    	; 217,  -39
33CE E3           defb E3h    	; 227,  -29
33CF C5           defb C5h    	; 197,  -59
33D0 7E           defb 7Eh    	; 126, '~'
33D1 E6           defb E6h    	; 230,  -26
33D2 C0           defb C0h    	; 192,  -64
33D3 07           defb 07h    	; 7
33D4 07           defb 07h    	; 7
33D5 4F           defb 4Fh    	; 79, 'O'
33D6 0C           defb 0Ch    	; 12
33D7 7E           defb 7Eh    	; 126, '~'
33D8 E6           defb E6h    	; 230,  -26
33D9 3F           defb 3Fh    	; 63, '?'
33DA 20           defb 20h    	; 32, ' '
33DB 02           defb 02h    	; 2
33DC 23           defb 23h    	; 35, '#'
33DD 7E           defb 7Eh    	; 126, '~'
33DE C6           defb C6h    	; 198,  -58
33DF 50           defb 50h    	; 80, 'P'
33E0 12           defb 12h    	; 18
33E1 3E           defb 3Eh    	; 62, '>'
33E2 05           defb 05h    	; 5
33E3 91           defb 91h    	; 145, -111
33E4 23           defb 23h    	; 35, '#'
33E5 13           defb 13h    	; 19
33E6 06           defb 06h    	; 6
33E7 00           defb 00h    	; 0
33E8 ED           defb EDh    	; 237,  -19
33E9 B0           defb B0h    	; 176,  -80
33EA C1           defb C1h    	; 193,  -63
33EB E3           defb E3h    	; 227,  -29
33EC D9           defb D9h    	; 217,  -39
33ED E1           defb E1h    	; 225,  -31
33EE D9           defb D9h    	; 217,  -39
33EF 47           defb 47h    	; 71, 'G'
33F0 AF           defb AFh    	; 175,  -81
33F1 05           defb 05h    	; 5
33F2 C8           defb C8h    	; 200,  -56
33F3 12           defb 12h    	; 18
33F4 13           defb 13h    	; 19
33F5 18           defb 18h    	; 24
33F6 FA           defb FAh    	; 250,   -6
33F7 A7           defb A7h    	; 167,  -89
33F8 C8           defb C8h    	; 200,  -56
33F9 F5           defb F5h    	; 245,  -11
33FA D5           defb D5h    	; 213,  -43
33FB 11           defb 11h    	; 17
33FC 00           defb 00h    	; 0
33FD 00           defb 00h    	; 0
33FE CD           defb CDh    	; 205,  -51
33FF C8           defb C8h    	; 200,  -56
3400 33           defb 33h    	; 51, '3'
3401 D1           defb D1h    	; 209,  -47
3402 F1           defb F1h    	; 241,  -15
3403 3D           defb 3Dh    	; 61, '='
3404 18           defb 18h    	; 24
3405 F2           defb F2h    	; 242,  -14
3406 4F           defb 4Fh    	; 79, 'O'
3407 07           defb 07h    	; 7
3408 07           defb 07h    	; 7
3409 81           defb 81h    	; 129, -127
340A 4F           defb 4Fh    	; 79, 'O'
340B 06           defb 06h    	; 6
340C 00           defb 00h    	; 0
340D 09           defb 09h    	; 9
340E C9           defb C9h    	; 201,  -55
340F D5           defb D5h    	; 213,  -43
3410 2A           defb 2Ah    	; 42, '*'
3411 68           defb 68h    	; 104, 'h'
3412 5C           defb 5Ch    	; 92, '\'
3413 CD           defb CDh    	; 205,  -51
3414 06           defb 06h    	; 6
; ...
; ...
; ...


             org 88ABh ; 88ABh


; Label not accessed.
88AB L88AB:
88AB FF           RST  38h    
88AC FF           RST  38h    
88AD FF           RST  38h    
88AE FF           RST  38h    
88AF FF           RST  38h    
88B0 FF           RST  38h    
88B1 FF           RST  38h    
88B2 FF           RST  38h    
88B3 FF           RST  38h    
88B4 FF           RST  38h    
88B5 FF           RST  38h    
88B6 FF           RST  38h    
88B7 FF           RST  38h    
88B8 FF           RST  38h    
88B9 FF           RST  38h    
88BA FF           RST  38h    
88BB FF           RST  38h    
88BC FF           RST  38h    
88BD FF           RST  38h    
88BE FF           RST  38h    
88BF FF           RST  38h    
88C0 FF           RST  38h    
88C1 FF           RST  38h    
88C2 FF           RST  38h    
88C3 FF           RST  38h    
88C4 FF           RST  38h    
88C5 FF           RST  38h    
88C6 FF           RST  38h    
88C7 FF           RST  38h    
88C8 FF           RST  38h    
88C9 FF           RST  38h    
88CA FF           RST  38h    
88CB FF           RST  38h    
88CC FF           RST  38h    
88CD FF           RST  38h    
88CE FF           RST  38h    
88CF FF           RST  38h    
88D0 FF           RST  38h    
88D1 FF           RST  38h    
88D2 FF           RST  38h    
88D3 FF           RST  38h    
88D4 FF           RST  38h    
88D5 FF           RST  38h    
88D6 FF           RST  38h    
88D7 FF           RST  38h    
88D8 FF           RST  38h    
88D9 FF           RST  38h    
88DA FF           RST  38h    
88DB FF           RST  38h    
88DC FF           RST  38h    
88DD FF           RST  38h    
88DE FF           RST  38h    
88DF FF           RST  38h    
88E0 FF           RST  38h    
88E1 FF           RST  38h    
88E2 FF           RST  38h    
88E3 FF           RST  38h    
88E4 FF           RST  38h    
88E5 FF           RST  38h    
88E6 FF           RST  38h    
88E7 FF           RST  38h    
88E8 FF           RST  38h    
88E9 FF           RST  38h    
88EA FF           RST  38h    
88EB FF           RST  38h    
88EC FF           RST  38h    
88ED FF           RST  38h    
88EE FF           RST  38h    
88EF FF           RST  38h    
88F0 FF           RST  38h    
88F1 FF           RST  38h    
88F2 FF           RST  38h    
88F3 FF           RST  38h    
88F4 FF           RST  38h    
88F5 FF           RST  38h    
88F6 FF           RST  38h    
88F7 FF           RST  38h    
88F8 FF           RST  38h    
88F9 FF           RST  38h    
88FA FF           RST  38h    
88FB FF           RST  38h    
88FC FF           RST  38h    
88FD FF           RST  38h    
88FE FF           RST  38h    
88FF FF           RST  38h    
8900 FF           RST  38h    
8901 FF           RST  38h    
8902 FF           RST  38h    
8903 FF           RST  38h    
8904 FF           RST  38h    
8905 FF           RST  38h    
8906 FF           RST  38h    
8907 FF           RST  38h    
8908 FF           RST  38h    
8909 FF           RST  38h    
890A FF           RST  38h    
890B FF           RST  38h    
890C FF           RST  38h    
890D FF           RST  38h    
890E FF           RST  38h    
; ...
; ...
; ...