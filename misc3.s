; KBD specific patches

.segment "CODE"

.ifdef KBD
VARTAB_MINUS_2_TO_AY:
        lda     VARTAB
        sec
        sbc     #$02
        ldy     VARTAB+1
        bcs     LF42C
        dey
LF42C:
        rts

; ----------------------------------------------------------------------------
GET_UPPER:
        lda     INPUTBUFFERX,x
LF430:
        cmp     #'a'
        bcc     LF43A
        cmp     #'z'+1
        bcs     LF43A
LF438:
        sbc     #$1F
LF43A:
        rts

; ----------------------------------------------------------------------------
GETLN:
        ldx     #$5D
LF43D:
        txa
        and     #$7F
        cmp     $0340
        beq     LF44D
        sta     $0340
        lda     #$03
        jsr     LDE48
LF44D:
        jsr     LDE7F
        bne     RTS4
        cpx     #$80
        bcc     LF44D
RTS4:
        rts

; ----------------------------------------------------------------------------
LF457:
        lda     TXTTAB
        ldx     TXTTAB+1
LF45B:
        sta     JMPADRS+1
        stx     JMPADRS+2
        ldy     #$01
        lda     (JMPADRS+1),y
        beq     LF438
        iny
        iny
        lda     (JMPADRS+1),y
        dey
        cmp     LINNUM+1
        bne     LF472
        lda     (JMPADRS+1),y
        cmp     LINNUM
LF472:
        bcs     LF43A
        dey
        lda     (JMPADRS+1),y
        tax
        dey
        lda     (JMPADRS+1),y
        bcc     LF45B
LF47D:
        jmp     (JMPADRS+1)
.endif
