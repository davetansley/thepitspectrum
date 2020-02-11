; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0038:       equ  0038h	; 56. Restart. Called by: L86DE[86DEh], L86DE[86E3h], L86DE[86E4h], L86DE[86E5h], L86DE[86E6h], L86DE[86E7h], L86DE[86E8h], L86DE[86E9h], L86DE[86EFh], L86DE[86F0h], L86DE[86F1h], L86DE[86F2h], L86DE[86F3h], L86DE[86F7h], L86DE[86FAh], L86DE[86FBh], L86DE[86FCh], L86DE[86FDh], L86DE[86FEh], L86DE[8703h], L86DE[8704h], L86DE[8705h], L86DE[8706h], L86DE[8707h], L86DE[8708h], L86DE[8709h], L86DE[870Fh], L86DE[8710h], L86DE[8711h], L86DE[8712h], L86DE[8713h], L86DE[8717h], L86DE[871Ah], L86DE[871Bh], L86DE[871Ch], L86DE[871Dh], L86DE[871Eh], L86DE[8723h], L86DE[8724h], L86DE[8725h], L86DE[8726h], L86DE[8727h], L86DE[8728h], L86DE[8729h], L86DE[872Fh], L86DE[8730h], L86DE[8731h], L86DE[8732h], L86DE[8733h], L86DE[8737h], L86DE[873Ah], L86DE[873Bh], L86DE[873Ch], L86DE[873Dh], L86DE[873Eh].
L00AA:       equ  00AAh	; 170. Subroutine. Called by: L86DE[8740h].


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


             org 86DEh ; 86DEh


; Label not accessed.
86DE L86DE:
86DE FF           RST  38h    
86DF 00           NOP         
86E0 20 55        JR   NZ,L8737 	; 8737h
86E2 55           LD   D,L    
86E3 FF           RST  38h    
86E4 FF           RST  38h    
86E5 FF           RST  38h    
86E6 FF           RST  38h    
86E7 FF           RST  38h    
86E8 FF           RST  38h    
86E9 FF           RST  38h    
86EA 00           NOP         
86EB 00           NOP         
86EC 00           NOP         
86ED 00           NOP         
86EE 00           NOP         
86EF FF           RST  38h    
86F0 FF           RST  38h    
86F1 FF           RST  38h    
86F2 FF           RST  38h    
86F3 FF           RST  38h    
86F4 00           NOP         
86F5 00           NOP         
86F6 00           NOP         
86F7 FF           RST  38h    
86F8 AA           XOR  D      
86F9 AA           XOR  D      
86FA FF           RST  38h    
86FB FF           RST  38h    
86FC FF           RST  38h    
86FD FF           RST  38h    
86FE FF           RST  38h    
86FF 02           LD   (BC),A 
8700 00           NOP         
8701 AA           XOR  D      
8702 AA           XOR  D      
8703 FF           RST  38h    
8704 FF           RST  38h    
8705 FF           RST  38h    
8706 FF           RST  38h    
8707 FF           RST  38h    
8708 FF           RST  38h    
8709 FF           RST  38h    
870A 00           NOP         
870B 00           NOP         
870C 00           NOP         
870D 00           NOP         
870E 00           NOP         
870F FF           RST  38h    
8710 FF           RST  38h    
8711 FF           RST  38h    
8712 FF           RST  38h    
8713 FF           RST  38h    
8714 00           NOP         
8715 00           NOP         
8716 00           NOP         
8717 FF           RST  38h    
8718 55           LD   D,L    
8719 55           LD   D,L    
871A FF           RST  38h    
871B FF           RST  38h    
871C FF           RST  38h    
871D FF           RST  38h    
871E FF           RST  38h    
871F 01 24 55     LD   BC,5524h 	; 21796
8722 55           LD   D,L    
8723 FF           RST  38h    
8724 FF           RST  38h    
8725 FF           RST  38h    
8726 FF           RST  38h    
8727 FF           RST  38h    
8728 FF           RST  38h    
8729 FF           RST  38h    
872A 00           NOP         
872B 00           NOP         
872C 00           NOP         
872D 00           NOP         
872E 00           NOP         
872F FF           RST  38h    
8730 FF           RST  38h    
8731 FF           RST  38h    
8732 FF           RST  38h    
8733 FF           RST  38h    
8734 00           NOP         
8735 00           NOP         
8736 00           NOP         
8737 L8737:
8737 FF           RST  38h    
8738 AA           XOR  D      
8739 AA           XOR  D      
873A FF           RST  38h    
873B FF           RST  38h    
873C FF           RST  38h    
873D FF           RST  38h    
873E FF           RST  38h    
873F 00           NOP         
8740 FC AA 00     CALL M,L00AA 	; 00AAh
; ...
; ...
; ...