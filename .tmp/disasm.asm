; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0010:       equ  0010h	; 16. Restart. Called by: L1802[1838h].
L0018:       equ  0018h	; 24. Restart. Called by: L1802[1805h], L1802[180Bh].
L0020:       equ  0020h	; 32. Restart. Called by: L1802[1814h].
L0ADC:       equ  0ADCh	; 2780. Subroutine. Called by: L0DC6[0DFBh].
L0E44:       equ  0E44h	; 3652. Subroutine. Called by: L0DC6[0DC6h].
L0E4A:       equ  0E4Ah
L0E4D:       equ  0E4Dh
L1601:       equ  1601h	; 5633. Subroutine. Called by: L1802[1802h].
L190F:       equ  190Fh	; 6415. Subroutine. Called by: L1802[184Eh].
L196E:       equ  196Eh	; 6510. Subroutine. Called by: L1802[1830h].
L1980:       equ  1980h	; 6528. Subroutine. Called by: L1855[1859h].
L1BEE:       equ  1BEEh	; 7150. Subroutine. Called by: L1802[1822h].
L1C82:       equ  1C82h	; 7298. Subroutine. Called by: L1802[1815h].
L1CDE:       equ  1CDEh	; 7390. Subroutine. Called by: L1802[181Fh].
L1CE6:       equ  1CE6h	; 7398. Subroutine. Called by: L1802[181Ah].
L1E99:       equ  1E99h	; 7833. Subroutine. Called by: L1802[1825h].
L2070:       equ  2070h	; 8304. Subroutine. Called by: L1802[1806h].
L5C48:       equ  5C48h	; 23624. Data accessed by: 0E7Dh(in L0E5C)
L5C49:       equ  5C49h	; 23625. Data accessed by: 182Dh(in L1802), 1855h(in L1855)
L5C51:       equ  5C51h	; 23633. Data accessed by: 0DC9h(in L0DC6)
L5C6B:       equ  5C6Bh	; 23659. Data accessed by: 183Fh(in L1802)
L5C8D:       equ  5C8Dh	; 23693. Data accessed by: 0E74h(in L0E5C)


             org 0DC6h ; 0DC6h


; Label not accessed.
0DC6 L0DC6:
0DC6 CD 44 0E     CALL L0E44  	; 0E44h
0DC9 2A 51 5C     LD   HL,(L5C51) 	; 5C51h
0DCC 11 F4 09     LD   DE,09F4h 	; 2548
0DCF 73           LD   (HL),E 
0DD0 23           INC  HL     
0DD1 72           LD   (HL),D 
0DD2 FD 36 52 01  LD   (IY+82),%s 
0DD6 01 21 18     LD   BC,1821h 	; 6177
0DD9 21 00 5B     LD   HL,5B00h 	; 23296
0DDC FD CB 01 4E  BIT  1,(IY+1) 
0DE0 20 12        JR   NZ,L0DF4 	; 0DF4h
0DE2 78           LD   A,B    
0DE3 FD CB 02 46  BIT  0,(IY+2) 
0DE7 28 05        JR   Z,L0DEE 	; 0DEEh
0DE9 FD 86 31     ADD  A,(IY+49) 
0DEC D6 18        SUB  18h    	; 24
0DEE L0DEE:
0DEE C5           PUSH BC     
0DEF 47           LD   B,A    
0DF0 CD 9B 0E     CALL L0E9B  	; 0E9Bh
0DF3 C1           POP  BC     
0DF4 L0DF4:
0DF4 3E 21        LD   A,21h  	; 33, '!'
0DF6 91           SUB  C      
0DF7 5F           LD   E,A    
0DF8 16 00        LD   D,00h  	; 0
0DFA 19           ADD  HL,DE  
0DFB C3 DC 0A     JP   L0ADC  	; 0ADCh


0DFE 06           defb 06h    	; 6
0DFF 17           defb 17h    	; 23
0E00 CD           defb CDh    	; 205,  -51
0E01 9B           defb 9Bh    	; 155, -101
0E02 0E           defb 0Eh    	; 14
0E03 0E           defb 0Eh    	; 14
0E04 08           defb 08h    	; 8
0E05 C5           defb C5h    	; 197,  -59
0E06 E5           defb E5h    	; 229,  -27
0E07 78           defb 78h    	; 120, 'x'
0E08 E6           defb E6h    	; 230,  -26
0E09 07           defb 07h    	; 7
0E0A 78           defb 78h    	; 120, 'x'
0E0B 20           defb 20h    	; 32, ' '
0E0C 0C           defb 0Ch    	; 12
0E0D EB           defb EBh    	; 235,  -21
0E0E 21           defb 21h    	; 33, '!'
0E0F E0           defb E0h    	; 224,  -32
0E10 F8           defb F8h    	; 248,   -8
0E11 19           defb 19h    	; 25
0E12 EB           defb EBh    	; 235,  -21
0E13 01           defb 01h    	; 1
0E14 20           defb 20h    	; 32, ' '
0E15 00           defb 00h    	; 0
0E16 3D           defb 3Dh    	; 61, '='
0E17 ED           defb EDh    	; 237,  -19
0E18 B0           defb B0h    	; 176,  -80
0E19 EB           defb EBh    	; 235,  -21
0E1A 21           defb 21h    	; 33, '!'
0E1B E0           defb E0h    	; 224,  -32
0E1C FF           defb FFh    	; 255,   -1
0E1D 19           defb 19h    	; 25
0E1E EB           defb EBh    	; 235,  -21
0E1F 47           defb 47h    	; 71, 'G'
0E20 E6           defb E6h    	; 230,  -26
0E21 07           defb 07h    	; 7
0E22 0F           defb 0Fh    	; 15
0E23 0F           defb 0Fh    	; 15
0E24 0F           defb 0Fh    	; 15
0E25 4F           defb 4Fh    	; 79, 'O'
0E26 78           defb 78h    	; 120, 'x'
0E27 06           defb 06h    	; 6
0E28 00           defb 00h    	; 0
0E29 ED           defb EDh    	; 237,  -19
; ...
; ...
; ...


             org 0E5Ch ; 0E5Ch


; Subroutine: Size=44, CC=4.
; Called by: -
; Calls: L0E88.
0E5C L0E5C:
0E5C ED B0        LDIR        
0E5E 11 01 07     LD   DE,0701h 	; 1793
0E61 19           ADD  HL,DE  
0E62 3D           DEC  A      
0E63 E6 F8        AND  F8h    	; 248,   -8
0E65 47           LD   B,A    
0E66 20 E5        JR   NZ,L0E4D 	; 0E4Dh
0E68 E1           POP  HL     
0E69 24           INC  H      
0E6A C1           POP  BC     
0E6B 0D           DEC  C      
0E6C 20 DC        JR   NZ,L0E4A 	; 0E4Ah
0E6E CD 88 0E     CALL L0E88  	; 0E88h
0E71 62           LD   H,D    
0E72 6B           LD   L,E    
0E73 13           INC  DE     
0E74 3A 8D 5C     LD   A,(L5C8D) 	; 5C8Dh
0E77 FD CB 02 46  BIT  0,(IY+2) 
0E7B 28 03        JR   Z,L0E80 	; 0E80h
0E7D 3A 48 5C     LD   A,(L5C48) 	; 5C48h
0E80 L0E80:
0E80 77           LD   (HL),A 
0E81 0B           DEC  BC     
0E82 ED B0        LDIR        
0E84 C1           POP  BC     
0E85 0E 21        LD   C,21h  	; 33, '!'
0E87 C9           RET         


; Subroutine: Size=19, CC=1.
; Called by: L0E5C[0E6Eh].
; Calls: -
0E88 L0E88:
0E88 7C           LD   A,H    
0E89 0F           RRCA        
0E8A 0F           RRCA        
0E8B 0F           RRCA        
0E8C 3D           DEC  A      
0E8D F6 50        OR   50h    	; 80, 'P'
0E8F 67           LD   H,A    
0E90 EB           EX   DE,HL  
0E91 61           LD   H,C    
0E92 68           LD   L,B    
0E93 29           ADD  HL,HL  
0E94 29           ADD  HL,HL  
0E95 29           ADD  HL,HL  
0E96 29           ADD  HL,HL  
0E97 29           ADD  HL,HL  
0E98 44           LD   B,H    
0E99 4D           LD   C,L    
0E9A C9           RET         


; Subroutine: Size=17, CC=1.
; Called by: L0DC6[0DF0h].
; Calls: -
0E9B L0E9B:
0E9B 3E 18        LD   A,18h  	; 24
0E9D 90           SUB  B      
0E9E 57           LD   D,A    
0E9F 0F           RRCA        
0EA0 0F           RRCA        
0EA1 0F           RRCA        
0EA2 E6 E0        AND  E0h    	; 224,  -32
0EA4 6F           LD   L,A    
0EA5 7A           LD   A,D    
0EA6 E6 18        AND  18h    	; 24
0EA8 F6 40        OR   40h    	; 64, '@'
0EAA 67           LD   H,A    
0EAB C9           RET         


0EAC F3           defb F3h    	; 243,  -13
0EAD 06           defb 06h    	; 6
0EAE B0           defb B0h    	; 176,  -80
0EAF 21           defb 21h    	; 33, '!'
0EB0 00           defb 00h    	; 0
0EB1 40           defb 40h    	; 64, '@'
0EB2 E5           defb E5h    	; 229,  -27
0EB3 C5           defb C5h    	; 197,  -59
0EB4 CD           defb CDh    	; 205,  -51
0EB5 F4           defb F4h    	; 244,  -12
0EB6 0E           defb 0Eh    	; 14
0EB7 C1           defb C1h    	; 193,  -63
0EB8 E1           defb E1h    	; 225,  -31
0EB9 24           defb 24h    	; 36, '$'
0EBA 7C           defb 7Ch    	; 124, '|'
0EBB E6           defb E6h    	; 230,  -26
0EBC 07           defb 07h    	; 7
0EBD 20           defb 20h    	; 32, ' '
0EBE 0A           defb 0Ah    	; 10
0EBF 7D           defb 7Dh    	; 125, '}'
; ...
; ...
; ...


             org 1802h ; 1802h


; Subroutine: Size=83, CC=8.
; Called by: -
; Calls: L0010, L0018, L0020, L1601, L1855, L190F, L196E, L1BEE, L1C82, L1CDE, L1CE6, L1E99, L2070.
1802 L1802:
1802 C4 01 16     CALL NZ,L1601 	; 1601h
1805 DF           RST  18h    
1806 CD 70 20     CALL L2070  	; 2070h
1809 38 14        JR   C,L181F 	; 181Fh
180B DF           RST  18h    
180C FE 3B        CP   3Bh    	; 59, ';'
180E 28 04        JR   Z,L1814 	; 1814h
1810 FE 2C        CP   2Ch    	; 44, ','
1812 20 06        JR   NZ,L181A 	; 181Ah
1814 L1814:
1814 E7           RST  20h    
1815 CD 82 1C     CALL L1C82  	; 1C82h
1818 18 08        JR   L1822  	; 1822h
181A L181A:
181A CD E6 1C     CALL L1CE6  	; 1CE6h
181D 18 03        JR   L1822  	; 1822h
181F L181F:
181F CD DE 1C     CALL L1CDE  	; 1CDEh
1822 L1822:
1822 CD EE 1B     CALL L1BEE  	; 1BEEh
1825 CD 99 1E     CALL L1E99  	; 1E99h
1828 78           LD   A,B    
1829 E6 3F        AND  3Fh    	; 63, '?'
182B 67           LD   H,A    
182C 69           LD   L,C    
182D 22 49 5C     LD   (L5C49),HL 	; 5C49h
1830 CD 6E 19     CALL L196E  	; 196Eh
1833 1E 01        LD   E,01h  	; 1
1835 L1835:
1835 CD 55 18     CALL L1855  	; 1855h
1838 D7           RST  10h    
1839 FD CB 02 66  BIT  4,(IY+2) 
183D 28 F6        JR   Z,L1835 	; 1835h
183F 3A 6B 5C     LD   A,(L5C6B) 	; 5C6Bh
1842 FD 96 4F     SUB  (IY+79) 
1845 20 EE        JR   NZ,L1835 	; 1835h
1847 AB           XOR  E      
1848 C8           RET  Z      
1849 E5           PUSH HL     
184A D5           PUSH DE     
184B 21 6C 5C     LD   HL,5C6Ch 	; 23660
184E CD 0F 19     CALL L190F  	; 190Fh
1851 D1           POP  DE     
1852 E1           POP  HL     
1853 18 E0        JR   L1835  	; 1835h


; Subroutine: Size=18, CC=2.
; Called by: L1802[1835h].
; Calls: L1980.
1855 L1855:
1855 ED 4B 49 5C  LD   BC,(L5C49) 	; 5C49h
1859 CD 80 19     CALL L1980  	; 1980h
185C 16 3E        LD   D,3Eh  	; 62, '>'
185E 28 05        JR   Z,L1865 	; 1865h
1860 11 00 00     LD   DE,0000h 	; 0
1863 CB 13        RL   E      
1865 L1865:
1865 FD 00        NOP         
; ...
; ...
; ...