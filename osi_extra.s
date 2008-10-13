.segment "EXTRA"

        .byte   $00,$00
LBEE4:
        lda     LBF05
        lsr     a
        bcc     LBEE4
        lda     $FB03
        sta     $FB07
        and     #$7F
        rts
        pha
LBEF4:
        lda     $FB05
        bpl     LBEF4
        pla
        sta     $FB04
        rts
        lda     $FB06
        lda     #$FF
        .byte   $8D
        .byte   $05
LBF05:
        .byte   $FB
        rts
LBF07:
        lda     $FC00
        lsr     a
        bcc     LBF07
        lda     $FC01
        beq     LBF07
        and     #$7F
        rts
        pha
LBF16:
        lda     $FC00
        lsr     a
        lsr     a
        bcc     LBF16
        pla
        sta     $FC01
        rts
        lda     #$03
        sta     $FC00
        lda     #$B1
        sta     $FC00
        rts
        sta     $0202
        pha
        txa
        pha
        tya
        pha
        lda     $0202
        beq     LBF6D
        ldy     $0206
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
        sta     $0201
        jsr     LBFC2
        inc     $0200
        lda     $FFE1
        clc
        adc     $FFE0
        cmp     $0200
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
        lda     $FFE0
        and     #$E0
        sta     $0202
        ldx     #$07
LBF83:
        lda     LBFF3,x
        sta     L0207,x
        dex
        bpl     LBF83
        ldx     LBFFB,y
        lda     #$20
        ldy     $FFE1
        cpy     #$20
        bmi     LBF99
        asl     a
LBF99:
        sta     $0208
        ldy     #$00
LBF9E:
        jsr     L0207
        bne     LBF9E
        inc     $0209
        inc     $020C
        cpx     $0209
        bne     LBF9E
LBFAE:
        jsr     L0207
        cpy     $0202
        bne     LBFAE
        lda     #$20
LBFB8:
        jsr     L020A
        dec     $0208
        bne     LBFB8
        beq     LBF6A
LBFC2:
        ldx     $0200
        lda     $0201
LBFC8:
        ldy     $FFE2
        bne     LBFD1
        sta     $D300,x
        rts
LBFD1:
        sta     $D700,x
        rts
LBFD5:
        jsr     LBFC2
LBFD8:
        lda     $FFE0
        sta     $0200
LBFDE:
        ldx     $0200
        lda     $D300,x
        ldy     $FFE2
        beq     LBFEC
        lda     $D700,x
LBFEC:
        sta     $0201
        lda     #$5F
        bne     LBFC8
LBFF3:
        lda     $D000,y
        sta     $D000,y
        iny
        rts
LBFFB:
        .byte   $D3
        .byte   $D7
        brk
        brk
        brk
