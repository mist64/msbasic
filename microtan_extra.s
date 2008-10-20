		.byte 0,0,0,0,0,0,0,0,0
LE210:
        jmp     LE34A
LE213:
        jmp     LE34A
LE216:
        jmp     LE33C
LE219:
        jmp     LE252
LE21C:
        jmp     LE6AD
LE21F:
        jmp     LE6B9
LE222:
        pla
        tay
        sta     $5E
        pla
        sta     $5F
        pha
        tya
        pha
        ldy     #$03
LE22E:
        lda     ($5E),y
        beq     LE238
        jsr     LFE75
        iny
        bne     LE22E
LE238:
        jsr     LFDFA
        lda     $01
        cmp     #$03
        beq     LE24C
        cmp     #$0D
        beq     LE24B
        jsr     LFE75
        jmp     LE238
LE24B:
        rts
LE24C:
        pla
        pla
        pla
        jmp     LE2D6
LE252:
        tya
        pha
        jsr     LE222
        bcs     LE260
        .byte   "FAST?"
        .byte   $0D,$00
LE260:
        ldy     #$00
        sty     $50
        sty     $31
        lda     $03E0
        cmp     #$59
        beq     LE26F
        inc     $50
LE26F:
        pla
        pha
        beq     LE28C
        jsr     LE222
        bcs     LE280
        ora     $5845
        .byte   "AM?"
        .byte   $0D,$00
LE280:
        lda     $03E0
        cmp     #$59
        beq     LE28C
        pla
        clc
        adc     #$01
        pha
LE28C:
        jsr     LE222
        bcs     LE29D
        ora     $4946
        .byte   "LENAME?"
        .byte   $0D,$00
LE29D:
        ldy     #$FF
        jsr     LF006
        bcs     LE28C
        cmp     #$FF
        bne     LE28C
        lda     #$00
        lda     #$42
        jsr     LF003
        jsr     LF000
        pla
        bne     LE2C3
        ldy     #$20
        jsr     LF009
        jsr     LF00C
        jsr     LF01E
        jmp     LE2D6
LE2C3:
        pha
        jsr     LF01B
        pla
        clc
        sbc     #$00
        jsr     LF021
        lda     $1E
        sta     $9C
        lda     $1F
        sta     $9D
LE2D6:
        jsr     LFE73
        cli
        lda     #$00
        sta     $BFCB
        sta     $BFC2
        ldx     #$00
LE2E4:
        pla
        sta     $13,x
        inx
        cpx     #$4D
        bne     LE2E4
        rts
        lda     #$0F
        sta     $0C
        lda     #$00
        sta     $BFC2
        sta     $15
        sta     $16
        jmp     COLD_START
LE2FD:
        pha
        txa
        pha
        lda     #$02
        sta     $14
        lda     #$00
LE306:
        dex
        bmi     LE312
        clc
        adc     #$20
        bcc     LE306
        inc     $14
        bne     LE306
LE312:
        sta     $13
        pla
        tax
        pla
        rts
LE318:
        jsr     LE2FD
        sta     ($13),y
        rts
LE31E:
        pha
        txa
        pha
        ldx     #$00
LE323:
        lda     $0220,x
        sta     $0200,x
        inx
        cpx     #$A0
        bne     LE323
        lda     #$20
        ldx     #$1F
LE332:
        sta     $0280,x
        dex
        bpl     LE332
        pla
        tax
LE33A:
        pla
        rts
LE33C:
        pha
        lda     $16
        beq     LE346
        bpl     LE33A
        jmp     LE714
LE346:
        pla
        jmp     LC7A5
LE34A:
        lda     $16
        beq     LE357
        bmi     LE353
        jmp     LE778
LE353:
        lda     #$00
        sta     $16
LE357:
        lda     $15
        beq     LE35E
        jmp     LE660
LE35E:
        jsr     LC764
        cmp     #$05
        beq     LE366
        rts
LE366:
        stx     $0E
        lda     #$00
        sta     $33
        sta     $34
        ldx     #$FF
LE370:
        inx
        cpx     $0E
        beq     LE3C8
        lda     $34
        cmp     #$19
        bcs     LE3A7
        pha
        lda     $33
        asl     a
        rol     $34
        asl     a
        rol     $34
        adc     $33
        sta     $33
        pla
        adc     $34
        sta     $34
        asl     $33
        rol     $34
        lda     $35,x
        sec
        sbc     #$30
        bmi     LE3A7
        cmp     #$3A
        bcs     LE3A7
        clc
        adc     $33
        sta     $33
        bcc     LE370
        inc     $34
        bne     LE370
LE3A7:
        ldx     #$00
LE3A9:
        lda     LE3B4,x
        beq     LE3C3
        jsr     LFE75
        inx
        bne     LE3A9
LE3B4:
        ora     $4F4E
        .byte   " SUCH LINE"

        .byte   $0D,$00
LE3C3:
        ldx     #$00
        lda     #$0D
        rts
LE3C8:
        ldx     #$09
LE3CA:
        lda     #$04
        sta     $45,x
        dex
        lda     #$01
        sta     $45,x
        dex
        bpl     LE3CA
        sta     $CE
        lda     #$04
        sta     $CF
        stx     $7D
        stx     $7B
LE3E0:
        ldy     #$03
        lda     ($CE),y
        pha
        dey
        lda     ($CE),y
        pha
        dey
        lda     ($CE),y
        tax
        dey
        lda     ($CE),y
        sta     $CE
        stx     $CF
        sta     $4F
        stx     $50
        pla
        tax
        pla
        cmp     $34
        bne     LE403
        cpx     $33
        beq     LE419
LE403:
        stx     $7A
        sta     $7B
        ldx     #$00
LE409:
        lda     $47,x
        sta     $45,x
        inx
        cpx     #$0A
        bne     LE409
        iny
        lda     ($CE),y
        beq     LE3A7
        bne     LE3E0
LE419:
        iny
        lda     ($CE),y
        beq     LE428
        iny
        lda     ($CE),y
        sta     $7C
        iny
        lda     ($CE),y
        sta     $7D
LE428:
        ldx     #$03
LE42A:
        lda     $7A,x
        pha
        dex
        bpl     LE42A
        lda     #$20
        ldx     #$0F
LE434:
        ldy     #$1F
LE436:
        jsr     LE318
        dey
        bpl     LE436
        dex
        bpl     LE434
        ldx     #$05
LE441:
        ldy     #$1F
        lda     #$2D
LE445:
        jsr     LE318
        dey
        bpl     LE445
        cpx     #$09
        beq     LE453
        ldx     #$09
        bne     LE441
LE453:
        lda     $45
        sta     $CE
        lda     $46
        sta     $CF
LE45B:
        txa
        pha
        lda     #$00
        sta     $07
        ldy     #$02
        lda     ($CE),y
        tax
        iny
        lda     ($CE),y
        cmp     $34
        beq     LE473
        bcc     LE479
LE46F:
        dec     $07
        bmi     LE47B
LE473:
        cpx     $33
        beq     LE47B
        bcs     LE46F
LE479:
        inc     $07
LE47B:
        sty     $08
        stx     $D2
        sta     $D1
        ldx     #$90
        sec
        jsr     FLOAT2
        jsr     FOUT
        ldx     #$00
LE48C:
        lda     $0100,x
        beq     LE496
        sta     $35,x
        inx
        bne     LE48C
LE496:
        lda     #$20
LE498:
        ldy     $08
        and     #$7F
LE49C:
        sta     $35,x
        beq     LE4D0
        inx
        cpx     #$4F
        bcc     LE4A9
        lda     #$00
        beq     LE49C
LE4A9:
        iny
        lda     ($CE),y
        bpl     LE49C
        sec
        sbc     #$7F
        stx     $09
        tax
        sty     $08
        ldy     #$FF
LE4B8:
        dex
        beq     LE4C3
LE4BB:
        iny
        lda     TOKEN_NAME_TABLE,y
        bpl     LE4BB
        bmi     LE4B8
LE4C3:
        ldx     $09
LE4C5:
        iny
        lda     TOKEN_NAME_TABLE,y
        bmi     LE498
        sta     $35,x
        inx
        bne     LE4C5
LE4D0:
        ldx     #$00
        stx     $08
        pla
        tax
        ldy     #$00
        lda     $07
        bne     LE4E0
        ldx     #$06
        bne     LE4EE
LE4E0:
        bpl     LE4E9
LE4E2:
        inx
        cpx     #$0E
        beq     LE529
        bne     LE4EE
LE4E9:
        jsr     LE31E
        ldx     #$04
LE4EE:
        stx     $09
LE4F0:
        ldx     $08
        lda     $35,x
        beq     LE50D
        inx
        stx     $08
        ldx     $09
        jsr     LE318
        iny
        cpy     #$20
        bne     LE4F0
        ldy     #$00
        lda     $07
        beq     LE4E2
        bpl     LE4E9
        bmi     LE4E2
LE50D:
        ldy     #$00
        lda     ($CE),y
        pha
        iny
        lda     ($CE),y
        sta     $CF
        pla
        sta     $CE
        lda     ($CE),y
        beq     LE529
        ldx     $09
        lda     $07
        bne     LE526
        ldx     #$09
LE526:
        jmp     LE45B
LE529:
        ldx     #$00
LE52B:
        lda     $02C1,x
        cmp     #$20
        beq     LE53A
        sta     $03E1,x
        inx
        stx     $0E
        bne     LE52B
LE53A:
        ldx     #$00
LE53C:
        pla
        sta     $7A,x
        inx
        cpx     #$04
        bne     LE53C
        ldx     #$06
        ldy     #$00
        sty     $01
LE54A:
        jsr     LE2FD
        lda     ($13),y
        sta     $82
        lda     #$FF
        sta     ($13),y
LE555:
        lda     #$40
        sta     $80
        sta     $81
LE55B:
        lda     $01
        bne     LE574
        dec     $80
        bne     LE55B
        dec     $81
        bne     LE55B
        lda     ($13),y
        pha
        lda     $82
        sta     ($13),y
        pla
        sta     $82
        jmp     LE555
LE574:
        lda     $82
        bmi     LE57A
        sta     ($13),y
LE57A:
        lda     $01
        cmp     #$18
        bne     LE584
        dey
        bpl     LE584
        iny
LE584:
        cmp     #$06
        bne     LE58D
        cpy     #$1F
        beq     LE58D
        iny
LE58D:
        cmp     #$02
        bne     LE596
        cpx     #$06
        beq     LE596
        dex
LE596:
        cmp     #$04
        bne     LE59F
        cpx     #$08
        beq     LE59F
        inx
LE59F:
        cmp     #$7F
        bne     LE5B6
        cpy     #$00
        bne     LE5AB
        cpx     #$06
        beq     LE5B6
LE5AB:
        dey
        bpl     LE5BA
        ldy     #$1F
        dex
        jsr     LE2FD
        bne     LE5BA
LE5B6:
        cmp     #$05
        bne     LE5D5
LE5BA:
        pha
        tya
        pha
LE5BD:
        tya
        clc
        adc     $13
        cmp     #$1F
        beq     LE5CE
        iny
        lda     ($13),y
        dey
        sta     ($13),y
        iny
        bne     LE5BD
LE5CE:
        lda     #$20
        sta     ($13),y
        pla
        tay
        pla
LE5D5:
        cmp     #$1B
        beq     LE641
        cmp     #$0D
        beq     LE657
        cmp     #$0A
        beq     LE631
        cmp     #$03
        beq     LE645
        cmp     #$0B
        beq     LE627
        cmp     #$09
        beq     LE63D
        cmp     #$20
        bcc     LE620
        cmp     #$7E
        bcs     LE620
        pha
        tya
        pha
        lda     ($13),y
LE5FA:
        sta     $80
        tya
        clc
        adc     $13
        cmp     #$1F
        beq     LE60F
        iny
        lda     ($13),y
        pha
        lda     $80
        sta     ($13),y
        pla
        bne     LE5FA
LE60F:
        pla
        tay
        pla
        sta     ($13),y
        cpy     #$1F
        bne     LE61F
        cpx     #$08
        beq     LE620
        inx
        ldy     #$FF
LE61F:
        iny
LE620:
        lda     #$00
        sta     $01
        jmp     LE54A
LE627:
        ldx     #$5F
        lda     #$20
LE62B:
        sta     $02C0,x
        dex
        bpl     LE62B
LE631:
        ldx     #$02
LE633:
        lda     $7A,x
        sta     $13
        inx
        lda     $7A,x
        jmp     LE659
LE63D:
        ldx     #$00
        stx     $0E
LE641:
        ldx     #$00
        beq     LE633
LE645:
        jsr     LFE73
        ldx     #$00
        lda     #$00
        sta     $16
LE64E:
        sta     $15
        ldy     #$00
        sty     $03
        lda     #$0D
        rts
LE657:
        lda     #$FF
LE659:
        sta     $14
        lda     #$01
        pha
        bne     LE685
LE660:
        cmp     #$03
        beq     LE69E
        cmp     #$02
        beq     LE681
        ldx     $03C0
        cpx     #$20
        bne     LE645
        ldx     #$FF
LE671:
        inx
        cpx     $0E
        bne     LE67A
        lda     #$02
        bne     LE64E
LE67A:
        lda     $03E1,x
        sta     $35,x
        bne     LE671
LE681:
        tax
        inx
        txa
        pha
LE685:
        ldx     #$4F
LE687:
        lda     $02C0,x
        sta     $35,x
        dex
        bpl     LE687
        ldx     #$4F
LE691:
        lda     $02BF,x
        cmp     #$20
        bne     LE69B
        dex
        bne     LE691
LE69B:
        pla
        bne     LE64E
LE69E:
        ldx     $14
        cpx     #$FF
        beq     LE645
        stx     $34
        lda     $13
        sta     $33
        jmp     LE3C8
LE6AD:
        pha
        lda     #$05
        sta     $0E
        pla
        jsr     LINGET
        jmp     LC57E
LE6B9:
        lda     $0E
        bmi     LE6D1
        dec     $0E
        bne     LE6D1
        jsr     LFDFA
        lda     #$82
        sta     $0E
        lda     $01
        cmp     #$0A
        beq     LE6D1
        sec
        rol     $0E
LE6D1:
        jsr     ISCNTC
        jmp     LC5A9
LE6D7:
        ldx     #$FF
LE6D9:
        jsr     LE6E2
        dey
        bne     LE6D9
        dex
        bne     LE6D9
LE6E2:
        rts
LE6E3:
        lda     #$0C
LE6E5:
        ldx     #$FF
        tay
        lda     $01
        cmp     #$03
        beq     LE6E2
        tya
LE6EF:
        pha
        lda     $BFC0
LE6F3:
        lda     $BFCD
        and     #$08
        beq     LE6F3
        lda     $BFC9
        pha
        lda     #$FF
        sta     $BFC9
        pla
        cmp     #$FC
        pla
        bcc     LE6E5
        dex
        bne     LE6EF
        dey
        bne     LE6EF
        rts
LE710:
        lda     #$06
        bne     LE6E5
LE714:
        stx     $13
        sty     $14
        lda     $16
        cmp     #$FD
        beq     LE749
        lda     #$00
        sta     $BFCB
        lda     #$20
        sta     $BFC0
        lda     #$40
        sta     $BFC2
        jsr     LE6D7
        jsr     LF000
        lda     $16
        cmp     #$FF
        bne     LE740
        ldy     #$20
        jsr     LF009
        dec     $16
LE740:
        ldy     #$10
        ldx     #$FF
        jsr     LF009
        dec     $16
LE749:
        pla
        sei
        pha
        cmp     #$0A
        beq     LE771
        ldx     $0E
        stx     $50
        jsr     LF00F
        cli
        lda     $01
        cmp     #$03
        beq     LE771
        pla
        pha
        cmp     #$0D
        bne     LE771
        lda     #$00
        sta     $16
        sta     $BFCB
        jsr     LE6D7
        sta     $BFC2
LE771:
        ldx     $13
        ldy     $14
        cli
        pla
        rts
LE778:
        lda     #$40
        sta     $BFC0
        jsr     LF000
        cli
        lda     $16
        cmp     #$01
        bne     LE78A
        jsr     LE6E3
LE78A:
        jsr     LE710
        lda     $01
        cmp     #$03
        beq     LE7CE
LE793:
        lda     $50
        pha
        lda     $51
        pha
        lda     $0E
        sta     $50
        sei
        jsr     LF018
        cli
        tay
        pla
        sta     $51
        pla
        sta     $50
        bcs     LE7BD
        lda     #$00
        sta     $16
        ldx     #$06
LE7B1:
        lda     LE7DC,x	; "PARITY"
        jsr     LFE75
        dex
        bpl     LE7B1
        inx
        beq     LE7CE
LE7BD:
        lda     $01
        cmp     #$03
        beq     LE7CE
        cpy     #$0D
        beq     LE7CE
        sty     $35,x
        inx
        cpx     #$4F
        bne     LE793
LE7CE:
        lda     #$00
        sta     $BFCB
        sta     $BFC2
        sta     $16
        cli
        lda     #$0D
        rts
LE7DC:
        .byte   "YTIRAP"
        .byte   $0D,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF
        .byte   $FF,$FF,$FF,$FF,$FF,$FF
