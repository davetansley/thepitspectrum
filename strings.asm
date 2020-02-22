string_score1: 
    defb 4,0,'SCORE1',255 
string_scorenumbers1:
    defb 4,1,'000000',255  
string_company:
    defb 14,0,'ENV',255
string_credits:
    defb 12,1,'PLAYER 1',255
string_score2: 
    defb 22,0,'SCORE2',255
string_scorenumbers2:
    defb 22,1,'000000',255  
string_titlescreen_copyright:
    defb 4,22, 127,' 1982 AW ZILEC ELC LTD',255


string_alttitlescreen_1:
    defb 12,0,'CREDITS 1',255
string_alttitlescreen_2:
    defb 0,2,'           THE OBJECT',254
    defb 0,3,'          OF THIS GAME',254
    defb 0,4,'         IS TO DIG DOWN',254
    defb 0,5,'        TO THE BOTTOM PIT',254
    defb 0,6,'               AND',254
    defb 0,7,'        COLLECT AT LEAST',254
    defb 0,8,'         ONE LARGE JEWEL',254
    defb 0,9,'              THEN',254
    defb 0,10,'         RETURN TO SHIP',254
    defb 0,11,'         THRU UPPER PIT',255
string_alttitlescreen_3:
    defb 0,13,'    SINGLE BONUS  5000 POINTS',254
    defb 0,14,'      COLLECT 1 LARGE JEWEL',254
    defb 0,15,'       AND RETURN TO SHIP',254
    defb 0,17,'    DOUBLE BONUS  10000 POINTS',254
    defb 0,18,'    COLLECT ALL 3 LARGE JEWELS',254
    defb 0,19,'       OR   ALL 4 SMALL JEWELS',254
    defb 0,21,'    TRIPLE BONUS  15000 POINTS',254
    defb 0,22,'       COLLECT ALL 7 JEWELS',255

string_lifescreen_player:
    defb 11,0,' PLAYER 1 ',255
string_lifescreen_lives:
    defb 11,3,48,' MEN LEFT',255
string_lifescreen_lastman:
    defb 12,3,'LAST MAN',255

string_gameoverscreen_gameover:
    defb 12,6,'GAME OVER',255
string_gameoverscreen_copyright:
    defb 5,18,127,' 1982 AW ZILEC ELC LTD',255
string_gameoverscreen_bestscores:
    defb 7,22,'BEST SCORES TODAY',255
string_gameover_credits:
    defb 12,1,'CREDITS 0',255

string_highscore_congratulations:
    defb 8,5,'CONGRATULATIONS',255
string_highscore_player1:
    defb 12,7,'PLAYER 1',255
string_highscore_player2:
    defb 12,7,'PLAYER 2',255    
string_highscore_youhaveearned:
    defb 8,10,'YOU HAVE EARNED',255
string_highscore_place1:
    defb 6,12,'THE GREATEST SCORE',255
string_highscore_place2:
    defb 6,12,'THE 2ND BEST SCORE',255
string_highscore_place3:
    defb 6,12,'THE 3RD BEST SCORE',255
string_highscore_pleaseenter
    defb 3,15,'RECORD YOUR INITIALS BELOW',255
;
; Prints specified string
; Inputs:
; de: pointer to string
; bc: length of string
;
; Print String Data
; First two bytes of string contain X and Y char position, then the string
; Individual strings are terminated with 0xFE
; End of data is terminated with 0xFF
; HL: Address of string
;
string_print:           LD E,(HL)                       ; Fetch the X coordinate
                        INC HL                          ; Increase HL to the next memory location
                        LD D,(HL)                       ; Fetch the Y coordinate
                        INC HL                          ; Increase HL to the next memory location
                        CALL string_getcharaddress           ; Calculate the screen address (in DE)
string_print_0:         LD A,(HL)                       ; Fetch the character to print
                        INC HL                          ; Increase HL to the next character
                        CP 0xFE                         ; Compare with 0xFE
                        JR Z,string_print               ; If it is equal to 0xFE then loop back to print next string
                        RET NC                          ; If it is greater or equal to (carry bit set) then
                        PUSH HL                         ; Push HL on stack (Print_Char will not preserve HL)
                        CALL Print_Char                 ; Print the character
                        POP HL                          ; Retrieve HL back off the stack
                        INC E                           ; Go to the next screen address
                        JR string_print_0               ; Loop back to print next character
                        RET

; Get screen address
; D = Y character position
; E = X character position
; Returns address in DE
;
string_getcharaddress:       LD A,D
                        AND %00000111
                        RRA
                        RRA
                        RRA
                        RRA
                        OR E
                        LD E,A
                        LD A,D
                        AND %00011000
                        OR %01000000
                        LD D,A
                        RET                             ; Returns screen address in DE

; Print a single character out
; A:  Character to print
; DE: Screen address to print character at
;
Print_Char:             LD HL,0x3C00                    ; Address of character set table in ROM
                        LD B,0                          ; Set BC to A
                        LD C,A
                        AND 0xFF                        ; Clear the carry bit
                        RL C                            ; Multiply BC by 8 (shift left 3 times)
                        RL B
                        RL C
                        RL B
                        RL C
                        RL B
                        ADD HL,BC                       ; Get the character address in HL
                        LD C,8                          ; Loop counter
                        PUSH DE
Print_Char_1:           LD A,(HL)                       ; Get the byte from the ROM into A
                        LD (DE),A                       ; Stick A onto the screen
                        INC D                           ; Goto next line on screen
                        INC L                           ; Goto next byte of character
                        DEC C                           ; Decrease the loop counter
                        JR NZ,Print_Char_1              ; Loop around whilst it is Not Zero (NZ)
                        POP DE
                        RET                             ; Return from the subroutine