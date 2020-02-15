; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0028:       equ  0028h	; 40. Restart. Called by: L044A[044Ah].
L0038:       equ  0038h	; 56. Restart. Called by: L4822[4822h], L4822[4829h], L4822[483Dh], L4822[4842h], L4822[4843h], L4822[4844h], L4822[4846h], L4822[4847h], L4822[4848h], L4822[4849h], L4822[485Dh], L4822[4862h], L4822[487Dh], L4822[4882h], L4822[4883h], L4822[4884h], L4822[4885h].
L03B5:       equ  03B5h	; 949. Subroutine. Called by: L044A[0469h].
L0429:       equ  0429h
L1E99:       equ  1E99h	; 7833. Subroutine. Called by: L044A[045Fh].


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


             org 4822h ; 4822h


; Label not accessed.
4822 L4822:
4822 FF           RST  38h    
4823 55           LD   D,L    
4824 55           LD   D,L    
4825 55           LD   D,L    
4826 55           LD   D,L    
4827 55           LD   D,L    
4828 55           LD   D,L    
4829 FF           RST  38h    
482A 55           LD   D,L    
482B 55           LD   D,L    
482C 3C           INC  A      
482D 55           LD   D,L    
482E 55           LD   D,L    
482F 55           LD   D,L    
4830 3C           INC  A      
4831 55           LD   D,L    
4832 00           NOP         
4833 00           NOP         
4834 00           NOP         
4835 00           NOP         
4836 55           LD   D,L    
4837 55           LD   D,L    
4838 55           LD   D,L    
4839 55           LD   D,L    
483A 55           LD   D,L    
483B 55           LD   D,L    
483C 55           LD   D,L    
483D FF           RST  38h    
483E 00           NOP         
483F 00           NOP         
4840 00           NOP         
4841 00           NOP         
4842 FF           RST  38h    
4843 FF           RST  38h    
4844 FF           RST  38h    
4845 55           LD   D,L    
4846 FF           RST  38h    
4847 FF           RST  38h    
4848 FF           RST  38h    
4849 FF           RST  38h    
484A 55           LD   D,L    
484B 3C           INC  A      
484C 55           LD   D,L    
484D 55           LD   D,L    
484E 3C           INC  A      
484F 55           LD   D,L    
4850 55           LD   D,L    
4851 55           LD   D,L    
4852 00           NOP         
4853 3C           INC  A      
4854 55           LD   D,L    
4855 55           LD   D,L    
4856 55           LD   D,L    
4857 55           LD   D,L    
4858 55           LD   D,L    
4859 55           LD   D,L    
485A 55           LD   D,L    
485B 55           LD   D,L    
485C 55           LD   D,L    
485D FF           RST  38h    
485E 00           NOP         
485F 00           NOP         
4860 00           NOP         
4861 00           NOP         
4862 FF           RST  38h    
4863 00           NOP         
4864 00           NOP         
4865 00           NOP         
4866 00           NOP         
4867 00           NOP         
4868 00           NOP         
4869 55           LD   D,L    
486A 55           LD   D,L    
486B 55           LD   D,L    
486C 55           LD   D,L    
486D 3C           INC  A      
486E 55           LD   D,L    
486F 55           LD   D,L    
4870 55           LD   D,L    
4871 55           LD   D,L    
4872 00           NOP         
4873 55           LD   D,L    
4874 55           LD   D,L    
4875 55           LD   D,L    
4876 3C           INC  A      
4877 55           LD   D,L    
4878 55           LD   D,L    
4879 3C           INC  A      
487A 55           LD   D,L    
487B 55           LD   D,L    
487C 3C           INC  A      
487D FF           RST  38h    
487E 00           NOP         
487F 00           NOP         
4880 00           NOP         
4881 00           NOP         
4882 FF           RST  38h    
4883 FF           RST  38h    
4884 FF           RST  38h    
4885 FF           RST  38h    
; ...
; ...
; ...