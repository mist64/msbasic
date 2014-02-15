.segment "CODE"

.ifndef CONFIG_NO_INPUTBUFFER_ZP
L2420:
  .ifdef OSI
        jsr     OUTDO
  .endif
        dex
  .ifdef AIM65
        bmi     L2423
        jsr     PSLS
        jmp     INLIN2
LB35F:
        jsr     OUTDO
  .else
        bpl     INLIN2
  .endif
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
    .ifdef AIM65
        cmp     #$1A
        bne     INLINAIM
        jsr     DU13
        jmp     INLIN
INLINAIM:
    .endif
    .ifndef CONFIG_NO_LINE_EDITING
        cmp     #$07
        beq     L2443
    .endif
        cmp     #$0D
        beq     L2453
    .ifndef CONFIG_NO_LINE_EDITING
        cmp     #$20
      .ifdef AIM65
        bcc     L244E
      .else
        bcc     INLIN2
      .endif
      .ifdef MICROTAN
        cmp     #$80
      .else
        .ifdef AIM65
        cmp     #$7F
        beq     L2420
        .endif
        cmp     #$7D
      .endif
        bcs     INLIN2
        cmp     #$40 ; @
      .ifdef AIM65
        beq     LB35F
      .else
        beq     L2423
      .ifdef MICROTAN
        cmp     #$7F ; DEL
      .else
        cmp     #$5F ; _
      .endif
        beq     L2420
      .endif
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
    .if .def(OSI) || .def(AIM65)
        .byte   $2C
    .else
        bne     INLIN2
    .endif
L244C:
    .ifndef CONFIG_NO_LINE_EDITING
        lda     #$07 ; BEL
L244E:
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
  .endif
  .ifdef APPLE
RDKEY:
        jsr     LFD0C
        and     #$7F
  .endif
    .ifdef SYM1
        cmp     #$14
    .else
        cmp     #$0F
    .endif
        bne     L2465
        pha
        lda     Z14
        eor     #$FF
        sta     Z14
        pla
L2465:
        rts
.endif
