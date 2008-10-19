.segment "EXTRA"

        .byte   $00,$00
LBEE4:
        lda     LBF03+2
        lsr     a
        bcc     LBEE4
        lda     LFB00+3
        sta     LFB00+7
        and     #$7F
        rts
        pha
LBEF4:
        lda     LFB00+5
        bpl     LBEF4
        pla
        sta     LFB00+4
        rts
        lda     LFB00+6
        lda     #$FF
LBF03:
        sta     LFB00+5
        rts
LBF07:
        lda     LFC00
        lsr     a
        bcc     LBF07
        lda     LFC00+1
        beq     LBF07
        and     #$7F
        rts
        pha
LBF16:
        lda     LFC00
        lsr     a
        lsr     a
        bcc     LBF16
        pla
        sta     LFC00+1
        rts
        lda     #$03
        sta     LFC00
        lda     #$B1
        sta     LFC00
        rts
        sta     L0200+2
        pha
        txa
        pha
        tya
        pha
        lda     L0200+2
        beq     LBF6D
        ldy     L0200+6
        beq     LBF47
LBF3F:
        ldx     #$40
LBF41:
        dex
        bne     LBF41
        dey
        bne     LBF3F
LBF47:
        cmp     #$0A
        beq     LBF76
        cmp     #$0D
        bne     LBF55
        jsr     LBFD5
        jmp     LBF6D
LBF55:
        sta     L0200+1
        jsr     LBFC2
        inc     L0200+0
        lda     LFFE0+1
        clc
        adc     LFFE0+0
        cmp     L0200+0
        bmi     LBF73
LBF6A:
        jsr     LBFDE
LBF6D:
        pla
        tay
        pla
        tax
        pla
        rts
LBF73:
        jsr     LBFD8
LBF76:
        jsr     LBFC2
        lda     LFFE0
        and     #$E0
        sta     L0200+2
        ldx     #$07
LBF83:
        lda     LBFF3,x
        sta     L0200+7,x
        dex
        bpl     LBF83
        ldx     LBFFB,y
        lda     #$20
        ldy     LFFE0+1
        cpy     #$20
        bmi     LBF99
        asl     a
LBF99:
        sta     L0200+8
        ldy     #$00
LBF9E:
        jsr     L0200+7
        bne     LBF9E
        inc     L0200+9
        inc     L0200+12
        cpx     L0200+9
        bne     LBF9E
LBFAE:
        jsr     L0200+7
        cpy     L0200+2
        bne     LBFAE
        lda     #$20
LBFB8:
        jsr     L0200+10
        dec     L0200+8
        bne     LBFB8
        beq     LBF6A
LBFC2:
        ldx     L0200+0
        lda     L0200+1
LBFC8:
        ldy     LFFE0+2
        bne     LBFD1
        sta     LD300,x
        rts
LBFD1:
        sta     LD700,x
        rts
LBFD5:
        jsr     LBFC2
LBFD8:
        lda     LFFE0
        sta     L0200+0
LBFDE:
        ldx     L0200+0
        lda     LD300,x
        ldy     LFFE0+2
        beq     LBFEC
        lda     LD700,x
LBFEC:
        sta     L0200+1
        lda     #$5F
        bne     LBFC8
LBFF3:
        lda     LD000,y
        sta     LD000,y
        iny
        rts
LBFFB:
        .byte   $D3
        .byte   $D7
        brk
        brk
        brk
