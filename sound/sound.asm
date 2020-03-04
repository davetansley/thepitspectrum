sound_dig:
    exx
	
    exx
	ret

sound_gamestart:
    di
    ld b,3
sound_gamestart0:
    push bc
    ld hl,554 ; pitch.
    ld de,150 ; duration.
    ld a,16
    and 248
    call 949 ; ROM beeper routine.
    ld hl,784 ; pitch.
    ld de,150 ; duration.
    ld a,16
    and 248
    call 949 ; ROM beeper routine.
    pop bc
    djnz sound_gamestart0
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
    ld b,8 ; length of step.
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
    