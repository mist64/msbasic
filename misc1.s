.segment "CODE"

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
.endif

; ----------------------------------------------------------------------------
; INSTALL STRING, DESCRIPTOR ADDRESS IS AT FAC+3,4
; ----------------------------------------------------------------------------
PUTSTR:
.ifdef CONFIG_CBM_ALL
        ldy     FORPNT+1
  .ifdef CBM1
        cpy     #$D0	; TI$
  .else
        cpy     #$DE
  .endif
        bne     LC92B
        jsr     FREFAC
        cmp     #$06
  .ifdef CBM2
        bne     IQERR1
  .else
        jne     IQERR
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
        sta     TISTR,x
        dex
        bpl     LC912
        cli
        rts
LC91C:
        lda     (INDEX),y
        jsr     CHRGOT2
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
RET5:
        rts
.ifdef AIM65
LB89D:
        cmp     #$21
        bne     RET5
        lda     #$80
        sta     PRIFLG
        jmp     CHRGET
.endif

.ifdef CONFIG_FILE
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
        stx     CURDVC
        plp
        jmp     PRINT
.endif

