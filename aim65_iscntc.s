.segment "CODE"
ISCNTC:
        lda     DRA2
        pha
        lda     #$7f
        sta     DRA2
        pha
        pla
        lda     DRB2
        rol     a
        pla
        sta     DRA2
        bcs     RET2

        jsr     GETKEY
        lda     #$03
        cmp     #$03
;!!! runs into "STOP"