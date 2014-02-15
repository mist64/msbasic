.segment "CODE"

SAVE:
        beq     L2739
        sta     P1L
        jsr     CHRGET
        bne     NULL-1

        lda     TXTTAB
        ldy     TXTTAB+1
        sta     P2L
        sty     P2H

        lda     VARTAB
        ldy     VARTAB+1
        sta     P3L
        sty     P3H

        ldy     #$80
        jsr     USR2
        bcs     LC6DD
        lda     #<SAVED
        ldy     #>SAVED
        jmp     STROUT

LOADED:
        .byte "LOADED",CR,LF
        .byte "OK",CR,LF,0

SAVED:
        .byte "SAVED",CR,LF,0

LOAD:
        beq     L2739
        sta     $A64E
        jsr     CHRGET
        bne     L2738
        ldy     #$80
        jsr     USR3
        bcs     LC6EF

        lda     #<LOADED
        ldy     #>LOADED
        jsr     STROUT

        ldx     P3L
        ldy     P3H
        txa
        stx     VARTAB
        sty     VARTAB+1
        jmp     FIX_LINKS

LC6DD:
        lda     #<BAD_SAVE
        ldy     #>BAD_SAVE
        jmp     STROUT

BAD_SAVE:
        htasc   "BAD SAVE"
        .byte   CR,LF,0
LC6EF:
        lda     #<BAD_LOAD
        ldy     #>BAD_LOAD
        jsr     STROUT
        jsr     SCRTCH
        jmp     RESTART

BAD_LOAD:
        htasc   "BAD LOAD"
        .byte   CR,LF,0
