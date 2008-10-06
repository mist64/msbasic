; da65 V2.12.9 - (C) Copyright 2000-2005,  Ullrich von Bassewitz
; Created:    2008-10-05 12:21:17

.ifdef OSI
.include "defines_osi.s"
.endif
.ifdef KIM
.include "defines_kim.s"
.endif
.ifdef CBM
.include "defines_cbm.s"
.endif

.ifdef CBM
CLOSE	:= $AAAA
OPEN	:= $AAAA
SYS	:= $AAAA
CMD	:= $AAAA
PRINTH	:= $AAAA
VERIFY	:= $AAAA
INPUTH	:= $AAAA
LFFCC	:= $AAAA
LC48C	:=	$AAAA
LFFCF	:=	$AAAA
LC9C8	:=	$AAAA
GETLN	:= $AAAA
LFFE7	:= $AAAA
LOAD	:= $AAAA
SAVE	:= $AAAA
LDC50	:= $AAAA
L00CF	:= $00AA
L0071	:= $00AA
LDB6D	:= $AAAA
LD9BF	:= $AAAA
LDADE	:= $AAAA
LD9B4	:= $AAAA
LD130	:= $AAAA
LD57E	:= $AAAA
LC99F	:= $AAAA
LFFC9	:= $AAAA
LCE13	:= $AAAA
LD676	:= $AAAA
LFFD2	:= $AAAA
LE1CC	:= $AAAA
LE1C2	:= $AAAA
LFFC6	:= $AAAA
L00C2	:= $00AA
LC7F0	:= $AAAA
LCAF1	:= $AAAA
LE19B	:= $AAAA
LE1BC	:= $AAAA
LDA74	:= $AAAA
LD353	:= $AAAA
LDD3A	:= $AAAA
LE19F	:= $AAAA
LDB0E	:= $AAAA
LDB21	:= $AAAA
LE7F3	:= $AAAA
LC38B	:= $AAAA
.endif

.include "macros.s"

        .setcpu "6502"
        .segment "BASIC"

STACK           := $0100

TOKEN_ADDRESS_TABLE:
        .word   END-1
        .word   FOR-1
        .word   NEXT-1
        .word   DATA-1
.ifdef CBM
        .word   INPUTH-1
.endif
        .word   INPUT-1
        .word   DIM-1
        .word   READ-1
        .word   LET-1
        .word   GOTO-1
        .word   RUN-1
        .word   IF-1
        .word   RESTORE-1
        .word   GOSUB-1
        .word   POP-1
        .word   REM-1
        .word   STOP-1
        .word   ON-1
.ifndef CBM
        .word   NULL-1
.endif
        .word   WAIT-1
        .word   LOAD-1
        .word   SAVE-1
.ifdef CBM
        .word   VERIFY-1
.endif
        .word   DEF-1
        .word   POKE-1
.ifdef CBM
        .word   PRINTH-1
.endif
        .word   PRINT-1
        .word   CONT-1
        .word   LIST-1
        .word   CLEAR-1
.ifdef CBM
		.word	CMD-1
		.word	SYS-1
		.word	OPEN-1
		.word	CLOSE-1
.endif
.ifdef CONFIG_11
        .word   GET-1
.endif /* CONFIG_11 */
        .word   NEW-1
UNFNC:
        .addr   SGN
        .addr   INT
        .addr   ABS
.ifndef CONFIG_11
        .addr   USR
.else /* CONFIG_11 */
        .addr   IQERR
.endif /* CONFIG_11 */
        .addr   FRE
        .addr   POS
        .addr   SQR
        .addr   RND
        .addr   LOG
        .addr   EXP
        .addr   COS
        .addr   SIN
        .addr   TAN
        .addr   ATN
        .addr   PEEK
        .addr   LEN
        .addr   STR
        .addr   VAL
        .addr   ASC
        .addr   CHRSTR
        .addr   LEFTSTR
        .addr   RIGHTSTR
        .addr   MIDSTR
MATHTBL:
        .byte   $79
        .word   FADDT-1
        .byte   $79
        .word   FSUBT-1
        .byte   $7B
        .word   FMULTT-1
        .byte   $7B
        .word   FDIVT-1
        .byte   $7F
        .word   FPWRT-1
        .byte   $50
        .word   L2E07-1
        .byte   $46
        .word   L2E04-1
        .byte   $7D
        .word   NEGOP-1
        .byte   $5A
        .word   L2D65-1
        .byte   $64
        .word   RELOPS-1
TOKEN_NAME_TABLE:
	htasc	"END"
	htasc	"FOR"
	htasc	"NEXT"
	htasc	"DATA"
.ifdef CBM
	htasc	"INPUT#"
.endif
	htasc	"INPUT"
	htasc	"DIM"
	htasc	"READ"
	htasc	"LET"
	htasc	"GOTO"
	htasc	"RUN"
	htasc	"IF"
	htasc	"RESTORE"
	htasc	"GOSUB"
	htasc	"RETURN"
	htasc	"REM"
	htasc	"STOP"
	htasc	"ON"
.ifndef CBM
	htasc	"NULL"
.endif
	htasc	"WAIT"
	htasc	"LOAD"
	htasc	"SAVE"
.ifdef CBM
	htasc	"VERIFY"
.endif
	htasc	"DEF"
	htasc	"POKE"
.ifdef CBM
	htasc	"PRINT#"
.endif
	htasc	"PRINT"
	htasc	"CONT"
	htasc	"LIST"
.ifdef CBM
	htasc	"CLR"
.else
	htasc	"CLEAR"
.endif
.ifdef CBM
	htasc	"CMD"
	htasc	"SYS"
	htasc	"OPEN"
	htasc	"CLOSE"
.endif
.ifdef CONFIG_11
	htasc	"GET"
.endif /* CONFIG_11 */
	htasc	"NEW"
	htasc	"TAB("
	htasc	"TO"
	htasc	"FN"
	htasc	"SPC("
	htasc	"THEN"
	htasc	"NOT"
	htasc	"STEP"
	htasc	"+"
	htasc	"-"
	htasc	"*"
	htasc	"/"
	htasc	"^"
	htasc	"AND"
	htasc	"OR"
	htasc	">"
	htasc	"="
	htasc	"<"
	htasc	"SGN"
	htasc	"INT"
	htasc	"ABS"
	htasc	"USR"
	htasc	"FRE"
	htasc	"POS"
	htasc	"SQR"
	htasc	"RND"
	htasc	"LOG"
	htasc	"EXP"
	htasc	"COS"
	htasc	"SIN"
	htasc	"TAN"
	htasc	"ATN"
	htasc	"PEEK"
	htasc	"LEN"
	htasc	"STR$"
	htasc	"VAL"
	htasc	"ASC"
	htasc	"CHR$"
	htasc	"LEFT$"
	htasc	"RIGHT$"
	htasc	"MID$"
	.byte   0
ERROR_MESSAGES:
.ifndef CONFIG_11
.define ERRSTR_NOFOR "NF"
.define ERRSTR_SYNTAX "SN"
.define ERRSTR_NOGOSUB "RG"
.define ERRSTR_NODATA "OD"
.define ERRSTR_ILLQTY "FC"
.define ERRSTR_OVERFLOW "OV"
.define ERRSTR_MEMFULL "OM"
.define ERRSTR_UNDEFSTAT "US"
.define ERRSTR_BADSUBS "BS"
.define ERRSTR_REDIMD "DD"
.define ERRSTR_ZERODIV "/0"
.define ERRSTR_ILLDIR "ID"
.define ERRSTR_BADTYPE "TM"
.define ERRSTR_STRLONG "LS"
.define ERRSTR_FRMCPX "ST"
.define ERRSTR_CANTCONT "CN"
.define ERRSTR_UNDEFFN "UF"
.else /* CONFIG_11 */
.define ERRSTR_NOFOR "NEXT WITHOUT FOR"
.define ERRSTR_SYNTAX "SYNTAX"
.define ERRSTR_NOGOSUB "RETURN WITHOUT GOSUB"
.define ERRSTR_NODATA "OUT OF DATA"
.define ERRSTR_ILLQTY "ILLEGAL QUANTITY"
.define ERRSTR_OVERFLOW "OVERFLOW"
.define ERRSTR_MEMFULL "OUT OF MEMORY"
.define ERRSTR_UNDEFSTAT "UNDEF'D STATEMENT"
.define ERRSTR_BADSUBS "BAD SUBSCRIPT"
.define ERRSTR_REDIMD "REDIM'D ARRAY"
.define ERRSTR_ZERODIV "DIVISION BY ZERO"
.define ERRSTR_ILLDIR "ILLEGAL DIRECT"
.define ERRSTR_BADTYPE "TYPE MISMATCH"
.define ERRSTR_STRLONG "STRING TOO LONG"
.ifdef CBM
.define ERRSTR_BADDATA "BAD DATA"
.endif
.define ERRSTR_FRMCPX "FORMULA TOO COMPLEX"
.define ERRSTR_CANTCONT "CAN'T CONTINUE"
.define ERRSTR_UNDEFFN "UNDEF'D FUNCTION"
.endif /* ! CONFIG_11 */

ERR_NOFOR	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_NOFOR
ERR_SYNTAX	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_SYNTAX
ERR_NOGOSUB	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_NOGOSUB
ERR_NODATA	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_NODATA
ERR_ILLQTY	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_ILLQTY
.ifdef CBM
	.byte 0,0,0,0,0
.endif
ERR_OVERFLOW	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_OVERFLOW
ERR_MEMFULL	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_MEMFULL
ERR_UNDEFSTAT	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_UNDEFSTAT
ERR_BADSUBS	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_BADSUBS
ERR_REDIMD	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_REDIMD
ERR_ZERODIV	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_ZERODIV
ERR_ILLDIR	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_ILLDIR
ERR_BADTYPE	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_BADTYPE
ERR_STRLONG	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_STRLONG
.ifdef CBM
ERR_BADDATA	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_BADDATA
.endif
ERR_FRMCPX	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_FRMCPX
ERR_CANTCONT	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_CANTCONT
ERR_UNDEFFN	:= <(*-ERROR_MESSAGES)
	htasc ERRSTR_UNDEFFN
QT_ERROR:
        .byte   " ERROR"
        .byte   $00
QT_IN:
        .byte   " IN "
        .byte   $00
QT_OK:
		.byte   $0D,$0A
.ifdef CBM
        .byte   "READY."
.else
        .byte   "OK"
.endif
        .byte   $0D,$0A,$00
QT_BREAK:
		.byte $0D,$0A
        .byte   "BREAK"
        .byte   $00
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
CHKMEM:
        asl     a
        adc     #SPACE_FOR_GOSUB
        bcs     MEMERR
        sta     INDEX
        tsx
        cpx     INDEX
        bcc     MEMERR
        rts
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
MEMERR:
        ldx     #ERR_MEMFULL
ERROR:
        lsr     Z14
.ifdef CBM
        lda     $03
        beq     L2329
        jsr     LFFCC
        lda     #$00
        sta     $03
LC366:
        jsr     LC9D2
        jsr     OUTDO
.else
        jsr     CRDO
        jsr     OUTQUES
.endif
L2329:
        lda     ERROR_MESSAGES,x
.ifdef CONFIG_11
        pha
        and     #$7F
.endif /* CONFIG_11 */
        jsr     OUTDO
.ifndef CONFIG_11
        lda     ERROR_MESSAGES+1,x
        jsr     OUTDO
.else /* CONFIG_11 */
        inx
        pla
        bpl     L2329
.endif /* CONFIG_11 */
        jsr     STKINI
        lda     #<QT_ERROR
        ldy     #>QT_ERROR
PRINT_ERROR_LINNUM:
        jsr     STROUT
        ldy     CURLIN+1
        iny
        beq     RESTART
        jsr     INPRT
RESTART:
        lsr     Z14
        lda     #<QT_OK
        ldy     #>QT_OK
        jsr     GOWARM
L2351:
        jsr     INLIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
.ifdef KIM
        tax
.endif /* CONFIG_11 */
        beq     L2351
        ldx     #$FF
        stx     CURLIN+1
        bcc     NUMBERED_LINE
        jsr     PARSE_INPUT_LINE
        jmp     NEWSTT2
NUMBERED_LINE:
        jsr     LINGET
        jsr     PARSE_INPUT_LINE
        sty     EOLPNTR
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
PUT_NEW_LINE:
        lda     INPUTBUFFER
        beq     FIX_LINKS
        lda     MEMSIZ
        ldy     MEMSIZ+1
        sta     FRETOP
        sty     FRETOP+1
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
        lda     STREND
        ldy     STREND+1
        sta     VARTAB
        sty     VARTAB+1
        ldy     EOLPNTR
        dey
L23E6:
        lda     Z17,y
        sta     (LOWTR),y
        dey
        bpl     L23E6
FIX_LINKS:
        jsr     SETPTRS
        lda     TXTTAB
        ldy     TXTTAB+1
        sta     INDEX
        sty     INDEX+1
        clc
L23FA:
        ldy     #$01
        lda     (INDEX),y
        bne     L2403
        jmp     L2351
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
L2420:
.ifndef CONFIG_11
        jsr     OUTDO
.endif /* ! CONFIG_11 */
        dex
        bpl     INLIN2
L2423:
.ifndef CONFIG_11
        jsr     OUTDO
.endif /* ! CONFIG_11 */
        jsr     CRDO
INLIN:
        ldx     #$00
INLIN2:
        jsr     GETLN
.ifndef CBM
        cmp     #$07
        beq     L2443
.endif
        cmp     #$0D
        beq     L2453
.ifndef CBM
        cmp     #$20
        bcc     INLIN2
        cmp     #$7D
        bcs     INLIN2
        cmp     #$40
        beq     L2423
        cmp     #$5F
        beq     L2420
L2443:
        cpx     #$47
        bcs     L244C
.endif
        sta     INPUTBUFFER,x
        inx
.ifndef CONFIG_11
        .byte   $2C
.else /* CONFIG_11 */
        bne     INLIN2
.endif /* CONFIG_11 */
L244C:
.ifndef CBM
        lda     #$07
        jsr     OUTDO
        bne     INLIN2
.endif
L2453:
        jmp     L29B9
.ifdef CBM
        jsr     LFFCF
        ldy     $03
        bne     L2465
.else
GETLN:
        jsr     MONRDKEY
.endif
.ifndef CONFIG_11
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
.endif /* ! CONFIG_11 */
        cmp     #$0F
        bne     L2465
        pha
        lda     Z14
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts
PARSE_INPUT_LINE:
        ldx     TXTPTR
        ldy     #$04
        sty     DATAFLG
L246C:
        lda     Z00,x
.ifdef CBM
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
        lda     #$97
        bne     L24AC
L2484:
        cmp     #$30
        bcc     L248C
        cmp     #$3C
        bcc     L24AC
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
        lda     Z00,x
        cmp     #$20
        beq     L2497
        sec
        sbc     TOKEN_NAME_TABLE,y
        beq     L2496
        cmp     #$80
        bne     L24D7
        ora     EOLPNTR
L24AA:
        ldy     STRNG2
L24AC:
        inx
        iny
        sta     Z16,y
        lda     Z16,y
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
        sbc     #$54
        bne     L246C
        sta     ENDCHR
L24C8:
        lda     Z00,x
        beq     L24AC
        cmp     ENDCHR
        beq     L24AC
L24D0:
        iny
        sta     Z16,y
        inx
        bne     L24C8
L24D7:
        ldx     TXTPTR
        inc     EOLPNTR
L24DB:
        iny
        lda     MATHTBL+28+1,y
        bpl     L24DB
        lda     TOKEN_NAME_TABLE,y
        bne     L2498
        lda     Z00,x
        bpl     L24AA
L24EA:
        sta     Z18,y
        lda     #INPUTBUFFER-1
        sta     TXTPTR
        rts
FNDLIN:
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
L2520:
        rts
NEW:
        bne     L2520
SCRTCH:
        lda     #$00
        tay
        sta     (TXTTAB),y
        iny
        sta     (TXTTAB),y
        lda     TXTTAB
        adc     #$02
        sta     VARTAB
        lda     TXTTAB+1
        adc     #$00
        sta     VARTAB+1
SETPTRS:
        jsr     STXTPT
.ifdef KIM
        lda     #$00
CLEAR:
        bne     L256A
.endif /* CONFIG_11 */
CLEARC:
        lda     MEMSIZ
        ldy     MEMSIZ+1
        sta     FRETOP
        sty     FRETOP+1
.ifdef CBM
        jsr     LFFE7
.endif
        lda     VARTAB
        ldy     VARTAB+1
        sta     ARYTAB
        sty     ARYTAB+1
        sta     STREND
        sty     STREND+1
        jsr     RESTORE
STKINI:
        ldx     #TEMPST
        stx     TEMPPT
        pla
        sta     STACK+253
        pla
        sta     STACK+254
        ldx     #$FC
        txs
        lda     #$00
        sta     OLDTEXT+1
        sta     SUBFLG
L256A:
        rts
STXTPT:
        clc
        lda     TXTTAB
        adc     #$FF
        sta     TXTPTR
        lda     TXTTAB+1
        adc     #$FF
        sta     TXTPTR+1
        rts
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
        ldy     #$01
.ifndef KIM
        sty     DATAFLG
.endif /* ! CONFIG_11 */
        lda     (LOWTR),y
        beq     L25E5
        jsr     ISCNTC
        jsr     CRDO
        iny
        lda     (LOWTR),y
        tax
        iny
        lda     (LOWTR),y
        cmp     LINNUM+1
        bne     L25C1
        cpx     LINNUM
        beq     L25C3
L25C1:
        bcs     L25E5
L25C3:
        sty     FORPNT
        jsr     LINPRT
        lda     #$20
L25CA:
        ldy     FORPNT
        and     #$7F
L25CE:
        jsr     OUTDO
.ifndef KIM
        cmp     #$22
        bne     LA519
        lda     DATAFLG
        eor     #$FF
        sta     DATAFLG
LA519:
.endif /* ! CONFIG_11 */
        iny
.ifdef KIM
        beq     L25E5
.endif /* CONFIG_11 */
        lda     (LOWTR),y
        bne     L25E8
        tay
        lda     (LOWTR),y
        tax
        iny
        lda     (LOWTR),y
        stx     LOWTR
        sta     LOWTR+1
        bne     L25A6
L25E5:
        jmp     RESTART
L25E8:
        bpl     L25CE
.ifndef KIM
        cmp     #$FF
        beq     L25CE
        bit     DATAFLG
        bmi     L25CE
.endif /* ! CONFIG_11 */
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
        jmp     L2CED
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
NEWSTT:
        jsr     ISCNTC
        lda     TXTPTR
        ldy     TXTPTR+1
        beq     L2683
        sta     OLDTEXT
        sty     OLDTEXT+1
        ldy     #$00
L2683:
        lda     (TXTPTR),y
.ifndef KIM
        beq     LA5DC
        cmp     #$3A
        beq     NEWSTT2
SYNERR1:
        jmp     SYNERR
LA5DC:
.else /* CONFIG_11 */
        bne     COLON
.endif /* CONFIG_11 */
        ldy     #$02
        lda     (TXTPTR),y
        clc
        beq     L2701
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
EXECUTE_STATEMENT:
.ifndef KIM
        beq     RET1
        sec
.else /* CONFIG_11 */
        beq     RET2
.endif /* CONFIG_11 */
EXECUTE_STATEMENT1:
        sbc     #$80
.ifndef KIM
        bcs     LA609
        jmp     LET
LA609:
.else /* CONFIG_11 */
        bcc     LET1
.endif /* CONFIG_11 */
        cmp     #NUM_TOKENS
        bcs     SYNERR1
        asl     a
        tay
        lda     TOKEN_ADDRESS_TABLE+1,y
        pha
        lda     TOKEN_ADDRESS_TABLE,y
        pha
        jmp     CHRGET
.ifdef KIM
LET1:
        jmp     LET
COLON:
        cmp     #$3A
        beq     NEWSTT2
SYNERR1:
        jmp     SYNERR
.endif /* CONFIG_11 */
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
ISCNTC:
.ifdef OSI
        jmp     MONISCNTC
        nop
        nop
        nop
        nop
        lsr     a
        bcc     RET2
        jsr     GETLN
.endif
.ifdef KIM
        lda     #$01
        bit     $1740
        bmi     RET2
        ldx     #$08
        lda     #$03
        clc
.endif /* KIM */
.ifndef CBM
        cmp     #$03
.endif
STOP:
        bcs     END2
END:
        clc
END2:
        bne     RET1
        lda     TXTPTR
        ldy     TXTPTR+1
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
        ldx     #$00
        stx     Z14
        bcc     L270E
        jmp     PRINT_ERROR_LINNUM
L270E:
        jmp     RESTART
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
.ifndef KIM
CLEAR:
        bne     RET1
        jmp     CLEARC
.else /* CONFIG_11 */
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
        lda     #$70
        ldy     #$27
        jmp     STROUT
        .byte   "LOADED"
        .byte   $00
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
        ldy     #$27
        sta     L0001
        sty     L0002
        jmp     L1873
        ldx     #$FF
        txs
        lda     #$48
        ldy     #$23
        sta     L0001
        sty     L0002
        lda     #$69
        ldy     #$27
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
.endif /* CONFIG_11 */
RUN:
        bne     L27CF
        jmp     SETPTRS
L27CF:
        jsr     CLEARC
        jmp     L27E9
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
        lda     #$8C
        pha
L27E9:
        jsr     CHRGOT
        jsr     GOTO
        jmp     NEWSTT
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
        jsr     FL1
        bcc     UNDERR
        lda     LOWTR
        sbc     #$01
        sta     TXTPTR
        lda     LOWTR+1
        sbc     #$00
        sta     TXTPTR+1
L281E:
        rts
POP:
        bne     L281E
        lda     #$FF
        sta     FORPNT
        jsr     GTFORPNT
        txs
        cmp     #$8C
        beq     RETURN
        ldx     #ERR_NOGOSUB
        .byte   $2C
UNDERR:
        ldx     #ERR_UNDEFSTAT
        jmp     ERROR
SYNERR2:
        jmp     SYNERR
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
DATA:
        jsr     DATAN
ADDON:
        tya
        clc
        adc     TXTPTR
        sta     TXTPTR
        bcc     L2852
        inc     TXTPTR+1
L2852:
        rts
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
.ifndef KIM
        beq     L285E
        bne     L2866
.else
        bne     L2866
        beq     L285E
.endif /* CONFIG_11 */
IF:
        jsr     FRMEVL
        jsr     CHRGOT
        cmp     #$88
        beq     L2884
        lda     #TOKEN_THEN
        jsr     SYNCHR
L2884:
        lda     FAC
        bne     L288D
REM:
        jsr     REMN
        beq     ADDON
L288D:
        jsr     CHRGOT
        bcs     L2895
        jmp     GOTO
L2895:
        jmp     EXECUTE_STATEMENT
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
LET:
        jsr     PTRGET
        sta     FORPNT
        sty     FORPNT+1
        lda     #TOKEN_EQUAL
        jsr     SYNCHR
.ifdef CONFIG_11
        lda     VALTYP+1
        pha
.endif /* CONFIG_11 */
        lda     VALTYP
        pha
        jsr     FRMEVL
        pla
        rol     a
        jsr     CHKVAL
        bne     LETSTRING
.ifdef CONFIG_11
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
.endif /* CONFIG_11 */
        jmp     SETFOR
LETSTRING:
.ifdef CONFIG_11
        pla
PUTSTR:
.endif /* CONFIG_11 */
.ifdef CBM
        ldy     $99
        cpy     #$D0
        bne     LC92B
        jsr     LD57E
        cmp     #$06
        beq     LC8E2
        jmp     LD130
LC8E2:
        ldy     #$00
        sty     $B0
        sty     $B5
LC8E8:
        sty     $C0
        jsr     LC91C
        jsr     LD9B4
        inc     $C0
        ldy     $C0
        jsr     LC91C
        jsr     LDADE
        tax
        beq     LC902
        inx
        txa
        jsr     LD9BF
LC902:
        ldy     $C0
        iny
        cpy     #$06
        bne     LC8E8
        jsr     LD9B4
        jsr     LDB6D
        ldx     #$02
        sei
LC912:
        lda     $B2,x
        sta     $0200,x
        dex
        bpl     LC912
        cli
        rts
LC91C:
        lda     (L0071),y
        jsr     L00CF
        bcc     LC926
        jmp     LD130
LC926:
        sbc     #$2F
        jmp     LDC50
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
.ifndef CONFIG_11
        lda     #$AC
.else /* CONFIG_11 */
        lda     #$AE
.endif /* CONFIG_11 */
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
.ifdef CBM
LC97F:
        jsr     LC985
        jmp     LCAD6
LC985:
        jsr     LD676
        beq     LC98F
        lda     #$2C
        jsr     LCE13
LC98F:
        php
        jsr     LFFC9
        stx     $03
        plp
        jmp     LC99F
.endif
PRSTRING:
        jsr     STRPRT
L297E:
        jsr     CHRGOT
PRINT:
        beq     CRDO
PRINT2:
        beq     L29DD
        cmp     #TOKEN_TAB
        beq     L29F5
        cmp     #TOKEN_SPC
        beq     L29F5
        cmp     #','
.ifdef KIM
        clc
.endif /* CONFIG_11 */
        beq     L29DE
        cmp     #$3B
        beq     L2A0D
        jsr     FRMEVL
        bit     VALTYP
        bmi     PRSTRING
        jsr     FOUT
        jsr     STRLIT
.ifndef CBM
        ldy     #$00
        lda     (FAC_LAST-1),y
        clc
        adc     Z16
        cmp     Z17
        bcc     L29B1
        jsr     CRDO
L29B1:
.endif
        jsr     STRPRT
        jsr     OUTSP
        bne     L297E
L29B9:
        ldy     #$00
        sty     INPUTBUFFER,x
.ifdef OSI
        ldx     #$12
.endif
.ifdef KIM
        ldx     #$1A
.endif /* CONFIG_11 */
.ifdef CBM
        ldx     #$09
        lda     $03
        bne     L29DD
LC9D2:
        lda     $03
        bne     LC9D8
        sta     $05
LC9D8:
.endif
CRDO:
        lda     #$0D
.ifndef CBM
        sta     Z16
.endif
        jsr     OUTDO
        lda     #$0A
        jsr     OUTDO
PRINTNULLS:
.ifdef CBM
        lda     $03
        bne     L29DD
.endif
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
L29DD:
        rts
L29DE:
        lda     Z16
.ifndef CBM
        cmp     Z18
        bcc     L29EA
        jsr     CRDO
        jmp     L2A0D
L29EA:
.endif
        sec
L29EB:
.ifdef CBM
        sbc     #$0A
.else
        sbc     #$0E
.endif
        bcs     L29EB
        eor     #$FF
        adc     #$01
        bne     L2A08
L29F5:
.ifndef KIM
        pha
.else /* CONFIG_11 */
        php
.endif /* CONFIG_11 */
        jsr     GTBYTC
        cmp     #$29
.ifndef KIM
.ifdef CBM
.byte $AA, $AA; XXX fixme
.else
        bne     L2A00
.endif
        pla
        cmp     #TOKEN_TAB
        bne     L2A0A
.else /* CONFIG_11 */
        beq     @1
        jmp     SYNERR
@1:
        plp	;; XXX c64 has this
        bcc     L2A09
.endif /* CONFIG_11 */
        txa
        sbc     Z16
        bcc     L2A0D
.ifndef KIM
        beq     L2A0D
.endif /* ! CONFIG_11 */
L2A08:
        tax
.ifdef KIM
L2A09:
        inx
.endif /* CONFIG_11 */
L2A0A:
.ifndef KIM
        jsr     OUTSP
.endif /* ! CONFIG_11 */
        dex
.ifndef KIM
        bne     L2A0A
.else /* CONFIG_11 */
        bne     L2A13
.endif /* CONFIG_11 */
L2A0D:
        jsr     CHRGET
        jmp     PRINT2
.ifdef KIM
L2A13:
        jsr     OUTSP
        bne     L2A0A
.endif /* CONFIG_11 */
STROUT:
        jsr     STRLIT
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
OUTSP:
.ifdef CBM
        lda     #$1D
.else
        lda     #$20
.endif
        .byte   $2C
OUTQUES:
        lda     #$3F
OUTDO:
        bit     Z14
        bmi     L2A56
        pha
.ifdef CBM
        cmp     #$1D
        beq     LCA6A
        cmp     #$9D
        beq     LCA5A
        cmp     #$14
        bne     LCA64
LCA5A:
        lda     $05
        beq     L2A4E
        lda     $03
        bne     L2A4E
        dec     $05
LCA64:
        and     #$7F
.endif
        cmp     #$20
        bcc     L2A4E
LCA6A:
.ifdef CBM
        lda     $03
        jsr     LE1CC
        nop
.else
        lda     Z16
        cmp     Z17
        bne     L2A4C
        jsr     CRDO
L2A4C:
        inc     Z16
.endif
L2A4E:
        pla
.ifdef OSI
        jsr     LFFEE
        nop
        nop
        nop
        nop
.endif
.ifdef KIM
        sty     DIMFLG
        jsr     MONCOUT
        ldy     DIMFLG
.endif
.ifdef CBM
        jsr     LFFD2
.endif
L2A56:
        and     #$FF
        rts
L2A59:
        lda     INPUTFLG
        beq     L2A6E
.ifdef KIM
        bmi     L2A63
        ldy     #$FF
        bne     L2A67
L2A63:
.endif /* CONFIG_11 */
.ifdef CBM
        jsr     LE1C2
		nop
.else
        lda     Z8C
        ldy     Z8C+1
.endif
L2A67:
        sta     CURLIN
        sty     CURLIN+1
L2A00:
        jmp     SYNERR
L2A6E:
.ifdef CBM
        lda     $03
        beq     LCA8F
        ldx     #$C4 ;; XXX
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
        rts
.ifdef CONFIG_11
GET:
        jsr     ERRDIR
.ifdef CBM
        cmp     #$23
        bne     LCAB6
        jsr     L00C2
        jsr     LD676
        lda     #$2C
        jsr     LCE13
        jsr     LFFC6
        stx     $03
LCAB6:
.endif
        ldx     #$1C
        ldy     #$00
        sty     $1C
        lda     #$40
        jsr     PROCESS_INPUT_LIST
.ifdef CBM
        ldx     $03
        bne     LCAD8
.endif
        rts
.endif /* CONFIG_G11 */
.ifdef CBM
LCAC6:
        jsr     LD676
        lda     #$2C
        jsr     LCE13
        jsr     LFFC6
        stx     $03
        jsr     LCAF1
LCAD6:
        lda     $03
LCAD8:
        jsr     LFFCC
        ldx     #$00
        stx     $03
        rts
LCAE0:
.endif
INPUT:
        lsr     Z14
        cmp     #$22
        bne     L2A9E
        jsr     STRTXT
        lda     #$3B
        jsr     SYNCHR
        jsr     STRPRT
L2A9E:
        jsr     ERRDIR
        lda     #$2C
        sta     LINNUM+1
LCAF8:
        jsr     NXIN
.ifdef CBM
        lda     $03
        beq     LCB0C
        lda     $020C
        and     #$02
        beq     LCB0C
        jsr     LCAD6
        jmp     LC7F0
LCB0C:
.endif
        lda     INPUTBUFFER
        bne     L2ABE
.ifdef CBM
        lda     $03
        bne     LCAF8
        jmp     LE19B
LCB17:
        lda     $03
        bne     LCB21
.else
        clc
        jmp     CONTROL_C_TYPED
.endif
NXIN:
        jsr     OUTQUES
        jsr     OUTSP
LCB21:
        jmp     INLIN
READ:
        ldx     DATPTR
        ldy     DATPTR+1
        .byte   $A9
L2ABE:
        tya
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
        sta     LINNUM
        sty     LINNUM+1
        ldx     INPTR
        ldy     INPTR+1
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        bne     INSTART
        bit     INPUTFLG
.ifdef CONFIG_11
        bvc     L2AF0
        jsr     MONRDKEY
        sta     INPUTBUFFER
        ldx     #<INPUTBUFFER-1
        ldy     #0
        bne     L2AF8
L2AF0:
.endif /* CONFIG_11 */
        bmi     FINDATA
.ifdef CBM
        lda     $03
        bne     LCB64
.endif
        jsr     OUTQUES
LCB64:
        jsr     NXIN
L2AF8:
        stx     TXTPTR
        sty     TXTPTR+1
INSTART:
        jsr     CHRGET
        bit     VALTYP
        bpl     L2B34
.ifdef CONFIG_11
        bit     INPUTFLG
        bvc     L2B10
.ifdef CBM
        lda     #$00
        jsr     LE1BC
        nop
.else
        inx
        stx     TXTPTR
        lda     #$00
        sta     CHARAC
        beq     L2B1C
.endif
L2B10:
.endif /* CONFIG_11 */
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
.ifndef CONFIG_11
        jsr     LETSTRING
.else /* CONFIG_11 */
        jsr     PUTSTR
.endif /* CONFIG_11 */
        jmp     INPUT_MORE
L2B34:
        jsr     FIN
.ifndef CONFIG_11
        jsr     SETFOR
.else /* CONFIG_11 */
        lda     VALTYP+1
        jsr     LET2
.endif /* CONFIG_11 */
INPUT_MORE:
        jsr     CHRGOT
        beq     L2B48
        cmp     #$2C
        beq     L2B48
        jmp     L2A59
L2B48:
        lda     TXTPTR
        ldy     TXTPTR+1
        sta     INPTR
        sty     INPTR+1
        lda     LINNUM
        ldy     LINNUM+1
        sta     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        beq     INPDONE
        jsr     CHKCOM
        jmp     PROCESS_INPUT_ITEM
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
INPDONE:
        lda     INPTR
        ldy     INPTR+1
        ldx     INPUTFLG
.ifndef CONFIG_11
        beq     L2B94
.else /* CONFIG_11 */
        bpl     L2B94
.endif /* CONFIG_11 */
        jmp     SETDA
L2B94:
        ldy     #$00
        lda     (INPTR),y
.ifdef CBM
        beq     L2BA1
        lda     $03
.endif
        beq     L2BA1
        lda     #<ERREXTRA
        ldy     #>ERREXTRA
        jmp     STROUT
L2BA1:
        rts

ERREXTRA:
        .byte   "?EXTRA IGNORED"

        .byte   $0D,$0A,$00
ERRREENTRY:
        .byte   "?REDO FROM START"
        .byte   $0D,$0A,$00
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
        inx
        inx
        inx
        inx
        txa
        inx
        inx
        inx
        inx
        inx
.ifdef CONFIG_11
        inx
.endif /* CONFIG_11 */
        stx     DEST
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
FRMNUM:
        jsr     FRMEVL
CHKNUM:
        clc
        .byte   $24
CHKSTR:
        sec
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
FRM_STACK1:
        lda     FACSIGN
        ldx     MATHTBL,y
FRM_STACK2:
        tay
        pla
        sta     INDEX
        inc     INDEX
        pla
        sta     INDEX+1
        tya
        pha
L2CED:
        jsr     ROUND_FAC
.ifdef CONFIG_11
        lda     FAC+4
        pha
.endif /* CONFIG_11 */
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
.ifdef CONFIG_11
        sta     ARG+4
        pla
.endif /* CONFIG_11 */
        sta     ARGSIGN
        eor     FACSIGN
        sta     STRNG1
EXIT:
        lda     FAC
        rts
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
.ifdef CBM
        cmp     #$FF
        bne     LCDC1
        lda     #<CON_PI
        ldy     #>CON_PI
        jsr     LDA74
        jmp     L00C2
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
STRTXT:
        lda     TXTPTR
        ldy     TXTPTR+1
        adc     #$00
        bcc     L2D57
        iny
L2D57:
        jsr     STRLIT
        jmp     POINT
NOT_:
        cmp     #TOKEN_NOT
        bne     L2D74
        ldy     #$18
        bne     EQUL
L2D65:
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
SYNCHR:
        ldy     #$00
        cmp     (TXTPTR),y
        bne     SYNERR
        jmp     CHRGET
SYNERR:
        ldx     #ERR_SYNTAX
        jmp     ERROR
MIN:
        ldy     #$15
EQUL:
        pla
        pla
        jmp     L2CA4
FRM_VARIABLE:
        jsr     PTRGET
FRM_VARIABLE_CALL	= *-1
        sta     FAC_LAST-1
        sty     FAC_LAST
.ifdef CBM
        lda     $94
        ldy     $95
.endif
        ldx     VALTYP
        beq     L2DB1
.ifdef CBM
        jmp     LE19F
        clc
LCE3B:
        cpy     #$C9
        bne     LCE53
        jsr     LCE76
        sty     $AD
        dey
        sty     $C0
        ldy     #$06
        sty     $AC
        ldy     #$24
        jsr     LDD3A
        jmp     LD353
LCE53:
.endif
        rts
L2DB1:
.ifdef CONFIG_11
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
.endif /* CONFIG_11 */
        jmp     LOAD_FAC_FROM_YA
.ifdef CBM
        .byte   $19
LCE69:
        cpy     #$49
        bne     LCE82
        jsr     LCE76
        tya
        ldx     #$A0
        jmp     LDB21
LCE76:
        lda     #$FE
        ldy     #$01
        sei
        jsr     LDA74
        cli
        sty     $B1
        rts
LCE82:
        cmp     #$53
        bne     LCE90
        cpy     #$54
        bne     LCE90
        lda     $020C
        jmp     LDB0E
LCE90:
        lda     $B3
        ldy     $B4
        jmp     LDA74
.endif
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
        sta     ARGEXTENSION
        jsr     JMPADRS
        jmp     CHKNUM
L2E04:
        ldy     #$FF
        .byte   $2C
L2E07:
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
NXDIM:
        jsr     CHKCOM
DIM:
        tax
        jsr     PTRGET2
        jsr     CHRGOT
        bne     NXDIM
        rts
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
.ifdef CONFIG_11
        stx     VALTYP+1
.endif /* CONFIG_11 */
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
.ifndef CONFIG_11
        bne     L2EF9
.else /* CONFIG_11 */
        bne     L2EE2
.endif /* CONFIG_11 */
        lda     #$FF
        sta     VALTYP
.ifdef CONFIG_11
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
.endif /* CONFIG_11 */
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
ISLETC:
        cmp     #$41
        bcc     L2F3C
        sbc     #$5B
        sec
        sbc     #$A5
L2F3C:
        rts
NAMENOTFOUND:
        pla
        pha
        cmp     #<FRM_VARIABLE_CALL
        bne     MAKENEWVARIABLE
.ifdef KIM
        tsx
        lda     STACK+2,x
        cmp     #>FRM_VARIABLE_CALL
        bne     MAKENEWVARIABLE
.endif /* CONFIG_11 */
LD015:
        lda     #<C_ZERO
        ldy     #>C_ZERO
        rts
C_ZERO:
        .byte   $00,$00
MAKENEWVARIABLE:
.ifdef CBM
        lda     $94
        ldy     $95
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
.ifdef CONFIG_11
        iny
        sta     (LOWTR),y
.endif /* CONFIG_11 */
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
GETARY:
        lda     EOLPNTR
        asl     a
        adc     #$05
        adc     LOWTR
        ldy     LOWTR+1
        bcc     L2FAF
        iny
L2FAF:
        sta     HIGHDS
        sty     HIGHDS+1
        rts
NEG32768:
        .byte   $90,$80,$00,$00
MAKINT:
        jsr     CHRGET
        jsr     FRMNUM
MKINT:
        lda     FACSIGN
        bmi     MI1
AYINT:
        lda     FAC
        cmp     #$90
        bcc     MI2
        lda     #<NEG32768
        ldy     #>NEG32768
        jsr     FCOMP
MI1:
        bne     IQERR
MI2:
        jmp     QINT
ARRAY:
        lda     DIMFLG
.ifdef CONFIG_11
        ora     VALTYP+1
.endif /* CONFIG_11 */
        pha
        lda     VALTYP
        pha
        ldy     #$00
L2FDE:
        tya
        pha
        lda     VARNAM+1
        pha
        lda     VARNAM
        pha
        jsr     MAKINT
        pla
        sta     VARNAM
        pla
        sta     VARNAM+1
        pla
        tay
        tsx
        lda     STACK+2,x
        pha
        lda     STACK+1,x
        pha
        lda     FAC_LAST-1
        sta     STACK+2,x
        lda     FAC_LAST
        sta     STACK+1,x
        iny
        jsr     CHRGOT
        cmp     #$2C
        beq     L2FDE
        sty     EOLPNTR
        jsr     CHKCLS
        pla
        sta     VALTYP
        pla
.ifdef CONFIG_11
        sta     VALTYP+1
        and     #$7F
.endif /* CONFIG_11 */
        sta     DIMFLG
        ldx     ARYTAB
        lda     ARYTAB+1
L301F:
        stx     LOWTR
        sta     LOWTR+1
        cmp     STREND+1
        bne     L302B
        cpx     STREND
        beq     MAKE_NEW_ARRAY
L302B:
        ldy     #$00
        lda     (LOWTR),y
        iny
        cmp     VARNAM
        bne     L303A
        lda     VARNAM+1
        cmp     (LOWTR),y
        beq     USE_OLD_ARRAY
L303A:
        iny
        lda     (LOWTR),y
        clc
        adc     LOWTR
        tax
        iny
        lda     (LOWTR),y
        adc     LOWTR+1
        bcc     L301F
SUBERR:
        ldx     #ERR_BADSUBS
        .byte   $2C
IQERR:
        ldx     #ERR_ILLQTY
JER:
        jmp     ERROR
USE_OLD_ARRAY:
        ldx     #ERR_REDIMD
        lda     DIMFLG
        bne     JER
        jsr     GETARY
        lda     EOLPNTR
        ldy     #$04
        cmp     (LOWTR),y
        bne     SUBERR
        jmp     FIND_ARRAY_ELEMENT
MAKE_NEW_ARRAY:
        jsr     GETARY
        jsr     REASON
        lda     #$00
        tay
        sta     STRNG2+1
        ldx     #BYTES_PER_ELEMENT
.ifndef CONFIG_11
        stx     STRNG2
.endif /* CONFIG_11 */
        lda     VARNAM
        sta     (LOWTR),y
.ifdef CONFIG_11
        bpl     L3078
        dex
L3078:
.endif /* CONFIG_11 */
        iny
        lda     VARNAM+1
        sta     (LOWTR),y
.ifdef CONFIG_11
        bpl     L3081
        dex
        dex
L3081:
        stx     STRNG2
.endif /* CONFIG_11 */
        lda     EOLPNTR
        iny
        iny
        iny
        sta     (LOWTR),y
L308A:
        ldx     #$0B
        lda     #$00
        bit     DIMFLG
        bvc     L309A
        pla
        clc
        adc     #$01
        tax
        pla
        adc     #$00
L309A:
        iny
        sta     (LOWTR),y
        iny
        txa
        sta     (LOWTR),y
        jsr     MULTIPLY_SUBSCRIPT
        stx     STRNG2
        sta     STRNG2+1
        ldy     INDEX
        dec     EOLPNTR
        bne     L308A
        adc     HIGHDS+1
        bcs     GME
        sta     HIGHDS+1
        tay
        txa
        adc     HIGHDS
        bcc     L30BD
        iny
        beq     GME
L30BD:
        jsr     REASON
        sta     STREND
        sty     STREND+1
        lda     #$00
        inc     STRNG2+1
        ldy     STRNG2
        beq     L30D1
L30CC:
        dey
        sta     (HIGHDS),y
        bne     L30CC
L30D1:
        dec     HIGHDS+1
        dec     STRNG2+1
        bne     L30CC
        inc     HIGHDS+1
        sec
        lda     STREND
        sbc     LOWTR
        ldy     #$02
        sta     (LOWTR),y
        lda     STREND+1
        iny
        sbc     LOWTR+1
        sta     (LOWTR),y
        lda     DIMFLG
        bne     RTS9
        iny
FIND_ARRAY_ELEMENT:
        lda     (LOWTR),y
        sta     EOLPNTR
        lda     #$00
        sta     STRNG2
L30F6:
        sta     STRNG2+1
        iny
        pla
        tax
        sta     FAC_LAST-1
        pla
        sta     FAC_LAST
        cmp     (LOWTR),y
        bcc     FAE2
        bne     GSE
        iny
        txa
        cmp     (LOWTR),y
        bcc     FAE3
GSE:
        jmp     SUBERR
GME:
        jmp     MEMERR
FAE2:
        iny
FAE3:
        lda     STRNG2+1
        ora     STRNG2
        clc
        beq     L3124
        jsr     MULTIPLY_SUBSCRIPT
        txa
        adc     FAC_LAST-1
        tax
        tya
        ldy     INDEX
L3124:
        adc     FAC_LAST
        stx     STRNG2
        dec     EOLPNTR
        bne     L30F6
.ifndef CONFIG_11
        asl     STRNG2
        rol     a
        bcs     GSE
        asl     STRNG2
        rol     a
        bcs     GSE
        tay
        lda     STRNG2
.else /* CONFIG_11 */
.ifndef CBM
        sta     STRNG2+1
.endif
        ldx     #$05
        lda     VARNAM
        bpl     L3135
        dex
L3135:
        lda     VARNAM+1
        bpl     L313B
        dex
        dex
L313B:
        stx     RESULT+2
        lda     #$00
        jsr     MULTIPLY_SUBS1
        txa
.endif /* CONFIG_11 */
        adc     HIGHDS
        sta     VARPNT
        tya
        adc     HIGHDS+1
        sta     VARPNT+1
        tay
        lda     VARPNT
RTS9:
        rts
MULTIPLY_SUBSCRIPT:
        sty     INDEX
        lda     (LOWTR),y
        sta     RESULT_LAST-2
        dey
        lda     (LOWTR),y
MULTIPLY_SUBS1:
        sta     RESULT_LAST-1
        lda     #$10
        sta     INDX
        ldx     #$00
        ldy     #$00
L3163:
        txa
        asl     a
        tax
        tya
        rol     a
        tay
        bcs     GME
        asl     STRNG2
        rol     STRNG2+1
        bcc     L317C
        clc
        txa
        adc     RESULT_LAST-2
        tax
        tya
        adc     RESULT_LAST-1
        tay
        bcs     GME
L317C:
        dec     INDX
        bne     L3163
        rts
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
GIVAYF:
        ldx     #$00
        stx     VALTYP
        sta     FAC+1
        sty     FAC+2
        ldx     #$90
        jmp     FLOAT1
POS:
        ldy     Z16
SNGFLT:
        lda     #$00
        beq     GIVAYF
ERRDIR:
        ldx     CURLIN+1
        inx
        bne     RTS9
        ldx     #ERR_ILLDIR
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
.ifdef CONFIG_11
        pha
.endif /* CONFIG_11 */
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
        ldx     #ERR_UNDEFFN
        lda     (FNCNAM),y
        beq     L31AF
        sta     VARPNT
        tax
        iny
        lda     (FNCNAM),y
        sta     VARPNT+1
.ifdef CONFIG_11
        iny
.endif /* CONFIG_11 */
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
.ifdef CONFIG_11
        pla
        iny
        sta     (FNCNAM),y
.endif /* CONFIG_11 */
        rts
STR:
        jsr     CHKNUM
        ldy     #$00
        jsr     FOUT1
        pla
        pla
        lda     #$FF
        ldy     #$00
        beq     STRLIT
STRINI:
        ldx     FAC_LAST-1
        ldy     FAC_LAST
        stx     DSCPTR
        sty     DSCPTR+1
STRSPA:
        jsr     GETSPA
        stx     FAC+1
        sty     FAC+2
        sta     FAC
        rts
STRLIT:
        ldx     #$22
        stx     CHARAC
        stx     ENDCHR
STRLT2:
        sta     STRNG1
        sty     STRNG1+1
        sta     FAC+1
        sty     FAC+2
        ldy     #$FF
L3298:
        iny
        lda     (STRNG1),y
        beq     L32A9
        cmp     CHARAC
        beq     L32A5
        cmp     ENDCHR
        bne     L3298
L32A5:
        cmp     #$22
        beq     L32AA
L32A9:
        clc
L32AA:
        sty     FAC
        tya
        adc     STRNG1
        sta     STRNG2
        ldx     STRNG1+1
        bcc     L32B6
        inx
L32B6:
        stx     STRNG2+1
        lda     STRNG1+1
        bne     PUTNEW
        tya
        jsr     STRINI
        ldx     STRNG1
        ldy     STRNG1+1
        jsr     MOVSTR
PUTNEW:
        ldx     TEMPPT
        cpx     #TEMPST+9
        bne     PUTEMP
        ldx     #ERR_FRMCPX
JERR:
        jmp     ERROR
PUTEMP:
        lda     FAC
        sta     0,x
        lda     FAC+1
        sta     1,x
        lda     FAC+2
        sta     2,x
        ldy     #$00
        stx     FAC_LAST-1
        sty     FAC_LAST
        dey
        sty     VALTYP
        stx     LASTPT
        inx
        inx
        inx
        stx     TEMPPT
        rts
GETSPA:
        lsr     DATAFLG
L32F1:
        pha
        eor     #$FF
        sec
        adc     FRETOP
        ldy     FRETOP+1
        bcs     L32FC
        dey
L32FC:
        cpy     STREND+1
        bcc     L3311
        bne     L3306
        cmp     STREND
        bcc     L3311
L3306:
        sta     FRETOP
        sty     FRETOP+1
        sta     FRESPC
        sty     FRESPC+1
        tax
        pla
        rts
L3311:
        ldx     #ERR_MEMFULL
        lda     DATAFLG
        bmi     JERR
        jsr     GARBAG
        lda     #$80
        sta     DATAFLG
        pla
        bne     L32F1
GARBAG:
        ldx     MEMSIZ
        lda     MEMSIZ+1
FINDHIGHESTSTRING:
        stx     FRETOP
        sta     FRETOP+1
        ldy     #$00
        sty     FNCNAM+1
        lda     STREND
        ldx     STREND+1
        sta     LOWTR
        stx     LOWTR+1
        lda     #TEMPST
        ldx     #$00
        sta     INDEX
        stx     INDEX+1
L333D:
        cmp     TEMPPT
        beq     L3346
        jsr     CHECK_VARIABLE
        beq     L333D
L3346:
        lda     #BYTES_PER_VARIABLE
        sta     DSCLEN
        lda     VARTAB
        ldx     VARTAB+1
        sta     INDEX
        stx     INDEX+1
L3352:
        cpx     ARYTAB+1
        bne     L335A
        cmp     ARYTAB
        beq     L335F
L335A:
        jsr     CHECK_SIMPLE_VARIABLE
        beq     L3352
L335F:
        sta     HIGHDS
        stx     HIGHDS+1
        lda     #$03
        sta     DSCLEN
L3367:
        lda     HIGHDS
        ldx     HIGHDS+1
L336B:
        cpx     STREND+1
        bne     L3376
        cmp     STREND
        bne     L3376
        jmp     MOVE_HIGHEST_STRING_TO_TOP
L3376:
        sta     INDEX
        stx     INDEX+1
.ifndef CONFIG_11
        ldy     #$01
.else /* CONFIG_11 */
        ldy     #$00
        lda     (INDEX),y
        tax
        iny
.endif /* CONFIG_11 */
        lda     (INDEX),y
        php
        iny
        lda     (INDEX),y
        adc     HIGHDS
        sta     HIGHDS
        iny
        lda     (INDEX),y
        adc     HIGHDS+1
        sta     HIGHDS+1
        plp
        bpl     L3367
.ifdef CONFIG_11
        txa
        bmi     L3367
.endif /* CONFIG_11 */
        iny
        lda     (INDEX),y
.ifdef CBM
        jsr     LE7F3
.else
.ifdef CONFIG_11
        ldy     #$00
.endif /* CONFIG_11 */
        asl     a
        adc     #$05
.endif
        adc     INDEX
        sta     INDEX
        bcc     L33A7
        inc     INDEX+1
L33A7:
        ldx     INDEX+1
L33A9:
        cpx     HIGHDS+1
        bne     L33B1
        cmp     HIGHDS
        beq     L336B
L33B1:
        jsr     CHECK_VARIABLE
        beq     L33A9
CHECK_SIMPLE_VARIABLE:
.ifdef CONFIG_11
        lda     (INDEX),y
        bmi     CHECK_BUMP
.endif /* CONFIG_11 */
        iny
        lda     (INDEX),y
        bpl     CHECK_BUMP
        iny
CHECK_VARIABLE:
        lda     (INDEX),y
        beq     CHECK_BUMP
        iny
        lda     (INDEX),y
        tax
        iny
        lda     (INDEX),y
        cmp     FRETOP+1
        bcc     L33D5
        bne     CHECK_BUMP
        cpx     FRETOP
        bcs     CHECK_BUMP
L33D5:
        cmp     LOWTR+1
        bcc     CHECK_BUMP
        bne     L33DF
        cpx     LOWTR
        bcc     CHECK_BUMP
L33DF:
        stx     LOWTR
        sta     LOWTR+1
        lda     INDEX
        ldx     INDEX+1
        sta     FNCNAM
        stx     FNCNAM+1
        lda     DSCLEN
        sta     JMPADRS+1
CHECK_BUMP:
        lda     DSCLEN
        clc
        adc     INDEX
        sta     INDEX
        bcc     L33FA
        inc     INDEX+1
L33FA:
        ldx     INDEX+1
        ldy     #$00
        rts
MOVE_HIGHEST_STRING_TO_TOP:
        ldx     FNCNAM+1
        beq     L33FA
        lda     JMPADRS+1
        and     #$04
        lsr     a
        tay
        sta     JMPADRS+1
        lda     (FNCNAM),y
        adc     LOWTR
        sta     HIGHTR
        lda     LOWTR+1
        adc     #$00
        sta     HIGHTR+1
        lda     FRETOP
        ldx     FRETOP+1
        sta     HIGHDS
        stx     HIGHDS+1
        jsr     BLTU2
        ldy     JMPADRS+1
        iny
        lda     HIGHDS
        sta     (FNCNAM),y
        tax
        inc     HIGHDS+1
        lda     HIGHDS+1
        iny
        sta     (FNCNAM),y
        jmp     FINDHIGHESTSTRING
CAT:
        lda     FAC_LAST
        pha
        lda     FAC_LAST-1
        pha
        jsr     FRM_ELEMENT
        jsr     CHKSTR
        pla
        sta     STRNG1
        pla
        sta     STRNG1+1
        ldy     #$00
        lda     (STRNG1),y
        clc
        adc     (FAC_LAST-1),y
        bcc     L3454
        ldx     #ERR_STRLONG
        jmp     ERROR
L3454:
        jsr     STRINI
        jsr     MOVINS
        lda     DSCPTR
        ldy     DSCPTR+1
        jsr     FRETMP
        jsr     MOVSTR1
        lda     STRNG1
        ldy     STRNG1+1
        jsr     FRETMP
        jsr     PUTNEW
        jmp     FRMEVL2
MOVINS:
        ldy     #$00
        lda     (STRNG1),y
        pha
        iny
        lda     (STRNG1),y
        tax
        iny
        lda     (STRNG1),y
        tay
        pla
MOVSTR:
        stx     INDEX
        sty     INDEX+1
MOVSTR1:
        tay
        beq     L3490
        pha
L3487:
        dey
        lda     (INDEX),y
        sta     (FRESPC),y
        tya
        bne     L3487
        pla
L3490:
        clc
        adc     FRESPC
        sta     FRESPC
        bcc     L3499
        inc     FRESPC+1
L3499:
        rts
FRESTR:
        jsr     CHKSTR
FREFAC:
        lda     FAC_LAST-1
        ldy     FAC_LAST
FRETMP:
        sta     INDEX
        sty     INDEX+1
        jsr     FRETMS
        php
        ldy     #$00
        lda     (INDEX),y
        pha
        iny
        lda     (INDEX),y
        tax
        iny
        lda     (INDEX),y
        tay
        pla
        plp
        bne     L34CD
        cpy     FRETOP+1
        bne     L34CD
        cpx     FRETOP
        bne     L34CD
        pha
        clc
        adc     FRETOP
        sta     FRETOP
        bcc     L34CC
        inc     FRETOP+1
L34CC:
        pla
L34CD:
        stx     INDEX
        sty     INDEX+1
        rts
FRETMS:
        cpy     LASTPT+1
        bne     L34E2
        cmp     LASTPT
        bne     L34E2
        sta     TEMPPT
        sbc     #$03
        sta     LASTPT
        ldy     #$00
L34E2:
        rts
CHRSTR:
        jsr     CONINT
        txa
        pha
        lda     #$01
        jsr     STRSPA
        pla
        ldy     #$00
        sta     (FAC+1),y
        pla
        pla
        jmp     PUTNEW
LEFTSTR:
        jsr     SUBSTRING_SETUP
        cmp     (DSCPTR),y
        tya
SUBSTRING1:
        bcc     L3503
        lda     (DSCPTR),y
        tax
        tya
L3503:
        pha
SUBSTRING2:
        txa
SUBSTRING3:
        pha
        jsr     STRSPA
        lda     DSCPTR
        ldy     DSCPTR+1
        jsr     FRETMP
        pla
        tay
        pla
        clc
        adc     INDEX
        sta     INDEX
        bcc     L351C
        inc     INDEX+1
L351C:
        tya
        jsr     MOVSTR1
        jmp     PUTNEW
RIGHTSTR:
        jsr     SUBSTRING_SETUP
        clc
        sbc     (DSCPTR),y
        eor     #$FF
        jmp     SUBSTRING1
MIDSTR:
        lda     #$FF
        sta     FAC_LAST
        jsr     CHRGOT
        cmp     #$29
        beq     L353F
        jsr     CHKCOM
        jsr     GETBYT
L353F:
        jsr     SUBSTRING_SETUP
        dex
        txa
        pha
        clc
        ldx     #$00
        sbc     (DSCPTR),y
        bcs     SUBSTRING2
        eor     #$FF
        cmp     FAC_LAST
        bcc     SUBSTRING3
        lda     FAC_LAST
        bcs     SUBSTRING3
SUBSTRING_SETUP:
        jsr     CHKCLS
        pla
.ifndef CONFIG_11
        sta     JMPADRS+1
        pla
        sta     JMPADRS+2
.else /* CONFIG_11 */
        tay
        pla
        sta     TEMPX
.endif /* CONFIG_11 */
        pla
        pla
        pla
        tax
        pla
        sta     DSCPTR
        pla
        sta     DSCPTR+1
.ifdef CONFIG_11
        lda     TEMPX
        pha
        tya
        pha
.endif /* CONFIG_11 */
        ldy     #$00
        txa
        beq     GOIQ
.ifndef CONFIG_11
        inc     JMPADRS+1
        jmp     (JMPADRS+1)
.else /* CONFIG_11 */
        rts
.endif /* CONFIG_11 */
LEN:
        jsr     GETSTR
SNGFLT1:
        jmp     SNGFLT
GETSTR:
        jsr     FRESTR
        ldx     #$00
        stx     VALTYP
        tay
        rts
ASC:
        jsr     GETSTR
        beq     GOIQ
        ldy     #$00
        lda     (INDEX),y
        tay
.ifndef CONFIG_11
        jmp     SNGFLT1
.else /* CONFIG_11 */
        jmp     SNGFLT
.endif /* CONFIG_11 */
GOIQ:
        jmp     IQERR
GTBYTC:
        jsr     CHRGET
GETBYT:
        jsr     FRMNUM
CONINT:
        jsr     MKINT
        ldx     FAC_LAST-1
        bne     GOIQ
        ldx     FAC_LAST
        jmp     CHRGOT
VAL:
        jsr     GETSTR
        bne     L35AC
        jmp     ZERO_FAC
L35AC:
        ldx     TXTPTR
        ldy     TXTPTR+1
        stx     STRNG2
        sty     STRNG2+1
        ldx     INDEX
        stx     TXTPTR
        clc
        adc     INDEX
        sta     DEST
        ldx     INDEX+1
        stx     TXTPTR+1
        bcc     L35C4
        inx
L35C4:
        stx     DEST+1
        ldy     #$00
        lda     (DEST),y
        pha
        lda     #$00
        sta     (DEST),y
        jsr     CHRGOT
        jsr     FIN
        pla
        ldy     #$00
        sta     (DEST),y
POINT:
        ldx     STRNG2
        ldy     STRNG2+1
        stx     TXTPTR
        sty     TXTPTR+1
        rts
GTNUM:
        jsr     FRMNUM
        jsr     GETADR
COMBYTE:
        jsr     CHKCOM
        jmp     GETBYT
GETADR:
        lda     FACSIGN
        bmi     GOIQ
        lda     FAC
        cmp     #$91
        bcs     GOIQ
        jsr     QINT
        lda     FAC_LAST-1
        ldy     FAC_LAST
        sty     LINNUM
        sta     LINNUM+1
        rts
PEEK:
        jsr     GETADR
        ldy     #$00
.ifdef CBM
        cmp     #$C0
        bcc     LD6F3
        cmp     #$E1
        bcc     LD6F6
LD6F3:
.endif
        lda     (LINNUM),y
        tay
LD6F6:
        jmp     SNGFLT
POKE:
        jsr     GTNUM
        txa
        ldy     #$00
        sta     (LINNUM),y
        rts
WAIT:
        jsr     GTNUM
        stx     FORPNT
        ldx     #$00
        jsr     CHRGOT
        beq     L3628
        jsr     COMBYTE
L3628:
        stx     FORPNT+1
        ldy     #$00
L362C:
        lda     (LINNUM),y
        eor     FORPNT+1
        and     FORPNT
        beq     L362C
L3634:
        rts
FADDH:
        lda     #<CON_HALF
        ldy     #>CON_HALF
        jmp     FADD
FSUB:
        jsr     LOAD_ARG_FROM_YA
FSUBT:
        lda     FACSIGN
        eor     #$FF
        sta     FACSIGN
        eor     ARGSIGN
        sta     STRNG1
        lda     FAC
        jmp     FADDT
FADD1:
        jsr     SHIFT_RIGHT
        bcc     FADD3
FADD:
        jsr     LOAD_ARG_FROM_YA
FADDT:
        bne     L365B
        jmp     COPY_ARG_TO_FAC
L365B:
        ldx     FACEXTENSION
        stx     ARGEXTENSION
        ldx     #ARG
        lda     ARG
FADD2:
        tay
        beq     L3634
        sec
        sbc     FAC
        beq     FADD3
        bcc     L367F
        sty     FAC
        ldy     ARGSIGN
        sty     FACSIGN
        eor     #$FF
        adc     #$00
        ldy     #$00
        sty     ARGEXTENSION
        ldx     #FAC
        bne     L3683
L367F:
        ldy     #$00
        sty     FACEXTENSION
L3683:
        cmp     #$F9
        bmi     FADD1
        tay
        lda     FACEXTENSION
        lsr     1,x
        jsr     SHIFT_RIGHT4
FADD3:
        bit     STRNG1
        bpl     FADD4
        ldy     #FAC
        cpx     #ARG
        beq     L369B
        ldy     #ARG
L369B:
        sec
        eor     #$FF
        adc     ARGEXTENSION
        sta     FACEXTENSION
.ifdef CONFIG_11
        lda     4,y
        sbc     4,x
        sta     FAC+4
.endif /* CONFIG_11 */
        lda     GOWARM,y
        sbc     GOWARM,x
        sta     FAC+3
        lda     2,y
        sbc     2,x
        sta     FAC+2
        lda     1,y
        sbc     1,x
        sta     FAC+1
NORMALIZE_FAC1:
        bcs     NORMALIZE_FAC2
        jsr     COMPLEMENT_FAC
NORMALIZE_FAC2:
        ldy     #$00
        tya
        clc
L36C7:
        ldx     FAC+1
        bne     NORMALIZE_FAC4
        ldx     FAC+2
        stx     FAC+1
        ldx     FAC+3
        stx     FAC+2
.ifndef CONFIG_11
        ldx     FACEXTENSION
        stx     FAC+3
.else /* CONFIG_11 */
        ldx     FAC+4
        stx     FAC+3
        ldx     FACEXTENSION
        stx     FAC+4
.endif /* CONFIG_11 */
        sty     FACEXTENSION
        adc     #$08
        cmp     #MANTISSA_BYTES*8
        bne     L36C7
ZERO_FAC:
        lda     #$00
STA_IN_FAC_SIGN_AND_EXP:
        sta     FAC
STA_IN_FAC_SIGN:
        sta     FACSIGN
        rts
FADD4:
        adc     ARGEXTENSION
        sta     FACEXTENSION
.ifdef CONFIG_11
        lda     FAC+4
        adc     ARG+4
        sta     FAC+4
.endif /* CONFIG_11 */
        lda     FAC+3
        adc     ARG+3
        sta     FAC+3
        lda     FAC+2
        adc     ARG+2
        sta     FAC+2
        lda     FAC+1
        adc     ARG+1
        sta     FAC+1
        jmp     NORMALIZE_FAC5
NORMALIZE_FAC3:
        adc     #$01
        asl     FACEXTENSION
.ifdef CONFIG_11
        rol     FAC+4
.endif /* CONFIG_11 */
        rol     FAC+3
        rol     FAC+2
        rol     FAC+1
NORMALIZE_FAC4:
        bpl     NORMALIZE_FAC3
        sec
        sbc     FAC
        bcs     ZERO_FAC
        eor     #$FF
        adc     #$01
        sta     FAC
NORMALIZE_FAC5:
        bcc     L3764
NORMALIZE_FAC6:
        inc     FAC
        beq     OVERFLOW
.ifndef KIM
        ror     FAC+1
        ror     FAC+2
        ror     FAC+3
.ifdef CBM
        ror     FAC+4
.endif
        ror     FACEXTENSION
.else /* CONFIG_11 */
        lda     #$00
        bcc     L372E
        lda     #$80
L372E:
        lsr     FAC+1
        ora     FAC+1
        sta     FAC+1
        lda     #$00
        bcc     L373A
        lda     #$80
L373A:
        lsr     FAC+2
        ora     FAC+2
        sta     FAC+2
        lda     #$00
        bcc     L3746
        lda     #$80
L3746:
        lsr     FAC+3
        ora     FAC+3
        sta     FAC+3
        lda     #$00
        bcc     L3752
        lda     #$80
L3752:
        lsr     FAC+4
        ora     FAC+4
        sta     FAC+4
        lda     #$00
        bcc     L375E
        lda     #$80
L375E:
        lsr     FACEXTENSION
        ora     FACEXTENSION
        sta     FACEXTENSION
.endif /* CONFIG_11 */
L3764:
        rts
COMPLEMENT_FAC:
        lda     FACSIGN
        eor     #$FF
        sta     FACSIGN
COMPLEMENT_FAC_MANTISSA:
        lda     FAC+1
        eor     #$FF
        sta     FAC+1
        lda     FAC+2
        eor     #$FF
        sta     FAC+2
        lda     FAC+3
        eor     #$FF
        sta     FAC+3
.ifdef CONFIG_11
        lda     FAC+4
        eor     #$FF
        sta     FAC+4
.endif /* CONFIG_11 */
        lda     FACEXTENSION
        eor     #$FF
        sta     FACEXTENSION
        inc     FACEXTENSION
        bne     RTS12
INCREMENT_FAC_MANTISSA:
.ifdef CONFIG_11
        inc     FAC+4
        bne     RTS12
.endif /* CONFIG_11 */
        inc     FAC+3
        bne     RTS12
        inc     FAC+2
        bne     RTS12
        inc     FAC+1
RTS12:
        rts
OVERFLOW:
        ldx     #ERR_OVERFLOW
        jmp     ERROR
SHIFT_RIGHT1:
        ldx     #RESULT-1
SHIFT_RIGHT2:
.ifndef CONFIG_11
        ldy     3,x
.else /* CONFIG_11 */
        ldy     4,x
.endif /* CONFIG_11 */
        sty     FACEXTENSION
.ifdef CONFIG_11
        ldy     3,x
        sty     4,x
.endif /* CONFIG_11 */
        ldy     2,x
        sty     3,x
        ldy     1,x
        sty     2,x
        ldy     SHIFTSIGNEXT
        sty     1,x
SHIFT_RIGHT:
        adc     #$08
        bmi     SHIFT_RIGHT2
        beq     SHIFT_RIGHT2
        sbc     #$08
        tay
        lda     FACEXTENSION
        bcs     SHIFT_RIGHT5
.ifndef KIM
LB588:
        asl     1,x
        bcc     LB58E
        inc     1,x
LB58E:
        ror     1,x
        ror     1,x
SHIFT_RIGHT4:
        ror     2,x
        ror     3,x
.ifdef CBM
        ror     4,x
.endif
        ror     a
        iny
        bne     LB588
.else /* CONFIG_11 */
L37C4:
        pha
        lda     1,x
        and     #$80
        lsr     1,x
        ora     1,x
        sta     1,x
        .byte   $24
SHIFT_RIGHT4:
        pha
        lda     #$00
        bcc     L37D7
        lda     #$80
L37D7:
        lsr     2,x
        ora     2,x
        sta     2,x
        lda     #$00
        bcc     L37E3
        lda     #$80
L37E3:
        lsr     3,x
        ora     3,x
        sta     3,x
        lda     #$00
        bcc     L37EF
        lda     #$80
L37EF:
        lsr     4,x
        ora     4,x
        sta     4,x
        pla
        php
        lsr     a
        plp
        bcc     L37FD
        ora     #$80
L37FD:
        iny
        bne     L37C4
.endif /* CONFIG_11 */
SHIFT_RIGHT5:
        clc
        rts
.ifndef CONFIG_11
CON_ONE:
        .byte   $81,$00,$00,$00
POLY_LOG:
		.byte	$02
		.byte   $80,$19,$56,$62
		.byte   $80,$76,$22,$F3
		.byte   $82,$38,$AA,$40
CON_SQR_HALF:
		.byte   $80,$35,$04,$F3
CON_SQR_TWO:
		.byte   $81,$35,$04,$F3
CON_NEG_HALF:
		.byte   $80,$80,$00,$00
CON_LOG_TWO:
		.byte   $80,$31,$72,$18
.else /* CONFIG_11 */
CON_ONE:
        .byte   $81,$00,$00,$00,$00
POLY_LOG:
        .byte   $03
		.byte   $7F,$5E,$56,$CB,$79
		.byte   $80,$13,$9B,$0B,$64
		.byte   $80,$76,$38,$93,$16
        .byte   $82,$38,$AA,$3B,$20
CON_SQR_HALF:
        .byte   $80,$35,$04,$F3,$34
CON_SQR_TWO:
        .byte   $81,$35,$04,$F3,$34
CON_NEG_HALF:
        .byte   $80,$80,$00,$00,$00
CON_LOG_TWO:
        .byte   $80,$31,$72,$17,$F8
.endif /* CONFIG_11 */
LOG:
        jsr     SIGN
        beq     GIQ
        bpl     LOG2
GIQ:
        jmp     IQERR
LOG2:
        lda     FAC
        sbc     #$7F
        pha
        lda     #$80
        sta     FAC
        lda     #<CON_SQR_HALF
        ldy     #>CON_SQR_HALF
        jsr     FADD
        lda     #<CON_SQR_TWO
        ldy     #>CON_SQR_TWO
        jsr     FDIV
        lda     #<CON_ONE
        ldy     #>CON_ONE
        jsr     FSUB
        lda     #<POLY_LOG
        ldy     #>POLY_LOG
        jsr     POLYNOMIAL_ODD
        lda     #<CON_NEG_HALF
        ldy     #>CON_NEG_HALF
        jsr     FADD
        pla
        jsr     ADDACC
        lda     #<CON_LOG_TWO
        ldy     #>CON_LOG_TWO
FMULT:
        jsr     LOAD_ARG_FROM_YA
FMULTT:
.ifndef KIM
        beq     L3903
.else /* CONFIG_11 */
        bne     L3876
        jmp     L3903
L3876:
.endif /* CONFIG_11 */
        jsr     ADD_EXPONENTS
        lda     #$00
        sta     RESULT
        sta     RESULT+1
        sta     RESULT+2
.ifdef CONFIG_11
        sta     RESULT+3
.endif /* CONFIG_11 */
        lda     FACEXTENSION
        jsr     MULTIPLY1
.ifdef CONFIG_11
        lda     FAC+4
        jsr     MULTIPLY1
.endif /* CONFIG_11 */
        lda     FAC+3
        jsr     MULTIPLY1
        lda     FAC+2
        jsr     MULTIPLY1
        lda     FAC+1
        jsr     MULTIPLY2
        jmp     COPY_RESULT_INTO_FAC
MULTIPLY1:
        bne     MULTIPLY2
        jmp     SHIFT_RIGHT1
MULTIPLY2:
        lsr     a
        ora     #$80
L38A7:
        tay
        bcc     L38C3
        clc
.ifdef CONFIG_11
        lda     RESULT+3
        adc     ARG+4
        sta     RESULT+3
.endif /* CONFIG_11 */
        lda     RESULT+2
        adc     ARG+3
        sta     RESULT+2
        lda     RESULT+1
        adc     ARG+2
        sta     RESULT+1
        lda     RESULT
        adc     ARG+1
        sta     RESULT
L38C3:
.ifndef KIM
        ror     RESULT
        ror     RESULT+1
        ror     RESULT+2
.ifdef CBM
        ror     RESULT+3
.endif
        ror     FACEXTENSION
.else /* CONFIG_11 */
        lda     #$00
        bcc     L38C9
        lda     #$80
L38C9:
        lsr     RESULT
        ora     RESULT
        sta     RESULT
        lda     #$00
        bcc     L38D5
        lda     #$80
L38D5:
        lsr     RESULT+1
        ora     RESULT+1
        sta     RESULT+1
        lda     #$00
        bcc     L38E1
        lda     #$80
L38E1:
        lsr     RESULT+2
        ora     RESULT+2
        sta     RESULT+2
        lda     #$00
        bcc     L38ED
        lda     #$80
L38ED:
        lsr     RESULT+3
        ora     RESULT+3
        sta     RESULT+3
        lda     #$00
        bcc     L38F9
        lda     #$80
L38F9:
        lsr     FACEXTENSION
        ora     FACEXTENSION
        sta     FACEXTENSION
.endif /* CONFIG_11 */
        tya
        lsr     a
        bne     L38A7
L3903:
        rts
LOAD_ARG_FROM_YA:
        sta     INDEX
        sty     INDEX+1
        ldy     #BYTES_FP-1
.ifdef CONFIG_11
        lda     (INDEX),y
        sta     ARG+4
        dey
.endif /* CONFIG_11 */
        lda     (INDEX),y
        sta     ARG+3
        dey
        lda     (INDEX),y
        sta     ARG+2
        dey
        lda     (INDEX),y
        sta     ARGSIGN
        eor     FACSIGN
        sta     STRNG1
        lda     ARGSIGN
        ora     #$80
        sta     ARG+1
        dey
        lda     (INDEX),y
        sta     ARG
        lda     FAC
        rts
ADD_EXPONENTS:
        lda     ARG
ADD_EXPONENTS1:
        beq     ZERO
        clc
        adc     FAC
        bcc     L393C
        bmi     JOV
        clc
        .byte   $2C
L393C:
        bpl     ZERO
        adc     #$80
        sta     FAC
        bne     L3947
        jmp     STA_IN_FAC_SIGN
L3947:
        lda     STRNG1
        sta     FACSIGN
        rts
OUTOFRNG:
        lda     FACSIGN
        eor     #$FF
        bmi     JOV
ZERO:
        pla
        pla
        jmp     ZERO_FAC
JOV:
        jmp     OVERFLOW
MUL10:
        jsr     COPY_FAC_TO_ARG_ROUNDED
        tax
        beq     L3970
        clc
        adc     #$02
        bcs     JOV
        ldx     #$00
        stx     STRNG1
        jsr     FADD2
        inc     FAC
        beq     JOV
L3970:
        rts
CONTEN:
.ifndef CONFIG_11
        .byte   $84,$20,$00,$00
.else /* CONFIG_11 */
        .byte   $84,$20,$00,$00,$00
.endif /* CONFIG_11 */
DIV10:
        jsr     COPY_FAC_TO_ARG_ROUNDED
        lda     #<CONTEN
        ldy     #>CONTEN
        ldx     #$00
DIV:
        stx     STRNG1
        jsr     LOAD_FAC_FROM_YA
        jmp     FDIVT
FDIV:
        jsr     LOAD_ARG_FROM_YA
FDIVT:
        beq     L3A02
        jsr     ROUND_FAC
        lda     #$00
        sec
        sbc     FAC
        sta     FAC
        jsr     ADD_EXPONENTS
        inc     FAC
        beq     JOV
        ldx     #-MANTISSA_BYTES
        lda     #$01
L39A1:
        ldy     ARG+1
        cpy     FAC+1
        bne     L39B7
        ldy     ARG+2
        cpy     FAC+2
        bne     L39B7
        ldy     ARG+3
        cpy     FAC+3
.ifdef CONFIG_11
        bne     L39B7
        ldy     ARG+4
        cpy     FAC+4
.endif /* CONFIG_11 */
L39B7:
        php
        rol     a
        bcc     L39C4
        inx
        sta     RESULT_LAST-1,x
        beq     L39F2
        bpl     L39F6
        lda     #$01
L39C4:
        plp
        bcs     L39D5
L39C7:
        asl     ARG_LAST
.ifdef CONFIG_11
        rol     ARG+3
.endif /* CONFIG_11 */
        rol     ARG+2
        rol     ARG+1
        bcs     L39B7
        bmi     L39A1
        bpl     L39B7
L39D5:
        tay
.ifdef CONFIG_11
        lda     ARG+4
        sbc     FAC+4
        sta     ARG+4
.endif /* CONFIG_11 */
        lda     ARG+3
        sbc     FAC+3
        sta     ARG+3
        lda     ARG+2
        sbc     FAC+2
        sta     ARG+2
        lda     ARG+1
        sbc     FAC+1
        sta     ARG+1
        tya
        jmp     L39C7
L39F2:
        lda     #$40
        bne     L39C4
L39F6:
        asl     a
        asl     a
        asl     a
        asl     a
        asl     a
        asl     a
        sta     FACEXTENSION
        plp
        jmp     COPY_RESULT_INTO_FAC
L3A02:
.ifndef CONFIG_11
        ldx     #ERR_ZERODIV
.else /* CONFIG_11 */
        ldx     #ERR_ZERODIV
.endif /* CONFIG_11 */
        jmp     ERROR
COPY_RESULT_INTO_FAC:
        lda     RESULT
        sta     FAC+1
        lda     RESULT+1
        sta     FAC+2
        lda     RESULT+2
        sta     FAC+3
.ifdef CONFIG_11
        lda     RESULT+3
        sta     FAC+4
.endif /* CONFIG_11 */
        jmp     NORMALIZE_FAC2
LOAD_FAC_FROM_YA:
        sta     INDEX
        sty     INDEX+1
        ldy     #MANTISSA_BYTES
.ifdef CONFIG_11
        lda     (INDEX),y
        sta     FAC+4
        dey
.endif /* CONFIG_11 */
        lda     (INDEX),y
        sta     FAC+3
        dey
        lda     (INDEX),y
        sta     FAC+2
        dey
        lda     (INDEX),y
        sta     FACSIGN
        ora     #$80
        sta     FAC+1
        dey
        lda     (INDEX),y
        sta     FAC
        sty     FACEXTENSION
        rts
STORE_FAC_IN_TEMP2_ROUNDED:
        ldx     #TEMP2
        .byte   $2C
STORE_FAC_IN_TEMP1_ROUNDED:
        ldx     #$A4
        ldy     #$00
        beq     STORE_FAC_AT_YX_ROUNDED
SETFOR:
        ldx     FORPNT
        ldy     FORPNT+1
STORE_FAC_AT_YX_ROUNDED:
        jsr     ROUND_FAC
        stx     INDEX
        sty     INDEX+1
        ldy     #MANTISSA_BYTES
.ifdef CONFIG_11
        lda     FAC+4
        sta     (INDEX),y
        dey
.endif /* CONFIG_11 */
        lda     FAC+3
        sta     (INDEX),y
        dey
        lda     FAC+2
        sta     (INDEX),y
        dey
        lda     FACSIGN
        ora     #$7F
        and     FAC+1
        sta     (INDEX),y
        dey
        lda     FAC
        sta     (INDEX),y
        sty     FACEXTENSION
        rts
COPY_ARG_TO_FAC:
        lda     ARGSIGN
MFA:
        sta     FACSIGN
        ldx     #BYTES_FP
L3A7A:
        lda     SHIFTSIGNEXT,x
        sta     EXPSGN,x
        dex
        bne     L3A7A
        stx     FACEXTENSION
        rts
COPY_FAC_TO_ARG_ROUNDED:
        jsr     ROUND_FAC
MAF:
        ldx     #BYTES_FP+1
L3A89:
        lda     EXPSGN,x
        sta     SHIFTSIGNEXT,x
        dex
        bne     L3A89
        stx     FACEXTENSION
RTS14:
        rts
ROUND_FAC:
        lda     FAC
        beq     RTS14
        asl     FACEXTENSION
        bcc     RTS14
INCREMENT_MANTISSA:
        jsr     INCREMENT_FAC_MANTISSA
        bne     RTS14
        jmp     NORMALIZE_FAC6
SIGN:
        lda     FAC
        beq     RTS15
L3AA7:
        lda     FACSIGN
SIGN2:
        rol     a
        lda     #$FF
        bcs     RTS15
        lda     #$01
RTS15:
        rts
SGN:
        jsr     SIGN
FLOAT:
        sta     FAC+1
        lda     #$00
        sta     FAC+2
        ldx     #$88
FLOAT1:
        lda     FAC+1
        eor     #$FF
        rol     a
FLOAT2:
        lda     #$00
.ifdef CONFIG_11
        sta     FAC+4
.endif /* CONFIG_11 */
        sta     FAC+3
        stx     FAC
        sta     FACEXTENSION
        sta     FACSIGN
        jmp     NORMALIZE_FAC1
ABS:
        lsr     FACSIGN
        rts
FCOMP:
        sta     DEST
FCOMP2:
        sty     DEST+1
        ldy     #$00
        lda     (DEST),y
        iny
        tax
        beq     SIGN
        lda     (DEST),y
        eor     FACSIGN
        bmi     L3AA7
        cpx     FAC
        bne     L3B0A
        lda     (DEST),y
        ora     #$80
        cmp     FAC+1
        bne     L3B0A
        iny
        lda     (DEST),y
        cmp     FAC+2
        bne     L3B0A
        iny
.ifdef CONFIG_11
        lda     (DEST),y
        cmp     FAC+3
        bne     L3B0A
        iny
.endif /* CONFIG_11 */
        lda     #$7F
        cmp     FACEXTENSION
        lda     (DEST),y
        sbc     FAC_LAST
        beq     L3B32
L3B0A:
        lda     FACSIGN
        bcc     L3B10
        eor     #$FF
L3B10:
        jmp     SIGN2
QINT:
        lda     FAC
        beq     QINT3
        sec
        sbc     #120+8*BYTES_FP
        bit     FACSIGN
        bpl     L3B27
        tax
        lda     #$FF
        sta     SHIFTSIGNEXT
        jsr     COMPLEMENT_FAC_MANTISSA
        txa
L3B27:
        ldx     #FAC
        cmp     #$F9
        bpl     QINT2
        jsr     SHIFT_RIGHT
        sty     SHIFTSIGNEXT
L3B32:
        rts
QINT2:
        tay
        lda     FACSIGN
        and     #$80
        lsr     FAC+1
        ora     FAC+1
        sta     FAC+1
        jsr     SHIFT_RIGHT4
        sty     SHIFTSIGNEXT
        rts
INT:
        lda     FAC
        cmp     #120+8*BYTES_FP
        bcs     RTS17
        jsr     QINT
        sty     FACEXTENSION
        lda     FACSIGN
        sty     FACSIGN
        eor     #$80
        rol     a
        lda     #120+8*BYTES_FP
        sta     FAC
        lda     FAC_LAST
        sta     CHARAC
        jmp     NORMALIZE_FAC1
QINT3:
        sta     FAC+1
        sta     FAC+2
        sta     FAC+3
.ifdef CONFIG_11
        sta     FAC+4
.endif /* CONFIG_11 */
        tay
RTS17:
        rts
FIN:
        ldy     #$00
        ldx     #SERLEN-TMPEXP
L3B6F:
        sty     TMPEXP,x
        dex
        bpl     L3B6F
        bcc     FIN2
        cmp     #$2D
        bne     L3B7E
        stx     SERLEN
        beq     FIN1
L3B7E:
        cmp     #$2B
        bne     FIN3
FIN1:
        jsr     CHRGET
FIN2:
        bcc     FIN9
FIN3:
        cmp     #$2E
        beq     FIN10
        cmp     #$45
        bne     FIN7
        jsr     CHRGET
        bcc     FIN5
        cmp     #TOKEN_MINUS
        beq     L3BA6
        cmp     #$2D
        beq     L3BA6
        cmp     #TOKEN_PLUS
        beq     FIN4
        cmp     #$2B
        beq     FIN4
        bne     FIN6
L3BA6:
.ifndef KIM
        ror     EXPSGN
.else /* CONFIG_11 */
        lda     #$00
        bcc     L3BAC
        lda     #$80
L3BAC:
        lsr     EXPSGN
        ora     EXPSGN
        sta     EXPSGN
.endif /* CONFIG_11 */
FIN4:
        jsr     CHRGET
FIN5:
        bcc     GETEXP
FIN6:
        bit     EXPSGN
        bpl     FIN7
        lda     #$00
        sec
        sbc     EXPON
        jmp     FIN8
FIN10:
.ifndef KIM
        ror     LOWTR
.else /* CONFIG_11 */
        lda     #$00
        bcc     L3BC9
        lda     #$80
L3BC9:
        lsr     LOWTR
        ora     LOWTR
        sta     LOWTR
.endif /* CONFIG_11 */
        bit     LOWTR
        bvc     FIN1
FIN7:
        lda     EXPON
FIN8:
        sec
        sbc     INDX
        sta     EXPON
        beq     L3BEE
        bpl     L3BE7
L3BDE:
        jsr     DIV10
        inc     EXPON
        bne     L3BDE
        beq     L3BEE
L3BE7:
        jsr     MUL10
        dec     EXPON
        bne     L3BE7
L3BEE:
        lda     SERLEN
        bmi     L3BF3
        rts
L3BF3:
        jmp     NEGOP
FIN9:
        pha
        bit     LOWTR
        bpl     L3BFD
        inc     INDX
L3BFD:
        jsr     MUL10
        pla
        sec
        sbc     #$30
        jsr     ADDACC
        jmp     FIN1
ADDACC:
        pha
        jsr     COPY_FAC_TO_ARG_ROUNDED
        pla
        jsr     FLOAT
        lda     ARGSIGN
        eor     FACSIGN
        sta     STRNG1
        ldx     FAC
        jmp     FADDT
GETEXP:
        lda     EXPON
.ifdef CBM
        cmp     #$0C
        bcc     L3C2C
        bit     EXPSGN
        bmi     LDC70
        jmp     OVERFLOW
LDC70:
        lda     #$0B
.else
        cmp     #$0A
        bcc     L3C2C
        lda     #$64
        bit     EXPSGN
        bmi     L3C3A
        jmp     OVERFLOW
.endif
L3C2C:
        asl     a
        asl     a
        clc
        adc     EXPON
        asl     a
        clc
        ldy     #$00
        adc     (TXTPTR),y
        sec
        sbc     #$30
L3C3A:
        sta     EXPON
        jmp     FIN4
.ifndef CONFIG_11
; these values are /1000 of what the labels say
CON_99999999_9:
        .byte   $91,$43,$4F,$F8
CON_999999999:
		.byte   $94,$74,$23,$F7
CON_BILLION:
        .byte   $94,$74,$24,$00
.else /* CONFIG_11 */
CON_99999999_9:
        .byte   $9B,$3E,$BC,$1F,$FD
CON_999999999:
        .byte   $9E,$6E,$6B,$27,$FD
CON_BILLION:
        .byte   $9E,$6E,$6B,$28,$00
.endif /* CONFIG_11 */
INPRT:
        lda     #<QT_IN
        ldy     #>QT_IN
        jsr     GOSTROUT2
        lda     CURLIN+1
        ldx     CURLIN
LINPRT:
        sta     FAC+1
        stx     FAC+2
        ldx     #$90
        sec
        jsr     FLOAT2
        jsr     FOUT
GOSTROUT2:
        jmp     STROUT
FOUT:
        ldy     #$01
FOUT1:
        lda     #$20
        bit     FACSIGN
        bpl     L3C73
        lda     #$2D
L3C73:
        sta     $FF,y
        sta     FACSIGN
        sty     STRNG2
        iny
        lda     #$30
        ldx     FAC
        bne     L3C84
        jmp     FOUT4
L3C84:
        lda     #$00
        cpx     #$80
        beq     L3C8C
        bcs     L3C95
L3C8C:
        lda     #<CON_BILLION
        ldy     #>CON_BILLION
        jsr     FMULT
.ifndef CONFIG_11
        lda     #-6
.else /* CONFIG_11 */
        lda     #-9
.endif /* CONFIG_11 */
L3C95:
        sta     INDX
L3C97:
        lda     #<CON_999999999
        ldy     #>CON_999999999
        jsr     FCOMP
        beq     L3CBE
        bpl     L3CB4
L3CA2:
        lda     #<CON_99999999_9
        ldy     #>CON_99999999_9
        jsr     FCOMP
        beq     L3CAD
        bpl     L3CBB
L3CAD:
        jsr     MUL10
        dec     INDX
        bne     L3CA2
L3CB4:
        jsr     DIV10
        inc     INDX
        bne     L3C97
L3CBB:
        jsr     FADDH
L3CBE:
        jsr     QINT
        ldx     #$01
        lda     INDX
        clc
.ifndef CONFIG_11
        adc     #$07
.else /* CONFIG_11 */
        adc     #$0A
.endif /* CONFIG_11 */
        bmi     L3CD3
.ifndef CONFIG_11
        cmp     #$08
.else /* CONFIG_11 */
        cmp     #$0B
.endif /* CONFIG_11 */
        bcs     L3CD4
        adc     #$FF
        tax
        lda     #$02
L3CD3:
        sec
L3CD4:
        sbc     #$02
        sta     EXPON
        stx     INDX
        txa
        beq     L3CDF
        bpl     L3CF2
L3CDF:
        ldy     STRNG2
        lda     #$2E
        iny
        sta     $FF,y
        txa
        beq     L3CF0
        lda     #$30
        iny
        sta     $FF,y
L3CF0:
        sty     STRNG2
L3CF2:
        ldy     #$00
        ldx     #$80
L3CF6:
        lda     FAC_LAST
        clc
.ifdef CONFIG_11
        adc     DECTBL+3,y
        sta     FAC+4
        lda     FAC+3
.endif /* CONFIG_11 */
        adc     DECTBL+2,y
        sta     FAC+3
        lda     FAC+2
        adc     DECTBL+1,y
        sta     FAC+2
        lda     FAC+1
        adc     DECTBL,y
        sta     FAC+1
        inx
        bcs     L3D1A
        bpl     L3CF6
        bmi     L3D1C
L3D1A:
        bmi     L3CF6
L3D1C:
        txa
        bcc     L3D23
        eor     #$FF
        adc     #$0A
L3D23:
        adc     #$2F
        iny
        iny
        iny
.ifdef CONFIG_11
        iny
.endif /* CONFIG_11 */
        sty     VARPNT
        ldy     STRNG2
        iny
        tax
        and     #$7F
        sta     $FF,y
        dec     INDX
        bne     L3D3E
        lda     #$2E
        iny
        sta     $FF,y
L3D3E:
        sty     STRNG2
        ldy     VARPNT
        txa
        eor     #$FF
        and     #$80
        tax
        cpy     #DECTBL_END-DECTBL
.ifdef CBM
        beq     LDD96
        cpy     #$3C
.endif
        bne     L3CF6
LDD96:
        ldy     STRNG2
L3D4E:
        lda     $FF,y
        dey
        cmp     #$30
        beq     L3D4E
        cmp     #$2E
        beq     L3D5B
        iny
L3D5B:
        lda     #$2B
        ldx     EXPON
        beq     L3D8F
        bpl     L3D6B
        lda     #$00
        sec
        sbc     EXPON
        tax
        lda     #$2D
L3D6B:
        sta     STACK+1,y
        lda     #$45
        sta     STACK,y
        txa
        ldx     #$2F
        sec
L3D77:
        inx
        sbc     #$0A
        bcs     L3D77
        adc     #$3A
        sta     STACK+3,y
        txa
        sta     STACK+2,y
        lda     #$00
        sta     STACK+4,y
        beq     L3D94
FOUT4:
        sta     $FF,y
L3D8F:
        lda     #$00
        sta     STACK,y
L3D94:
        lda     #$00
        ldy     #$01
        rts
.ifndef CONFIG_11
CON_HALF:
        .byte   $80,$00,$00,$00
DECTBL:
        .byte   $FE,$79,$60 ; -100000
		.byte	$00,$27,$10 ; 10000
		.byte	$FF,$FC,$18 ; -1000
		.byte	$00,$00,$64 ; 100
		.byte	$FF,$FF,$F6 ; -10
		.byte	$00,$00,$01 ; 1
DECTBL_END:
.else /* CONFIG_11 */
CON_HALF:
        .byte   $80,$00,$00,$00,$00
DECTBL:
        .byte   $FA,$0A,$1F,$00,$00,$98,$96,$80
        .byte   $FF,$F0,$BD,$C0,$00,$01,$86,$A0
        .byte   $FF,$FF,$D8,$F0,$00,$00,$03,$E8
        .byte   $FF,$FF,$FF,$9C,$00,$00,$00,$0A
        .byte   $FF,$FF,$FF,$FF
.ifdef CBM
		.byte	$FF,$DF,$0A,$80 ; TI$
		.byte	$00,$03,$4B,$C0
		.byte	$FF,$FF,$73,$60
		.byte	$00,$00,$0E,$10
		.byte	$FF,$FF,$FD,$A8
		.byte	$00,$00,$00,$3C
.endif
DECTBL_END:
.endif /* CONFIG_11 */
SQR:
        jsr     COPY_FAC_TO_ARG_ROUNDED
        lda     #<CON_HALF
        ldy     #>CON_HALF
        jsr     LOAD_FAC_FROM_YA
FPWRT:
        beq     EXP
        lda     ARG
        bne     L3DD5
        jmp     STA_IN_FAC_SIGN_AND_EXP
L3DD5:
        ldx     #TEMP3
        ldy     #$00
        jsr     STORE_FAC_AT_YX_ROUNDED
        lda     ARGSIGN
        bpl     L3DEF
        jsr     INT
        lda     #TEMP3
        ldy     #$00
        jsr     FCOMP
        bne     L3DEF
        tya
        ldy     CHARAC
L3DEF:
        jsr     MFA
        tya
        pha
        jsr     LOG
        lda     #TEMP3
        ldy     #$00
        jsr     FMULT
        jsr     EXP
        pla
        lsr     a
        bcc     L3E0F
NEGOP:
        lda     FAC
        beq     L3E0F
        lda     FACSIGN
        eor     #$FF
        sta     FACSIGN
L3E0F:
        rts
.ifndef CONFIG_11
CON_LOG_E:
        .byte   $81,$38,$AA,$3B
POLY_EXP:
		.byte	$06
		.byte	$74,$63,$90,$8C
		.byte	$77,$23,$0C,$AB
		.byte	$7A,$1E,$94,$00
		.byte	$7C,$63,$42,$80
		.byte	$7E,$75,$FE,$D0
		.byte	$80,$31,$72,$15
		.byte	$81,$00,$00,$00
.else /* CONFIG_11 */
CON_LOG_E:
        .byte   $81,$38,$AA,$3B,$29
POLY_EXP:
        .byte   $07
		.byte	$71,$34,$58,$3E,$56
		.byte	$74,$16,$7E,$B3,$1B
		.byte	$77,$2F,$EE,$E3,$85
        .byte   $7A,$1D,$84,$1C,$2A
		.byte	$7C,$63,$59,$58,$0A
		.byte	$7E,$75,$FD,$E7,$C6
		.byte	$80,$31,$72,$18,$10
		.byte	$81,$00,$00,$00,$00
.endif /* CONFIG_11 */
EXP:
        lda     #<CON_LOG_E
        ldy     #>CON_LOG_E
        jsr     FMULT
        lda     FACEXTENSION
        adc     #$50
        bcc     L3E4E
        jsr     INCREMENT_MANTISSA
L3E4E:
        sta     ARGEXTENSION
        jsr     MAF
        lda     FAC
        cmp     #$88
        bcc     L3E5C
L3E59:
        jsr     OUTOFRNG
L3E5C:
        jsr     INT
        lda     CHARAC
        clc
        adc     #$81
        beq     L3E59
        sec
        sbc     #$01
        pha
        ldx     #BYTES_FP
L3E6C:
        lda     ARG,x
        ldy     FAC,x
        sta     FAC,x
        sty     ARG,x
        dex
        bpl     L3E6C
        lda     ARGEXTENSION
        sta     FACEXTENSION
        jsr     FSUBT
        jsr     NEGOP
        lda     #<POLY_EXP
        ldy     #>POLY_EXP
        jsr     POLYNOMIAL
        lda     #$00
        sta     STRNG1
        pla
        jsr     ADD_EXPONENTS1
        rts
POLYNOMIAL_ODD:
        sta     STRNG2
        sty     STRNG2+1
        jsr     STORE_FAC_IN_TEMP1_ROUNDED
        lda     #$A4
        jsr     FMULT
        jsr     SERMAIN
        lda     #$A4
        ldy     #$00
        jmp     FMULT
POLYNOMIAL:
        sta     STRNG2
        sty     STRNG2+1
SERMAIN:
        jsr     STORE_FAC_IN_TEMP2_ROUNDED
        lda     (STRNG2),y
        sta     SERLEN
        ldy     STRNG2
        iny
        tya
        bne     L3EBA
        inc     STRNG2+1
L3EBA:
        sta     STRNG2
        ldy     STRNG2+1
L3EBE:
        jsr     FMULT
        lda     STRNG2
        ldy     STRNG2+1
        clc
        adc     #BYTES_FP
        bcc     L3ECB
        iny
L3ECB:
        sta     STRNG2
        sty     STRNG2+1
        jsr     FADD
        lda     #TEMP2
        ldy     #$00
        dec     SERLEN
        bne     L3EBE
L3EDA:
        rts
CONRND1:
        .byte   $98,$35,$44,$7A
CONRND2:
        .byte   $68,$28,$B1,$46
RND:
        jsr     SIGN
.ifdef CBM
        bmi     L3F01
        bne     LDF63
        lda     $9044
        sta     $B1
        lda     $9048
        sta     $B2
        lda     $9045
        sta     $B3
        lda     $9049
        sta     $B4
        jmp     LDF88
LDF63:
.else
        tax
        bmi     L3F01
.endif
        lda     #<RNDSEED
        ldy     #$00
        jsr     LOAD_FAC_FROM_YA
.ifndef CBM
        txa
        beq     L3EDA
.endif
        lda     #<CONRND1
        ldy     #>CONRND1
        jsr     FMULT
        lda     #<CONRND2
        ldy     #>CONRND2
        jsr     FADD
L3F01:
        ldx     FAC_LAST
        lda     FAC+1
        sta     FAC_LAST
        stx     FAC+1
.ifdef CBM
        ldx     $B2
        lda     $B3
        sta     $B2
        stx     $B3
LDF88:
.endif
        lda     #$00
        sta     FACSIGN
        lda     FAC
        sta     FACEXTENSION
        lda     #$80
        sta     FAC
        jsr     NORMALIZE_FAC2
.ifndef CONFIG_11
        ldx     #$D4
.else /* CONFIG_11 */
        ldx     #$D8
.endif /* CONFIG_11 */
        ldy     #$00
GOMOVMF:
        jmp     STORE_FAC_AT_YX_ROUNDED
SIN_COS_TAN_ATN:
COS:
        lda     #<CON_PI_HALF
        ldy     #>CON_PI_HALF
        jsr     FADD
SIN:
        jsr     COPY_FAC_TO_ARG_ROUNDED
        lda     #<CON_PI_DOUB
        ldy     #>CON_PI_DOUB
        ldx     ARGSIGN
        jsr     DIV
        jsr     COPY_FAC_TO_ARG_ROUNDED
        jsr     INT
        lda     #$00
        sta     STRNG1
        jsr     FSUBT
        lda     #<QUARTER
        ldy     #>QUARTER
        jsr     FSUB
        lda     FACSIGN
        pha
        bpl     SIN1
        jsr     FADDH
        lda     FACSIGN
        bmi     L3F5B
        lda     CPRMASK
        eor     #$FF
        sta     CPRMASK
SIN1:
        jsr     NEGOP
L3F5B:
        lda     #<QUARTER
        ldy     #>QUARTER
        jsr     FADD
        pla
        bpl     L3F68
        jsr     NEGOP
L3F68:
        lda     #<POLY_SIN
        ldy     #>POLY_SIN
        jmp     POLYNOMIAL_ODD
TAN:
        jsr     STORE_FAC_IN_TEMP1_ROUNDED
        lda     #$00
        sta     CPRMASK
        jsr     SIN
        ldx     #TEMP3
        ldy     #$00
        jsr     GOMOVMF
        lda     #$A4
        ldy     #$00
        jsr     LOAD_FAC_FROM_YA
        lda     #$00
        sta     FACSIGN
        lda     CPRMASK
        jsr     TAN1
        lda     #TEMP3
        ldy     #$00
        jmp     FDIV
TAN1:
        pha
        jmp     SIN1
.ifndef CONFIG_11
CON_PI_HALF:
        .byte   $81,$49,$0F,$DB
CON_PI_DOUB:
        .byte   $83,$49,$0F,$DB
QUARTER:
        .byte   $7F,$00,$00,$00
POLY_SIN:
        .byte   $04,$86,$1E,$D7,$FB,$87,$99,$26
        .byte   $65,$87,$23,$34,$58,$86,$A5,$5D
        .byte   $E1,$83,$49,$0F,$DB
.else
CON_PI_HALF:
        .byte   $81,$49,$0F,$DA,$A2
CON_PI_DOUB:
        .byte   $83,$49,$0F,$DA,$A2
QUARTER:
        .byte   $7F,$00,$00,$00,$00
POLY_SIN:
        .byte   $05,$84,$E6,$1A,$2D,$1B,$86,$28
        .byte   $07,$FB,$F8,$87,$99,$68,$89,$01
        .byte   $87,$23,$35,$DF,$E1,$86,$A5,$5D
        .byte   $E7,$28,$83,$49,$0F,$DA,$A2
.ifndef CBM
MICROSOFT:
        .byte   $A6,$D3,$C1,$C8,$D4,$C8,$D5,$C4
        .byte   $CE,$CA
.endif
.endif /* CONFIG_11 */
ATN:
        lda     FACSIGN
        pha
        bpl     L3FDB
        jsr     NEGOP
L3FDB:
        lda     FAC
        pha
        cmp     #$81
        bcc     L3FE9
        lda     #<CON_ONE
        ldy     #>CON_ONE
        jsr     FDIV
L3FE9:
        lda     #<POLY_ATN
        ldy     #>POLY_ATN
        jsr     POLYNOMIAL_ODD
        pla
        cmp     #$81
        bcc     L3FFC
        lda     #<CON_PI_HALF
        ldy     #>CON_PI_HALF
        jsr     FSUB
L3FFC:
        pla
        bpl     L4002
        jmp     NEGOP
L4002:
        rts
POLY_ATN:
.ifndef CONFIG_11
        .byte   $08
		.byte	$78,$3A,$C5,$37
		.byte	$7B,$83,$A2,$5C
		.byte	$7C,$2E,$DD,$4D
		.byte	$7D,$99,$B0,$1E
		.byte	$7D,$59,$ED,$24
		.byte	$7E,$91,$72,$00
		.byte	$7E,$4C,$B9,$73
		.byte	$7F,$AA,$AA,$53
		.byte	$81,$00,$00,$00
.else /* CONFIG_11 */
        .byte   $0B
		.byte	$76,$B3,$83,$BD,$D3
		.byte	$79,$1E,$F4,$A6,$F5
		.byte	$7B,$83,$FC,$B0,$10
        .byte   $7C,$0C,$1F,$67,$CA
		.byte	$7C,$DE,$53,$CB,$C1
		.byte	$7D,$14,$64,$70,$4C
		.byte	$7D,$B7,$EA,$51,$7A
		.byte	$7D,$63,$30,$88,$7E
		.byte	$7E,$92,$44,$99,$3A
		.byte	$7E,$4C,$CC,$91,$C7
		.byte	$7F,$AA,$AA,$AA,$13
        .byte   $81,$00,$00,$00,$00
.ifndef CBM
		.byte	$00 ; XXX
.endif
.endif /* CONFIG_11 */
RAMSTART1:
GENERIC_CHRGET:
        inc     TXTPTR
        bne     L4047
        inc     TXTPTR+1
L4047:
        lda     $EA60
        cmp     #$3A
        bcs     L4058
        cmp     #$20
        beq     GENERIC_CHRGET
        sec
        sbc     #$30
        sec
        sbc     #$D0
L4058:
        rts
.ifdef OSI
        .byte   $80,$4F,$C7,$52
.endif
.ifdef KIM
        .byte   $80,$4F,$C7,$52,$58
.endif
.ifdef CBM
        .byte   $80,$4F,$C7,$52,$59
.endif
GENERIC_CHRGET_END:
COLD_START:
.ifndef CBM
        lda     #<QT_WRITTEN_BY
        ldy     #>QT_WRITTEN_BY
        jsr     STROUT
.endif
COLD_START2:
        ldx     #$FF
        stx     CURLIN+1
        txs
.ifndef CBM
        lda     #<COLD_START2
        ldy     #>COLD_START2
        sta     L0001
        sty     L0002
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
.ifdef CBM
        sta     JMPADRS
        sta     Z00
.else
        sta     Z00
        sta     GOWARM
        sta     JMPADRS
.endif
.ifndef CONFIG_11
        sta     USR
        lda     #$88
        ldy     #$AE
        sta     $0B
        sty     $0C
.endif /* ! CONFIG_11 */
        lda     #$48
        sta     Z17
        lda     #$38
        sta     Z18
.ifndef CONFIG_11
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET
.else /* CONFIG_11 */
        ldx     #GENERIC_CHRGET_END-GENERIC_CHRGET-1 ; XXX
.endif /* CONFIG_11 */
L4098:
        lda     GENERIC_CHRGET-1,x
        sta     STRNG2+1,x
        dex
        bne     L4098
        txa
        sta     SHIFTSIGNEXT
.ifdef CBM
        sta     $03
.endif
        sta     LASTPT+1
        sta     Z15
.ifndef KIM
        sta     Z16
.endif /* ! CONFIG_11 */
        pha
        sta     Z14
        lda     #$03
        sta     DSCLEN
.ifndef KIM
        lda     #$2C
        sta     LINNUM+1
.endif /* ! CONFIG_11 */
        jsr     CRDO
        ldx     #TEMPST
        stx     TEMPPT
.ifndef CBM
        lda     #<QT_MEMORY_SIZE
        ldy     #>QT_MEMORY_SIZE
        jsr     STROUT
        jsr     NXIN
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGET
        cmp     #$41
        beq     COLD_START
        tay
        bne     L40EE
.endif
        lda     #<RAMSTART2
        ldy     #>RAMSTART2
        sta     LINNUM
        sty     LINNUM+1
        ldy     #$00
L40D7:
        inc     LINNUM
        bne     L40DD
        inc     LINNUM+1
.ifdef CBM
        lda     $09
        cmp     #$80
        beq     L40FA
.endif
L40DD:
        lda     #$92
        sta     (LINNUM),y
        cmp     (LINNUM),y
        bne     L40FA
        asl     a
        sta     (LINNUM),y
        cmp     (LINNUM),y
.ifdef CBM
        beq     L40D7
.endif
.ifdef OSI
        beq     L40D7
        bne     L40FA
.endif
.ifdef KIM
        bne     L40FA
        beq     L40D7
.endif
L40EE:
.ifndef CBM
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
.ifndef CBM
        lda     #<QT_TERMINAL_WIDTH
        ldy     #>QT_TERMINAL_WIDTH
        jsr     STROUT
        jsr     NXIN
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
.ifndef KIM
        ldx     #<RAMSTART3
        ldy     #>RAMSTART3
.else /* CONFIG_11 */
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
.endif /* CONFIG_11 */
        stx     TXTTAB
        sty     TXTTAB+1
        ldy     #$00
        tya
        sta     (TXTTAB),y
        inc     TXTTAB
        bne     L4192
        inc     TXTTAB+1
L4192:
        lda     TXTTAB
        ldy     TXTTAB+1
        jsr     REASON
        jsr     CRDO
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
.ifdef CONFIG_11
        jsr     SCRTCH
.endif /* CONFIG_11 */
.ifdef CBM
        jmp     LC38B
.else
        lda     #<STROUT
        ldy     #>STROUT
        sta     GOWARM+1
        sty     GOWARM+2
.ifndef CONFIG_11
        jsr     SCRTCH
.endif /* CONFIG_11 */
        lda     #<RESTART
        ldy     #>RESTART
        sta     L0001
        sty     L0002
        jmp     (L0001)
.endif
QT_WANT:
        .byte   "WANT SIN-COS-TAN-ATN"
        .byte   $00
QT_WRITTEN_BY:
        .byte   $0D,$0A,$0C
.ifndef CONFIG_11
        .byte   "WRITTEN BY RICHARD W. WEILAND."
.else /* CONFIG_11 */
        .byte   "WRITTEN BY WEILAND & GATES"
.endif /* CONFIG_11 */
        .byte   $0D,$0A,$00
QT_MEMORY_SIZE:
        .byte   "MEMORY SIZE"
        .byte   $00
QT_TERMINAL_WIDTH:
        .byte   "TERMINAL WIDTH"
        .byte   $00
QT_BYTES_FREE:
        .byte   " BYTES FREE"
        .byte   $0D,$0A,$0D,$0A
.ifndef CONFIG_11
        .byte   "OSI 6502 BASIC VERSION 1.0 REV "
        .byte   "3.2"
.else /* CONFIG_11 */
        .byte   "MOS TECH 6502 BASIC V1.1"
.endif /* CONFIG_11 */
        .byte   $0D,$0A
        .byte   "COPYRIGHT 1977 BY MICROSOFT CO."
        .byte   $0D,$0A,$00

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
.endif /* OSI */
.ifdef KIM
RAMSTART2:
        .byte   $08,$29,$25,$20,$60,$2A,$E5,$E4
        .byte   $20,$66,$24,$65,$AC,$04,$A4
.endif /* KIM */
