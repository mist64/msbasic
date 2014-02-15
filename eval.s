.segment "CODE"

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
.ifndef CONFIG_2
        inx
        inx
        inx
        inx
.endif
        txa
.ifdef CONFIG_2
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
.ifndef CONFIG_2B
        inc     INDEX ; bug: assumes not on page boundary
; bug exists on AppleSoft II
.endif
        pla
        sta     INDEX+1
.ifdef CONFIG_2B
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
        sta     SGNCPR
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
.ifdef SYM1
        cmp     #TOKEN_USR
        bne     LCC8A
        jmp     LCDBD
LCC8A:
        cmp     #$26
        bne     LCC91
        jmp     LCDFE
LCC91:
.endif
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
        stx     STRNG1+1
        bit     FAC+4
        bpl     LCE53
        cmp     #$54	; T
        bne     LCE53
  .endif
        cpy     #$C9	; I$
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
.ifdef CONFIG_2
  .ifndef CBM2
; bugfix?
; fixed on AppleSoft II, not on any CBM
        ldx     #$00
        stx     STRNG1+1
  .endif
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
        .byte   $19
.endif
.ifdef CBM2
        bit     FAC+4
        bpl     LCE90
        cmp     #$54
        bne     LCE82
.endif
.ifndef CONFIG_CBM_ALL
        jmp     LOAD_FAC_FROM_YA
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

.ifdef SYM1
LCDBD:
        jsr     CHRGET
        jsr     CHKOPN
        jsr     FRMEVL
        jsr     CHRGOT
        cmp     #$29
        beq     LCDF1
        jsr     AYINT
        lda     FAC+4
        ldy     FAC+3
        sta     USR+1
        sty     USR+2
LCDD8:
        jsr     CHKCOM
        jsr     FRMEVL
        jsr     CHRGOT
        cmp     #$29
        beq     LCDF1
        jsr     AYINT
        lda     FAC+3
        pha
        lda     FAC+4
        pha
        jmp     LCDD8

LCDF1:
        jsr     CHRGET
        jsr     AYINT
        lda     FAC+3
        ldy     FAC+4
        jmp     USR

LCDFE:
        lda     ZD4
        pha
        lda     ZD3
        pha
        jsr     CHRGET
        cmp     #$22
        bne     LCE49
        jsr     CHRGET
        jsr     LCE2B
        tax
        jsr     CHRGOT
        jsr     LCE2B
        pha
        jsr     CHRGOT
        cmp     #$22
        bne     LCE48
        jsr     CHRGET
        pla
        tay
        pla
        pla
        txa
        jmp     GIVAYF

LCE2B:
        jsr     ASCNIB
        bcs     LCE47
        pha
        jsr     CHRGET
        jsr     ASCNIB
        sta     FAC+4
        bcs     LCE46
        jsr     CHRGET
        pla
        asl     a
        asl     a
        asl     a
        asl     a
        ora     FAC+4
        rts

LCE46:
        pla
LCE47:
        pla
LCE48:
        pla
LCE49:
        pla
        sta     ZD3
        pla
        sta     ZD4
        jmp     ZERO_FAC
.endif
