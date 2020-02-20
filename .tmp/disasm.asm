; EQU:
; Data addresses used by the opcodes that point to uninitialized memory areas.
L0038:       equ  0038h	; 56. Restart. Called by: L48BD[48BDh], L48BD[48C2h], L48BD[48DDh], L48BD[48E2h], L48BD[48EAh], L48BD[48EBh], L48BD[48ECh], L48BD[48EDh], L48BD[48EEh], L48BD[48EFh], L48BD[48F0h], L48BD[48F1h], L48BD[48F2h], L48BD[48F3h], L48BD[48F4h], L48BD[48F5h], L48BD[48F6h], L48BD[48F7h], L48BD[48FDh], L48BD[4902h], L48BD[4903h], L48BD[4904h], L48BD[4905h], L48BD[4906h], L48BD[4907h], L48BD[4908h], L48BD[4909h], L48BD[491Dh].


             org 48BDh ; 48BDh


; Label not accessed.
48BD L48BD:
48BD FF           RST  38h    
48BE 00           NOP         
48BF 00           NOP         
48C0 00           NOP         
48C1 00           NOP         
48C2 FF           RST  38h    
48C3 00           NOP         
48C4 00           NOP         
48C5 00           NOP         
48C6 00           NOP         
48C7 00           NOP         
48C8 00           NOP         
48C9 00           NOP         
48CA 55           LD   D,L    
48CB 55           LD   D,L    
48CC 55           LD   D,L    
48CD 55           LD   D,L    
48CE 55           LD   D,L    
48CF 55           LD   D,L    
48D0 55           LD   D,L    
48D1 3C           INC  A      
48D2 00           NOP         
48D3 3C           INC  A      
48D4 55           LD   D,L    
48D5 55           LD   D,L    
48D6 55           LD   D,L    
48D7 55           LD   D,L    
48D8 55           LD   D,L    
48D9 00           NOP         
48DA 55           LD   D,L    
48DB 55           LD   D,L    
48DC 55           LD   D,L    
48DD FF           RST  38h    
48DE 00           NOP         
48DF 00           NOP         
48E0 00           NOP         
48E1 00           NOP         
48E2 FF           RST  38h    
48E3 00           NOP         
48E4 55           LD   D,L    
48E5 55           LD   D,L    
48E6 00           NOP         
48E7 00           NOP         
48E8 00           NOP         
48E9 55           LD   D,L    
48EA FF           RST  38h    
48EB FF           RST  38h    
48EC FF           RST  38h    
48ED FF           RST  38h    
48EE FF           RST  38h    
48EF FF           RST  38h    
48F0 FF           RST  38h    
48F1 FF           RST  38h    
48F2 FF           RST  38h    
48F3 FF           RST  38h    
48F4 FF           RST  38h    
48F5 FF           RST  38h    
48F6 FF           RST  38h    
48F7 FF           RST  38h    
48F8 55           LD   D,L    
48F9 00           NOP         
48FA 55           LD   D,L    
48FB 3C           INC  A      
48FC 55           LD   D,L    
48FD FF           RST  38h    
48FE 00           NOP         
48FF 00           NOP         
4900 00           NOP         
4901 00           NOP         
4902 FF           RST  38h    
4903 FF           RST  38h    
4904 FF           RST  38h    
4905 FF           RST  38h    
4906 FF           RST  38h    
4907 FF           RST  38h    
4908 FF           RST  38h    
4909 FF           RST  38h    
490A AA           XOR  D      
490B 00           NOP         
490C 00           NOP         
490D 00           NOP         
490E 00           NOP         
490F 00           NOP         
4910 00           NOP         
4911 00           NOP         
4912 00           NOP         
4913 00           NOP         
4914 00           NOP         
4915 00           NOP         
4916 00           NOP         
4917 00           NOP         
4918 00           NOP         
4919 7E           LD   A,(HL) 
491A AA           XOR  D      
491B AA           XOR  D      
491C 00           NOP         
491D FF           RST  38h    
491E 00           NOP         
491F 00           NOP         
4920 00           NOP         
; ...
; ...
; ...