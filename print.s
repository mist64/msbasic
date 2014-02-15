.segment "CODE"

.ifdef AIM65
PRINT:
        lda     PRIFLG
        sta     ZBE
        jsr     L297E
LB8B1:
        lda     ZBE
        sta     PRIFLG
        rts
.endif

PRSTRING:
        jsr     STRPRT
L297E:
        jsr     CHRGOT

; ----------------------------------------------------------------------------
; "PRINT" STATEMENT
; ----------------------------------------------------------------------------
.ifndef AIM65
PRINT:
.endif
        beq     CRDO
PRINT2:
        beq     L29DD
.ifdef AIM65
        jsr     LB89D
        beq     L29DD
.endif
        cmp     #TOKEN_TAB
        beq     L29F5
        cmp     #TOKEN_SPC
.ifdef CONFIG_2
        clc	; also AppleSoft II
.endif
        beq     L29F5
        cmp     #','
; Pre-KIM had no CLC. KIM added the CLC
; here. Post-KIM moved the CLC up...
; (makes no sense on KIM, liveness = 0)
.if .def(CONFIG_11A) && (!.def(CONFIG_2))
        clc
.endif
        beq     L29DE
        cmp     #$3B
        beq     L2A0D
        jsr     FRMEVL
        bit     VALTYP
        bmi     PRSTRING
        jsr     FOUT
        jsr     STRLIT
.ifndef CONFIG_NO_CR
        ldy     #$00
        lda     (FAC_LAST-1),y
        clc
        adc     POSX
  .ifdef KBD
        cmp     #$28
  .else
        cmp     Z17
  .endif
        bcc     L29B1
        jsr     CRDO
L29B1:
.endif
        jsr     STRPRT
.ifdef KBD
        jmp     L297E
.else
        jsr     OUTSP
        bne     L297E ; branch always
.endif

.ifdef KBD
; PATCHES
LE86C:
        pla
        jmp     CONTROL_C_TYPED
LE870:
        jsr     GETBYT
        txa
LE874:
        beq     LE878
        bpl     LE8F2
LE878:
        jmp     IQERR
; PATCHES
.endif



.ifndef KBD
L29B9:
  .ifdef CBM2
        lda     #$00
        sta     INPUTBUFFER,x
        ldx     #<(INPUTBUFFER-1)
        ldy     #>(INPUTBUFFER-1)
  .else
    .ifndef APPLE
        ldy     #$00
        sty     INPUTBUFFER,x
        ldx     #LINNUM+1
    .endif
    .if .def(MICROTAN) || .def(SYM1)
        bne     CRDO2
	.endif
  .endif
  .ifdef CONFIG_FILE
        lda     CURDVC
        bne     L29DD
  .endif
.endif


CRDO:
.if .def(CONFIG_PRINTNULLS) && .def(CONFIG_FILE)
        lda     CURDVC
        bne     LC9D8
        sta     POSX
LC9D8:
.endif
        lda     #CRLF_1
.ifndef CONFIG_CBM_ALL
        sta     POSX
.endif
        jsr     OUTDO
CRDO2:
        lda     #CRLF_2
        jsr     OUTDO

PRINTNULLS:
.if .def(KBD) || .def(AIM65)
        lda     #$00
        sta     POSX
        eor     #$FF
.else
  .if .def(CONFIG_NULL) || .def(CONFIG_PRINTNULLS)
    .ifdef CONFIG_FILE
    ; Although there is no statement for it,
    ; CBM1 had NULL support and ignores
    ; it when not targeting the screen,
    ; CBM2 dropped it completely.
        lda     CURDVC
        bne     L29DD
    .endif
        txa
        pha
        ldx     Z15
        beq     L29D9
      .ifdef SYM1
        lda     #$FF
      .else
        lda     #$00
      .endif
L29D3:
        jsr     OUTDO
        dex
        bne     L29D3
L29D9:
        stx     POSX
        pla
        tax
  .else
    .ifndef CONFIG_2
        lda     #$00
        sta     POSX
    .endif
        eor     #$FF
  .endif
.endif
L29DD:
        rts
L29DE:
        lda     POSX
.ifndef CONFIG_NO_CR
  .ifdef KBD
        cmp     #$1A
  .else
        cmp     Z18
  .endif
        bcc     L29EA
        jsr     CRDO
        jmp     L2A0D
L29EA:
.endif
        sec
L29EB:
.if .def(CONFIG_CBM_ALL) || .def(AIM65)
        sbc     #$0A
.else
  .ifdef KBD
        sbc     #$0D
  .else
        sbc     #$0E
  .endif
.endif
        bcs     L29EB
        eor     #$FF
        adc     #$01
        bne     L2A08
L29F5:
.ifdef CONFIG_11A
        php
.else
        pha
.endif
        jsr     GTBYTC
        cmp     #')'
.ifdef CONFIG_11A
  .ifdef CONFIG_2
        bne     SYNERR4
  .else
        jne     SYNERR
  .endif
        plp
        bcc     L2A09
.else
  .ifdef CONFIG_11
        jne     SYNERR
  .else
        bne     SYNERR4
  .endif
        pla
        cmp     #TOKEN_TAB
  .ifdef CONFIG_11
        bne     L2A09
  .else
        bne     L2A0A
  .endif
.endif
        txa
        sbc     POSX
        bcc     L2A0D
.ifndef CONFIG_11
        beq     L2A0D
.endif
L2A08:
        tax
.ifdef CONFIG_11
L2A09:
        inx
.endif
L2A0A:
.ifndef CONFIG_11
        jsr     OUTSP
.endif
        dex
.ifndef CONFIG_11
        bne     L2A0A
.else
        bne     L2A13
.endif
L2A0D:
        jsr     CHRGET
        jmp     PRINT2
.ifdef CONFIG_11
L2A13:
        jsr     OUTSP
        bne     L2A0A
.endif

; ----------------------------------------------------------------------------
; PRINT STRING AT (Y,A)
; ----------------------------------------------------------------------------
STROUT:
        jsr     STRLIT

; ----------------------------------------------------------------------------
; PRINT STRING AT (FACMO,FACLO)
; ----------------------------------------------------------------------------
STRPRT:
        jsr     FREFAC
        tax
        ldy     #$00
        inx
L2A22:
        dex
        beq     L29DD
        lda     (INDEX),y
        jsr     OUTDO
        iny
        cmp     #$0D
        bne     L2A22
        jsr     PRINTNULLS
        jmp     L2A22
; ----------------------------------------------------------------------------
OUTSP:
.ifdef CONFIG_FILE
  .ifndef CBM1
; on non-screen devices, print SPACE
; instead of CRSR RIGHT
        lda     CURDVC
        beq     LCA40
        lda     #$20
        .byte   $2C
LCA40:
  .endif
        lda     #$1D ; CRSR RIGHT
.else
        lda     #$20
.endif
        .byte   $2C
OUTQUES:
        lda     #$3F

; ----------------------------------------------------------------------------
; PRINT CHAR FROM (A)
; ----------------------------------------------------------------------------
OUTDO:
.ifndef KBD
        bit     Z14
        bmi     L2A56
.endif
.if .def(CONFIG_PRINT_CR) || .def(CBM1)
; Commodore forgot to remove this in CBM1
        pha
.endif
.ifdef CBM1
        cmp     #$1D ; CRSR RIGHT
        beq     LCA6A
        cmp     #$9D ; CRSR LEFT
        beq     LCA5A
        cmp     #$14 ; DEL
        bne     LCA64
LCA5A:
        lda     POSX
        beq     L2A4E
        lda     CURDVC
        bne     L2A4E
        dec     POSX
LCA64:
        and     #$7F
.endif
.ifndef CBM2
        cmp     #$20
        bcc     L2A4E
.endif
LCA6A:
.ifdef CONFIG_CBM1_PATCHES
        lda     CURDVC
        jsr     PATCH6
        nop
.endif
.ifdef CONFIG_PRINT_CR
        lda     POSX
        cmp     Z17
        bne     L2A4C
  .ifdef AIM65
        lda #$00
        sta POSX
  .elseif .def(APPLE)
        nop ; PATCH!
        nop ; don't print CR
        nop
  .else
        jsr     CRDO
  .endif
L2A4C:
.endif
.ifndef CONFIG_CBM_ALL
        inc     POSX
.endif
L2A4E:
.if .def(CONFIG_PRINT_CR) || .def(CBM1)
; Commodore forgot to remove this in CBM1
        pla
.endif
.ifdef CONFIG_MONCOUT_DESTROYS_Y
        sty     DIMFLG
.endif
.ifdef CONFIG_IO_MSB
        ora     #$80
.endif
        jsr     MONCOUT
.ifdef CONFIG_IO_MSB
        and     #$7F
.endif
.ifdef CONFIG_MONCOUT_DESTROYS_Y
        ldy     DIMFLG
.endif
.ifdef OSI
        nop
        nop
        nop
        nop
.endif
L2A56:
        and     #$FF
LE8F2:
        rts

; ----------------------------------------------------------------------------
; ???
; ----------------------------------------------------------------------------
.ifdef KBD
LE8F3:
        pha
        lda     $047F
        clc
        beq     LE900
        lda     #$00
        sta     $047F
        sec
LE900:
        pla
        rts
.endif
