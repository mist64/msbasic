; generic stack and memory management code
; this code is identical across all versions of
; BASIC

.segment "CODE"

; ----------------------------------------------------------------------------
; CALLED BY "NEXT" AND "FOR" TO SCAN THROUGH
; THE STACK FOR A FRAME WITH THE SAME VARIABLE.
;
; (FORPNT) = ADDRESS OF VARIABLE IF "FOR" OR "NEXT"
; 	= $XXFF IF CALLED FROM "RETURN"
; 	<<< BUG: SHOULD BE $FFXX >>>
;
;	RETURNS .NE. IF VARIABLE NOT FOUND,
;	(X) = STACK PNTR AFTER SKIPPING ALL FRAMES
;
;	.EQ. IF FOUND
;	(X) = STACK PNTR OF FRAME FOUND
; ----------------------------------------------------------------------------
GTFORPNT:
        tsx
        inx
        inx
        inx
        inx
L2279:
        lda     STACK+1,x
        cmp     #$81
        bne     L22A1
        lda     FORPNT+1
        bne     L228E
        lda     STACK+2,x
        sta     FORPNT
        lda     STACK+3,x
        sta     FORPNT+1
L228E:
        cmp     STACK+3,x
        bne     L229A
        lda     FORPNT
        cmp     STACK+2,x
        beq     L22A1
L229A:
        txa
        clc
        adc     #BYTES_PER_FRAME
        tax
        bne     L2279
L22A1:
        rts

; ----------------------------------------------------------------------------
; MOVE BLOCK OF MEMORY UP
;
; ON ENTRY:
;	(Y,A) = (HIGHDS) = DESTINATION END+1
;	(LOWTR) = LOWEST ADDRESS OF SOURCE
;	(HIGHTR) = HIGHEST SOURCE ADDRESS+1
; ----------------------------------------------------------------------------
BLTU:
        jsr     REASON
        sta     STREND
        sty     STREND+1
BLTU2:
        sec
        lda     HIGHTR
        sbc     LOWTR
        sta     INDEX
        tay
        lda     HIGHTR+1
        sbc     LOWTR+1
        tax
        inx
        tya
        beq     L22DD
        lda     HIGHTR
        sec
        sbc     INDEX
        sta     HIGHTR
        bcs     L22C6
        dec     HIGHTR+1
        sec
L22C6:
        lda     HIGHDS
        sbc     INDEX
        sta     HIGHDS
        bcs     L22D6
        dec     HIGHDS+1
        bcc     L22D6
L22D2:
        lda     (HIGHTR),y
        sta     (HIGHDS),y
L22D6:
        dey
        bne     L22D2
        lda     (HIGHTR),y
        sta     (HIGHDS),y
L22DD:
        dec     HIGHTR+1
        dec     HIGHDS+1
        dex
        bne     L22D6
        rts

; ----------------------------------------------------------------------------
; CHECK IF ENOUGH ROOM LEFT ON STACK
; FOR "FOR", "GOSUB", OR EXPRESSION EVALUATION
; ----------------------------------------------------------------------------
CHKMEM:
        asl     a
        adc     #SPACE_FOR_GOSUB
        bcs     MEMERR
        sta     INDEX
        tsx
        cpx     INDEX
        bcc     MEMERR
        rts

; ----------------------------------------------------------------------------
; CHECK IF ENOUGH ROOM BETWEEN ARRAYS AND STRINGS
; (Y,A) = ADDR ARRAYS NEED TO GROW TO
; ----------------------------------------------------------------------------
REASON:
        cpy     FRETOP+1
        bcc     L231E
        bne     L22FC
        cmp     FRETOP
        bcc     L231E
L22FC:
        pha
        ldx     #FAC-TEMP1-1
        tya
L2300:
        pha
        lda     TEMP1,x
        dex
        bpl     L2300
        jsr     GARBAG
        ldx     #TEMP1-FAC+1
L230B:
        pla
        sta     FAC,x
        inx
        bmi     L230B
        pla
        tay
        pla
        cpy     FRETOP+1
        bcc     L231E
        bne     MEMERR
        cmp     FRETOP
        bcs     MEMERR
L231E:
        rts
