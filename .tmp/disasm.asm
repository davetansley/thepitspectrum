; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0D6E:       equ  0D6Eh	; 3438. Subroutine. Called by: L10A8[10C1h].
L110D:       equ  110Dh
L111B:       equ  111Bh
L111D:       equ  111Dh	; 4381. Subroutine. Called by: L10A8[10ACh].
L5C08:       equ  5C08h	; 23560. Data accessed by: 10B5h(in L10A8)


             org 10A8h ; 10A8h


; Subroutine: Size=101, CC=11.
; Called by: -
; Calls: L0D6E, L111D.
10A8 L10A8:
10A8 FD CB 02 5E  BIT  3,(IY+2) 
10AC C4 1D 11     CALL NZ,L111D 	; 111Dh
10AF A7           AND  A      
10B0 FD CB 01 6E  BIT  5,(IY+1) 
10B4 C8           RET  Z      
10B5 3A 08 5C     LD   A,(L5C08) 	; 5C08h
10B8 FD CB 01 AE  RES  5,(IY+1) 
10BC F5           PUSH AF     
10BD FD CB 02 6E  BIT  5,(IY+2) 
10C1 C4 6E 0D     CALL NZ,L0D6E 	; 0D6Eh
10C4 F1           POP  AF     
10C5 FE 20        CP   20h    	; 32, ' '
10C7 30 52        JR   NC,L111B 	; 111Bh
10C9 FE 10        CP   10h    	; 16
10CB 30 2D        JR   NC,L10FA 	; 10FAh
10CD FE 06        CP   06h    	; 6
10CF 30 0A        JR   NC,L10DB 	; 10DBh
10D1 47           LD   B,A    
10D2 E6 01        AND  01h    	; 1
10D4 4F           LD   C,A    
10D5 78           LD   A,B    
10D6 1F           RRA         
10D7 C6 12        ADD  A,12h  	; 18
10D9 18 2A        JR   L1105  	; 1105h
10DB L10DB:
10DB 20 09        JR   NZ,L10E6 	; 10E6h
10DD 21 6A 5C     LD   HL,5C6Ah 	; 23658
10E0 3E 08        LD   A,08h  	; 8
10E2 AE           XOR  (HL)   
10E3 77           LD   (HL),A 
10E4 18 0E        JR   L10F4  	; 10F4h
10E6 L10E6:
10E6 FE 0E        CP   0Eh    	; 14
10E8 D8           RET  C      
10E9 D6 0D        SUB  0Dh    	; 13
10EB 21 41 5C     LD   HL,5C41h 	; 23617
10EE BE           CP   (HL)   
10EF 77           LD   (HL),A 
10F0 20 02        JR   NZ,L10F4 	; 10F4h
10F2 36 00        LD   (HL),00h 	; 0
10F4 L10F4:
10F4 FD CB 02 DE  SET  3,(IY+2) 
10F8 BF           CP   A      
10F9 C9           RET         
10FA L10FA:
10FA 47           LD   B,A    
10FB E6 07        AND  07h    	; 7
10FD 4F           LD   C,A    
10FE 3E 10        LD   A,10h  	; 16
1100 CB 58        BIT  3,B    
1102 20 01        JR   NZ,L1105 	; 1105h
1104 3C           INC  A      
1105 L1105:
1105 FD 71 D3     LD   (IY-45),C 
1108 11 0D 11     LD   DE,110Dh 	; 4365
110B 18 00        JR   L110D  	; 110Dh
; ...
; ...
; ...