.segment "CODE"

SAVE:
        pha
        jsr     WHEREO
        jsr     OUTSP
        lda     #$ff
        jmp     LB4BF

MONRDKEY:
        lda     INFLG
        jsr     COUT5
        bne     LOAD2
        jmp     INALL
LOAD2:
        jmp     CUREAD

MONCOUT:
        pha
        lda     OUTFLG
        jsr     COUT5
        bne     COUT3
        pla
        jmp     OUTALL

COUT3:
        pla
        cmp     #LF
        beq     COUT6
        cmp     #CR
        beq     COUT4
        jmp     OUTPUT
COUT4:
        jsr     CRCK
        lda     #CR
        rts

COUT5:
        cmp     #$54
        beq     COUT6
        cmp     #$55
        beq     COUT6
        cmp     #$4C
COUT6:
        rts

MONRDKEY2:
        jsr     ROONEK
        tya
        beq     COUT5
        jmp     GETKY
