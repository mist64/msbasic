.segment "INIT"

.ifdef KBD
FNDLIN2:
        php
        jmp     FNDLIN
.endif

; ----------------------------------------------------------------------------
PR_WRITTEN_BY:
.ifndef KBD
  .ifndef CONFIG_CBM_ALL
    .ifndef AIM65
      .ifndef SYM1
        lda     #<QT_WRITTEN_BY
        ldy     #>QT_WRITTEN_BY
        jsr     STROUT
      .endif
    .endif
  .endif
.endif
COLD_START:
.ifdef SYM1
        jsr     ACCESS
.endif
.ifdef KBD
        lda     #<LFD81
        sta     $03A0
        lda     #>LFD81
        sta     $03A1
        lda     #$20
        sta     $0480
        lda     $0352
        sta     $04
        lda     $0353
        sta     $05
.else
  .ifndef CBM2
        ldx     #$FF
        stx     CURLIN+1
  .endif
  .ifdef CONFIG_NO_INPUTBUFFER_ZP
        ldx     #$FB
  .elseif .def(AIM65)
        ldx     #$FE
  .endif
        txs
  .ifndef CONFIG_CBM_ALL
        lda     #<COLD_START
        ldy     #>COLD_START
        sta     GORESTART+1
        sty     GORESTART+2
    .ifndef AIM65
        sta     GOSTROUT+1
        sty     GOSTROUT+2
        lda     #<AYINT
        ldy     #>AYINT
        sta     GOAYINT
        sty     GOAYINT+1
        lda     #<GIVAYF
        ldy     #>GIVAYF
        sta     GOGIVEAYF
        sty     GOGIVEAYF+1
    .endif
  .endif
        lda     #$4C
  .ifdef CONFIG_CBM_ALL
        sta     JMPADRS
  .endif
        sta     GORESTART
  .ifdef AIM65
        sta     JMPADRS
        sta     ATN
        sta     GOSTROUT
  .else
  .ifndef CONFIG_CBM_ALL
        sta     GOSTROUT
        sta     JMPADRS
  .endif
  .ifdef SYM1
        sta     USR1
        sta     USR3
        sta     USR2
  .endif
  .if (!.def(CONFIG_RAM)) && (!.def(CONFIG_CBM_ALL))
        sta     USR
  .endif
  .endif

  .ifndef CONFIG_RAM
    .ifdef APPLE
          lda     #<USR_FUNC
          ldy     #>USR_FUNC
    .else
          lda     #<IQERR
          ldy     #>IQERR
    .endif
    .ifdef AIM65
          sta     ATN+1
          sty     ATN+2
          sta     GOSTROUT+1
          sty     GOSTROUT+2
    .else
          sta     USR+1
          sty     USR+2
      .ifdef SYM1
          sta     USR1+1
          sty     USR1+2
          lda     #<DUMPT
          ldy     #>DUMPT
          sta     USR2+1
          sty     USR2+2
          lda     #<L8C78
          ldy     #>L8C78
          sta     USR3+1
          sty     USR3+2
      .endif
    .endif
  .endif
  .ifndef CBM1
        lda     #WIDTH
        sta     Z17
        lda     #WIDTH2
        sta     Z18
  .endif
.endif

; All non-CONFIG_SMALL versions of BASIC have
; the same bug here: While the number of bytes
; to be copied is correct for CONFIG_SMALL,
; it is one byte short on non-CONFIG_SMALL:
; It seems the "ldx" value below has been
; hardcoded. So on these configurations,
; the last byte of GENERIC_RNDSEED, which
; is 5 bytes instead of 4, does not get copied -
; which is nothing major, because it is just
; the least significant 8 bits of the mantissa
; of the random number seed.
; KBD added three bytes to CHRGET and removed
; the random number seed, but only adjusted
; the number of bytes by adding 3 - this
; copies four bytes too many, which is no
; problem.
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
        sta     CHRGET-1,x
        dex
        bne     L4098
.ifdef CONFIG_2
        lda     #$03
        sta     DSCLEN
.endif
.ifndef KBD
        txa
        sta     SHIFTSIGNEXT
  .ifdef CONFIG_CBM_ALL
        sta     CURDVC
  .endif
        sta     LASTPT+1
  .ifndef AIM65
  .if .defined(CONFIG_NULL) || .defined(CONFIG_PRINTNULLS)
        sta     Z15
  .endif
  .endif
  .ifndef CONFIG_11
        sta     POSX
  .endif
        pha
        sta     Z14
  .ifndef CBM2
   .ifndef AIM65
   .ifndef SYM1
    .ifndef MICROTAN
        lda     #$03
        sta     DSCLEN
    .endif
   .endif
   .endif
    .ifndef CONFIG_11
        lda     #$2C
        sta     LINNUM+1
    .endif
        jsr     CRDO
  .endif
  .ifdef CBM2
        inx
        stx     INPUTBUFFER-3
        stx     INPUTBUFFER-4
  .endif
  .ifdef APPLE
        lda     #$01
        sta     INPUTBUFFER-3
        sta     INPUTBUFFER-4
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
  .ifndef AIM65
    .ifndef SYM1
        cmp     #$41
        beq     PR_WRITTEN_BY
    .endif
  .endif
        tay
        bne     L40EE
.endif
.ifndef CBM2
        lda     #<RAMSTART2
.endif
        ldy     #>RAMSTART2
.ifdef CONFIG_2
        sta     TXTTAB
        sty     TXTTAB+1
.endif
        sta     LINNUM
        sty     LINNUM+1
.ifdef CBM2
		tay
.else
        ldy     #$00
.endif
L40D7:
        inc     LINNUM
        bne     L40DD
        inc     LINNUM+1
.ifdef CBM1
; CBM: hard RAM top limit is $8000
        lda     LINNUM+1
        cmp     #$80
        beq     L40FA
.endif
.ifdef CBM2
; optimized version of the CBM1 code
        bmi     L40FA
.endif
.if .def(AIM65)
; AIM65: hard RAM top limit is $A000
        lda     LINNUM+1
        cmp     #$A0
        beq     L40FA
.endif
L40DD:
.ifdef CONFIG_2
        lda     #$55 ; 01010101 / 10101010
.else
        lda     #$92 ; 10010010 / 00100100
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
  .ifndef CONFIG_11
        beq     L40D7; old: faster
        bne     L40FA
  .else
        bne     L40FA; new: slower
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
.if !(.def(MICROTAN) || .def(AIM65) || .def(SYM1))
        sta     FRETOP
        sty     FRETOP+1
.endif
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
  .ifdef AIM65
        sbc     #$0A
  .else
        sbc     #$0E
  .endif
        bcs     L4129
        eor     #$FF
  .ifdef AIM65
        sbc     #$08
  .else
        sbc     #$0C
  .endif
        clc
        adc     Z17
        sta     Z18
.endif
L4136:
.ifdef CONFIG_RAM
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
        stx     UNFNC_ATN
        sty     UNFNC_ATN+1
        ldx     #<ATN	; overwrite starting
        ldy     #>ATN	; with ATN
        cmp     #'A'
        beq     L4183
        ldx     #<IQERR
        ldy     #>IQERR
        stx     UNFNC_COS
        sty     UNFNC_COS+1
        stx     UNFNC_TAN
        sty     UNFNC_TAN+1
        stx     UNFNC_SIN
        sty     UNFNC_SIN+1
        ldx     #<SIN_COS_TAN_ATN	; overwrite
        ldy     #>SIN_COS_TAN_ATN	; all of trig.s
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
.ifndef CBM2
        bne     L4192
        inc     TXTTAB+1
L4192:
.endif
.if CONFIG_SCRTCH_ORDER = 1
        jsr     SCRTCH
.endif
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     REASON
.ifdef CBM2
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
.if CONFIG_SCRTCH_ORDER = 2
        jsr     SCRTCH
.endif
.ifdef CONFIG_CBM_ALL
        jmp     RESTART
.elseif .def(AIM65)
        lda     #<CRDO
        ldy     #>CRDO
        sta     GORESTART+1
        sty     GORESTART+2
        jmp     RESTART
.else
        lda     #<STROUT
        ldy     #>STROUT
        sta     GOSTROUT+1
        sty     GOSTROUT+2
  .if CONFIG_SCRTCH_ORDER = 3
         jsr     SCRTCH
  .endif
        lda     #<RESTART
        ldy     #>RESTART
        sta     GORESTART+1
        sty     GORESTART+2
        jmp     (GORESTART+1)
.endif

  .if .def(CONFIG_RAM) || .def(OSI)
; OSI is compiled for ROM, but includes
; this unused string
QT_WANT:
        .byte   "WANT SIN-COS-TAN-ATN"
        .byte   0
  .endif
QT_WRITTEN_BY:
  .ifndef CONFIG_CBM_ALL
  .if !(.def(AIM65) || .def(SYM1))
    .ifdef APPLE
		asc80 "COPYRIGHT 1977 BY MICROSOFT CO"
		.byte	CR,0
    .else
        .byte   CR,LF,$0C ; FORM FEED
      .ifndef CONFIG_11
        .byte   "WRITTEN BY RICHARD W. WEILAND."
      .else
        .byte   "WRITTEN BY WEILAND & GATES"
      .endif
        .byte   CR,LF,0
    .endif
   .endif
QT_MEMORY_SIZE:
        .byte   "MEMORY SIZE"
        .byte   0
QT_TERMINAL_WIDTH:
    .if !(.def(AIM65) || .def(SYM1))
        .byte   "TERMINAL "
    .endif
        .byte   "WIDTH"
        .byte   0
  .endif
QT_BYTES_FREE:
        .byte   " BYTES FREE"
  .ifdef CBM1
  .elseif .def(CBM2)
        .byte   CR,0
  .elseif .def(APPLE)
        .byte   0
  .else
        .byte   CR,LF,CR,LF
  .endif
QT_BASIC:
  .ifdef OSI
        .byte   "OSI 6502 BASIC VERSION 1.0 REV 3.2"
  .endif
  .ifdef KIM
        .byte   "MOS TECH 6502 BASIC V1.1"
  .endif
  .ifdef MICROTAN
        .byte   "MICROTAN BASIC"
  .endif
  .ifdef AIM65
        .byte   "  AIM 65 BASIC V1.1"
  .endif
  .ifdef SYM1
        .byte   "BASIC V1.1"
  .endif
  .ifdef CBM1
        .byte   $13 ; HOME
        .byte   "*** COMMODORE BASIC ***"
        .byte   $11,$11,$11,0 ; DOWN/DOWN/DOWN
  .endif
  .ifdef CBM2
        .byte   "### COMMODORE BASIC ###"
        .byte   CR,CR,0
  .endif
  .ifdef APPLE
        .byte   LF,CR,LF
		.byte	"APPLE BASIC V1.1"
  .endif
  .ifndef CONFIG_CBM_ALL
        .byte   CR,LF
    .ifdef MICROTAN
        .byte   "(C) 1980 MICROSOFT"
    .elseif .def(AIM65)
        .byte   0
        .byte   "(C) 1978 MICROSOFT"
    .elseif .def(SYM1)
        .byte   "COPYRIGHT 1978 SYNERTEK SYSTEMS CORP."
    .else
        .byte   "COPYRIGHT 1977 BY MICROSOFT CO."
    .endif
        .byte   CR,LF
      .ifndef AIM65
        .byte   0
      .endif
  .endif
.endif
