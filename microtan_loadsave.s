.segment "CODE"

        ldy     #$00
        beq     LC74D
LC74B:
        ldy     #$01
LC74D:
        ldx     #$4C
LC74F:
        lda     $13,x
        pha
        dex
        bpl     LC74F
        ldx     #$03
LC757:
        lda     $9A,x
        sta     $1C,x
        dex
        bpl     LC757
        jmp     LE219
        nop
        nop
        nop
LC764:
        tya
        pha
        ldy     $03
        lda     #$FF
        sta     ($0A),y
        pla
        tay
        jsr     LFDFA
        lda     $01
        jsr     LC7A5
        rts
        .byte   "DED"
        .byte   $0D,$0A
        .byte   "OK"
        .byte   $0D,$0A,$00
        .byte   "SAVED"
        .byte   $0D,$0A,$00
LC789:
        jsr     LC74B
        ldx     #$FF
        tsx
        lda     #$4F
        jsr     LFE75
        lda     #$4B
        jsr     LFE75
        jsr     LFE73
        lda     $9C
        tax
        ldy     $9D
        jmp     LC3F0
        nop
LC7A5:
        pha
        cmp     #$0A
        beq     LC7AD
        jsr     LFE75
LC7AD:
        tya
        pha
        ldy     $03
        lda     #$20
        sta     ($0A),y
        pla
        tay
        pla
        rts
        inc     $8A17
        stx     $9C
        sty     $9D
        jmp     LC3F0
