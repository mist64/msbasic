.segment "CODE"
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
.ifdef CONFIG_2A
        sta     FORPNT+1 ; bugfix, wrong in AppleSoft II
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
        beq     L285E; old: swap & cont is faster
        bne     L2866
.else
        bne     L2866; new: cont is faster
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
