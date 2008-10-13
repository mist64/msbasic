.segment "CODE"

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
