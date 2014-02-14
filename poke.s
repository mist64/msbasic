.segment "CODE"

.ifndef CONFIG_NO_POKE
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
        nop ; PATCH
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
.ifdef CONFIG_PEEK_SAVE_LINNUM
        lda     LINNUM+1
        pha
        lda     LINNUM
        pha
.endif
        jsr     GETADR
        ldy     #$00
.ifdef CBM1
; disallow PEEK between $C000 and $DFFF
        cmp     #$C0
        bcc     LD6F3
        cmp     #$E1
        bcc     LD6F6
LD6F3:
.endif
.ifdef CBM2
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
.ifdef CONFIG_PEEK_SAVE_LINNUM
        pla
        sta     LINNUM
        pla
        sta     LINNUM+1
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
.ifdef CONFIG_EASTER_EGG
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
