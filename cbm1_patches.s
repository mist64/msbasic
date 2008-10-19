.segment "INIT"

PATCH1:
        clc
        jmp     CONTROL_C_TYPED
PATCH2:
        bit     FAC+4
        bpl     LE1AA
        cmp     #$54
        bne     LE1AA
        jmp     LCE3B
LE1AA:
        rts
PATCH3:
        bit     FAC+4
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
        lda     Z8C
        ldy     Z8C+1
        rts
LE1C9:
        ldy     #$FF
        rts
PATCH6:
        bne     LE1D8
LE1CE:
        inc     POSX
        bne     LE1D8
        lda     $E2
        sta     POSX
        bne     LE1CE
LE1D8:
        rts
LE1D9:
        stx     TXTPTR
        pla
        pla
        tya
        jmp     L2B1C
