.segment "EXTRA"
        stx     SHIFTSIGNEXT
        stx     $0800
        inx
        stx     Z17
        stx     Z18
        stx     TXTTAB
        lda     #$08
        sta     TXTTAB+1
        jsr     SCRTCH
        sta     STACK+255
LFD81:
        jsr     PRIMM
        .byte   $1B,$06,$01,$0C
		.byte	"INTELLIVISION BASIC"
        .byte	$0D,$0A,$0A
		.byte	"Copyright Microsoft, Mattel  1980"
        .byte	$0D,$0A,$00
        sta     $0435
        sta     $8F
        ldy     #$0F
        lda     #$FF
        sta     ($04),y
        jsr     LDE8C
        .byte   $0C	; NOP $xxxx
        jmp     RESTART
OUTQUESSP:
        jsr     OUTQUES
        jmp     OUTSP
INLIN:
        ldy     #$FF
LFDDC:
        iny
LFDDD:
        jsr     GETLN
        cmp     #$03	; CTRL+C
        beq     LFDF7
        cmp     #$20
        bcs     LFDEC	; no control char
        sbc     #$09
        bne     LFDDD
LFDEC:
        sta     INPUTBUFFER,y
        tax
        bne     LFDDC
        jsr     CRDO2
        ldy     #$06
LFDF7:
        tax
        clc
        rts
LFDFA:
        bit     $8F
        bmi     LFE01
        jsr     LDE48
LFE01:
        bit     $8F
        bvc     LFE10
        jmp     LDE53
LFE08:
        jsr     LFDFA
LFE0B:
        jsr     LDE24
        bne     LFE08
LFE10:
        rts
VSAV:
        jsr     GARBAG
        lda     FRETOP
        sta     $00
        lda     FRETOP+1
        .byte   $85
LFE1B:
        ora     ($A5,x)
        .byte   $2F
        sta     $02
        lda     STREND+1
        sta     $03
        ldy     #$00
LFE26:
        lda     ($00),y
        sta     ($02),y
        inc     $02
        bne     LFE30
        inc     $03
LFE30:
        inc     $00
        bne     LFE26
        inc     $01
        bit     $01
        bvc     LFE26
        ldx     VARTAB
        ldy     VARTAB+1
        lda     #$01
        bne     LFE50
PSAV:
        lda     VARTAB
        sta     $02
        lda     VARTAB+1
        sta     $03
        ldx     #$01
        ldy     #$08
        lda     #$02
LFE50:
        sta     $0513
        stx     $0503
        stx     $00
        sty     $0504
        sty     $01
        ldy     #$0D
        lda     #$00
LFE61:
        sta     $0504,y
        dey
        bne     LFE61
        sty     $0500
        lda     #$40
        sta     $0505
        lda     $02
        sec
        sbc     $00
        sta     $00
        lda     $03
        sbc     $01
        sta     $01
        lsr     a
        lsr     a
        lsr     a
        sta     $03
        jsr     LE870
        sta     $02
        jsr     CHRGOT
        beq     LFEA6
        cmp     #$2C
        beq     L40FA
        jmp     SYNERR
L40FA:
        jsr     CHRGET
        jsr     LE870
        sec
        sbc     $02
        cmp     $03
        bpl     LFEBF
        lda     #$27
        sta     JMPADRS
        jmp     LFFBD
LFEA6:
        lda     $02
        clc
        adc     $03
        jsr     LE874
        pha
        jsr     LFE0B
        jsr     L6874
        .byte   $72
        adc     $00,x
        pla
        tax
        lda     #$00
        jsr     LINPRT
LFEBF:
        ldx     #$07
LBF83:
        dex
        lda     VARTAB,x
        sec
        sbc     TXTTAB,x
        sta     $051B,x
        lda     VARTAB+1,x
        sbc     TXTTAB+1,x
        sta     $051C,x
        dex
        bpl     LBF83
        txa
        sbc     FRETOP
        sta     $0521
        lda     #>CONST_MEMSIZ
        sbc     FRETOP+1
        sta     $0522
        lda     FRETOP
        sta     $0523
        lda     FRETOP+1
        sta     $0524
        ldx     $02
        jsr     LFFDD
        jsr     LFFD1
        lda     $01
        ldx     #$05
LFEF7:
        stx     $0511
        ldy     #$E4
        sec
        sbc     #$08
        sta     $01
        bpl     LFF15
        adc     #$08
        asl     $00
        rol     a
        asl     $00
        rol     a
        asl     $00
        rol     a
        adc     #$01
        sta     $0505
        ldy     #$00
LFF15:
        sty     $0512
        jsr     LE4C0
        ldx     #$00
        lda     $01
        bpl     LFEF7
LFF21:
        rts
VLOD:
        jsr     LFFD1
        stx     JMPADRS
        lda     VARTAB
        ldy     VARTAB+1
        ldx     #$01
        jsr     LFF64
        ldx     #$00
        ldy     #$02
LFF34:
        jsr     LE39A
        iny
        iny
        inx
        inx
        cpx     #$05
        bmi     LFF34
        lda     STREND
        sta     LOWTR
        lda     STREND+1
        sta     LOWTR+1
        lda     FRETOP
        sta     HIGHTR
        lda     FRETOP+1
        sta     HIGHTR+1
        lda     #<CONST_MEMSIZ
        sta     HIGHDS
        lda     #>CONST_MEMSIZ
        sta     HIGHDS+1
        lda     $0523
        sta     FRETOP
        lda     $0524
        sta     FRETOP+1
        jmp     BLTU2
LFF64:
        sta     $9A
        sty     $9B
        stx     $00
        jsr     LE870
        jsr     LFFDD
        lda     JMPADRS
        beq     LFF7F
        lda     #$01
        sta     $9A
        lda     #$08
        sta     $9B
        jsr     STXTPT
LFF7F:
        lda     $9A
        sta     $0503
        lda     $9B
        sta     $0504
        lda     #$ED
        sta     $0512
        lda     #$05
        sta     $01
LFF92:
        ldx     $0512
        beq     LFF21
        ldy     #$04
        jsr     LE4C4
        lda     $01
        cmp     $0511
        bne     LFFB2
        lda     #$00
        sta     $01
        lda     $00
        cmp     $0513
        beq     LFF92
        lda     #$18
        bne     LFFB8
LFFB2:
        lda     #$27
        bne     LFFB8
LFFB6:
        lda     #$3C
LFFB8:
        sta     JMPADRS
        jsr     CLEARC
LFFBD:
        jsr     VARTAB_MINUS_2_TO_AY
        sta     $9A
        sty     $9B
        lda     #$00
        tay
        sta     ($9A),y
        iny
        sta     ($9A),y
        ldx     JMPADRS
        jmp     ERROR
LFFD1:
        ldx     #$00
LFFD3:
        lda     #$02
        .byte   $2C
LFFD6:
        lda     #$03
        jsr     LDE8C
        asl     FACSIGN
LFFDD:
        jsr     CHRGOT
        beq     LFFE5
        jmp     SYNERR
LFFE5:
        lda     #$0D
        ldy     #$00
        jsr     LDE8C
        .byte   $06
LFFED:
        lda     $034C
        bmi     LFFED
        ldy     #$01
        lda     ($04),y
        bne     LFFB6
        rts
        .byte   $FF
; NMI
        .addr   LC000
; RESET
        .addr   LC000
; IRQ
        .addr   LC009
