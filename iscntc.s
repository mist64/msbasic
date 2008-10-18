.segment "CODE"
; ----------------------------------------------------------------------------
; SEE IF CONTROL-C TYPED
; ----------------------------------------------------------------------------
.ifndef CONFIG_CBM_ALL
ISCNTC:
.endif
.ifdef KBD
        jsr     LE8F3
        bcc     RET1
LE633:
        jsr     LDE7F
        beq     STOP
        cmp     #$03
        bne     LE633
.endif
.ifdef OSI
        jmp     MONISCNTC
        nop
        nop
        nop
        nop
        lsr     a
        bcc     RET2
        jsr     GETLN
        cmp     #$03
.endif
.ifdef APPLE
        lda     $C000
        cmp     #$83
        beq     L0ECC
        rts
L0ECC:
        jsr     RDKEY
        cmp     #$03
.endif
.ifdef KIM
        lda     #$01
        bit     $1740
        bmi     RET2
        ldx     #$08
        lda     #$03
        clc
        cmp     #$03
.endif
.ifdef MICROTAN
        lda     $01
        cmp     #$03
        beq     LC6EF
        lda     #$01
        rts
LC6EF:
        nop
        nop
        cmp     #$03
.endif
;!!! runs into "STOP"