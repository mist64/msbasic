.segment "CODE"

; ----------------------------------------------------------------------------
; INPUT CONVERSION ERROR:  ILLEGAL CHARACTER
; IN NUMERIC FIELD.  MUST DISTINGUISH
; BETWEEN INPUT, READ, AND GET
; ----------------------------------------------------------------------------
INPUTERR:
        lda     INPUTFLG
        beq     RESPERR	; INPUT
.ifndef SYM1
.ifndef CONFIG_SMALL
.ifdef CONFIG_10A
; without this, it treats GET errors
; like READ errors
        bmi     L2A63	; READ
        ldy     #$FF	; GET
        bne     L2A67
L2A63:
.endif
.endif
.endif
.ifdef CONFIG_CBM1_PATCHES
        jsr     PATCH5
		nop
.else
        lda     Z8C
        ldy     Z8C+1
.endif
L2A67:
        sta     CURLIN
        sty     CURLIN+1
SYNERR4:
        jmp     SYNERR
RESPERR:
.ifdef CONFIG_FILE
        lda     CURDVC
        beq     LCA8F
        ldx     #ERR_BADDATA
        jmp     ERROR
LCA8F:
.endif
        lda     #<ERRREENTRY
        ldy     #>ERRREENTRY
        jsr     STROUT
        lda     OLDTEXT
        ldy     OLDTEXT+1
        sta     TXTPTR
        sty     TXTPTR+1
RTS20:
        rts

; ----------------------------------------------------------------------------
; "GET" STATEMENT
; ----------------------------------------------------------------------------
.ifndef CONFIG_SMALL
.ifndef SYM1
GET:
        jsr     ERRDIR
; CBM: if GET#, then switch input
.ifdef CONFIG_FILE
        cmp     #'#'
        bne     LCAB6
        jsr     CHRGET
        jsr     GETBYT
        lda     #','
        jsr     SYNCHR
        jsr     CHKIN
        stx     CURDVC
LCAB6:
.endif
        ldx     #<(INPUTBUFFER+1)
        ldy     #>(INPUTBUFFER+1)
.ifdef CONFIG_NO_INPUTBUFFER_ZP
        lda     #$00
        sta     INPUTBUFFER+1
.else
        sty     INPUTBUFFER+1
.endif
        lda     #$40
        jsr     PROCESS_INPUT_LIST
; CBM: if GET#, then switch input back
.ifdef CONFIG_FILE
        ldx     CURDVC
        bne     LCAD8
.endif
        rts
.endif
.endif

; ----------------------------------------------------------------------------
; "INPUT#" STATEMENT
; ----------------------------------------------------------------------------
.ifdef CONFIG_FILE
INPUTH:
        jsr     GETBYT
        lda     #$2C
        jsr     SYNCHR
        jsr     CHKIN
        stx     CURDVC
        jsr     L2A9E
LCAD6:
        lda     CURDVC
LCAD8:
        jsr     CLRCH
        ldx     #$00
        stx     CURDVC
        rts
LCAE0:
.endif

.ifdef SYM1
LC9B0:
        jsr     OUTQUES	; '?'
        jsr     OUTSP
        jmp     L2A9E
.endif
; ----------------------------------------------------------------------------
; "INPUT" STATEMENT
; ----------------------------------------------------------------------------
INPUT:
.ifndef KBD
        lsr     Z14
.endif
.ifdef AIM65
        lda     PRIFLG
        sta     ZBE
        jsr     LCFFA
.endif
        cmp     #$22
.ifdef SYM1
        bne     LC9B0
.else
        bne     L2A9E
.endif
        jsr     STRTXT
        lda     #$3B
        jsr     SYNCHR
        jsr     STRPRT
L2A9E:
        jsr     ERRDIR
        lda     #$2C
        sta     INPUTBUFFER-1
LCAF8:
.ifdef APPLE
        jsr     INLINX
.elseif .def(SYM1)
        jsr     INLIN
.else
        jsr     NXIN
.endif
.ifdef KBD
        bmi     L2ABE
.else
  .ifdef CONFIG_FILE
        lda     CURDVC
        beq     LCB0C
        lda     Z96
        and     #$02
        beq     LCB0C
        jsr     LCAD6
        jmp     DATA
LCB0C:
  .endif
        lda     INPUTBUFFER
        bne     L2ABE
  .ifdef CONFIG_FILE
        lda     CURDVC
        bne     LCAF8
  .endif
  .ifdef CONFIG_CBM1_PATCHES
        jmp     PATCH1
  .else
        clc
        jmp     CONTROL_C_TYPED
  .endif
.endif

NXIN:
.ifdef KBD
        jsr     INLIN
        bmi     RTS20
        pla
        jmp     LE86C
.else
  .ifdef CONFIG_FILE
        lda     CURDVC
        bne     LCB21
  .endif
        jsr     OUTQUES	; '?'
        jsr     OUTSP
LCB21:
        jmp     INLIN
.endif

; ----------------------------------------------------------------------------
; "GETC" STATEMENT
; ----------------------------------------------------------------------------
.ifdef KBD
GETC:
        jsr     CONINT
        jsr     LF43D
        jmp     LE664
.endif

; ----------------------------------------------------------------------------
; "READ" STATEMENT
; ----------------------------------------------------------------------------
READ:
        ldx     DATPTR
        ldy     DATPTR+1
.ifdef CONFIG_NO_READ_Y_IS_ZERO_HACK
; AppleSoft II, too
        lda     #$98	; READ
        .byte   $2C
L2ABE:
        lda     #$00	; INPUT
.else
        .byte   $A9	; LDA #$98
L2ABE:
        tya
.endif

; ----------------------------------------------------------------------------
; PROCESS INPUT LIST
;
; (Y,X) IS ADDRESS OF INPUT DATA STRING
; (A) = VALUE FOR INPUTFLG:  $00 FOR INPUT
; 				$40 FOR GET
;				$98 FOR READ
; ----------------------------------------------------------------------------
PROCESS_INPUT_LIST:
        sta     INPUTFLG
        stx     INPTR
        sty     INPTR+1
PROCESS_INPUT_ITEM:
        jsr     PTRGET
        sta     FORPNT
        sty     FORPNT+1
        lda     TXTPTR
        ldy     TXTPTR+1
        sta     TXPSV
        sty     TXPSV+1
        ldx     INPTR
        ldy     INPTR+1
        stx     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        bne     INSTART
        bit     INPUTFLG
.ifndef CONFIG_SMALL ; GET
 .ifndef SYM1
        bvc     L2AF0
  .ifdef MICROTAN
        jsr     MONRDKEY2
  .elseif .def(AIM65)
        jsr     MONRDKEY2
  .else
        jsr     MONRDKEY
  .endif
  .ifdef CONFIG_IO_MSB
        and     #$7F
  .endif
        sta     INPUTBUFFER
; BUG: The beq/bne L2AF8 below is supposed
; to be always taken. For this to happen,
; the last load must be a 0 for beq
; and != 0 for bne. The original Microsoft
; code had ldx/ldy/bne here, which was only
; correct for a non-ZP INPUTBUFFER. Commodore
; fixed it in CBMBASIC V1 by swapping the
; ldx and the ldy. It was broken on KIM,
; but okay on APPLE and CBM2, because
; these used a non-ZP INPUTBUFFER.
; Microsoft fixed this somewhere after KIM
; and before MICROTAN, by using beq instead
; of bne in the ZP case.
  .ifdef CBM1
        ldy     #>(INPUTBUFFER-1)
        ldx     #<(INPUTBUFFER-1)
  .else
        ldx     #<(INPUTBUFFER-1)
        ldy     #>(INPUTBUFFER-1)
  .endif
  .if .def(CONFIG_2) && (!.def(CONFIG_NO_INPUTBUFFER_ZP))
        beq     L2AF8	; always
  .else
        bne     L2AF8	; always
  .endif
L2AF0:
 .endif
.endif
        bmi     FINDATA
.ifdef CONFIG_FILE
        lda     CURDVC
        bne     LCB64
.endif
.ifdef KBD
        jsr     OUTQUESSP
.else
        jsr     OUTQUES
.endif
LCB64:
        jsr     NXIN
L2AF8:
        stx     TXTPTR
        sty     TXTPTR+1

; ----------------------------------------------------------------------------
INSTART:
        jsr     CHRGET
        bit     VALTYP
        bpl     L2B34
.ifndef CONFIG_SMALL ; GET
 .ifndef SYM1
        bit     INPUTFLG
        bvc     L2B10
  .ifdef CONFIG_CBM1_PATCHES
        lda     #$00
        jsr     PATCH4
        nop
  .else
        inx
        stx     TXTPTR
        lda     #$00
        sta     CHARAC
        beq     L2B1C
  .endif
L2B10:
 .endif
.endif
        sta     CHARAC
        cmp     #$22
        beq     L2B1D
        lda     #$3A
        sta     CHARAC
        lda     #$2C
L2B1C:
        clc
L2B1D:
        sta     ENDCHR
        lda     TXTPTR
        ldy     TXTPTR+1
        adc     #$00
        bcc     L2B28
        iny
L2B28:
        jsr     STRLT2
        jsr     POINT
.ifdef CONFIG_SMALL
        jsr     LETSTRING
.else
        jsr     PUTSTR
.endif
        jmp     INPUT_MORE
; ----------------------------------------------------------------------------
L2B34:
        jsr     FIN
.ifdef CONFIG_SMALL
        jsr     SETFOR
.else
        lda     VALTYP+1
        jsr     LET2
.endif
; ----------------------------------------------------------------------------
INPUT_MORE:
        jsr     CHRGOT
        beq     L2B48
        cmp     #$2C
        beq     L2B48
        jmp     INPUTERR
L2B48:
        lda     TXTPTR
        ldy     TXTPTR+1
        sta     INPTR
        sty     INPTR+1
        lda     TXPSV
        ldy     TXPSV+1
        sta     TXTPTR
        sty     TXTPTR+1
        jsr     CHRGOT
        beq     INPDONE
        jsr     CHKCOM
        jmp     PROCESS_INPUT_ITEM
; ----------------------------------------------------------------------------
FINDATA:
        jsr     DATAN
        iny
        tax
        bne     L2B7C
        ldx     #ERR_NODATA
        iny
        lda     (TXTPTR),y
        beq     GERR
        iny
        lda     (TXTPTR),y
        sta     Z8C
        iny
        lda     (TXTPTR),y
        iny
        sta     Z8C+1
L2B7C:
        lda     (TXTPTR),y
        tax
        jsr     ADDON
        cpx     #$83
        bne     FINDATA
        jmp     INSTART
; ---NO MORE INPUT REQUESTED------
INPDONE:
        lda     INPTR
        ldy     INPTR+1
        ldx     INPUTFLG
.if .def(CONFIG_SMALL) && (!.def(CONFIG_11))
        beq     L2B94 ; INPUT
.else
        bpl     L2B94; INPUT or GET
.endif
        jmp     SETDA
L2B94:
        ldy     #$00
.ifdef AIM65
        jsr     LB8B1
.endif
        lda     (INPTR),y
        beq     L2BA1
.ifdef CONFIG_FILE
        lda     CURDVC
        bne     L2BA1
.endif
        lda     #<ERREXTRA
        ldy     #>ERREXTRA
        jmp     STROUT
L2BA1:
        rts

; ----------------------------------------------------------------------------
ERREXTRA:
.ifdef KBD
        .byte   "?Extra"
.else
        .byte   "?EXTRA IGNORED"
.endif
        .byte   $0D,$0A,$00
ERRREENTRY:
.ifdef KBD
        .byte   "What?"
.else
        .byte   "?REDO FROM START"
.endif
        .byte   $0D,$0A,$00
.ifdef KBD
LEA30:
        .byte   "B"
        .byte   $FD
        .byte   "GsBASIC"
        .byte   $00,$1B,$0D,$13
        .byte   " BASIC"
.endif
