.segment "INIT"

.ifdef KBD
LFD3E:
        php
        jmp     FNDLIN
.endif
COLD_START:
.ifdef KBD
        lda     #$81
        sta     $03A0
        lda     #$FD
        sta     $03A1
        lda     #$20
        sta     $0480
        lda     $0352
        sta     $04
        lda     $0353
        sta     $05
.else
.ifndef CONFIG_CBM_ALL
        lda     #<QT_WRITTEN_BY
        ldy     #>QT_WRITTEN_BY
        jsr     STROUT
.endif
COLD_START2:
.ifndef CBM2
        ldx     #$FF
        stx     CURLIN+1
.endif
.if INPUTBUFFER >= $0100
        ldx     #$FB
.endif
        txs
.ifndef CONFIG_CBM_ALL
        lda     #<COLD_START2
        ldy     #>COLD_START2
        sta     Z00+1
        sty     Z00+2
        sta     GOWARM+1
        sty     GOWARM+2
        lda     #<AYINT
        ldy     #>AYINT
        sta     GOSTROUT
        sty     GOSTROUT+1
        lda     #<GIVAYF
        ldy     #>GIVAYF
        sta     GOGIVEAYF
        sty     GOGIVEAYF+1
.endif
        lda     #$4C
.ifdef CONFIG_CBM_ALL
        sta     JMPADRS
        sta     Z00
.else
        sta     Z00
        sta     GOWARM
        sta     JMPADRS
.endif
.ifdef APPLE
        sta     L000A
.endif
.ifdef CONFIG_SMALL
        sta     USR
        lda     #$88
        ldy     #$AE
        sta     $0B
        sty     $0C
.endif
.ifdef CONFIG_CBM_ALL
        lda     #<IQERR
        ldy     #>IQERR
.endif
.ifdef APPLE
        lda     #<L29D0
        ldy     #>L29D0
.endif
.ifdef CBM_APPLE
        sta     L0001
        sty     L0001+1
.endif
.ifndef CONFIG_CBM_ALL
.ifdef APPLE
        lda     #$28
.else
        lda     #$48
.endif
        sta     Z17
.ifdef APPLE
        lda     #$0E
.else
        lda     #$38
.endif
        sta     Z18
.endif
.ifdef CBM2_KBD
        lda     #$28
        sta     $0F
        lda     #$1E
        sta     $10
.endif
.endif
.ifdef CONFIG_SMALL
.ifdef KBD
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET+4
.else
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET
.endif
.else
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET-1 ; XXX
.endif
L4098:
        lda     GENERIC_CHRGET-1,x
        sta     STRNG2+1,x
        dex
        bne     L4098
.ifdef CBM2_KBD
        lda     #$03
        sta     DSCLEN
.endif
.ifndef KBD
        txa
        sta     SHIFTSIGNEXT
.ifdef CONFIG_CBM_ALL
        sta     Z03
.endif
        sta     LASTPT+1
.if .defined(CONFIG_NULL) || .defined(CBM1)
        sta     Z15
.endif
.ifndef CONFIG_11
        sta     Z16
.endif
        pha
        sta     Z14
.ifdef CBM2_KBD
        inx
        stx     $01FD
        stx     $01FC
.else
        lda     #$03
        sta     DSCLEN
.ifndef KIM_APPLE
        lda     #$2C
        sta     LINNUM+1
.endif
        jsr     CRDO
.endif
.ifdef APPLE
        lda     #$01
        sta     $01FD
        sta     $01FC
.endif
        ldx     #TEMPST
        stx     TEMPPT
.ifndef CONFIG_CBM_ALL
        lda     #<QT_MEMORY_SIZE
        ldy     #>QT_MEMORY_SIZE
        jsr     STROUT
.ifdef APPLE
        jsr     INLINX
.else
        jsr     NXIN
.endif
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        cmp     #$41
        beq     COLD_START
        tay
        bne     L40EE
.endif
.ifndef CBM2_KBD
        lda     #<RAMSTART2
.endif
        ldy     #>RAMSTART2
.ifdef CBM2_KBD
        sta     $28
        sty     $29
.endif
        sta     LINNUM
        sty     LINNUM+1
.ifdef CBM2_KBD
		tay
.else
        ldy     #$00
.endif
L40D7:
        inc     LINNUM
        bne     L40DD
        inc     LINNUM+1
.ifdef CBM1
        lda     $09
        cmp     #$80
        beq     L40FA
.endif
.ifdef CBM2_KBD
        bmi     L40FA
.endif
L40DD:
.ifdef CBM2_KBD
        lda     #$55
.else
        lda     #$92
.endif
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA
        asl     a
        sta     (LINNUM),y
        cmp     (LINNUM),y
.ifdef CONFIG_CBM_ALL
        beq     L40D7
.else
.ifdef CONFIG_SMALL
        beq     L40D7
        bne     L40FA
.else
        bne     L40FA
        beq     L40D7
.endif
L40EE:
        jsr     CHRGOT
        jsr     LINGET
        tay
        beq     L40FA
        jmp     SYNERR
.endif
L40FA:
        lda     LINNUM
        ldy     LINNUM+1
        sta     MEMSIZ
        sty     MEMSIZ+1
        sta     FRETOP
        sty     FRETOP+1
L4106:
.ifndef CONFIG_CBM_ALL
.ifdef APPLE
        lda     #$FF
        jmp     L2829
        .word	STROUT ; PATCH!
        jsr     NXIN
.else
        lda     #<QT_TERMINAL_WIDTH
        ldy     #>QT_TERMINAL_WIDTH
        jsr     STROUT
        jsr     NXIN
.endif
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        tay
        beq     L4136
        jsr     LINGET
        lda     LINNUM+1
        bne     L4106
        lda     LINNUM
        cmp     #$10
        bcc     L4106
L2829:
        sta     Z17
L4129:
        sbc     #$0E
        bcs     L4129
        eor     #$FF
        sbc     #$0C
        clc
        adc     Z17
        sta     Z18
L4136:
.endif
.ifdef KIM
        lda     #<QT_WANT
        ldy     #>QT_WANT
        jsr     STROUT
        jsr     NXIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        ldx     #<RAMSTART1
        ldy     #>RAMSTART1
        cmp     #'Y'
        beq     L4183
        cmp     #'A'
        beq     L4157
        cmp     #'N'
        bne     L4136
L4157:
        ldx     #<IQERR
        ldy     #>IQERR
        stx     UNFNC+26
        sty     UNFNC+26+1
        ldx     #<ATN
        ldy     #>ATN
        cmp     #'A'
        beq     L4183
        ldx     #<IQERR
        ldy     #>IQERR
        stx     UNFNC+20
        sty     UNFNC+20+1
        stx     UNFNC+20+1+3
        sty     UNFNC+20+1+3+1
        stx     UNFNC+20+1+1
        sty     UNFNC+20+1+1+1
        ldx     #<SIN_COS_TAN_ATN
        ldy     #>SIN_COS_TAN_ATN
L4183:
.else
        ldx     #<RAMSTART2
        ldy     #>RAMSTART2
.endif
        stx     TXTTAB
        sty     TXTTAB+1
        ldy     #$00
        tya
        sta     (TXTTAB),y
        inc     TXTTAB
.ifndef CBM2_KBD
        bne     L4192
        inc     TXTTAB+1
L4192:
.endif
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     REASON
.ifdef CBM2_KBD
        lda     #<QT_BASIC
        ldy     #>QT_BASIC
        jsr     STROUT
.else
        jsr     CRDO
.endif
        lda     MEMSIZ
        sec
        sbc     TXTTAB
        tax
        lda     MEMSIZ+1
        sbc     TXTTAB+1
        jsr     LINPRT
        lda     #<QT_BYTES_FREE
        ldy     #>QT_BYTES_FREE
        jsr     STROUT
.ifndef CONFIG_SCRTCH_ORDER
        jsr     SCRTCH
.endif
.ifdef CONFIG_CBM_ALL
        jmp     RESTART
.else
        lda     #<STROUT
        ldy     #>STROUT
        sta     GOWARM+1
        sty     GOWARM+2
.ifdef CONFIG_SCRTCH_ORDER
        jsr     SCRTCH
.endif
        lda     #<RESTART
        ldy     #>RESTART
        sta     Z00+1
        sty     Z00+2
        jmp     (Z00+1)
.endif
.ifndef CBM_APPLE
QT_WANT:
        .byte   "WANT SIN-COS-TAN-ATN"
        .byte   $00
.endif
QT_WRITTEN_BY:
.ifndef CONFIG_CBM_ALL
.ifdef APPLE
		asc80 "COPYRIGHT 1977 BY MICROSOFT CO"
		.byte	$0D,$00
.else
        .byte   $0D,$0A,$0C
.ifdef CONFIG_SMALL
        .byte   "WRITTEN BY RICHARD W. WEILAND."
.else
        .byte   "WRITTEN BY WEILAND & GATES"
.endif
        .byte   $0D,$0A,$00
.endif
QT_MEMORY_SIZE:
        .byte   "MEMORY SIZE"
        .byte   $00
QT_TERMINAL_WIDTH:
        .byte   "TERMINAL WIDTH"
        .byte   $00
.endif
QT_BYTES_FREE:
        .byte   " BYTES FREE"
.ifndef CBM_APPLE
        .byte   $0D,$0A,$0D,$0A
.endif
.ifdef CBM2_KBD
        .byte   $0D,$00
.endif
.ifdef APPLE
        .byte   $00
.endif
QT_BASIC:
.ifdef OSI
        .byte   "OSI 6502 BASIC VERSION 1.0 REV 3.2"
.endif
.ifdef KIM
        .byte   "MOS TECH 6502 BASIC V1.1"
.endif
.ifdef CBM1
        .byte   $13
        .byte   "*** COMMODORE BASIC ***"
        .byte   $11,$11,$11,$00
.endif
.ifdef CBM2
        .byte   "### COMMODORE BASIC ###"
        .byte   $0D,$0D,$00
.endif
.ifdef APPLE
        .byte   $0A,$0D,$0A
		.byte	"APPLE BASIC V1.1"
.endif
.ifndef CONFIG_CBM_ALL
        .byte   $0D,$0A
        .byte   "COPYRIGHT 1977 BY MICROSOFT CO."
        .byte   $0D,$0A,$00
.endif
.endif /* KBD */
.ifdef OSI
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
.endif /* CONFIG_SMALL */
.ifdef KIM
RAMSTART2:
        .byte   $08,$29,$25,$20,$60,$2A,$E5,$E4
        .byte   $20,$66,$24,$65,$AC,$04,$A4
.endif /* KIM */
.ifdef CONFIG_CBM1_PATCHES
PATCH1:
        clc
        jmp     CONTROL_C_TYPED
PATCH2:
        bit     $B4
        bpl     LE1AA
        cmp     #$54
        bne     LE1AA
        jmp     LCE3B
LE1AA:
        rts
PATCH3:
        bit     $B4
        bmi     LE1B2
        jmp     LCE90
LE1B2:
        cmp     #$54
        beq     LE1B9
        jmp     LCE82
LE1B9:
        jmp     LCE69
PATCH4:
        sta     CHARAC
        inx
        jmp     LE1D9
PATCH5:
        bpl     LE1C9
        lda     $8E
        ldy     $8F
        rts
LE1C9:
        ldy     #$FF
        rts
PATCH6:
        bne     LE1D8
LE1CE:
        inc     $05
        bne     LE1D8
        lda     $E2
        sta     $05
        bne     LE1CE
LE1D8:
        rts
LE1D9:
        stx     $C9
        pla
        pla
        tya
        jmp     L2B1C
.endif
.ifdef KBD
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
        jsr     LDE42
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
        .byte   $0C
        jmp     RESTART
OUTQUESSP:
        jsr     OUTQUES
        jmp     OUTSP
LFDDA:
        ldy     #$FF
LFDDC:
        iny
LFDDD:
        jsr     LF43B
        cmp     #$03
        beq     LFDF7
        cmp     #$20
        bcs     LFDEC
        sbc     #$09
        bne     LFDDD
LFDEC:
        sta     Z00,y
        tax
        bne     LFDDC
        jsr     LE882
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
        lda     #$3F
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
        lda     #$FF
        sta     HIGHDS
        lda     #$3F
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
        jsr     LF422
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
        .addr   LC000
        .addr   LC000
        .addr   LC009
.endif
.ifdef APPLE
        .byte   0,0,0
L2900:
        jsr     LFD6A
        stx     $33
        ldx     #$00
L2907:
        lda     $0200,x
        and     #$7F
        cmp     #$0D
        bne     L2912
        lda     #$00
L2912:
        sta     $0200,x
        inx
        bne     L2907
        ldx     $33
        rts
PLT:
        jmp     L29F0
L291E:
        cmp     #$47
        bne     L2925
        jmp     L29E0
L2925:
        cmp     #$43
        bne     L292B
        beq     L2988
L292B:
        cmp     #$50
        beq     L2930
        inx
L2930:
        stx     $33
L2932:
        jsr     FRMEVL
        jsr     ROUND_FAC
        jsr     AYINT
        lda     FAC+4
        ldx     $33
        sta     $0300,x
        dec     $33
        bmi     L294Dx
        lda     #$2C
		jsr     SYNCHR
        bpl     L2932
L294Dx:
        tay
        pla
        cmp     #$43
        bne     L2957
        tya
        jmp     LF864
L2957:
        cmp     #$50
        bne     L2962
        tya
        ldy     $0301
        jmp     LF800
L2962:
        pha
        lda     $0301
        sta     $2C
        sta     $2D
        pla
        cmp     #$48
        bne     L2978
        lda     $0300
        ldy     $0302
        jmp     LF819
L2978:
        cmp     #$56
        beq     L297F
        jmp     SYNERR
L297F:
        ldy     $0300
        lda     $0302
        jmp     LF828
L2988:
        dex
        beq     L2930
INLINX:
        jsr     OUTQUES
        jsr     OUTSP
        ldx     #$80
        jmp     INLIN1
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .byte   0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0
        .byte   0,0,0,0,0,0,0,0,0,0
L29D0:
        jsr     L29DA
        lda     FAC+3
        sta     FAC+5
        jmp     (FAC+4)
L29DA:
        jmp     (GOSTROUT)
        brk
        brk
        brk
L29E0:
        pla
        jmp     LFB40
        .byte   0,0,0,0,0,0,0,0,0,0,0,0
L29F0:
        pha
        ldx     #$01
        inc     $B9
        bne     L29F9
        inc     $BA
L29F9:
        jmp     L291E
        .byte   $00,$00,$00,$00,$41,$53,$21,$D2
		.byte   $02,$FA,$00 
        lda     $12
        beq     L2A0E
        jmp     (L0008)
L2A0E:
        jsr     LF689
        .byte   $15,$BC,$08,$10,$52,$45,$75,$10
        .byte   $CD,$00,$55,$15,$9E,$08,$10,$4C
        .byte   $45,$75,$10,$D4,$00,$55,$15,$0E
        .byte   $08,$10,$89,$10,$75,$15,$1C,$08
        .byte   $10,$1F,$10,$75,$00 
        jmp     (L0008)
; ----------------------------------------------------------------------------
        .byte   0,0,0,0,0,0
.endif