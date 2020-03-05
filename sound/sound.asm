

;
; Plays a note
; Inputs:
; d - border
; e - pitch
; bc - duration
sound_play:
    ld a,e
    ld (sound_play2+1),a
	ld a,d
sound_play0:
    out (254),a
    dec e
    jr nz,sound_play1
sound_play2:
    ld e,0
    xor 24
sound_play1:
    djnz sound_play0
    dec c
    jr nz,sound_play0
    ret

sound_gamestart:
    di
    ld b,3
sound_gamestart0:
    push bc
    ld e,54
    ld bc,75
    ld d,2
    call sound_play
    ld e,76
    ld bc,75
    ld d,2
    call sound_play
    pop bc
    djnz sound_gamestart0
    ei
    ret

sound_lifestart:
    di
    ld b,3
sound_lifestart0:
    push bc
    ld e,45
    ld bc,32
    ld d,1
    call sound_play
    ld e,65
    ld bc,32
    ld d,1
    call sound_play
    ld e,45
    ld bc,32
    call sound_play
    ld e,65
    ld bc,32
    call sound_play
    pop bc
    djnz sound_lifestart0
    ei
    ret

sound_gameover:
    di
    ld b,10
    ld e,40
sound_gameover0:
    push bc
    push de
    push af
    ld bc,32
    ld d,0
    call sound_play
    pop af
    pop de
    ld a,10
    add e
    ld e,a
    add 4
    pop bc
    djnz sound_gameover0
    ei
    ret

sound_scoretick:
    di
    ld e,35
    ld bc,24
    ld d,0
    call sound_play
    ei
    ret

sound_tankalarm:
    di
    ld e,25
    ld bc,24
    ld d,0
    call sound_play
    ei
    ret

sound_laser:
	ld d,16		            ;speaker = bit 4
	ld e,0		            ;distance between speaker move counter
	ld b,128	            ;overall length counter
sound_laser0:	
    ld a,d
	and 248		            ;keep border colour the same
	out (254),a	            ;move the speaker in or out depending on bit 4
	cpl		                ;toggle, so we alternative between speaker in and out to make sound
	ld d,a		            ;store it
	ld c,e		            ;now a pause
sound_laser1:	
    dec c
	jr nz,sound_laser1
	dec e		            ;change to inc e to reverse the sound, or remove to make it a note
	djnz sound_laser0	;repeat B=255 times
	ret

sound_gemcollected:
	ld d,16		            ;speaker = bit 4
	ld e,0		            ;distance between speaker move counter
	ld b,128	            ;overall length counter
sound_gemcollected0:	
    ld a,d
	and 248		            ;keep border colour the same
	out (254),a	            ;move the speaker in or out depending on bit 4
	cpl		                ;toggle, so we alternative between speaker in and out to make sound
	ld d,a		            ;store it
	ld c,e		            ;now a pause
sound_gemcollected1:	
    dec c
	jr nz,sound_gemcollected1
	inc e		            ;change to inc e to reverse the sound, or remove to make it a note
	djnz sound_gemcollected0	;repeat B=255 times
	ret

sound_pitchbend:
    ld hl,500 ; starting pitch.
    ld b,250 ; length of pitch bend.
sound_pitchbend0:
     push bc
    push hl ; store pitch.
    ld de,1 ; very short duration.
    call 949 ; ROM beeper routine.
    pop hl ; restore pitch.
    inc hl ; pitch going up.
    pop bc
    djnz sound_pitchbend0 ; repeat.
    ret

sound_pitchbenddown:
    ld hl,750 ; starting pitch.
    ld b,250 ; length of pitch bend.
sound_pitchbenddown0:
    push bc
    push hl ; store pitch.
    ld de,1 ; very short duration.
    call 949 ; ROM beeper routine.
    pop hl ; restore pitch.
    dec hl ; pitch going down.
    pop bc
    djnz sound_pitchbenddown0 ; repeat.
    ret

sound_rockfell:
    ex af,af'
    ld e,50 ; repeat 250 times.
    ld hl,0 ; start pointer in ROM.
sound_rockfell2 
    push de
    ld b,32 ; length of step.
sound_rockfell0 push bc
    ld a,(hl) ; next "random" number.
    inc hl ; pointer.
    and 248 ; we want a black border.
    out (254),a ; write to speaker.
    ld a,e ; as e gets smaller...
    cpl ; ...we increase the delay.
sound_rockfell1 dec a ; decrement loop counter.
    jr nz,sound_rockfell1 ; delay loop.
    pop bc
    djnz sound_rockfell0 ; next step.
    pop de
    ld a,e
    sub 24 ; size of step.
    cp 30 ; end of range.
    jp z,sound_rockfell5
    jp c, sound_rockfell5
    ld e,a
    cpl
sound_rockfell3 ld b,40 ; silent period.
sound_rockfell4 djnz sound_rockfell4
    dec a
    jr nz,sound_rockfell3
    jr sound_rockfell2
sound_rockfell5
    ex af,af'
    ret

sound_tankshoot:
    ex af,af'
    ld e,50 ; repeat 250 times.
    ld hl,0 ; start pointer in ROM.
sound_tankshoot2 
    push de
    ld b,16 ; length of step.
sound_tankshoot0 push bc
    ld a,(hl) ; next "random" number.
    inc hl ; pointer.
    and 248 ; we want a black border.
    out (254),a ; write to speaker.
    ld a,e ; as e gets smaller...
    cpl ; ...we increase the delay.
sound_tankshoot1 dec a ; decrement loop counter.
    jr nz,sound_tankshoot1 ; delay loop.
    pop bc
    djnz sound_tankshoot0 ; next step.
    pop de
    ld a,e
    sub 24 ; size of step.
    cp 30 ; end of range.
    jp z,sound_tankshoot5
    jp c, sound_tankshoot5
    ld e,a
    cpl
sound_tankshoot3 ld b,40 ; silent period.
sound_tankshoot4 djnz sound_tankshoot4
    dec a
    jr nz,sound_tankshoot3
    jr sound_tankshoot2
sound_tankshoot5
    ex af,af'
    ret
    
; Call this every time you want to initialise a sound effect
; A = Variable 1
; B = Variable 2
; C = Duration of overall sound effect
; D = Duration of each step of the sound effect
;
soundfx_a_init:         
    ld (soundfx_a_v2+1),a
    ld a,b
    ld (soundfx_a_v3+1),a
    ld a,c
    ld (soundfx_a_main+1),a
    ld a,d
    ld (soundfx_a_v1+1),a
    xor a
    ld (soundfx_a_v4),a
    ret
 
; Call this during your main loop
; It will play one step of the sound effect each pass
; until the complete sound effect has finished
;
soundfx_a_main:         
    ld a,0
    dec a
    ret z
    ld (soundfx_a_main+1),a
soundfx_a_v1:           
    ld b,0
    ld hl,soundfx_a_v4
soundfx_a_l1:           
    ld c,b
    ld a,%00001000
    out (254),a
    ld a,(hl)
soundfx_a_v2:           
    xor 0
    ld b,a
    djnz $
    xor a
    out (254),a
    ld a,(hl)
soundfx_a_v3:           
    xor 0
    ld b,a
    djnz $
    dec (hl)
    ld b,c
    djnz soundfx_a_l1
    ret
 
soundfx_a_v4:           
    defb 0