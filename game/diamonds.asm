;
; Changes the attribute of gem and diamond cells based on the frame count
; Inputs:
; hl - memory location of gem type
diamonds_twinkle_type:
    call game_getcurrentframe       ; get current frame number
    and 7                           ; want a number from 0-7
    add 64                          ; add to 60 to get attr colour
diamonds_twinkle_type0:
    ld c,(hl)                      ; get coords into bc
    ex af, af'
    ld a,c                          ; load c into add
    cp 255                          ; is this the end?
    jp z,diamonds_twinkle_type1           ; step out if so
    inc hl
    inc hl
    ld a,(hl)                       ; check the state, don't process if collection
    cp 1
    jp z,diamonds_twinkle_type1           ; step out if so
    inc hl 
    ex af,af'
    ld de,(hl)                      ; get the memory location into de
    ld (de),a                       ; set the value of attr
    inc hl
    inc hl                          ; move to next diamond 
    jp diamonds_twinkle_type0
diamonds_twinkle_type1:
    ret

;
; Initialise diamonds and gems
; 
diamonds_twinkle
    ld hl, level01diamonds
    call diamonds_twinkle_type
    ld hl, level01gems
    call diamonds_twinkle_type
    ret

;
; Initialise diamonds and gems
; 
diamonds_init:
    ld hl, level01diamonds
    call diamonds_init_type
    ld hl, level01gems
    call diamonds_init_type
    ret

;
; Initialise diamonds or gems, get memory addresses
; Inputs:
; hl - memory location
diamonds_init_type:
    ld c,(hl)                      ; get coords into c
    ld a,c                          ; load c into add
    cp 255                          ; is this the end?
    jp z,diamonds_init_type1             ; step out if so
    inc hl
    ld b,(hl)                       ; get coords into b
    push hl
    call screen_getcellattradress ; get memory of attr for this diamond into de 
    pop hl
    inc hl                          ; move to state 
    inc hl                          ; move to memory
    ld (hl),de                      ; store the memory location 
    inc hl                          ; move to next diamond 
    inc hl
    jp diamonds_init_type
diamonds_init_type1:
    ret