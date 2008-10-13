; Microsoft BASIC for 6502

.debuginfo +

.if .def(cbmbasic1)
CBM1 := 1
.include "defines_cbm.s"
.elseif .def(osi)
OSI := 1
.include "defines_osi.s"
.elseif .def(applesoft)
APPLE := 1
.include "defines_apple.s"
.elseif .def(kb9)
KIM := 1
.include "defines_kim.s"
.elseif .def(cbmbasic2)
CBM2 := 1
.include "defines_cbm.s"
.elseif .def(kbdbasic)
KBD := 1
.include "defines_kbd.s"
.endif

.ifdef CONFIG_SMALL
BYTES_FP		:= 4
.else
BYTES_FP		:= 5
.endif

.ifdef APPLE
BYTES_PER_ELEMENT := 6 ; ???
.else
BYTES_PER_ELEMENT := BYTES_FP
.endif
BYTES_PER_VARIABLE := BYTES_FP+2
MANTISSA_BYTES	:= BYTES_FP-1
BYTES_PER_FRAME := 2*BYTES_FP+8
FOR_STACK1		:= 2*BYTES_FP+5
FOR_STACK2		:= BYTES_FP+4

.ifdef CBM1
MAX_EXPON = 12
.else
MAX_EXPON = 10
.endif


.include "macros.s"
.include "zeropage.s"

        .setcpu "6502"
		.macpack longbranch

STACK           := $0100

		.segment "HEADER"
.ifdef KBD
        jmp     LE68C
        .byte   $00,$13,$56
.endif

.include "token.s"

.include "error.s"

.segment "CODE"

QT_ERROR:
.ifdef KBD
        .byte   " err"
.else
.ifdef APPLE
        .byte   " ERR"
		.byte	$07,$07
.else
        .byte   " ERROR"
.endif
.endif
        .byte   $00
.ifndef KBD
QT_IN:
        .byte   " IN "
        .byte   $00
QT_OK:
.ifdef APPLE
        .byte   $0D,$00,$00
        .byte   "K"
.else
		.byte   $0D,$0A
.ifdef CONFIG_CBM_ALL
        .byte   "READY."
.else
        .byte   "OK"
.endif
.endif
        .byte   $0D,$0A,$00
.else
		.byte	$54,$D2 ; ???
OKPRT:
		jsr     LDE42
        .byte   $0D,$0D
        .byte   ">>"
        .byte   $0D,$0A,$00
        rts
        nop
.endif
QT_BREAK:
.ifdef KBD
		.byte	$0D,$0A
        .byte   " Brk"
        .byte   $00
        .byte   $54,$D0 ; ???
.else
		.byte $0D,$0A
        .byte   "BREAK"
        .byte   $00
.endif










; ----------------------------------------------------------------------------
; CALLED BY "NEXT" AND "FOR" TO SCAN THROUGH
; THE STACK FOR A FRAME WITH THE SAME VARIABLE.
;
; (FORPNT) = ADDRESS OF VARIABLE IF "FOR" OR "NEXT"
; 	= $XXFF IF CALLED FROM "RETURN"
; 	<<< BUG: SHOULD BE $FFXX >>>
;
;	RETURNS .NE. IF VARIABLE NOT FOUND,
;	(X) = STACK PNTR AFTER SKIPPING ALL FRAMES
;
;	.EQ. IF FOUND
;	(X) = STACK PNTR OF FRAME FOUND
; ----------------------------------------------------------------------------
GTFORPNT:
        tsx
        inx
        inx
        inx
        inx
L2279:
        lda     STACK+1,x
        cmp     #$81
        bne     L22A1
        lda     FORPNT+1
        bne     L228E
        lda     STACK+2,x
        sta     FORPNT
        lda     STACK+3,x
        sta     FORPNT+1
L228E:
        cmp     STACK+3,x
        bne     L229A
        lda     FORPNT
        cmp     STACK+2,x
        beq     L22A1
L229A:
        txa
        clc
        adc     #BYTES_PER_FRAME
        tax
        bne     L2279
L22A1:
        rts

; ----------------------------------------------------------------------------
; MOVE BLOCK OF MEMORY UP
;
; ON ENTRY:
;	(Y,A) = (HIGHDS) = DESTINATION END+1
;	(LOWTR) = LOWEST ADDRESS OF SOURCE
;	(HIGHTR) = HIGHEST SOURCE ADDRESS+1
; ----------------------------------------------------------------------------
BLTU:
        jsr     REASON
        sta     STREND
        sty     STREND+1
BLTU2:
        sec
        lda     HIGHTR
        sbc     LOWTR
        sta     INDEX
        tay
        lda     HIGHTR+1
        sbc     LOWTR+1
        tax
        inx
        tya
        beq     L22DD
        lda     HIGHTR
        sec
        sbc     INDEX
        sta     HIGHTR
        bcs     L22C6
        dec     HIGHTR+1
        sec
L22C6:
        lda     HIGHDS
        sbc     INDEX
        sta     HIGHDS
        bcs     L22D6
        dec     HIGHDS+1
        bcc     L22D6
L22D2:
        lda     (HIGHTR),y
        sta     (HIGHDS),y
L22D6:
        dey
        bne     L22D2
        lda     (HIGHTR),y
        sta     (HIGHDS),y
L22DD:
        dec     HIGHTR+1
        dec     HIGHDS+1
        dex
        bne     L22D6
        rts

; ----------------------------------------------------------------------------
; CHECK IF ENOUGH ROOM LEFT ON STACK
; FOR "FOR", "GOSUB", OR EXPRESSION EVALUATION
; ----------------------------------------------------------------------------
CHKMEM:
        asl     a
        adc     #SPACE_FOR_GOSUB
        bcs     MEMERR
        sta     INDEX
        tsx
        cpx     INDEX
        bcc     MEMERR
        rts

; ----------------------------------------------------------------------------
; CHECK IF ENOUGH ROOM BETWEEN ARRAYS AND STRINGS
; (Y,A) = ADDR ARRAYS NEED TO GROW TO
; ----------------------------------------------------------------------------
REASON:
        cpy     FRETOP+1
        bcc     L231E
        bne     L22FC
        cmp     FRETOP
        bcc     L231E
L22FC:
        pha
        ldx     #FAC-TEMP1-1
        tya
L2300:
        pha
        lda     TEMP1,x
        dex
        bpl     L2300
        jsr     GARBAG
        ldx     #TEMP1-FAC+1
L230B:
        pla
        sta     FAC,x
        inx
        bmi     L230B
        pla
        tay
        pla
        cpy     FRETOP+1
        bcc     L231E
        bne     MEMERR
        cmp     FRETOP
        bcs     MEMERR
L231E:
        rts

; ----------------------------------------------------------------------------
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
.ifdef CONFIG_CBM_ALL
        lda     Z03       ; output
        beq     LC366     ; is screen
        jsr     CLRCH     ; otherwise redirect output back to screen
        lda     #$00
        sta     Z03
LC366:
.endif
        jsr     CRDO
        jsr     OUTQUES
L2329:
        lda     ERROR_MESSAGES,x
.ifndef CONFIG_SMALL
        pha
        and     #$7F
.endif
        jsr     OUTDO
.ifdef CONFIG_SMALL
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
;
; COME HERE FROM MONITOR BY CTL-C, 0G, 3D0G, OR E003G
; ----------------------------------------------------------------------------
RESTART:
.ifdef KBD
        jsr     CRDO
        nop
L2351X:
        jsr     OKPRT
L2351:
        jsr     LFDDA
LE28E:
        bpl     RESTART
.else
        lsr     Z14
        lda     #<QT_OK
        ldy     #>QT_OK
.ifdef CONFIG_CBM_ALL
        jsr     STROUT
.else
        jsr     GOWARM
.endif
L2351:
        jsr     INLIN
.endif
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
.ifdef CONFIG_11
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
        jsr     LFD3E
        lda     JMPADRS+1
        sta     LOWTR
        sta     $96
        lda     JMPADRS+2
        sta     LOWTR+1
        sta     $97
        lda     $13
        sta     $06FE
        lda     $14
        sta     $06FF
        inc     $13
        bne     LE2D2
        inc     $14
        bne     LE2D2
        jmp     SYNERR
LE2D2:
        jsr     LF457
        ldx     #$96
        jsr     LE4D4
        bcs     LE2FD
LE2DC:
        ldx     #$00
        lda     (JMPADRS+1,x)
        sta     ($96,x)
        inc     JMPADRS+1
        bne     LE2E8
        inc     JMPADRS+2
LE2E8:
        inc     $96
        bne     LE2EE
        inc     $97
LE2EE:
        ldx     #$2B
        jsr     LE4D4
        bne     LE2DC
        lda     $96
        sta     VARTAB
        lda     $97
        sta     VARTAB+1
LE2FD:
        jsr     SETPTRS
        jsr     LE33D
        lda     Z00
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
.ifdef CBM2
        jsr     SETPTRS
        jsr     LE33D
        lda     INPUTBUFFER
        beq     L2351
        clc
.else
.ifndef KBD
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
.ifdef CBM2_APPLE
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
.ifdef CBM2_KBD
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
.ifdef CBM2_KBD
        beq     RET3
.else
        bne     L2403
        jmp     L2351
.endif
L2403:
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
        bcc     L23FA
.ifdef KBD
SLOD:
        ldx     #$01
        .byte   $2C
PLOD:
        ldx     #$00
        ldy     CURLIN+1
        iny
        sty     JMPADRS
        jsr     LFFD3
        jsr     LF422
        ldx     #$02
        jsr     LFF64
        ldx     #$6F
        ldy     #$00
        jsr     LE39A
        jsr     LE33D
        jmp     CLEARC
        .byte   $FF
        .byte   $FF
        .byte   $FF
VER:
        lda     #$13
        ldx     FAC
        beq     LE397
        lda     $DFF9
LE397:
        jmp     FLOAT
LE39A:
        lda     VARTAB,x
        clc
        adc     $051B,y
        sta     VARTAB,y
        lda     VARTAB+1,x
        adc     $051C,y
        sta     VARTAB+1,y
RET3:
        rts
.else

; ----------------------------------------------------------------------------
; READ A LINE, AND STRIP OFF SIGN BITS
; ----------------------------------------------------------------------------
.ifdef APPLE
INLIN:
        ldx     #$DD
INLIN1:
        stx     $33
        jsr     L2900
        cpx     #$EF
        bcs     L0C32
        ldx     #$EF
L0C32:
        lda     #$00
        sta     INPUTBUFFER,x
        ldx     #<INPUTBUFFER-1
        ldy     #>INPUTBUFFER-1
        rts
RDKEY:
        jsr     LFD0C
        and     #$7F
.else
.ifdef CBM2
RET3:
		rts
.else
L2420:
.ifdef OSI
        jsr     OUTDO
.endif
        dex
        bpl     INLIN2
L2423:
.ifdef OSI
        jsr     OUTDO
.endif
        jsr     CRDO
.endif
INLIN:
        ldx     #$00
INLIN2:
        jsr     GETLN
.ifndef CONFIG_CBM_ALL
        cmp     #$07
        beq     L2443
.endif
        cmp     #$0D
        beq     L2453
.ifndef CONFIG_CBM_ALL
        cmp     #$20 ; line editing
        bcc     INLIN2
        cmp     #$7D
        bcs     INLIN2
        cmp     #$40 ; @
        beq     L2423
        cmp     #$5F ; _
        beq     L2420
L2443:
        cpx     #$47
        bcs     L244C
.endif
        sta     INPUTBUFFER,x
        inx
.ifdef OSI
        .byte   $2C
.else
        bne     INLIN2
.endif
L244C:
.ifndef CONFIG_CBM_ALL
        lda     #$07
        jsr     OUTDO
        bne     INLIN2
.endif
L2453:
        jmp     L29B9
GETLN:
.ifdef CONFIG_CBM_ALL
        jsr     CHRIN
        ldy     Z03
        bne     L2465
.else
        jsr     MONRDKEY
.endif
.ifdef OSI
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        and     #$7F
.endif
.endif
        cmp     #$0F
        bne     L2465
        pha
        lda     Z14
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts
.endif /* KBD */

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
        jsr     LF42D
.else
        lda     INPUTBUFFERX,x
.ifndef CBM2
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
.if INPUTBUFFER >= $0100
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
        stx     $13
        stx     $14
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
.ifdef CBM2_KBD
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
.ifndef APPLE
.ifdef CONFIG_11
        lda     #$00

; ----------------------------------------------------------------------------
; "CLEAR" STATEMENT
; ----------------------------------------------------------------------------
CLEAR:
        bne     L256A
.endif
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
.ifdef CBM2_KBD
		tay
.else
.ifdef APPLE
        sta     STACK+249
.else
        sta     STACK+253
.endif
.endif
        pla
.ifndef CBM2_KBD
.ifdef APPLE
        sta     STACK+250
.else
        sta     STACK+254
.endif
.endif
        ldx     #STACK_TOP
        txs
.ifdef CBM2_KBD
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
LE4D4:
        lda     $01,x
        cmp     JMPADRS+2
        bne     LE4DE
        lda     $00,x
        cmp     JMPADRS+1
LE4DE:
        rts

; ----------------------------------------------------------------------------
; "LIST" STATEMENT
; ----------------------------------------------------------------------------
LIST:
        jsr     LE440
        bne     LE4DE
        pla
        pla
L25A6:
        jsr     CRDO
.else
LIST:
        bcc     L2581
        beq     L2581
        cmp     #TOKEN_MINUS
        bne     L256A
L2581:
        jsr     LINGET
        jsr     FNDLIN
        jsr     CHRGOT
        beq     L2598
        cmp     #TOKEN_MINUS
        bne     L2520
        jsr     CHRGET
        jsr     LINGET
        bne     L2520
L2598:
        pla
        pla
        lda     LINNUM
        ora     LINNUM+1
        bne     L25A6
        lda     #$FF
        sta     LINNUM
        sta     LINNUM+1
L25A6:
.endif
        ldy     #$01
.ifdef CONFIG_DATAFLAG
        sty     DATAFLG
.endif
        lda     (LOWTRX),y
        beq     L25E5
        jsr     ISCNTC
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
.ifdef CONFIG_DATAFLAG
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
        bne     L25A6
L25E5:
        jmp     RESTART
L25E8:
        bpl     L25CE
.ifdef CONFIG_DATAFLAG
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
        bne     L25FD

; ----------------------------------------------------------------------------
; "FOR" STATEMENT
;
; FOR PUSHES 18 BYTES ON THE STACK:
; 2 -- TXTPTR
; 2 -- LINE NUMBER
; 5 -- INITIAL (CURRENT)  FOR VARIABLE VALUE
; 1 -- STEP SIGN
; 5 -- STEP VALUE
; 2 -- ADDRESS OF FOR VARIABLE IN VARTAB
; 1 -- FOR TOKEN ($81)
; ----------------------------------------------------------------------------
FOR:
        lda     #$80
        sta     SUBFLG
        jsr     LET
        jsr     GTFORPNT
        bne     L2619
        txa
        adc     #FOR_STACK1
        tax
        txs
L2619:
        pla
        pla
        lda     #FOR_STACK2
        jsr     CHKMEM
        jsr     DATAN
        clc
        tya
        adc     TXTPTR
        pha
        lda     TXTPTR+1
        adc     #$00
        pha
        lda     CURLIN+1
        pha
        lda     CURLIN
        pha
        lda     #TOKEN_TO
        jsr     SYNCHR
        jsr     CHKNUM
        jsr     FRMNUM
        lda     FACSIGN
        ora     #$7F
        and     FAC+1
        sta     FAC+1
        lda     #<STEP
        ldy     #>STEP
        sta     INDEX
        sty     INDEX+1
        jmp     FRM_STACK3

; ----------------------------------------------------------------------------
; "STEP" PHRASE OF "FOR" STATEMENT
; ----------------------------------------------------------------------------
STEP:
        lda     #<CON_ONE
        ldy     #>CON_ONE
        jsr     LOAD_FAC_FROM_YA
        jsr     CHRGOT
        cmp     #TOKEN_STEP
        bne     L2665
        jsr     CHRGET
        jsr     FRMNUM
L2665:
        jsr     SIGN
        jsr     FRM_STACK2
        lda     FORPNT+1
        pha
        lda     FORPNT
        pha
        lda     #$81
        pha

; ----------------------------------------------------------------------------
; PERFORM NEXT STATEMENT
; ----------------------------------------------------------------------------
NEWSTT:
        jsr     ISCNTC
        lda     TXTPTR
        ldy     TXTPTR+1
.ifdef CBM2_KBD
        cpy     #>INPUTBUFFER
.endif
.ifdef CBM2
        nop
.endif
.ifdef CBM2_KBD
        beq     LC6D4
.else
        beq     L2683
.endif
        sta     OLDTEXT
        sty     OLDTEXT+1
LC6D4:
        ldy     #$00
L2683:
        lda     (TXTPTR),y
.ifndef CONFIG_11
        beq     LA5DC
        cmp     #$3A
        beq     NEWSTT2
SYNERR1:
        jmp     SYNERR
LA5DC:
.else
        bne     COLON
.endif
        ldy     #$02
        lda     (TXTPTR),y
        clc
.ifdef CBM2_KBD
        jeq     L2701
.else
        beq     L2701
.endif
        iny
        lda     (TXTPTR),y
        sta     CURLIN
        iny
        lda     (TXTPTR),y
        sta     CURLIN+1
        tya
        adc     TXTPTR
        sta     TXTPTR
        bcc     NEWSTT2
        inc     TXTPTR+1
NEWSTT2:
        jsr     CHRGET
        jsr     EXECUTE_STATEMENT
        jmp     NEWSTT

; ----------------------------------------------------------------------------
; EXECUTE A STATEMENT
;
; (A) IS FIRST CHAR OF STATEMENT
; CARRY IS SET
; ----------------------------------------------------------------------------
EXECUTE_STATEMENT:
.ifndef CONFIG_11_NOAPPLE
        beq     RET1
.ifndef APPLE
        sec
.endif
.else
        beq     RET2
.endif
EXECUTE_STATEMENT1:
        sbc     #$80
.ifndef CONFIG_11
        jcc     LET
.else
        bcc     LET1
.endif
        cmp     #NUM_TOKENS
.ifdef CBM2_KBD
        bcs     LC721
.else
        bcs     SYNERR1
.endif
        asl     a
        tay
        lda     TOKEN_ADDRESS_TABLE+1,y
        pha
        lda     TOKEN_ADDRESS_TABLE,y
        pha
        jmp     CHRGET
.ifdef CONFIG_11
LET1:
        jmp     LET
COLON:
        cmp     #$3A
        beq     NEWSTT2
SYNERR1:
        jmp     SYNERR
.endif
.ifdef CBM2_KBD
LC721:
.ifdef KBD
        cmp     #$45
.else
        cmp     #$4B
.endif
        bne     SYNERR1
        jsr     CHRGET
        lda     #TOKEN_TO
        jsr     SYNCHR
        jmp     GOTO
.endif

; ----------------------------------------------------------------------------
; "RESTORE" STATEMENT
; ----------------------------------------------------------------------------
RESTORE:
        sec
        lda     TXTTAB
        sbc     #$01
        ldy     TXTTAB+1
        bcs     SETDA
        dey
SETDA:
        sta     DATPTR
        sty     DATPTR+1
RET2:
        rts
.ifndef CONFIG_CBM_ALL

; ----------------------------------------------------------------------------
; SEE IF CONTROL-C TYPED
; ----------------------------------------------------------------------------
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

; ----------------------------------------------------------------------------
; "STOP" STATEMENT
; ----------------------------------------------------------------------------
STOP:
        bcs     END2

; ----------------------------------------------------------------------------
; "END" STATEMENT
; ----------------------------------------------------------------------------
END:
        clc
END2:
        bne     RET1
        lda     TXTPTR
        ldy     TXTPTR+1
.ifdef CBM2_KBD
        ldx     CURLIN+1
        inx
.endif
        beq     END4
        sta     OLDTEXT
        sty     OLDTEXT+1
CONTROL_C_TYPED:
        lda     CURLIN
        ldy     CURLIN+1
        sta     OLDLIN
        sty     OLDLIN+1
END4:
        pla
        pla
L2701:
        lda     #<QT_BREAK
        ldy     #>QT_BREAK
.ifndef KBD
        ldx     #$00
        stx     Z14
.endif
        bcc     L270E
        jmp     PRINT_ERROR_LINNUM
L270E:
        jmp     RESTART
.ifdef KBD
LE664:
        tay
        jmp     SNGFLT
.endif

; ----------------------------------------------------------------------------
; "CONT" COMMAND
; ----------------------------------------------------------------------------
CONT:
        bne     RET1
        ldx     #ERR_CANTCONT
        ldy     OLDTEXT+1
        bne     L271C
        jmp     ERROR
L271C:
        lda     OLDTEXT
        sta     TXTPTR
        sty     TXTPTR+1
        lda     OLDLIN
        ldy     OLDLIN+1
        sta     CURLIN
        sty     CURLIN+1
RET1:
        rts
.ifdef KBD
PRT:
        jsr     GETBYT
        txa
        ror     a
        ror     a
        ror     a
        sta     $8F
        rts
LE68C:
        ldy     #$12
LE68E:
        lda     LEA30,y
        sta     $03A2,y
        dey
        bpl     LE68E
        rts
.endif
.if .def(CONFIG_NULL) || .def(CBM1)
; CBM1 has the keyword removed,
; but the code is, still here
NULL:
        jsr     GETBYT
        bne     RET1
        inx
        cpx     #NULL_MAX
        bcs     L2739
        dex
        stx     Z15
        rts
L2739:
        jmp     IQERR
.endif
.ifndef CONFIG_11_NOAPPLE
CLEAR:
        bne     RET1
        jmp     CLEARC
.endif
.ifdef APPLE
SAVE:
        jsr     L0F42
        jsr     LFECD
        jsr     L0F51
        jmp     LFECD
LOAD:
        jsr     L0F42
        jsr     LFEFD
        jsr     L0F51
        jsr     LFEFD
        lda     #<QT_LOADED
        ldy     #>QT_LOADED
        jsr     STROUT
        jmp     FIX_LINKS
QT_LOADED:
        .byte   0 ; XXX PATCHED
        .byte   "OADED"
        .byte   0
L0F42:
        lda     #$6C
        ldy     #$00
        sta     $3C
        sty     $3D
        lda     #$6E
        sta     $3E
        sty     $3F
        rts
L0F51:
        lda     $6A
        ldy     $6B
        sta     $3C
        sty     $3D
        lda     $6C
        ldy     $6D
        sta     $3E
        sty     $3F
        rts
.endif
.ifdef KIM
SAVE:
        tsx
        stx     INPUTFLG
        lda     #$37
        sta     $F2
        lda     #$FE
        sta     $17F9
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     $17F5
        sty     $17F6
        lda     VARTAB
        ldy     VARTAB+1
        sta     $17F7
        sty     $17F8
        jmp     L1800
        ldx     INPUTFLG
        txs
        lda     #<QT_SAVED
        ldy     #>QT_SAVED
        jmp     STROUT
QT_LOADED:
        .byte   "LOADED"
        .byte   $00
QT_SAVED:
        .byte   "SAVED"
        .byte   $0D,$0A,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00,$00
        .byte   $00,$00,$00,$00,$00,$00,$00
LOAD:
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     $17F5
        sty     $17F6
        lda     #$FF
        sta     $17F9
        lda     #$A6
        ldy     #$27 ; XXX
        sta     L0001
        sty     L0001+1
        jmp     L1873
        ldx     #$FF
        txs
        lda     #$48
        ldy     #$23 ; XXX
        sta     L0001
        sty     L0001+1
        lda     #<QT_LOADED
        ldy     #>QT_LOADED
        jsr     STROUT
        ldx     $17ED
        ldy     $17EE
        txa
        bne     L27C2
        nop
L27C2:
        nop
        stx     VARTAB
        sty     VARTAB+1
        jmp     FIX_LINKS
.endif

; ----------------------------------------------------------------------------
; "RUN" COMMAND
; ----------------------------------------------------------------------------
RUN:
        bne     L27CF
        jmp     SETPTRS
L27CF:
        jsr     CLEARC
        jmp     L27E9

; ----------------------------------------------------------------------------
; "GOSUB" STATEMENT
;
; LEAVES 7 BYTES ON STACK:
; 2 -- RETURN ADDRESS (NEWSTT)
; 2 -- TXTPTR
; 2 -- LINE #
; 1 -- GOSUB TOKEN
; ----------------------------------------------------------------------------
GOSUB:
        lda     #$03
        jsr     CHKMEM
        lda     TXTPTR+1
        pha
        lda     TXTPTR
        pha
        lda     CURLIN+1
        pha
        lda     CURLIN
        pha
        lda     #TOKEN_GOSUB
        pha
L27E9:
        jsr     CHRGOT
        jsr     GOTO
        jmp     NEWSTT

; ----------------------------------------------------------------------------
; "GOTO" STATEMENT
; ALSO USED BY "RUN" AND "GOSUB"
; ----------------------------------------------------------------------------
GOTO:
        jsr     LINGET
        jsr     REMN
        lda     CURLIN+1
        cmp     LINNUM+1
        bcs     L2809
        tya
        sec
        adc     TXTPTR
        ldx     TXTPTR+1
        bcc     L280D
        inx
        bcs     L280D
L2809:
        lda     TXTTAB
        ldx     TXTTAB+1
L280D:
.ifdef KBD
        jsr     LF457
        bne     UNDERR
.else
        jsr     FL1
        bcc     UNDERR
.endif
        lda     LOWTRX
        sbc     #$01
        sta     TXTPTR
        lda     LOWTRX+1
        sbc     #$00
        sta     TXTPTR+1
L281E:
        rts

; ----------------------------------------------------------------------------
; "POP" AND "RETURN" STATEMENTS
; ----------------------------------------------------------------------------
POP:
        bne     L281E
        lda     #$FF
.ifdef CBM2_KBD
        sta     FORPNT+1 ; bugfix, wrong in AppleSoft
.else
        sta     FORPNT
.endif
        jsr     GTFORPNT
        txs
        cmp     #TOKEN_GOSUB
        beq     RETURN
        ldx     #ERR_NOGOSUB
        .byte   $2C
UNDERR:
        ldx     #ERR_UNDEFSTAT
        jmp     ERROR
; ----------------------------------------------------------------------------
SYNERR2:
        jmp     SYNERR
; ----------------------------------------------------------------------------
RETURN:
        pla
        pla
        sta     CURLIN
        pla
        sta     CURLIN+1
        pla
        sta     TXTPTR
        pla
        sta     TXTPTR+1

; ----------------------------------------------------------------------------
; "DATA" STATEMENT
; EXECUTED BY SKIPPING TO NEXT COLON OR EOL
; ----------------------------------------------------------------------------
DATA:
        jsr     DATAN

; ----------------------------------------------------------------------------
; ADD (Y) TO TXTPTR
; ----------------------------------------------------------------------------
ADDON:
        tya
        clc
        adc     TXTPTR
        sta     TXTPTR
        bcc     L2852
        inc     TXTPTR+1
L2852:
        rts

; ----------------------------------------------------------------------------
; SCAN AHEAD TO NEXT ":" OR EOL
; ----------------------------------------------------------------------------
DATAN:
        ldx     #$3A
        .byte   $2C
REMN:
        ldx     #$00
        stx     CHARAC
        ldy     #$00
        sty     ENDCHR
L285E:
        lda     ENDCHR
        ldx     CHARAC
        sta     CHARAC
        stx     ENDCHR
L2866:
        lda     (TXTPTR),y
        beq     L2852
        cmp     ENDCHR
        beq     L2852
        iny
        cmp     #$22
.ifndef CONFIG_11
        beq     L285E
        bne     L2866
.else
        bne     L2866
        beq     L285E
.endif

; ----------------------------------------------------------------------------
; "IF" STATEMENT
; ----------------------------------------------------------------------------
IF:
        jsr     FRMEVL
        jsr     CHRGOT
        cmp     #TOKEN_GOTO
        beq     L2884
        lda     #TOKEN_THEN
        jsr     SYNCHR
L2884:
        lda     FAC
        bne     L288D

; ----------------------------------------------------------------------------
; "REM" STATEMENT, OR FALSE "IF" STATEMENT
; ----------------------------------------------------------------------------
REM:
        jsr     REMN
        beq     ADDON
L288D:
        jsr     CHRGOT
        bcs     L2895
        jmp     GOTO
L2895:
        jmp     EXECUTE_STATEMENT

; ----------------------------------------------------------------------------
; "ON" STATEMENT
;
; ON <EXP> GOTO <LIST>
; ON <EXP> GOSUB <LIST>
; ----------------------------------------------------------------------------
ON:
        jsr     GETBYT
        pha
        cmp     #TOKEN_GOSUB
        beq     L28A4
L28A0:
        cmp     #TOKEN_GOTO
        bne     SYNERR2
L28A4:
        dec     FAC_LAST
        bne     L28AC
        pla
        jmp     EXECUTE_STATEMENT1
L28AC:
        jsr     CHRGET
        jsr     LINGET
        cmp     #$2C
        beq     L28A4
        pla
L28B7:
        rts

; ----------------------------------------------------------------------------
; CONVERT LINE NUMBER
; ----------------------------------------------------------------------------
LINGET:
        ldx     #$00
        stx     LINNUM
        stx     LINNUM+1
L28BE:
        bcs     L28B7
        sbc     #$2F
        sta     CHARAC
        lda     LINNUM+1
        sta     INDEX
        cmp     #$19
        bcs     L28A0
; <<<<<DANGEROUS CODE>>>>>
; NOTE THAT IF (A) = $AB ON THE LINE ABOVE,
; ON.1 WILL COMPARE = AND CAUSE A CATASTROPHIC
; JUMP TO $22D9 (FOR GOTO), OR OTHER LOCATIONS
; FOR OTHER CALLS TO LINGET.
;
; YOU CAN SEE THIS IS YOU FIRST PUT "BRK" IN $22D9,
; THEN TYPE "GO TO 437761".
;
; ANY VALUE FROM 437760 THROUGH 440319 WILL CAUSE
; THE PROBLEM.  ($AB00 - $ABFF)
; <<<<<DANGEROUS CODE>>>>>
        lda     LINNUM
        asl     a
        rol     INDEX
        asl     a
        rol     INDEX
        adc     LINNUM
        sta     LINNUM
        lda     INDEX
        adc     LINNUM+1
        sta     LINNUM+1
        asl     LINNUM
        rol     LINNUM+1
        lda     LINNUM
        adc     CHARAC
        sta     LINNUM
        bcc     L28EC
        inc     LINNUM+1
L28EC:
        jsr     CHRGET
        jmp     L28BE

; ----------------------------------------------------------------------------
; "LET" STATEMENT
;
; LET <VAR> = <EXP>
; <VAR> = <EXP>
; ----------------------------------------------------------------------------
LET:
        jsr     PTRGET
        sta     FORPNT
        sty     FORPNT+1
        lda     #TOKEN_EQUAL
        jsr     SYNCHR
.ifndef CONFIG_SMALL
        lda     VALTYP+1
        pha
.endif
        lda     VALTYP
        pha
        jsr     FRMEVL
        pla
        rol     a
        jsr     CHKVAL
        bne     LETSTRING
.ifndef CONFIG_SMALL
        pla
LET2:
        bpl     L2923
        jsr     ROUND_FAC
        jsr     AYINT
        ldy     #$00
        lda     FAC+3
        sta     (FORPNT),y
        iny
        lda     FAC+4
        sta     (FORPNT),y
        rts
L2923:
.endif

; ----------------------------------------------------------------------------
; REAL VARIABLE = EXPRESSION
; ----------------------------------------------------------------------------
        jmp     SETFOR
LETSTRING:
.ifndef CONFIG_SMALL
        pla

; ----------------------------------------------------------------------------
; INSTALL STRING, DESCRIPTOR ADDRESS IS AT FAC+3,4
; ----------------------------------------------------------------------------
PUTSTR:
.endif
.ifdef CONFIG_CBM_ALL
        ldy     FORPNT+1
.ifdef CBM1
        cpy     #$D0
.else
        cpy     #$DE
.endif
        bne     LC92B
        jsr     FREFAC
        cmp     #$06
.ifdef CBM2_KBD
        bne     IQERR1
.else
        beq     LC8E2
        jmp     IQERR
LC8E2:
.endif
        ldy     #$00
        sty     FAC
        sty     FACSIGN
LC8E8:
        sty     STRNG2
        jsr     LC91C
        jsr     MUL10
        inc     STRNG2
        ldy     STRNG2
        jsr     LC91C
        jsr     COPY_FAC_TO_ARG_ROUNDED
        tax
        beq     LC902
        inx
        txa
        jsr     LD9BF
LC902:
        ldy     STRNG2
        iny
        cpy     #$06
        bne     LC8E8
        jsr     MUL10
        jsr     QINT
        ldx     #$02
        sei
LC912:
        lda     FAC+2,x
.ifdef CBM2
        sta     $8D,x
.else
        sta     $0200,x
.endif
        dex
        bpl     LC912
        cli
        rts
LC91C:
        lda     (INDEX),y
        jsr     L00CF
        bcc     LC926
IQERR1:
        jmp     IQERR
LC926:
        sbc     #$2F
        jmp     ADDACC
LC92B:
.endif
        ldy     #$02
        lda     (FAC_LAST-1),y
        cmp     FRETOP+1
        bcc     L2946
        bne     L2938
        dey
        lda     (FAC_LAST-1),y
        cmp     FRETOP
        bcc     L2946
L2938:
        ldy     FAC_LAST
        cpy     VARTAB+1
        bcc     L2946
        bne     L294D
        lda     FAC_LAST-1
        cmp     VARTAB
        bcs     L294D
L2946:
        lda     FAC_LAST-1
        ldy     FAC_LAST
        jmp     L2963
L294D:
        ldy     #$00
        lda     (FAC_LAST-1),y
        jsr     STRINI
        lda     DSCPTR
        ldy     DSCPTR+1
        sta     STRNG1
        sty     STRNG1+1
        jsr     MOVINS
        lda     #FAC
        ldy     #$00
L2963:
        sta     DSCPTR
        sty     DSCPTR+1
        jsr     FRETMS
        ldy     #$00
        lda     (DSCPTR),y
        sta     (FORPNT),y
        iny
        lda     (DSCPTR),y
        sta     (FORPNT),y
        iny
        lda     (DSCPTR),y
        sta     (FORPNT),y
        rts
.ifdef CONFIG_CBM_ALL
PRINTH:
        jsr     CMD
        jmp     LCAD6
CMD:
        jsr     GETBYT
        beq     LC98F
        lda     #$2C
        jsr     SYNCHR
LC98F:
        php
        jsr     CHKOUT
        stx     Z03
        plp
        jmp     PRINT
.endif

; ----------------------------------------------------------------------------
PRSTRING:
        jsr     STRPRT
L297E:
        jsr     CHRGOT

; ----------------------------------------------------------------------------
; "PRINT" STATEMENT
; ----------------------------------------------------------------------------
PRINT:
        beq     CRDO
PRINT2:
        beq     L29DD
        cmp     #TOKEN_TAB
        beq     L29F5
        cmp     #TOKEN_SPC
.ifdef CBM2_KBD
        clc
.endif
        beq     L29F5
        cmp     #','
.ifdef KIM
        clc
.endif
        beq     L29DE
        cmp     #$3B
        beq     L2A0D
        jsr     FRMEVL
        bit     VALTYP
        bmi     PRSTRING
        jsr     FOUT
        jsr     STRLIT
.ifndef CONFIG_CBM_ALL
        ldy     #$00
        lda     (FAC_LAST-1),y
        clc
        adc     Z16
.ifdef KBD
        cmp     #$28
.else
        cmp     Z17
.endif
        bcc     L29B1
        jsr     CRDO
L29B1:
.endif
        jsr     STRPRT
.ifdef KBD
        jmp     L297E
LE86C:
        pla
        jmp     CONTROL_C_TYPED
LE870:
        jsr     GETBYT
        txa
LE874:
        beq     LE878
        bpl     LE8F2
LE878:
        jmp     IQERR
CRDO:
        lda     #$0A
        sta     $10
        jsr     OUTDO
LE882:
        lda     #$0D
        jsr     OUTDO
PRINTNULLS:
        lda     #$00
        sta     $10
        eor     #$FF
.else
        jsr     OUTSP
        bne     L297E
L29B9:
.ifdef CBM2
        lda     #$00
        sta     INPUTBUFFER,x
        ldx     #<(INPUTBUFFER-1)
        ldy     #>(INPUTBUFFER-1)
.else
.ifndef APPLE
        ldy     #$00
        sty     INPUTBUFFER,x
        ldx     #LINNUM+1
.endif
.endif
.ifdef CONFIG_CBM_ALL
        lda     Z03
        bne     L29DD
LC9D2:
.endif
CRDO:
.ifdef CBM1
        lda     Z03
        bne     LC9D8
        sta     $05
LC9D8:
.endif
        lda     #$0D
.ifndef CONFIG_CBM_ALL
        sta     Z16
.endif
        jsr     OUTDO
.ifdef APPLE
        lda     #$80
.else
        lda     #$0A
.endif
        jsr     OUTDO
PRINTNULLS:
.ifdef CBM1
        lda     Z03
        bne     L29DD
.endif
.if .def(CONFIG_NULL) || .def(CBM1)
        txa
        pha
        ldx     Z15
        beq     L29D9
        lda     #$00
L29D3:
        jsr     OUTDO
        dex
        bne     L29D3
L29D9:
        stx     Z16
        pla
        tax
.else
.ifdef APPLE
        lda     #$00
        sta     $50
.endif
        eor     #$FF
.endif
.endif
L29DD:
        rts
L29DE:
        lda     Z16
.ifndef CONFIG_CBM_ALL
.ifdef KBD
        cmp     #$1A
.else
        cmp     Z18
.endif
        bcc     L29EA
        jsr     CRDO
        jmp     L2A0D
L29EA:
.endif
        sec
L29EB:
.ifdef CONFIG_CBM_ALL
        sbc     #$0A
.else
.ifdef KBD
        sbc     #$0D
.else
        sbc     #$0E
.endif
.endif
        bcs     L29EB
        eor     #$FF
        adc     #$01
        bne     L2A08
L29F5:
.ifdef CONFIG_11_NOAPPLE
        php
.else
        pha
.endif
        jsr     GTBYTC
        cmp     #$29
.ifndef CONFIG_11_NOAPPLE
.ifdef APPLE
        beq     L1185
        jmp     SYNERR
L1185:
.else
        bne     SYNERR4
.endif
        pla
        cmp     #TOKEN_TAB
.ifdef APPLE
        bne     L2A09
.else
        bne     L2A0A
.endif
.else
.ifdef CBM2_KBD
        bne     SYNERR4
.else
        beq     @1
        jmp     SYNERR
@1:
.endif
        plp	;; XXX c64 has this
        bcc     L2A09
.endif
        txa
        sbc     Z16
        bcc     L2A0D
.ifndef CONFIG_11
        beq     L2A0D
.endif
L2A08:
        tax
.ifdef CONFIG_11
L2A09:
        inx
.endif
L2A0A:
.ifndef CONFIG_11
        jsr     OUTSP
.endif
        dex
.ifndef CONFIG_11
        bne     L2A0A
.else
        bne     L2A13
.endif
L2A0D:
        jsr     CHRGET
        jmp     PRINT2
.ifdef CONFIG_11
L2A13:
        jsr     OUTSP
        bne     L2A0A
.endif

; ----------------------------------------------------------------------------
; PRINT STRING AT (Y,A)
; ----------------------------------------------------------------------------
STROUT:
        jsr     STRLIT

; ----------------------------------------------------------------------------
; PRINT STRING AT (FACMO,FACLO)
; ----------------------------------------------------------------------------
STRPRT:
        jsr     FREFAC
        tax
        ldy     #$00
        inx
L2A22:
        dex
        beq     L29DD
        lda     (INDEX),y
        jsr     OUTDO
        iny
        cmp     #$0D
        bne     L2A22
        jsr     PRINTNULLS
        jmp     L2A22
; ----------------------------------------------------------------------------
OUTSP:
.ifdef CBM2
        lda     $0E
        beq     LCA40
        lda     #$20
        .byte   $2C
LCA40:
.endif
.ifdef CONFIG_CBM_ALL
        lda     #$1D
.else
        lda     #$20
.endif
        .byte   $2C
OUTQUES:
        lda     #$3F

; ----------------------------------------------------------------------------
; PRINT CHAR FROM (A)
; ----------------------------------------------------------------------------
OUTDO:
.ifndef KBD
        bit     Z14
        bmi     L2A56
.endif
.ifndef CBM2_KBD
        pha
.endif
.ifdef CBM1
        cmp     #$1D
        beq     LCA6A
        cmp     #$9D
        beq     LCA5A
        cmp     #$14
        bne     LCA64
LCA5A:
        lda     $05
        beq     L2A4E
        lda     Z03
        bne     L2A4E
        dec     $05
LCA64:
        and     #$7F
.endif
.ifndef CBM2
        cmp     #$20
        bcc     L2A4E
.endif
LCA6A:
.ifdef CONFIG_CBM1_PATCHES
        lda     Z03
        jsr     PATCH6
        nop
.endif
.ifdef CONFIG_PRINT_CR
        lda     Z16
        cmp     Z17
        bne     L2A4C
.ifdef APPLE
        nop ; PATCH!
        nop ; don't print CR
        nop
.else
        jsr     CRDO
.endif
L2A4C:
.endif
.ifndef CONFIG_CBM_ALL
        inc     Z16
.endif
L2A4E:
.ifndef CBM2_KBD
        pla
.endif
.ifdef KIM
        sty     DIMFLG
.endif
.ifdef APPLE
        ora     #$80
.endif
        jsr     MONCOUT
.ifdef APPLE
        and     #$7F
.endif
.ifdef KIM
        ldy     DIMFLG
.endif
.ifdef OSI
        nop
        nop
        nop
        nop
.endif
L2A56:
        and     #$FF
LE8F2:
        rts
.ifdef KBD
LE8F3:
        pha
        lda     $047F
        clc
        beq     LE900
        lda     #$00
        sta     $047F
        sec
LE900:
        pla
        rts
.endif

; ----------------------------------------------------------------------------
; INPUT CONVERSION ERROR:  ILLEGAL CHARACTER
; IN NUMERIC FIELD.  MUST DISTINGUISH
; BETWEEN INPUT, READ, AND GET
; ----------------------------------------------------------------------------
INPUTERR:
        lda     INPUTFLG
        beq     RESPERR
.ifdef CBM2_KIM_APPLE
        bmi     L2A63
        ldy     #$FF
        bne     L2A67
L2A63:
.endif
.ifdef CONFIG_CBM1_PATCHES
        jsr     PATCH5
		nop
.else
        lda     Z8C
        ldy     Z8C+1
.endif
L2A67:
        sta     CURLIN
        sty     CURLIN+1
SYNERR4:
        jmp     SYNERR
RESPERR:
.ifdef CONFIG_CBM_ALL
        lda     Z03
        beq     LCA8F
        ldx     #ERR_BADDATA
        jmp     ERROR
LCA8F:
.endif
        lda     #<ERRREENTRY
        ldy     #>ERRREENTRY
        jsr     STROUT
        lda     OLDTEXT
        ldy     OLDTEXT+1
        sta     TXTPTR
        sty     TXTPTR+1
LE920:
        rts
.ifndef CONFIG_SMALL

; ----------------------------------------------------------------------------
; "GET" STATEMENT
; ----------------------------------------------------------------------------
GET:
        jsr     ERRDIR
.ifdef CONFIG_CBM_ALL
        cmp     #$23
        bne     LCAB6
        jsr     CHRGET
        jsr     GETBYT
        lda     #$2C
        jsr     SYNCHR
        jsr     CHKIN
        stx     Z03
LCAB6:
.endif
        ldx     #<(INPUTBUFFER+1)
        ldy     #>(INPUTBUFFER+1)
.if INPUTBUFFER >= $0100
        lda     #$00
        sta     INPUTBUFFER+1
.else
        sty     INPUTBUFFER+1
.endif
        lda     #$40
        jsr     PROCESS_INPUT_LIST
.ifdef CONFIG_CBM_ALL
        ldx     Z03
        bne     LCAD8
.endif
        rts
.endif
.ifdef CONFIG_CBM_ALL
INPUTH:
        jsr     GETBYT
        lda     #$2C
        jsr     SYNCHR
        jsr     CHKIN
        stx     Z03
        jsr     L2A9E
LCAD6:
        lda     Z03
LCAD8:
        jsr     CLRCH
        ldx     #$00
        stx     Z03
        rts
LCAE0:
.endif

; ----------------------------------------------------------------------------
; "INPUT" STATEMENT
; ----------------------------------------------------------------------------
INPUT:
.ifndef KBD
        lsr     Z14
.endif
        cmp     #$22
        bne     L2A9E
        jsr     STRTXT
        lda     #$3B
        jsr     SYNCHR
        jsr     STRPRT
L2A9E:
        jsr     ERRDIR
        lda     #$2C
        sta     INPUTBUFFER-1
LCAF8:
.ifdef APPLE
        jsr     INLINX
.else
        jsr     NXIN
.endif
.ifdef KBD
        bmi     L2ABE
NXIN:
        jsr     LFDDA
        bmi     LE920
        pla
        jmp     LE86C
.else
.ifdef CONFIG_CBM_ALL
        lda     Z03
        beq     LCB0C
        lda     Z96
        and     #$02
        beq     LCB0C
        jsr     LCAD6
        jmp     DATA
LCB0C:
.endif
        lda     INPUTBUFFER
        bne     L2ABE
.ifdef CONFIG_CBM_ALL
        lda     Z03
        bne     LCAF8
.ifdef CONFIG_CBM1_PATCHES
        jmp     PATCH1
.else
        clc
        jmp     CONTROL_C_TYPED
.endif
NXIN:
        lda     Z03
        bne     LCB21
.else
        clc
        jmp     CONTROL_C_TYPED
NXIN:
.endif
        jsr     OUTQUES
        jsr     OUTSP
LCB21:
        jmp     INLIN
.endif /* KBD */
.ifdef KBD
GETC:
        jsr     CONINT
        jsr     LF43D
        jmp     LE664
.endif

; ----------------------------------------------------------------------------
; "READ" STATEMENT
; ----------------------------------------------------------------------------
READ:
        ldx     DATPTR
        ldy     DATPTR+1
.ifdef CBM2_KBD
        lda     #$98 ; AppleSoft, too
        .byte   $2C
L2ABE:
        lda     #$00
.else
        .byte   $A9
L2ABE:
        tya
.endif

; ----------------------------------------------------------------------------
; PROCESS INPUT LIST
;
; (Y,X) IS ADDRESS OF INPUT DATA STRING
; (A) = VALUE FOR INPUTFLG:  $00 FOR INPUT
; 				$40 FOR GET
;				$98 FOR READ
; ----------------------------------------------------------------------------
PROCESS_INPUT_LIST:
        sta     INPUTFLG
        stx     INPTR
        sty     INPTR+1
PROCESS_INPUT_ITEM:
        jsr     PTRGET
        sta     FORPNT
        sty     FORPNT+1
        lda     TXTPTR
        ldy     TXTPTR+1
        sta     TXPSV
        sty     TXPSV+1
        ldx     INPTR
        ldy     INPTR+1
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        bne     INSTART
        bit     INPUTFLG
.ifndef CONFIG_SMALL
        bvc     L2AF0
        jsr     MONRDKEY
.ifdef APPLE
        and     #$7F
.endif
        sta     INPUTBUFFER
.ifdef CBM1
        ldy     #>(INPUTBUFFER-1)
        ldx     #<(INPUTBUFFER-1)
.else
        ldx     #<(INPUTBUFFER-1)
        ldy     #>(INPUTBUFFER-1)
.endif
        bne     L2AF8
L2AF0:
.endif
        bmi     FINDATA
.ifdef CONFIG_CBM_ALL
        lda     Z03
        bne     LCB64
.endif
.ifdef KBD
        jsr     OUTQUESSP
.else
        jsr     OUTQUES
.endif
LCB64:
        jsr     NXIN
L2AF8:
        stx     TXTPTR
        sty     TXTPTR+1

; ----------------------------------------------------------------------------
INSTART:
        jsr     CHRGET
        bit     VALTYP
        bpl     L2B34
.ifndef CONFIG_SMALL
        bit     INPUTFLG
        bvc     L2B10
.ifdef CONFIG_CBM1_PATCHES
        lda     #$00
        jsr     PATCH4
        nop
.else
        inx
        stx     TXTPTR
        lda     #$00
        sta     CHARAC
        beq     L2B1C
.endif
L2B10:
.endif
        sta     CHARAC
        cmp     #$22
        beq     L2B1D
        lda     #$3A
        sta     CHARAC
        lda     #$2C
L2B1C:
        clc
L2B1D:
        sta     ENDCHR
        lda     TXTPTR
        ldy     TXTPTR+1
        adc     #$00
        bcc     L2B28
        iny
L2B28:
        jsr     STRLT2
        jsr     POINT
.ifdef CONFIG_SMALL
        jsr     LETSTRING
.else
        jsr     PUTSTR
.endif
        jmp     INPUT_MORE
; ----------------------------------------------------------------------------
L2B34:
        jsr     FIN
.ifdef CONFIG_SMALL
        jsr     SETFOR
.else
        lda     VALTYP+1
        jsr     LET2
.endif
; ----------------------------------------------------------------------------
INPUT_MORE:
        jsr     CHRGOT
        beq     L2B48
        cmp     #$2C
        beq     L2B48
        jmp     INPUTERR
L2B48:
        lda     TXTPTR
        ldy     TXTPTR+1
        sta     INPTR
        sty     INPTR+1
        lda     TXPSV
        ldy     TXPSV+1
        sta     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        beq     INPDONE
        jsr     CHKCOM
        jmp     PROCESS_INPUT_ITEM
; ----------------------------------------------------------------------------
FINDATA:
        jsr     DATAN
        iny
        tax
        bne     L2B7C
        ldx     #ERR_NODATA
        iny
        lda     (TXTPTR),y
        beq     GERR
        iny
        lda     (TXTPTR),y
        sta     Z8C
        iny
        lda     (TXTPTR),y
        iny
        sta     Z8C+1
L2B7C:
        lda     (TXTPTR),y
        tax
        jsr     ADDON
        cpx     #$83
        bne     FINDATA
        jmp     INSTART
; ---NO MORE INPUT REQUESTED------
INPDONE:
        lda     INPTR
        ldy     INPTR+1
        ldx     INPUTFLG
.ifdef OSI
        beq     L2B94
.else
        bpl     L2B94
.endif
        jmp     SETDA
L2B94:
        ldy     #$00
        lda     (INPTR),y
        beq     L2BA1
.ifdef CONFIG_CBM_ALL
        lda     Z03
        bne     L2BA1
.endif
        lda     #<ERREXTRA
        ldy     #>ERREXTRA
        jmp     STROUT
L2BA1:
        rts

; ----------------------------------------------------------------------------
ERREXTRA:
.ifdef KBD
        .byte   "?Extra"
.else
        .byte   "?EXTRA IGNORED"
.endif
        .byte   $0D,$0A,$00
ERRREENTRY:
.ifdef KBD
        .byte   "What?"
.else
        .byte   "?REDO FROM START"
.endif
        .byte   $0D,$0A,$00
.ifdef KBD
LEA30:
        .byte   "B"
        .byte   $FD
        .byte   "GsBASIC"
        .byte   $00,$1B,$0D,$13
        .byte   " BASIC"
.endif

; ----------------------------------------------------------------------------
; "NEXT" STATEMENT
; ----------------------------------------------------------------------------
NEXT:
        bne     NEXT1
        ldy     #$00
        beq     NEXT2
NEXT1:
        jsr     PTRGET
NEXT2:
        sta     FORPNT
        sty     FORPNT+1
        jsr     GTFORPNT
        beq     NEXT3
        ldx     #$00
GERR:
        beq     JERROR
NEXT3:
        txs
.ifndef CBM2_KBD
        inx
        inx
        inx
        inx
.endif
        txa
.ifdef CBM2_KBD
        clc
        adc     #$04
        pha
        adc     #BYTES_FP+1
        sta     DEST
        pla
.else
        inx
        inx
        inx
        inx
        inx
.ifndef CONFIG_SMALL
        inx
.endif
        stx     DEST
.endif
        ldy     #>STACK
        jsr     LOAD_FAC_FROM_YA
        tsx
        lda     STACK+BYTES_FP+4,x
        sta     FACSIGN
        lda     FORPNT
        ldy     FORPNT+1
        jsr     FADD
        jsr     SETFOR
        ldy     #>STACK
        jsr     FCOMP2
        tsx
        sec
        sbc     STACK+BYTES_FP+4,x
        beq     L2C22
        lda     STACK+2*BYTES_FP+5,x
        sta     CURLIN
        lda     STACK+2*BYTES_FP+6,x
        sta     CURLIN+1
        lda     STACK+2*BYTES_FP+8,x
        sta     TXTPTR
        lda     STACK+2*BYTES_FP+7,x
        sta     TXTPTR+1
L2C1F:
        jmp     NEWSTT
L2C22:
        txa
        adc     #2*BYTES_FP+7
        tax
        txs
        jsr     CHRGOT
        cmp     #$2C
        bne     L2C1F
        jsr     CHRGET
        jsr     NEXT1

; ----------------------------------------------------------------------------
; EVALUATE EXPRESSION, MAKE SURE IT IS NUMERIC
; ----------------------------------------------------------------------------
FRMNUM:
        jsr     FRMEVL

; ----------------------------------------------------------------------------
; MAKE SURE (FAC) IS NUMERIC
; ----------------------------------------------------------------------------
CHKNUM:
        clc
        .byte   $24

; ----------------------------------------------------------------------------
; MAKE SURE (FAC) IS STRING
; ----------------------------------------------------------------------------
CHKSTR:
        sec

; ----------------------------------------------------------------------------
; MAKE SURE (FAC) IS CORRECT TYPE
; IF C=0, TYPE MUST BE NUMERIC
; IF C=1, TYPE MUST BE STRING
; ----------------------------------------------------------------------------
CHKVAL:
        bit     VALTYP
        bmi     L2C41
        bcs     L2C43
L2C40:
        rts
L2C41:
        bcs     L2C40
L2C43:
        ldx     #ERR_BADTYPE
JERROR:
        jmp     ERROR

; ----------------------------------------------------------------------------
; EVALUATE THE EXPRESSION AT TXTPTR, LEAVING THE
; RESULT IN FAC.  WORKS FOR BOTH STRING AND NUMERIC
; EXPRESSIONS.
; ----------------------------------------------------------------------------
FRMEVL:
        ldx     TXTPTR
        bne     L2C4E
        dec     TXTPTR+1
L2C4E:
        dec     TXTPTR
        ldx     #$00
        .byte   $24
FRMEVL1:
        pha
        txa
        pha
        lda     #$01
        jsr     CHKMEM
        jsr     FRM_ELEMENT
        lda     #$00
        sta     CPRTYP
FRMEVL2:
        jsr     CHRGOT
L2C65:
        sec
        sbc     #TOKEN_GREATER
        bcc     L2C81
        cmp     #$03
        bcs     L2C81
        cmp     #$01
        rol     a
        eor     #$01
        eor     CPRTYP
        cmp     CPRTYP
        bcc     SNTXERR
        sta     CPRTYP
        jsr     CHRGET
        jmp     L2C65
L2C81:
        ldx     CPRTYP
        bne     FRM_RELATIONAL
        bcs     L2D02
        adc     #$07
        bcc     L2D02
        adc     VALTYP
        bne     L2C92
        jmp     CAT
L2C92:
        adc     #$FF
        sta     INDEX
        asl     a
        adc     INDEX
        tay
FRM_PRECEDENCE_TEST:
        pla
        cmp     MATHTBL,y
        bcs     FRM_PERFORM1
        jsr     CHKNUM
L2CA3:
        pha
L2CA4:
        jsr     FRM_RECURSE
        pla
        ldy     LASTOP
        bpl     PREFNC
        tax
        beq     GOEX
        bne     FRM_PERFORM2

; ----------------------------------------------------------------------------
; FOUND ONE OR MORE RELATIONAL OPERATORS <,=,>
; ----------------------------------------------------------------------------
FRM_RELATIONAL:
        lsr     VALTYP
        txa
        rol     a
        ldx     TXTPTR
        bne     L2CBB
        dec     TXTPTR+1
L2CBB:
        dec     TXTPTR
        ldy     #$1B
        sta     CPRTYP
        bne     FRM_PRECEDENCE_TEST
PREFNC:
        cmp     MATHTBL,y
        bcs     FRM_PERFORM2
        bcc     L2CA3

; ----------------------------------------------------------------------------
; STACK THIS OPERATION AND CALL FRMEVL FOR
; ANOTHER ONE
; ----------------------------------------------------------------------------
FRM_RECURSE:
        lda     MATHTBL+2,y
        pha
        lda     MATHTBL+1,y
        pha
        jsr     FRM_STACK1
        lda     CPRTYP
        jmp     FRMEVL1
SNTXERR:
        jmp     SYNERR

; ----------------------------------------------------------------------------
; STACK (FAC)
; THREE ENTRY POINTS:
; 	1, FROM FRMEVL
;	2, FROM "STEP"
;	3, FROM "FOR"
; ----------------------------------------------------------------------------
FRM_STACK1:
        lda     FACSIGN
        ldx     MATHTBL,y

; ----------------------------------------------------------------------------
; ENTER HERE FROM "STEP", TO PUSH STEP SIGN AND VALUE
; ----------------------------------------------------------------------------
FRM_STACK2:
        tay
        pla
        sta     INDEX
.ifndef KBD
        inc     INDEX ; bug: assumes not on page boundary
.endif
        pla
        sta     INDEX+1
.ifdef KBD
        inc     INDEX
        bne     LEB69
        inc     INDEX+1
LEB69:
.endif
        tya
        pha

; ----------------------------------------------------------------------------
; ENTER HERE FROM "FOR", WITH (INDEX) = STEP,
; TO PUSH INITIAL VALUE OF "FOR" VARIABLE
; ----------------------------------------------------------------------------
FRM_STACK3:
        jsr     ROUND_FAC
.ifndef CONFIG_SMALL
        lda     FAC+4
        pha
.endif
        lda     FAC+3
        pha
        lda     FAC+2
        pha
        lda     FAC+1
        pha
        lda     FAC
        pha
        jmp     (INDEX)
L2D02:
        ldy     #$FF
        pla
GOEX:
        beq     EXIT

; ----------------------------------------------------------------------------
; PERFORM STACKED OPERATION
;
; (A) = PRECEDENCE BYTE
; STACK:  1 -- CPRMASK
;	5 -- (ARG)
;	2 -- ADDR OF PERFORMER
; ----------------------------------------------------------------------------
FRM_PERFORM1:
        cmp     #$64
        beq     L2D0E
        jsr     CHKNUM
L2D0E:
        sty     LASTOP
FRM_PERFORM2:
        pla
        lsr     a
        sta     CPRMASK
        pla
        sta     ARG
        pla
        sta     ARG+1
        pla
        sta     ARG+2
        pla
        sta     ARG+3
        pla
.ifndef CONFIG_SMALL
        sta     ARG+4
        pla
.endif
        sta     ARGSIGN
        eor     FACSIGN
        sta     STRNG1
EXIT:
        lda     FAC
        rts

; ----------------------------------------------------------------------------
; GET ELEMENT IN EXPRESSION
;
; GET VALUE OF VARIABLE OR NUMBER AT TXTPNT, OR POINT
; TO STRING DESCRIPTOR IF A STRING, AND PUT IN FAC.
; ----------------------------------------------------------------------------
FRM_ELEMENT:
        lda     #$00
        sta     VALTYP
L2D31:
        jsr     CHRGET
        bcs     L2D39
L2D36:
        jmp     FIN
L2D39:
        jsr     ISLETC
        bcs     FRM_VARIABLE
.ifdef CONFIG_CBM_ALL
        cmp     #$FF
        bne     LCDC1
        lda     #<CON_PI
        ldy     #>CON_PI
        jsr     LOAD_FAC_FROM_YA
        jmp     CHRGET
CON_PI:
        .byte   $82,$49,$0f,$DA,$A1
LCDC1:
.endif
        cmp     #$2E
        beq     L2D36
        cmp     #TOKEN_MINUS
        beq     MIN
        cmp     #TOKEN_PLUS
        beq     L2D31
        cmp     #$22
        bne     NOT_

; ----------------------------------------------------------------------------
; STRING CONSTANT ELEMENT
;
; SET Y,A = (TXTPTR)+CARRY
; ----------------------------------------------------------------------------
STRTXT:
        lda     TXTPTR
        ldy     TXTPTR+1
        adc     #$00
        bcc     L2D57
        iny
L2D57:
        jsr     STRLIT
        jmp     POINT

; ----------------------------------------------------------------------------
; "NOT" FUNCTION
; IF FAC=0, RETURN FAC=1
; IF FAC<>0, RETURN FAC=0
; ----------------------------------------------------------------------------
NOT_:
        cmp     #TOKEN_NOT
        bne     L2D74
        ldy     #$18
        bne     EQUL

; ----------------------------------------------------------------------------
; COMPARISON FOR EQUALITY (= OPERATOR)
; ALSO USED TO EVALUATE "NOT" FUNCTION
; ----------------------------------------------------------------------------
EQUOP:
        jsr     AYINT
        lda     FAC_LAST
        eor     #$FF
        tay
        lda     FAC_LAST-1
        eor     #$FF
        jmp     GIVAYF
L2D74:
        cmp     #TOKEN_FN
        bne     L2D7B
        jmp     L31F3
L2D7B:
        cmp     #TOKEN_SGN
        bcc     PARCHK
        jmp     UNARY

; ----------------------------------------------------------------------------
; EVALUATE "(EXPRESSION)"
; ----------------------------------------------------------------------------
PARCHK:
        jsr     CHKOPN
        jsr     FRMEVL
CHKCLS:
        lda     #$29
        .byte   $2C
CHKOPN:
        lda     #$28
        .byte   $2C
CHKCOM:
        lda     #$2C

; ----------------------------------------------------------------------------
; UNLESS CHAR AT TXTPTR = (A), SYNTAX ERROR
; ----------------------------------------------------------------------------
SYNCHR:	; XXX all CBM code calls SYNCHR instead of CHKCOM
        ldy     #$00
        cmp     (TXTPTR),y
        bne     SYNERR
        jmp     CHRGET
; ----------------------------------------------------------------------------
SYNERR:
        ldx     #ERR_SYNTAX
        jmp     ERROR
; ----------------------------------------------------------------------------
MIN:
        ldy     #$15
EQUL:
        pla
        pla
        jmp     L2CA4
; ----------------------------------------------------------------------------
FRM_VARIABLE:
        jsr     PTRGET
FRM_VARIABLE_CALL	= *-1
        sta     FAC_LAST-1
        sty     FAC_LAST
.ifdef CONFIG_CBM_ALL
        lda     VARNAM
        ldy     VARNAM+1
.endif
        ldx     VALTYP
        beq     L2DB1
.ifdef CONFIG_CBM_ALL
.ifdef CONFIG_CBM1_PATCHES
        jmp     PATCH2
        clc
LCE3B:
.else
        ldx     #$00
        stx     $6D
        bit     $62
        bpl     LCE53
        cmp     #$54
        bne     LCE53
.endif
        cpy     #$C9
        bne     LCE53
        jsr     LCE76
        sty     EXPON
        dey
        sty     STRNG2
        ldy     #$06
        sty     INDX
        ldy     #$24
        jsr     LDD3A
        jmp     LD353
LCE53:
.endif
.ifdef KBD
        ldx     #$00
        stx     STRNG1+1
.endif
        rts
L2DB1:
.ifndef CONFIG_SMALL
        ldx     VALTYP+1
        bpl     L2DC2
        ldy     #$00
        lda     (FAC+3),y
        tax
        iny
        lda     (FAC+3),y
        tay
        txa
        jmp     GIVAYF
L2DC2:
.endif
.ifdef CONFIG_CBM1_PATCHES
        jmp     PATCH3
.endif
.ifdef CBM2
        bit     $62
        bpl     LCE90
        cmp     #$54
        bne     LCE82
.endif
.ifndef CONFIG_CBM_ALL
        jmp     LOAD_FAC_FROM_YA
.endif
.ifdef CBM1
        .byte   $19
.endif
.ifdef CONFIG_CBM_ALL
LCE69:
        cpy     #$49
.ifdef CBM1
        bne     LCE82
.else
        bne     LCE90
.endif
        jsr     LCE76
        tya
        ldx     #$A0
        jmp     LDB21
LCE76:
.ifdef CBM1
        lda     #$FE
        ldy     #$01
.else
        lda     #$8B
        ldy     #$00
.endif
        sei
        jsr     LOAD_FAC_FROM_YA
        cli
        sty     FAC+1
        rts
LCE82:
        cmp     #$53
        bne     LCE90
        cpy     #$54
        bne     LCE90
        lda     Z96
        jmp     FLOAT
LCE90:
        lda     FAC+3
        ldy     FAC+4
        jmp     LOAD_FAC_FROM_YA
.endif

; ----------------------------------------------------------------------------
UNARY:
        asl     a
        pha
        tax
        jsr     CHRGET
        cpx     #<(TOKEN_LEFTSTR*2-1)
        bcc     L2DEF
        jsr     CHKOPN
        jsr     FRMEVL
        jsr     CHKCOM
        jsr     CHKSTR
        pla
        tax
        lda     FAC_LAST
        pha
        lda     FAC_LAST-1
        pha
        txa
        pha
        jsr     GETBYT
        pla
        tay
        txa
        pha
        jmp     L2DF4
L2DEF:
        jsr     PARCHK
        pla
        tay
L2DF4:
        lda     UNFNC-TOKEN_SGN-TOKEN_SGN+$100,y
        sta     JMPADRS+1
        lda     UNFNC-TOKEN_SGN-TOKEN_SGN+$101,y
        sta     JMPADRS+2
.ifdef KBD
        jsr     LF47D
.else
        jsr     JMPADRS
.endif
        jmp     CHKNUM

; ----------------------------------------------------------------------------
OR:
        ldy     #$FF
        .byte   $2C
; ----------------------------------------------------------------------------
TAND:
        ldy     #$00
        sty     EOLPNTR
        jsr     AYINT
        lda     FAC_LAST-1
        eor     EOLPNTR
        sta     CHARAC
        lda     FAC_LAST
        eor     EOLPNTR
        sta     ENDCHR
        jsr     COPY_ARG_TO_FAC
        jsr     AYINT
        lda     FAC_LAST
        eor     EOLPNTR
        and     ENDCHR
        eor     EOLPNTR
        tay
        lda     FAC_LAST-1
        eor     EOLPNTR
        and     CHARAC
        eor     EOLPNTR
        jmp     GIVAYF

; ----------------------------------------------------------------------------
; PERFORM RELATIONAL OPERATIONS
; ----------------------------------------------------------------------------
RELOPS:
        jsr     CHKVAL
        bcs     STRCMP
        lda     ARGSIGN
        ora     #$7F
        and     ARG+1
        sta     ARG+1
        lda     #<ARG
        ldy     #$00
        jsr     FCOMP
        tax
        jmp     NUMCMP

; ----------------------------------------------------------------------------
; STRING COMPARISON
; ----------------------------------------------------------------------------
STRCMP:
        lda     #$00
        sta     VALTYP
        dec     CPRTYP
        jsr     FREFAC
        sta     FAC
        stx     FAC+1
        sty     FAC+2
        lda     ARG_LAST-1
        ldy     ARG_LAST
        jsr     FRETMP
        stx     ARG_LAST-1
        sty     ARG_LAST
        tax
        sec
        sbc     FAC
        beq     L2E74
        lda     #$01
        bcc     L2E74
        ldx     FAC
        lda     #$FF
L2E74:
        sta     FACSIGN
        ldy     #$FF
        inx
STRCMP1:
        iny
        dex
        bne     L2E84
        ldx     FACSIGN
NUMCMP:
        bmi     CMPDONE
        clc
        bcc     CMPDONE
L2E84:
        lda     (ARG_LAST-1),y
        cmp     (FAC+1),y
        beq     STRCMP1
        ldx     #$FF
        bcs     CMPDONE
        ldx     #$01
CMPDONE:
        inx
        txa
        rol     a
        and     CPRMASK
        beq     L2E99
        lda     #$FF
L2E99:
        jmp     FLOAT

; ----------------------------------------------------------------------------
; "DIM" STATEMENT
; ----------------------------------------------------------------------------
NXDIM:
        jsr     CHKCOM
DIM:
        tax
        jsr     PTRGET2
        jsr     CHRGOT
        bne     NXDIM
        rts

; ----------------------------------------------------------------------------
; PTRGET -- GENERAL VARIABLE SCAN
;
; SCANS VARIABLE NAME AT TXTPTR, AND SEARCHES THE
; VARTAB AND ARYTAB FOR THE NAME.
; IF NOT FOUND, CREATE VARIABLE OF APPROPRIATE TYPE.
; RETURN WITH ADDRESS IN VARPNT AND Y,A
;
; ACTUAL ACTIVITY CONTROLLED SOMEWHAT BY TWO FLAGS:
;	DIMFLG -- NONZERO IF CALLED FROM "DIM"
;		ELSE = 0
;
;	SUBFLG -- = $00
;		= $40 IF CALLED FROM "GETARYPT"
; ----------------------------------------------------------------------------
PTRGET:
        ldx     #$00
        jsr     CHRGOT
PTRGET2:
        stx     DIMFLG
PTRGET3:
        sta     VARNAM
        jsr     CHRGOT
        jsr     ISLETC
        bcs     NAMOK
SYNERR3:
        jmp     SYNERR
NAMOK:
        ldx     #$00
        stx     VALTYP
.ifndef CONFIG_SMALL
        stx     VALTYP+1
.endif
        jsr     CHRGET
        bcc     L2ECD
        jsr     ISLETC
        bcc     L2ED8
L2ECD:
        tax
L2ECE:
        jsr     CHRGET
        bcc     L2ECE
        jsr     ISLETC
        bcs     L2ECE
L2ED8:
        cmp     #$24
.ifdef CONFIG_SMALL
        bne     L2EF9
.else
        bne     L2EE2
.endif
        lda     #$FF
        sta     VALTYP
.ifndef CONFIG_SMALL
        bne     L2EF2
L2EE2:
        cmp     #$25
        bne     L2EF9
        lda     SUBFLG
        bne     SYNERR3
        lda     #$80
        sta     VALTYP+1
        ora     VARNAM
        sta     VARNAM
L2EF2:
.endif
        txa
        ora     #$80
        tax
        jsr     CHRGET
L2EF9:
        stx     VARNAM+1
        sec
        ora     SUBFLG
        sbc     #$28
        bne     L2F05
        jmp     ARRAY
L2F05:
        lda     #$00
        sta     SUBFLG
        lda     VARTAB
        ldx     VARTAB+1
        ldy     #$00
L2F0F:
        stx     LOWTR+1
L2F11:
        sta     LOWTR
        cpx     ARYTAB+1
        bne     L2F1B
        cmp     ARYTAB
        beq     NAMENOTFOUND
L2F1B:
        lda     VARNAM
        cmp     (LOWTR),y
        bne     L2F29
        lda     VARNAM+1
        iny
        cmp     (LOWTR),y
        beq     SET_VARPNT_AND_YA
        dey
L2F29:
        clc
        lda     LOWTR
        adc     #BYTES_PER_VARIABLE
        bcc     L2F11
        inx
        bne     L2F0F

; ----------------------------------------------------------------------------
; CHECK IF (A) IS ASCII LETTER A-Z
;
; RETURN CARRY = 1 IF A-Z
;	= 0 IF NOT
; ----------------------------------------------------------------------------
ISLETC:
        cmp     #$41
        bcc     L2F3C
        sbc     #$5B
        sec
        sbc     #$A5
L2F3C:
        rts

; ----------------------------------------------------------------------------
; VARIABLE NOT FOUND, SO MAKE ONE
; ----------------------------------------------------------------------------
NAMENOTFOUND:
        pla
        pha
        cmp     #<FRM_VARIABLE_CALL
        bne     MAKENEWVARIABLE
.ifdef CONFIG_SAFE_NAMENOTFOUND
        tsx
        lda     STACK+2,x
        cmp     #>FRM_VARIABLE_CALL
        bne     MAKENEWVARIABLE
.endif
LD015:
        lda     #<C_ZERO
        ldy     #>C_ZERO
        rts

; ----------------------------------------------------------------------------
.ifndef CBM2_KBD
C_ZERO:
        .byte   $00,$00
.endif

; ----------------------------------------------------------------------------
; MAKE A NEW SIMPLE VARIABLE
;
; MOVE ARRAYS UP 7 BYTES TO MAKE ROOM FOR NEW VARIABLE
; ENTER 7-BYTE VARIABLE DATA IN THE HOLE
; ----------------------------------------------------------------------------
MAKENEWVARIABLE:
.ifdef CONFIG_CBM_ALL
        lda     VARNAM
        ldy     VARNAM+1
        cmp     #$54
        bne     LD02F
        cpy     #$C9
        beq     LD015
        cpy     #$49
        bne     LD02F
LD02C:
        jmp     SYNERR
LD02F:
        cmp     #$53
        bne     LD037
        cpy     #$54
        beq     LD02C
LD037:
.endif
        lda     ARYTAB
        ldy     ARYTAB+1
        sta     LOWTR
        sty     LOWTR+1
        lda     STREND
        ldy     STREND+1
        sta     HIGHTR
        sty     HIGHTR+1
        clc
        adc     #BYTES_PER_VARIABLE
        bcc     L2F68
        iny
L2F68:
        sta     HIGHDS
        sty     HIGHDS+1
        jsr     BLTU
        lda     HIGHDS
        ldy     HIGHDS+1
        iny
        sta     ARYTAB
        sty     ARYTAB+1
        ldy     #$00
        lda     VARNAM
        sta     (LOWTR),y
        iny
        lda     VARNAM+1
        sta     (LOWTR),y
        lda     #$00
        iny
        sta     (LOWTR),y
        iny
        sta     (LOWTR),y
        iny
        sta     (LOWTR),y
        iny
        sta     (LOWTR),y
.ifndef CONFIG_SMALL
        iny
        sta     (LOWTR),y
.endif

; ----------------------------------------------------------------------------
; PUT ADDRESS OF VALUE OF VARIABLE IN VARPNT AND Y,A
; ----------------------------------------------------------------------------
SET_VARPNT_AND_YA:
        lda     LOWTR
        clc
        adc     #$02
        ldy     LOWTR+1
        bcc     L2F9E
        iny
L2F9E:
        sta     VARPNT
        sty     VARPNT+1
        rts


.include "array.s"


; ----------------------------------------------------------------------------
; "FRE" FUNCTION
;
; COLLECTS GARBAGE AND RETURNS # BYTES OF MEMORY LEFT
; ----------------------------------------------------------------------------
FRE:
        lda     VALTYP
        beq     L3188
        jsr     FREFAC
L3188:
        jsr     GARBAG
        sec
        lda     FRETOP
        sbc     STREND
        tay
        lda     FRETOP+1
        sbc     STREND+1
; FALL INTO GIVAYF TO FLOAT THE VALUE
; NOTE THAT VALUES OVER 32767 WILL RETURN AS NEGATIVE

; ----------------------------------------------------------------------------
; FLOAT THE SIGNED INTEGER IN A,Y
; ----------------------------------------------------------------------------
GIVAYF:
        ldx     #$00
        stx     VALTYP
        sta     FAC+1
        sty     FAC+2
        ldx     #$90
        jmp     FLOAT1
POS:
        ldy     Z16

; ----------------------------------------------------------------------------
; FLOAT (Y) INTO FAC, GIVING VALUE 0-255
; ----------------------------------------------------------------------------
SNGFLT:
        lda     #$00
        beq     GIVAYF

; ----------------------------------------------------------------------------
; CHECK FOR DIRECT OR RUNNING MODE
; GIVING ERROR IF DIRECT MODE
; ----------------------------------------------------------------------------
ERRDIR:
        ldx     CURLIN+1
        inx
        bne     RTS9
        ldx     #ERR_ILLDIR
.ifdef CBM2_KBD
        .byte   $2C
LD288:
        ldx     #ERR_UNDEFFN
.endif
L31AF:
        jmp     ERROR
DEF:
        jsr     FNC
        jsr     ERRDIR
        jsr     CHKOPN
        lda     #$80
        sta     SUBFLG
        jsr     PTRGET
        jsr     CHKNUM
        jsr     CHKCLS
        lda     #TOKEN_EQUAL
        jsr     SYNCHR
.ifndef CONFIG_SMALL
        pha
.endif
        lda     VARPNT+1
        pha
        lda     VARPNT
        pha
        lda     TXTPTR+1
        pha
        lda     TXTPTR
        pha
        jsr     DATA
        jmp     L3250
FNC:
        lda     #TOKEN_FN
        jsr     SYNCHR
        ora     #$80
        sta     SUBFLG
        jsr     PTRGET3
        sta     FNCNAM
        sty     FNCNAM+1
        jmp     CHKNUM
L31F3:
        jsr     FNC
        lda     FNCNAM+1
        pha
        lda     FNCNAM
        pha
        jsr     PARCHK
        jsr     CHKNUM
        pla
        sta     FNCNAM
        pla
        sta     FNCNAM+1
        ldy     #$02
.ifndef CBM2_KBD
        ldx     #ERR_UNDEFFN
.endif
        lda     (FNCNAM),y
.ifndef CBM2_KBD
        beq     L31AF
.endif
        sta     VARPNT
        tax
        iny
        lda     (FNCNAM),y
.ifdef CBM2_KBD
        beq     LD288
.endif
        sta     VARPNT+1
.ifndef CONFIG_SMALL
        iny
.endif
L3219:
        lda     (VARPNT),y
        pha
        dey
        bpl     L3219
        ldy     VARPNT+1
        jsr     STORE_FAC_AT_YX_ROUNDED
        lda     TXTPTR+1
        pha
        lda     TXTPTR
        pha
        lda     (FNCNAM),y
        sta     TXTPTR
        iny
        lda     (FNCNAM),y
        sta     TXTPTR+1
        lda     VARPNT+1
        pha
        lda     VARPNT
        pha
        jsr     FRMNUM
        pla
        sta     FNCNAM
        pla
        sta     FNCNAM+1
        jsr     CHRGOT
        beq     L324A
        jmp     SYNERR
L324A:
        pla
        sta     TXTPTR
        pla
        sta     TXTPTR+1
L3250:
        ldy     #$00
        pla
        sta     (FNCNAM),y
        pla
        iny
        sta     (FNCNAM),y
        pla
        iny
        sta     (FNCNAM),y
        pla
        iny
        sta     (FNCNAM),y
.ifndef CONFIG_SMALL
        pla
        iny
        sta     (FNCNAM),y
.endif
        rts


.include "string.s"


.ifdef KBD
LF422:
        lda     VARTAB
        sec
        sbc     #$02
        ldy     VARTAB+1
        bcs     LF42C
        dey
LF42C:
        rts
LF42D:
        lda     Z00,x
LF430:
        cmp     #$61
        bcc     LF43A
        cmp     #$7B
        bcs     LF43A
LF438:
        sbc     #$1F
LF43A:
        rts
LF43B:
        ldx     #$5D
LF43D:
        txa
        and     #$7F
        cmp     $0340
        beq     LF44D
        sta     $0340
        lda     #$03
        jsr     LDE48
LF44D:
        jsr     LDE7F
        bne     RTS4
        cpx     #$80
        bcc     LF44D
RTS4:
        rts
LF457:
        lda     TXTTAB
        ldx     TXTTAB+1
LF45B:
        sta     JMPADRS+1
        stx     JMPADRS+2
        ldy     #$01
        lda     (JMPADRS+1),y
        beq     LF438
        iny
        iny
        lda     (JMPADRS+1),y
        dey
        cmp     $14
        bne     LF472
        lda     (JMPADRS+1),y
        cmp     $13
LF472:
        bcs     LF43A
        dey
        lda     (JMPADRS+1),y
        tax
        dey
        lda     (JMPADRS+1),y
        bcc     LF45B
LF47D:
        jmp     (JMPADRS+1)
.else

; ----------------------------------------------------------------------------
; EVALUATE "EXP1,EXP2"
;
; CONVERT EXP1 TO 16-BIT NUMBER IN LINNUM
; CONVERT EXP2 TO 8-BIT NUMBER IN X-REG
; ----------------------------------------------------------------------------
GTNUM:
        jsr     FRMNUM
        jsr     GETADR

; ----------------------------------------------------------------------------
; EVALUATE ",EXPRESSION"
; CONVERT EXPRESSION TO SINGLE BYTE IN X-REG
; ----------------------------------------------------------------------------
COMBYTE:
        jsr     CHKCOM
        jmp     GETBYT

; ----------------------------------------------------------------------------
; CONVERT (FAC) TO A 16-BIT VALUE IN LINNUM
; ----------------------------------------------------------------------------
GETADR:
        lda     FACSIGN
.ifdef APPLE
        nop
        nop
.else
        bmi     GOIQ
.endif
        lda     FAC
        cmp     #$91
        bcs     GOIQ
        jsr     QINT
        lda     FAC_LAST-1
        ldy     FAC_LAST
        sty     LINNUM
        sta     LINNUM+1
        rts


















































; ----------------------------------------------------------------------------
; "PEEK" FUNCTION
; ----------------------------------------------------------------------------
PEEK:
.ifdef CBM2_KBD
        lda     $12
        pha
        lda     $11
        pha
.endif
        jsr     GETADR
        ldy     #$00
.ifdef CBM1
        cmp     #$C0
        bcc     LD6F3
        cmp     #$E1
        bcc     LD6F6
LD6F3:
.endif
.ifdef CBM2_KBD
		nop ; patch that disables the compares above
		nop
		nop
		nop
		nop
		nop
		nop
		nop
.endif
        lda     (LINNUM),y
        tay
.ifdef CBM2_KBD
        pla
        sta     $11
        pla
        sta     $12
.endif
LD6F6:
        jmp     SNGFLT

; ----------------------------------------------------------------------------
; "POKE" STATEMENT
; ----------------------------------------------------------------------------
POKE:
        jsr     GTNUM
        txa
        ldy     #$00
        sta     (LINNUM),y
        rts

; ----------------------------------------------------------------------------
; "WAIT" STATEMENT
; ----------------------------------------------------------------------------
WAIT:
        jsr     GTNUM
        stx     FORPNT
        ldx     #$00
        jsr     CHRGOT
.ifdef CBM2
        beq     EASTER_EGG
.else
        beq     L3628
.endif
        jsr     COMBYTE
L3628:
        stx     FORPNT+1
        ldy     #$00
L362C:
        lda     (LINNUM),y
        eor     FORPNT+1
        and     FORPNT
        beq     L362C
RTS3:
        rts
.endif


.include "float.s"

.include "chrget.s"

.include "rnd.s"

.include "trig.s"

.include "init.s"
