.segment "CODE"

.ifndef CONFIG_NO_INPUTBUFFER_ZP
L2420:
  .ifdef OSI
        jsr     OUTDO
  .endif
        dex
        bpl     INLIN2
L2423:
  .ifdef OSI
        jsr     OUTDO
  .endif
        jsr     CRDO
.endif

; ----------------------------------------------------------------------------
; READ A LINE, AND STRIP OFF SIGN BITS
; ----------------------------------------------------------------------------
.ifndef KBD
INLIN:
  .ifdef APPLE
        ldx     #$DD
INLIN1:
        stx     $33
        jsr     L2900
        cpx     #$EF
        bcs     L0C32
        ldx     #$EF
L0C32:
        lda     #$00
        sta     INPUTBUFFER,x
        ldx     #<INPUTBUFFER-1
        ldy     #>INPUTBUFFER-1
        rts
  .endif

  .ifndef APPLE
        ldx     #$00
INLIN2:
        jsr     GETLN
    .ifndef CONFIG_NO_LINE_EDITING
        cmp     #$07
        beq     L2443
    .endif
        cmp     #$0D
        beq     L2453
    .ifndef CONFIG_NO_LINE_EDITING
        cmp     #$20
        bcc     INLIN2
      .ifdef MICROTAN
        cmp     #$80
      .else
        cmp     #$7D
      .endif
        bcs     INLIN2
        cmp     #$40 ; @
        beq     L2423
      .ifdef MICROTAN
        cmp     #$7F ; DEL
      .else
        cmp     #$5F ; _
      .endif
        beq     L2420
L2443:
      .ifdef MICROTAN
        cpx     #$4F
      .else
        cpx     #$47
      .endif
        bcs     L244C
    .endif
        sta     INPUTBUFFER,x
        inx
    .ifdef OSI
        .byte   $2C
    .else
        bne     INLIN2
    .endif
L244C:
    .ifndef CONFIG_NO_LINE_EDITING
        lda     #$07 ; BEL
        jsr     OUTDO
        bne     INLIN2
    .endif
L2453:
        jmp     L29B9
  .endif
.endif

.ifndef KBD
  .ifndef APPLE
GETLN:
    .ifdef CONFIG_FILE
        jsr     CHRIN
        ldy     CURDVC
        bne     L2465
    .else
        jsr     MONRDKEY
    .endif
    .ifdef OSI
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        nop
        and     #$7F
    .endif
  .endif /* APPLE */
  .ifdef APPLE
RDKEY:
        jsr     LFD0C
        and     #$7F
  .endif
        cmp     #$0F
        bne     L2465
        pha
        lda     Z14
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts
.endif /* KBD */
