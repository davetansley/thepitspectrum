; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0008:       equ  0008h	; 8. Restart. Called by: 2812h.
L0065:       equ  0065h	; 101. Data accessed by: 286Ah
L198B:       equ  198Bh	; 6539. Subroutine. Called by: 282Bh.
L1D86:       equ  1D86h	; 7558. Subroutine. Called by: 280Ch.
L24FB:       equ  24FBh	; 9467. Subroutine. Called by: 2855h.
L2885:       equ  2885h
L288B:       equ  288Bh
L28AB:       equ  28ABh	; 10411. Subroutine. Called by: 2815h, 281Dh, 2832h, 283Bh, 284Ch.
L5C5D:       equ  5C5Dh	; 23645. Data accessed by: 2837h
L5C65:       equ  5C65h	; 23653. Data accessed by: 2862h


             org 2808h ; 2808h
2808 L2808:
2808 11 CE 00     LD   DE,00CEh 	; 206
280B C5           PUSH BC     
280C CD 86 1D     CALL L1D86  	; 1D86h
280F C1           POP  BC     
2810 30 02        JR   NC,L2814 	; 2814h
2812 CF 18        RST  08h,18h 	; Custom opcode
2814 L2814:
2814 E5           PUSH HL     
2815 CD AB 28     CALL L28AB  	; 28ABh
2818 E6 DF        AND  DFh    	; 223,  -33
281A B8           CP   B      
281B 20 08        JR   NZ,L2825 	; 2825h
281D CD AB 28     CALL L28AB  	; 28ABh
2820 D6 24        SUB  24h    	; 36, '$'
2822 B9           CP   C      
2823 28 0C        JR   Z,L2831 	; 2831h
2825 L2825:
2825 E1           POP  HL     
2826 2B           DEC  HL     
2827 11 00 02     LD   DE,0200h 	; 512
282A C5           PUSH BC     
282B CD 8B 19     CALL L198B  	; 198Bh
282E C1           POP  BC     
282F 18 D7        JR   L2808  	; 2808h
2831 L2831:
2831 A7           AND  A      
2832 CC AB 28     CALL Z,L28AB 	; 28ABh
2835 D1           POP  DE     
2836 D1           POP  DE     
2837 ED 53 5D 5C  LD   (L5C5D),DE 	; 5C5Dh
283B CD AB 28     CALL L28AB  	; 28ABh
283E E5           PUSH HL     
283F FE 29        CP   29h    	; 41, ')'
2841 28 42        JR   Z,L2885 	; 2885h
2843 23           INC  HL     
2844 7E           LD   A,(HL) 
2845 FE 0E        CP   0Eh    	; 14
2847 16 40        LD   D,40h  	; 64, '@'
2849 28 07        JR   Z,L2852 	; 2852h
284B 2B           DEC  HL     
284C CD AB 28     CALL L28AB  	; 28ABh
284F 23           INC  HL     
2850 16 00        LD   D,00h  	; 0
2852 L2852:
2852 23           INC  HL     
2853 E5           PUSH HL     
2854 D5           PUSH DE     
2855 CD FB 24     CALL L24FB  	; 24FBh
2858 F1           POP  AF     
2859 FD AE 01     XOR  (IY+1) 
285C E6 40        AND  40h    	; 64, '@'
285E 20 2B        JR   NZ,L288B 	; 288Bh
2860 E1           POP  HL     
2861 EB           EX   DE,HL  
2862 2A 65 5C     LD   HL,(L5C65) 	; 5C65h
2865 01 05 00     LD   BC,0005h 	; 5
2868 ED 42        SBC  HL,BC  
286A 22 65 00     LD   (L0065),HL 	; 0065h
; ...
; ...
; ...