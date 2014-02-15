; error
; line input, line editing
; tokenize
; detokenize
; BASIC program memory management

; MICROTAN has some nonstandard extension to LIST here

.segment "CODE"

MEMERR:
        ldx     #ERR_MEMFULL

; ----------------------------------------------------------------------------
; HANDLE AN ERROR
;
; (X)=OFFSET IN ERROR MESSAGE TABLE
; (ERRFLG) > 128 IF "ON ERR" TURNED ON
; (CURLIN+1) = $FF IF IN DIRECT MODE
; ----------------------------------------------------------------------------
ERROR:
        lsr     Z14
.ifdef CONFIG_FILE
        lda     CURDVC    ; output
        beq     LC366     ; is screen
        jsr     CLRCH     ; otherwise redirect output back to screen
        lda     #$00
        sta     CURDVC
LC366:
.endif
        jsr     CRDO
        jsr     OUTQUES
L2329:
        lda     ERROR_MESSAGES,x
.ifndef CONFIG_SMALL_ERROR
        pha
        and     #$7F
.endif
        jsr     OUTDO
.ifdef CONFIG_SMALL_ERROR
        lda     ERROR_MESSAGES+1,x
  .ifdef KBD
        and     #$7F
  .endif
        jsr     OUTDO
.else
        inx
        pla
        bpl     L2329
.endif
        jsr     STKINI
        lda     #<QT_ERROR
        ldy     #>QT_ERROR

; ----------------------------------------------------------------------------
; PRINT STRING AT (Y,A)
; PRINT CURRENT LINE # UNLESS IN DIRECT MODE
; FALL INTO WARM RESTART
; ----------------------------------------------------------------------------
PRINT_ERROR_LINNUM:
        jsr     STROUT
        ldy     CURLIN+1
        iny
        beq     RESTART
        jsr     INPRT

; ----------------------------------------------------------------------------
; WARM RESTART ENTRY
; ----------------------------------------------------------------------------
RESTART:
.ifdef KBD
        jsr     CRDO
        nop
L2351X:
        jsr     OKPRT
L2351:
        jsr     INLIN
LE28E:
        bpl     RESTART
.else
        lsr     Z14
 .ifndef AIM65
        lda     #<QT_OK
        ldy     #>QT_OK
  .ifdef CONFIG_CBM_ALL
        jsr     STROUT
  .else
        jsr     GOSTROUT
  .endif
 .else
        jsr     GORESTART
 .endif
L2351:
        jsr     INLIN
.endif
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
.ifdef CONFIG_11
; bug in pre-1.1: CHRGET sets Z on '\0'
; and ':' - a line starting with ':' in
; direct mode gets ignored
        tax
.endif
.ifdef KBD
        beq     L2351X
.else
        beq     L2351
.endif
        ldx     #$FF
        stx     CURLIN+1
        bcc     NUMBERED_LINE
        jsr     PARSE_INPUT_LINE
        jmp     NEWSTT2

; ----------------------------------------------------------------------------
; HANDLE NUMBERED LINE
; ----------------------------------------------------------------------------
NUMBERED_LINE:
        jsr     LINGET
        jsr     PARSE_INPUT_LINE
        sty     EOLPNTR
.ifdef KBD
        jsr     FNDLIN2
        lda     JMPADRS+1
        sta     LOWTR
        sta     Z96
        lda     JMPADRS+2
        sta     LOWTR+1
        sta     Z96+1
        lda     LINNUM
        sta     L06FE
        lda     LINNUM+1
        sta     L06FE+1
        inc     LINNUM
        bne     LE2D2
        inc     LINNUM+1
        bne     LE2D2
        jmp     SYNERR
LE2D2:
        jsr     LF457
        ldx     #Z96
        jsr     CMPJMPADRS
        bcs     LE2FD
LE2DC:
        ldx     #$00
        lda     (JMPADRS+1,x)
        sta     (Z96,x)
        inc     JMPADRS+1
        bne     LE2E8
        inc     JMPADRS+2
LE2E8:
        inc     Z96
        bne     LE2EE
        inc     Z96+1
LE2EE:
        ldx     #VARTAB
        jsr     CMPJMPADRS
        bne     LE2DC
        lda     Z96
        sta     VARTAB
        lda     Z96+1
        sta     VARTAB+1
LE2FD:
        jsr     SETPTRS
        jsr     LE33D
        lda     INPUTBUFFER
LE306:
        beq     LE28E
        cmp     #$A5
        beq     LE306
        clc
.else
        jsr     FNDLIN
        bcc     PUT_NEW_LINE
        ldy     #$01
        lda     (LOWTR),y
        sta     INDEX+1
        lda     VARTAB
        sta     INDEX
        lda     LOWTR+1
        sta     DEST+1
        lda     LOWTR
        dey
        sbc     (LOWTR),y
        clc
        adc     VARTAB
        sta     VARTAB
        sta     DEST
        lda     VARTAB+1
        adc     #$FF
        sta     VARTAB+1
        sbc     LOWTR+1
        tax
        sec
        lda     LOWTR
        sbc     VARTAB
        tay
        bcs     L23A5
        inx
        dec     DEST+1
L23A5:
        clc
        adc     INDEX
        bcc     L23AD
        dec     INDEX+1
        clc
L23AD:
        lda     (INDEX),y
        sta     (DEST),y
        iny
        bne     L23AD
        inc     INDEX+1
        inc     DEST+1
        dex
        bne     L23AD
.endif
; ----------------------------------------------------------------------------
PUT_NEW_LINE:
.ifndef KBD
  .ifdef CONFIG_2
        jsr     SETPTRS
        jsr     LE33D
        lda     INPUTBUFFER
        beq     L2351
        clc
  .else
        lda     INPUTBUFFER
        beq     FIX_LINKS
        lda     MEMSIZ
        ldy     MEMSIZ+1
        sta     FRETOP
        sty     FRETOP+1
  .endif
.endif
        lda     VARTAB
        sta     HIGHTR
        adc     EOLPNTR
        sta     HIGHDS
        ldy     VARTAB+1
        sty     HIGHTR+1
        bcc     L23D6
        iny
L23D6:
        sty     HIGHDS+1
        jsr     BLTU
.ifdef CONFIG_INPUTBUFFER_0200
        lda     LINNUM
        ldy     LINNUM+1
        sta     INPUTBUFFER-2
        sty     INPUTBUFFER-1
.endif
        lda     STREND
        ldy     STREND+1
        sta     VARTAB
        sty     VARTAB+1
        ldy     EOLPNTR
        dey
; ---COPY LINE INTO PROGRAM-------
L23E6:
        lda     INPUTBUFFER-4,y
        sta     (LOWTR),y
        dey
        bpl     L23E6

; ----------------------------------------------------------------------------
; CLEAR ALL VARIABLES
; RE-ESTABLISH ALL FORWARD LINKS
; ----------------------------------------------------------------------------
FIX_LINKS:
        jsr     SETPTRS
.ifdef CONFIG_2
        jsr     LE33D
        jmp     L2351
LE33D:
.endif
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     INDEX
        sty     INDEX+1
        clc
L23FA:
        ldy     #$01
        lda     (INDEX),y
.ifdef CONFIG_2
        beq     RET3
.else
        jeq     L2351
.endif
        ldy     #$04
L2405:
        iny
        lda     (INDEX),y
        bne     L2405
        iny
        tya
        adc     INDEX
        tax
        ldy     #$00
        sta     (INDEX),y
        lda     INDEX+1
        adc     #$00
        iny
        sta     (INDEX),y
        stx     INDEX
        sta     INDEX+1
        bcc     L23FA	; always

; ----------------------------------------------------------------------------
.ifdef KBD
.include "kbd_loadsave.s"
.endif

.ifdef CONFIG_2
; !!! kbd_loadsave.s requires an RTS here!
RET3:
		rts
.endif

.include "inline.s"

; ----------------------------------------------------------------------------
; TOKENIZE THE INPUT LINE
; ----------------------------------------------------------------------------
PARSE_INPUT_LINE:
        ldx     TXTPTR
        ldy     #$04
        sty     DATAFLG
L246C:
        lda     INPUTBUFFERX,x
.ifdef CONFIG_CBM_ALL
        bpl     LC49E
        cmp     #$FF
        beq     L24AC
        inx
        bne     L246C
LC49E:
.endif
        cmp     #$20
        beq     L24AC
        sta     ENDCHR
        cmp     #$22
        beq     L24D0
        bit     DATAFLG
        bvs     L24AC
        cmp     #$3F
        bne     L2484
        lda     #TOKEN_PRINT
        bne     L24AC
L2484:
        cmp     #$30
        bcc     L248C
        cmp     #$3C
        bcc     L24AC
; ----------------------------------------------------------------------------
; SEARCH TOKEN NAME TABLE FOR MATCH STARTING
; WITH CURRENT CHAR FROM INPUT LINE
; ----------------------------------------------------------------------------
L248C:
        sty     STRNG2
        ldy     #$00
        sty     EOLPNTR
        dey
        stx     TXTPTR
        dex
L2496:
        iny
L2497:
        inx
L2498:
.ifdef KBD
        jsr     GET_UPPER
.else
        lda     INPUTBUFFERX,x
  .ifndef CONFIG_2
        cmp     #$20
        beq     L2497
  .endif
.endif
        sec
        sbc     TOKEN_NAME_TABLE,y
        beq     L2496
        cmp     #$80
        bne     L24D7
        ora     EOLPNTR
; ----------------------------------------------------------------------------
; STORE CHARACTER OR TOKEN IN OUTPUT LINE
; ----------------------------------------------------------------------------
L24AA:
        ldy     STRNG2
L24AC:
        inx
        iny
        sta     INPUTBUFFER-5,y
        lda     INPUTBUFFER-5,y
        beq     L24EA
        sec
        sbc     #$3A
        beq     L24BF
        cmp     #$49
        bne     L24C1
L24BF:
        sta     DATAFLG
L24C1:
        sec
        sbc     #TOKEN_REM-':'
        bne     L246C
        sta     ENDCHR
; ----------------------------------------------------------------------------
; HANDLE LITERAL (BETWEEN QUOTES) OR REMARK,
; BY COPYING CHARS UP TO ENDCHR.
; ----------------------------------------------------------------------------
L24C8:
        lda     INPUTBUFFERX,x
        beq     L24AC
        cmp     ENDCHR
        beq     L24AC
L24D0:
        iny
        sta     INPUTBUFFER-5,y
        inx
        bne     L24C8
; ----------------------------------------------------------------------------
; ADVANCE POINTER TO NEXT TOKEN NAME
; ----------------------------------------------------------------------------
L24D7:
        ldx     TXTPTR
        inc     EOLPNTR
L24DB:
        iny
        lda     MATHTBL+28+1,y
        bpl     L24DB
        lda     TOKEN_NAME_TABLE,y
        bne     L2498
        lda     INPUTBUFFERX,x
        bpl     L24AA
; ---END OF LINE------------------
L24EA:
        sta     INPUTBUFFER-3,y
.ifdef CONFIG_NO_INPUTBUFFER_ZP
        dec     TXTPTR+1
.endif
        lda     #<INPUTBUFFER-1
        sta     TXTPTR
        rts

; ----------------------------------------------------------------------------
; SEARCH FOR LINE
;
; (LINNUM) = LINE # TO FIND
; IF NOT FOUND:  CARRY = 0
;	LOWTR POINTS AT NEXT LINE
; IF FOUND:      CARRY = 1
;	LOWTR POINTS AT LINE
; ----------------------------------------------------------------------------
FNDLIN:
.ifdef KBD
        jsr     CHRGET
        jmp     LE444
LE440:
        php
        jsr     LINGET
LE444:
        jsr     LF457
        ldx     #$FF
        plp
        beq     LE464
        jsr     CHRGOT
        beq     L2520
        cmp     #$A5
        bne     L2520
        jsr     CHRGET
        beq     LE464
        bcs     LE461
        jsr     LINGET
        beq     L2520
LE461:
        jmp     SYNERR
LE464:
        stx     LINNUM
        stx     LINNUM+1
.else
        lda     TXTTAB
        ldx     TXTTAB+1
FL1:
        ldy     #$01
        sta     LOWTR
        stx     LOWTR+1
        lda     (LOWTR),y
        beq     L251F
        iny
        iny
        lda     LINNUM+1
        cmp     (LOWTR),y
        bcc     L2520
        beq     L250D
        dey
        bne     L2516
L250D:
        lda     LINNUM
        dey
        cmp     (LOWTR),y
        bcc     L2520
        beq     L2520
L2516:
        dey
        lda     (LOWTR),y
        tax
        dey
        lda     (LOWTR),y
        bcs     FL1
L251F:
        clc
.endif
L2520:
        rts

; ----------------------------------------------------------------------------
; "NEW" STATEMENT
; ----------------------------------------------------------------------------
NEW:
        bne     L2520
SCRTCH:
        lda     #$00
        tay
        sta     (TXTTAB),y
        iny
        sta     (TXTTAB),y
        lda     TXTTAB
.ifdef CONFIG_2
		clc
.endif
        adc     #$02
        sta     VARTAB
        lda     TXTTAB+1
        adc     #$00
        sta     VARTAB+1
; ----------------------------------------------------------------------------
SETPTRS:
        jsr     STXTPT
.ifdef CONFIG_11A
        lda     #$00

; ----------------------------------------------------------------------------
; "CLEAR" STATEMENT
; ----------------------------------------------------------------------------
CLEAR:
        bne     L256A
.endif
CLEARC:
.ifdef KBD
        lda     #<CONST_MEMSIZ
        ldy     #>CONST_MEMSIZ
.else
        lda     MEMSIZ
        ldy     MEMSIZ+1
.endif
        sta     FRETOP
        sty     FRETOP+1
.ifdef CONFIG_CBM_ALL
        jsr     CLALL
.endif
        lda     VARTAB
        ldy     VARTAB+1
        sta     ARYTAB
        sty     ARYTAB+1
        sta     STREND
        sty     STREND+1
        jsr     RESTORE
; ----------------------------------------------------------------------------
STKINI:
        ldx     #TEMPST
        stx     TEMPPT
        pla
.ifdef CONFIG_2
		tay
.else
        sta     STACK+STACK_TOP+1
.endif
        pla
.ifndef CONFIG_2
        sta     STACK+STACK_TOP+2
.endif
        ldx     #STACK_TOP
        txs
.ifdef CONFIG_2
        pha
        tya
        pha
.endif
        lda     #$00
        sta     OLDTEXT+1
        sta     SUBFLG
L256A:
        rts

; ----------------------------------------------------------------------------
; SET TXTPTR TO BEGINNING OF PROGRAM
; ----------------------------------------------------------------------------
STXTPT:
        clc
        lda     TXTTAB
        adc     #$FF
        sta     TXTPTR
        lda     TXTTAB+1
        adc     #$FF
        sta     TXTPTR+1
        rts

; ----------------------------------------------------------------------------
.ifdef KBD
LE4C0:
        ldy     #<LE444
        ldx     #>LE444
LE4C4:
        jsr     LFFD6
        jsr     LFFED
        lda     $0504
        clc
        adc     #$08
        sta     $0504
        rts

CMPJMPADRS:
        lda     1,x
        cmp     JMPADRS+2
        bne     LE4DE
        lda     0,x
        cmp     JMPADRS+1
LE4DE:
        rts
.endif

; ----------------------------------------------------------------------------
; "LIST" STATEMENT
; ----------------------------------------------------------------------------
LIST:
.ifdef KBD
        jsr     LE440
        bne     LE4DE
        pla
        pla
L25A6:
        jsr     CRDO
.else
    .ifdef AIM65
        pha
        lda     #$00
LB4BF:
        sta     INPUTFLG
        pla
    .endif
  .ifdef MICROTAN
        php
        jmp     LE21C ; patch
LC57E:
   .elseif .def(AIM65) || .def(SYM1)
        php
        jsr     LINGET
LC57E:
  .else
        bcc     L2581
        beq     L2581
        cmp     #TOKEN_MINUS
        bne     L256A
L2581:
        jsr     LINGET
  .endif
        jsr     FNDLIN
  .if .def(MICROTAN) || .def(AIM65) || .def(SYM1)
        plp
        beq     L2598
  .endif
        jsr     CHRGOT
  .if .def(MICROTAN) || .def(AIM65) || .def(SYM1)
        beq     L25A6
  .else
        beq     L2598
  .endif
        cmp     #TOKEN_MINUS
        bne     L2520
        jsr     CHRGET
  .if .def(MICROTAN) || .def(AIM65) || .def(SYM1)
        beq     L2598
        jsr     LINGET
        beq     L25A6
        rts
  .else
        jsr     LINGET
        bne     L2520
  .endif
L2598:
  .if !(.def(MICROTAN) || .def(AIM65) || .def(SYM1))
        pla
        pla
        lda     LINNUM
        ora     LINNUM+1
        bne     L25A6
  .endif
        lda     #$FF
        sta     LINNUM
        sta     LINNUM+1
L25A6:
  .if .def(MICROTAN) || .def(AIM65) || .def(SYM1)
        pla
        pla
  .endif
L25A6X:
.endif
        ldy     #$01
.ifdef CONFIG_DATAFLG
        sty     DATAFLG
.endif
        lda     (LOWTRX),y
        beq     L25E5
.ifdef MICROTAN
        jmp     LE21F
LC5A9:
.else
        jsr     ISCNTC
.endif
.ifndef KBD
        jsr     CRDO
.endif
        iny
        lda     (LOWTRX),y
        tax
        iny
        lda     (LOWTRX),y
        cmp     LINNUM+1
        bne     L25C1
        cpx     LINNUM
        beq     L25C3
L25C1:
        bcs     L25E5
; ---LIST ONE LINE----------------
L25C3:
        sty     FORPNT
        jsr     LINPRT
        lda     #$20
L25CA:
        ldy     FORPNT
        and     #$7F
L25CE:
        jsr     OUTDO
.ifdef CONFIG_DATAFLG
        cmp     #$22
        bne     LA519
        lda     DATAFLG
        eor     #$FF
        sta     DATAFLG
LA519:
.endif
        iny
.ifdef CONFIG_11
        beq     L25E5
.endif
        lda     (LOWTRX),y
        bne     L25E8
        tay
        lda     (LOWTRX),y
        tax
        iny
        lda     (LOWTRX),y
        stx     LOWTRX
        sta     LOWTRX+1
.if .def(MICROTAN) || .def(AIM65) || .def(SYM1)
        bne     L25A6X
.else
        bne     L25A6
.endif
L25E5:
.ifdef AIM65
        lda     INPUTFLG
        beq     L25E5a
        jsr     CRDO
        jsr     CRDO
        lda     #$1a
        jsr     OUTDO
        jsr     $e50a
L25E5a:
.endif
        jmp     RESTART
L25E8:
        bpl     L25CE
.ifdef CONFIG_DATAFLG
        cmp     #$FF
        beq     L25CE
        bit     DATAFLG
        bmi     L25CE
.endif
        sec
        sbc     #$7F
        tax
        sty     FORPNT
        ldy     #$FF
L25F2:
        dex
        beq     L25FD
L25F5:
        iny
        lda     TOKEN_NAME_TABLE,y
        bpl     L25F5
        bmi     L25F2
L25FD:
        iny
        lda     TOKEN_NAME_TABLE,y
        bmi     L25CA
        jsr     OUTDO
        bne     L25FD	; always

