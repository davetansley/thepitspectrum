sound_gemcollected:
    ld hl,200 ; pitch.
    ld de,62 ; duration.
    call 949 ; ROM beeper routine.
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
sound_rockfell2 push de
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
    