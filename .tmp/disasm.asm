; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0008:       equ  0008h	; 8. Restart. Called by: L00FC[0114h].
L0028:       equ  0028h	; 40. Restart. Called by: L044A[044Ah].
L0038:       equ  0038h	; 56. Restart. Called by: L55FD[55FDh], L55FD[5602h], L55FD[5603h], L55FD[5604h], L55FD[5605h], L55FD[5606h], L55FD[5607h], L55FD[5608h], L55FD[5609h], L55FD[5619h], L55FD[561Dh], L55FD[5622h], L55FD[5623h], L55FD[5624h], L55FD[5625h], L55FD[5626h], L55FD[5627h], L55FD[5628h], L55FD[5629h], L55FD[563Dh], L55FD[5642h], L55FD[5643h], L55FD[5644h], L55FD[5645h], L55FD[5646h], L55FD[5647h], L55FD[5648h], L55FD[5649h], L55FD[5654h], L55FD[5655h], L55FD[5659h], L55FD[565Dh].
L00DA:       equ  00DAh
L00E1:       equ  00E1h
L0164:       equ  0164h
L03B5:       equ  03B5h	; 949. Subroutine. Called by: L044A[0469h].
L0429:       equ  0429h
L1E99:       equ  1E99h	; 7833. Subroutine. Called by: L044A[045Fh].
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


             org 044Ah ; 044Ah


; Subroutine: Size=34, CC=5.
; Called by: -
; Calls: L0028, L03B5, L1E99.
044A L044A:
044A EF           RST  28h    
044B E0           RET  PO     
044C 04           INC  B      
044D E0           RET  PO     
044E 34           INC  (HL)   
044F 80           ADD  A,B    
0450 43           LD   B,E    
0451 55           LD   D,L    
0452 9F           SBC  A,A    
0453 80           ADD  A,B    
0454 01 05 34     LD   BC,3405h 	; 13317
0457 35           DEC  (HL)   
0458 71           LD   (HL),C 
0459 03           INC  BC     
045A 38 CD        JR   C,L0429 	; 0429h
045C 99           SBC  A,C    
045D 1E C5        LD   E,C5h  	; 197,  -59
045F CD 99 1E     CALL L1E99  	; 1E99h
0462 E1           POP  HL     
0463 50           LD   D,B    
0464 59           LD   E,C    
0465 7A           LD   A,D    
0466 B3           OR   E      
0467 C8           RET  Z      
0468 1B           DEC  DE     
0469 C3 B5 03     JP   L03B5  	; 03B5h


046C CF           defb CFh    	; 207,  -49
046D 0A           defb 0Ah    	; 10
046E 89           defb 89h    	; 137, -119
046F 02           defb 02h    	; 2
0470 D0           defb D0h    	; 208,  -48
0471 12           defb 12h    	; 18
0472 86           defb 86h    	; 134, -122
0473 89           defb 89h    	; 137, -119
0474 0A           defb 0Ah    	; 10
0475 97           defb 97h    	; 151, -105
0476 60           defb 60h    	; 96, '`'
0477 75           defb 75h    	; 117, 'u'
0478 89           defb 89h    	; 137, -119
0479 12           defb 12h    	; 18
047A D5           defb D5h    	; 213,  -43
047B 17           defb 17h    	; 23
047C 1F           defb 1Fh    	; 31
047D 89           defb 89h    	; 137, -119
047E 1B           defb 1Bh    	; 27
047F 90           defb 90h    	; 144, -112
0480 41           defb 41h    	; 65, 'A'
0481 02           defb 02h    	; 2
0482 89           defb 89h    	; 137, -119
0483 24           defb 24h    	; 36, '$'
0484 D0           defb D0h    	; 208,  -48
0485 53           defb 53h    	; 83, 'S'
0486 CA           defb CAh    	; 202,  -54
0487 89           defb 89h    	; 137, -119
0488 2E           defb 2Eh    	; 46, '.'
0489 9D           defb 9Dh    	; 157,  -99
048A 36           defb 36h    	; 54, '6'
048B B1           defb B1h    	; 177,  -79
048C 89           defb 89h    	; 137, -119
048D 38           defb 38h    	; 56, '8'
048E FF           defb FFh    	; 255,   -1
048F 49           defb 49h    	; 73, 'I'
0490 3E           defb 3Eh    	; 62, '>'
0491 89           defb 89h    	; 137, -119
0492 43           defb 43h    	; 67, 'C'
0493 FF           defb FFh    	; 255,   -1
0494 6A           defb 6Ah    	; 106, 'j'
0495 73           defb 73h    	; 115, 's'
0496 89           defb 89h    	; 137, -119
0497 4F           defb 4Fh    	; 79, 'O'
0498 A7           defb A7h    	; 167,  -89
0499 00           defb 00h    	; 0
049A 54           defb 54h    	; 84, 'T'
049B 89           defb 89h    	; 137, -119
049C 5C           defb 5Ch    	; 92, '\'
049D 00           defb 00h    	; 0
049E 00           defb 00h    	; 0
049F 00           defb 00h    	; 0
04A0 89           defb 89h    	; 137, -119
04A1 69           defb 69h    	; 105, 'i'
04A2 14           defb 14h    	; 20
04A3 F6           defb F6h    	; 246,  -10
04A4 24           defb 24h    	; 36, '$'
04A5 89           defb 89h    	; 137, -119
04A6 76           defb 76h    	; 118, 'v'
04A7 F1           defb F1h    	; 241,  -15
04A8 10           defb 10h    	; 16
04A9 05           defb 05h    	; 5
04AA CD           defb CDh    	; 205,  -51
04AB FB           defb FBh    	; 251,   -5
04AC 24           defb 24h    	; 36, '$'
04AD 3A           defb 3Ah    	; 58, ':'
; ...
; ...
; ...


             org 55FDh ; 55FDh


; Label not accessed.
55FD L55FD:
55FD FF           RST  38h    
55FE 00           NOP         
55FF 00           NOP         
5600 00           NOP         
5601 00           NOP         
5602 FF           RST  38h    
5603 FF           RST  38h    
5604 FF           RST  38h    
5605 FF           RST  38h    
5606 FF           RST  38h    
5607 FF           RST  38h    
5608 FF           RST  38h    
5609 FF           RST  38h    
560A 55           LD   D,L    
560B 00           NOP         
560C 00           NOP         
560D 00           NOP         
560E 00           NOP         
560F 00           NOP         
5610 00           NOP         
5611 00           NOP         
5612 00           NOP         
5613 00           NOP         
5614 00           NOP         
5615 00           NOP         
5616 00           NOP         
5617 00           NOP         
5618 00           NOP         
5619 FF           RST  38h    
561A 55           LD   D,L    
561B 55           LD   D,L    
561C 00           NOP         
561D FF           RST  38h    
561E 00           NOP         
561F 00           NOP         
5620 00           NOP         
5621 00           NOP         
5622 FF           RST  38h    
5623 FF           RST  38h    
5624 FF           RST  38h    
5625 FF           RST  38h    
5626 FF           RST  38h    
5627 FF           RST  38h    
5628 FF           RST  38h    
5629 FF           RST  38h    
562A 55           LD   D,L    
562B 00           NOP         
562C 55           LD   D,L    
562D 55           LD   D,L    
562E 55           LD   D,L    
562F 55           LD   D,L    
5630 55           LD   D,L    
5631 55           LD   D,L    
5632 00           NOP         
5633 55           LD   D,L    
5634 55           LD   D,L    
5635 55           LD   D,L    
5636 00           NOP         
5637 55           LD   D,L    
5638 55           LD   D,L    
5639 55           LD   D,L    
563A 55           LD   D,L    
563B 55           LD   D,L    
563C 00           NOP         
563D FF           RST  38h    
563E 00           NOP         
563F 00           NOP         
5640 00           NOP         
5641 00           NOP         
5642 FF           RST  38h    
5643 FF           RST  38h    
5644 FF           RST  38h    
5645 FF           RST  38h    
5646 FF           RST  38h    
5647 FF           RST  38h    
5648 FF           RST  38h    
5649 FF           RST  38h    
564A 55           LD   D,L    
564B 00           NOP         
564C 55           LD   D,L    
564D 55           LD   D,L    
564E 55           LD   D,L    
564F 55           LD   D,L    
5650 55           LD   D,L    
5651 55           LD   D,L    
5652 00           NOP         
5653 55           LD   D,L    
5654 FF           RST  38h    
5655 FF           RST  38h    
5656 00           NOP         
5657 55           LD   D,L    
5658 55           LD   D,L    
5659 FF           RST  38h    
565A 55           LD   D,L    
565B 55           LD   D,L    
565C 00           NOP         
565D FF           RST  38h    
565E 00           NOP         
565F 00           NOP         
5660 00           NOP         
; ...
; ...
; ...