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

		init_token_tables

		keyword_rts "END", END
		keyword_rts "FOR", FOR
		keyword_rts "NEXT", NEXT
		keyword_rts "DATA", DATA
.ifdef CONFIG_CBM_ALL
		keyword_rts "INPUT#", INPUTH
.endif
		keyword_rts "INPUT", INPUT
		keyword_rts "DIM", DIM
		keyword_rts "READ", READ
.ifdef APPLE
		keyword_rts "PLT", PLT
.else
		keyword_rts "LET", LET
.endif
		keyword_rts "GOTO", GOTO, TOKEN_GOTO
		keyword_rts "RUN", RUN
		keyword_rts "IF", IF
		keyword_rts "RESTORE", RESTORE
		keyword_rts "GOSUB", GOSUB, TOKEN_GOSUB
		keyword_rts "RETURN", POP
.ifdef APPLE
		keyword_rts "TEX", TEX, TOKEN_REM
.else
		keyword_rts "REM", REM, TOKEN_REM
.endif
		keyword_rts "STOP", STOP
		keyword_rts "ON", ON
.ifdef CONFIG_NULL
		keyword_rts "NULL", NULL
.endif
.ifdef KBD
		keyword_rts "PLOD", PLOD
		keyword_rts "PSAV", PSAV
		keyword_rts "VLOD", VLOD
		keyword_rts "VSAV", VSAV
.else
		keyword_rts "WAIT", WAIT
		keyword_rts "LOAD", LOAD
		keyword_rts "SAVE", SAVE
.endif
.ifdef CONFIG_CBM_ALL
		keyword_rts "VERIFY", VERIFY
.endif
		keyword_rts "DEF", DEF
.ifdef KBD
		keyword_rts "SLOD", SLOD
.else
		keyword_rts "POKE", POKE
.endif
.ifdef CONFIG_CBM_ALL
		keyword_rts "PRINT#", PRINTH
.endif
		keyword_rts "PRINT", PRINT, TOKEN_PRINT
		keyword_rts "CONT", CONT
		keyword_rts "LIST", LIST
.ifdef CONFIG_CBM_ALL
		keyword_rts "CLR", CLEAR
.else
		keyword_rts "CLEAR", CLEAR
.endif
.ifdef CONFIG_CBM_ALL
		keyword_rts "CMD", CMD
		keyword_rts "SYS", SYS
		keyword_rts "OPEN", OPEN
		keyword_rts "CLOSE", CLOSE
.endif
.ifndef CONFIG_SMALL
		keyword_rts "GET", GET
.endif
.ifdef KBD
		keyword_rts "PRT", PRT
.endif
		keyword_rts "NEW", NEW

		count_tokens

		keyword	"TAB(", TOKEN_TAB
		keyword	"TO", TOKEN_TO
		keyword	"FN", TOKEN_FN
		keyword	"SPC(", TOKEN_SPC
		keyword	"THEN", TOKEN_THEN
		keyword	"NOT", TOKEN_NOT
		keyword	"STEP", TOKEN_STEP
		keyword	"+", TOKEN_PLUS
		keyword	"-", TOKEN_MINUS
		keyword	"*"
		keyword	"/"
.ifdef KBD
		keyword	"#"
.else
		keyword	"^"
.endif
		keyword	"AND"
		keyword	"OR"
		keyword	">", TOKEN_GREATER
		keyword	"=", TOKEN_EQUAL
		keyword	"<"

        .segment "VECTORS"
UNFNC:

		keyword_addr "SGN", SGN, TOKEN_SGN
		keyword_addr "INT", INT
		keyword_addr "ABS", ABS
.ifdef KBD
		keyword_addr "VER", VER
.else
.ifdef KIM
		keyword_addr "USR", IQERR
.else
		keyword_addr "USR", USR
.endif
.endif
		keyword_addr "FRE", FRE
		keyword_addr "POS", POS
		keyword_addr "SQR", SQR
		keyword_addr "RND", RND
		keyword_addr "LOG", LOG
		keyword_addr "EXP", EXP
		keyword_addr "COS", COS
		keyword_addr "SIN", SIN
		keyword_addr "TAN", TAN
		keyword_addr "ATN", ATN
.ifdef KBD
		keyword_addr "GETC", GETC
.else
		keyword_addr "PEEK", PEEK
.endif
		keyword_addr "LEN", LEN
		keyword_addr "STR$", STR
		keyword_addr "VAL", VAL
		keyword_addr "ASC", ASC
		keyword_addr "CHR$", CHRSTR
		keyword_addr "LEFT$", LEFTSTR, TOKEN_LEFTSTR
		keyword_addr "RIGHT$", RIGHTSTR
		keyword_addr "MID$", MIDSTR
.ifdef CBM2_KBD
		keyword	"GO"
.endif
        .segment "KEYWORDS"
		.byte   0

        .segment "VECTORS"
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
        .word   TAND-1
        .byte   $46
        .word   OR-1
        .byte   $7D
        .word   NEGOP-1
        .byte   $5A
        .word   EQUOP-1
        .byte   $64
        .word   RELOPS-1

        .segment "CODE"
ERROR_MESSAGES:
.ifdef CONFIG_SMALL
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
.else
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
.ifdef CBM1
.define ERRSTR_BADDATA "BAD DATA"
.endif
.ifdef CBM2
.define ERRSTR_BADDATA "FILE DATA"
.endif
.define ERRSTR_FRMCPX "FORMULA TOO COMPLEX"
.define ERRSTR_CANTCONT "CAN'T CONTINUE"
.define ERRSTR_UNDEFFN "UNDEF'D FUNCTION"
.endif

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
.ifdef CBM1
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
.ifdef CONFIG_CBM_ALL
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
PRINT_ERROR_LINNUM:
        jsr     STROUT
        ldy     CURLIN+1
        iny
        beq     RESTART
        jsr     INPRT
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
PUT_NEW_LINE:
.ifdef CBM2
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
L23E6:
        lda     INPUTBUFFER-4,y
        sta     (LOWTR),y
        dey
        bpl     L23E6
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
        sta     $0200,x
        ldx     #$FF
        ldy     #$01
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
L24EA:
        sta     INPUTBUFFER-3,y
.if INPUTBUFFER >= $0100
        dec     TXTPTR+1
.endif
        lda     #<INPUTBUFFER-1
        sta     TXTPTR
        rts
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
SETPTRS:
        jsr     STXTPT
.ifndef APPLE
.ifdef CONFIG_11
        lda     #$00
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
STOP:
        bcs     END2
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
        lda     #TOKEN_GOSUB
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
.ifndef CONFIG_11
        beq     L285E
        bne     L2866
.else
        bne     L2866
        beq     L285E
.endif
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
        jmp     SETFOR
LETSTRING:
.ifndef CONFIG_SMALL
        pla
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
L2A59:
        lda     INPUTFLG
        beq     L2A6E
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
L2A6E:
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
L2B34:
        jsr     FIN
.ifdef CONFIG_SMALL
        jsr     SETFOR
.else
        lda     VALTYP+1
        jsr     LET2
.endif
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
        lda     TXPSV
        ldy     TXPSV+1
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
L2CED:
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
SYNCHR:	; XXX all CBM code calls SYNCHR instead of CHKCOM
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
OR:
        ldy     #$FF
        .byte   $2C
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
.ifndef CBM2_KBD
C_ZERO:
        .byte   $00,$00
.endif
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
.ifdef CBM2_KBD
        jsr     FRMEVL
.else
        jsr     FRMNUM
.endif
MKINT:
.ifdef CBM2_KBD
        jsr     CHKNUM
.endif
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
.ifndef CONFIG_SMALL
        ora     VALTYP+1
.endif
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
.ifndef CONFIG_SMALL
        sta     VALTYP+1
        and     #$7F
.endif
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
.ifdef OSI
        stx     STRNG2
.endif
        lda     VARNAM
        sta     (LOWTR),y
.ifndef CONFIG_SMALL
        bpl     L3078
        dex
L3078:
.endif
        iny
        lda     VARNAM+1
        sta     (LOWTR),y
.ifndef OSI
        bpl     L3081
        dex
.ifndef KBD
        dex
.endif
L3081:
        stx     STRNG2
.endif
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
.ifdef OSI
        asl     STRNG2
        rol     a
        bcs     GSE
        asl     STRNG2
        rol     a
        bcs     GSE
        tay
        lda     STRNG2
.else
.ifndef CBM1_APPLE
        sta     STRNG2+1
.endif
        ldx     #BYTES_FP
.ifdef KBD
        lda     VARNAM+1
.else
        lda     VARNAM
.endif
        bpl     L3135
        dex
L3135:
.ifndef KBD
        lda     VARNAM+1
        bpl     L313B
        dex
        dex
L313B:
.endif
.ifdef KBD
        stx     RESULT+1
.else
        stx     RESULT+2
.endif
        lda     #$00
        jsr     MULTIPLY_SUBS1
        txa
.endif
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
STR:
        jsr     CHKNUM
        ldy     #$00
        jsr     FOUT1
        pla
        pla
LD353:
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
.if INPUTBUFFER >= $0100
        beq     LD399
        cmp     #>INPUTBUFFER
.endif
        bne     PUTNEW
LD399:
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
.ifdef CBM2_KBD
        sty     FACEXTENSION
.endif
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

.ifdef KBD
        ldx     #<CONST_MEMSIZ
        lda     #>CONST_MEMSIZ
.else
        ldx     MEMSIZ
        lda     MEMSIZ+1
.endif
FINDHIGHESTSTRING:
        stx     FRETOP
        sta     FRETOP+1
        ldy     #$00
        sty     FNCNAM+1
.ifdef CBM2_KBD
        sty     FNCNAM
.endif
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
.ifdef CONFIG_SMALL
        ldy     #$01
.else
        ldy     #$00
        lda     (INDEX),y
        tax
        iny
.endif
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
.ifndef CONFIG_SMALL
        txa
        bmi     L3367
.endif
        iny
        lda     (INDEX),y
.ifdef KBD
        ldy     #$00
.endif
.ifdef CBM1
        jsr     LE7F3
.else
.ifndef CONFIG_SMALL
        ldy     #$00
.endif
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
.ifndef CONFIG_SMALL
        lda     (INDEX),y
        bmi     CHECK_BUMP
.endif
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
        sta     Z52
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
.ifdef CBM2_KBD
        lda     FNCNAM+1
        ora     FNCNAM
.else
        ldx     FNCNAM+1
.endif
        beq     L33FA
        lda     Z52
.ifdef CBM1
        sbc     #$03
.else
        and     #$04
.endif
        lsr     a
        tay
        sta     Z52
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
        ldy     Z52
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
.ifdef KBD
        cpy     #$00
.else
        cpy     LASTPT+1
.endif
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
.ifdef CBM2_KBD
        beq     GOIQ
.endif
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
.else
        tay
        pla
        sta     Z52
.endif
        pla
        pla
        pla
        tax
        pla
        sta     DSCPTR
        pla
        sta     DSCPTR+1
.ifdef CONFIG_11
        lda     Z52
        pha
        tya
        pha
.endif
        ldy     #$00
        txa
.ifndef CBM2_KBD
        beq     GOIQ
.endif
.ifndef CONFIG_11
        inc     JMPADRS+1
        jmp     (JMPADRS+1)
.else
        rts
.endif
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
.ifndef CONFIG_11_NOAPPLE
        jmp     SNGFLT1
.else
        jmp     SNGFLT
.endif
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
GTNUM:
        jsr     FRMNUM
        jsr     GETADR
COMBYTE:
        jsr     CHKCOM
        jmp     GETBYT
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
		nop
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













.ifndef KBD
CONRND1:
        .byte   $98,$35,$44,$7A
CONRND2:
        .byte   $68,$28,$B1,$46
.endif
RND:
.ifdef KBD
        ldx     #$10
        jsr     SIGN
        beq     LFC26
        bmi     LFC10
        lda     $87
        ldy     $88
LFBFA:
        sta     FAC+2
        sty     FAC+1
LFBFE:
        asl     a
        asl     a
        eor     FAC+2
        asl     a
        eor     FAC+1
        asl     a
        asl     a
        asl     a
        asl     a
        eor     FAC+1
        asl     a
        rol     FAC+2
        rol     FAC+1
LFC10:
        lda     FAC+2
        dex
        bne     LFBFE
        sta     $87
        sta     FAC+3
        lda     FAC+1
        sta     $88
        lda     #$80
        sta     FAC
        stx     FACSIGN
        jmp     NORMALIZE_FAC2
LFC26:
        ldy     $03CA
        lda     $03C7
        ora     #$01
GOMOVMF:
        bne     LFBFA
        .byte   $F0
.else
        jsr     SIGN
.ifdef CONFIG_CBM_ALL
        bmi     L3F01
        bne     LDF63
        lda     ENTROPY
        sta     FAC+1
        lda     ENTROPY+4
        sta     FAC+2
        lda     ENTROPY+1
        sta     FAC+3
        lda     ENTROPY+5
        sta     FAC+4
        jmp     LDF88
LDF63:
.else
        tax
        bmi     L3F01
.endif
        lda     #<RNDSEED
        ldy     #$00
        jsr     LOAD_FAC_FROM_YA
.ifndef CONFIG_CBM_ALL
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
.ifdef CONFIG_CBM_ALL
        ldx     FAC+2
        lda     FAC+3
        sta     FAC+2
        stx     FAC+3
LDF88:
.endif
        lda     #$00
        sta     FACSIGN
        lda     FAC
        sta     FACEXTENSION
        lda     #$80
        sta     FAC
        jsr     NORMALIZE_FAC2
        ldx     #RNDSEED
        ldy     #$00
GOMOVMF:
        jmp     STORE_FAC_AT_YX_ROUNDED
.endif
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
        lda     #TEMP1+(5-BYTES_FP)
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
.ifdef CONFIG_SMALL
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
.ifndef CONFIG_CBM_ALL
MICROSOFT:
        .byte   $A6,$D3,$C1,$C8,$D4,$C8,$D5,$C4
        .byte   $CE,$CA
.endif
.ifdef CBM2
MICROSOFT:
        .byte   $A1,$54,$46,$8F,$13,$8F,$52,$43
        .byte   $89,$CD
.endif
.endif
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
.ifdef CONFIG_SMALL
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
.else
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
.ifdef KIM
		.byte	$00 ; XXX
.endif
.endif
RAMSTART1:
GENERIC_CHRGET:
        inc     TXTPTR
        bne     GENERIC_CHRGOT
        inc     TXTPTR+1
GENERIC_CHRGOT:
GENERIC_TXTPTR = GENERIC_CHRGOT + 1
        lda     $EA60
.ifdef KBD
        jsr     LF430
.endif
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
.ifndef KBD
; random number seed
.ifdef OSI
        .byte   $80,$4F,$C7,$52
.endif
.ifdef CONFIG_11
        .byte   $80,$4F,$C7,$52,$58
.endif
.ifdef CBM1
        .byte   $80,$4F,$C7,$52,$59
.endif
.endif
GENERIC_CHRGET_END:
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