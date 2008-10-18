.segment "CODE"
SLOD:
        ldx     #$01
        .byte   $2C
PLOD:
        ldx     #$00
        ldy     CURLIN+1
        iny
        sty     JMPADRS
        jsr     LFFD3
        jsr     VARTAB_MINUS_2_TO_AY
        ldx     #$02
        jsr     LFF64
        ldx     #$6F
        ldy     #$00
        jsr     LE39A
        jsr     LE33D
        jmp     CLEARC
        .byte   $FF,$FF,$FF

; ----------------------------------------------------------------------------
VER:
        lda     #$13
        ldx     FAC
        beq     LE397
        lda     $DFF9
LE397:
        jmp     FLOAT
LE39A:
        lda     VARTAB,x
        clc
        adc     $051B,y
        sta     VARTAB,y
        lda     VARTAB+1,x
        adc     $051C,y
        sta     VARTAB+1,y
; !!! next instruction is an RTS!