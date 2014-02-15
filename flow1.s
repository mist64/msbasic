.segment "CODE"

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
.if .def(CONFIG_NO_INPUTBUFFER_ZP) && .def(CONFIG_2)
        cpy     #>INPUTBUFFER
  .ifdef CBM2
        nop
  .endif
        beq     LC6D4
.else
; BUG on AppleSoft I,
; fixed differently on AppleSoft II (ldx/inx)
        beq     L2683
.endif
        sta     OLDTEXT
        sty     OLDTEXT+1
LC6D4:
        ldy     #$00
L2683:
        lda     (TXTPTR),y
.ifndef CONFIG_11
        beq     LA5DC	; old: 1 cycle more on generic case
        cmp     #$3A
        beq     NEWSTT2
SYNERR1:
        jmp     SYNERR
LA5DC:
.else
        bne     COLON; new: 1 cycle more on ":" case
.endif
        ldy     #$02
        lda     (TXTPTR),y
        clc
.ifdef CONFIG_2
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
.ifndef CONFIG_11A
        beq     RET1
.else
        beq     RET2
.endif
.ifndef CONFIG_11
        sec
.endif
EXECUTE_STATEMENT1:
        sbc     #$80
.ifndef CONFIG_11
        jcc     LET	; old: 1 cycle more on instr.
.else
        bcc     LET1; new: 1 cycle more on assignment
.endif
        cmp     #NUM_TOKENS
.ifdef CONFIG_2
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

.ifdef CONFIG_2; GO TO
LC721:
        cmp     #TOKEN_GO-$80
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

.include "iscntc.s"
;!!! runs into "STOP"
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
.if .def(CONFIG_NO_INPUTBUFFER_ZP) && .def(CONFIG_2)
; BUG on AppleSoft I
; fix exists on AppleSoft II
; TXTPTR+1 will always be > 0
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
; not ROR bug safe
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

.ifndef AIM65
.if .def(CONFIG_NULL) || .def(CONFIG_PRINTNULLS)
; CBM1 has the keyword removed,
; but the code is still here
NULL:
        jsr     GETBYT
        bne     RET1
        inx
        cpx     #NULL_MAX
        bcs     L2739
        dex
        stx     Z15
L2738:
        rts
L2739:
        jmp     IQERR
.endif
.ifndef CONFIG_11A
CLEAR:
        bne     RET1
        jmp     CLEARC
.endif
.endif
