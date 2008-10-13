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
        sta     USR+1
        sty     USR+2
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
.if .defined(CONFIG_NULL) || .defined(CONFIG_PRINTNULLS)
        sta     Z15
.endif
.ifndef CONFIG_11
        sta     POSX
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

.segment "EXTRA"

.ifdef OSI
.include "osi_extra.s"
.endif

.ifdef KIM
.include "kim_extra.s"
.endif

.ifdef CONFIG_CBM1_PATCHES
.include "cbm1_patches.s"
.endif


.ifdef KBD
.include "kbd_extra.s"
.endif

.ifdef APPLE
.include "apple_extra.s"
.endif