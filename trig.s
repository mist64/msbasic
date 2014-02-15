.segment "CODE"

.ifndef SYM1
SIN_COS_TAN_ATN:
; ----------------------------------------------------------------------------
; "COS" FUNCTION
; ----------------------------------------------------------------------------
COS:
        lda     #<CON_PI_HALF
        ldy     #>CON_PI_HALF
        jsr     FADD

; ----------------------------------------------------------------------------
; "SIN" FUNCTION
; ----------------------------------------------------------------------------
SIN:
        jsr     COPY_FAC_TO_ARG_ROUNDED
        lda     #<CON_PI_DOUB
        ldy     #>CON_PI_DOUB
        ldx     ARGSIGN
        jsr     DIV
        jsr     COPY_FAC_TO_ARG_ROUNDED
        jsr     INT
        lda     #$00
        sta     STRNG1
        jsr     FSUBT
; ----------------------------------------------------------------------------
; (FAC) = ANGLE AS A FRACTION OF A FULL CIRCLE
;
; NOW FOLD THE RANGE INTO A QUARTER CIRCLE
;
; <<< THERE ARE MUCH SIMPLER WAYS TO DO THIS >>>
; ----------------------------------------------------------------------------
        lda     #<QUARTER
        ldy     #>QUARTER
        jsr     FSUB
        lda     FACSIGN
        pha
        bpl     SIN1
        jsr     FADDH
        lda     FACSIGN
        bmi     L3F5B
        lda     CPRMASK
        eor     #$FF
        sta     CPRMASK
; ----------------------------------------------------------------------------
; IF FALL THRU, RANGE IS 0...1/2
; IF BRANCH HERE, RANGE IS 0...1/4
; ----------------------------------------------------------------------------
SIN1:
        jsr     NEGOP
; ----------------------------------------------------------------------------
; IF FALL THRU, RANGE IS -1/2...0
; IF BRANCH HERE, RANGE IS -1/4...0
; ----------------------------------------------------------------------------
L3F5B:
        lda     #<QUARTER
        ldy     #>QUARTER
        jsr     FADD
        pla
        bpl     L3F68
        jsr     NEGOP
L3F68:
        lda     #<POLY_SIN
        ldy     #>POLY_SIN
        jmp     POLYNOMIAL_ODD

; ----------------------------------------------------------------------------
; "TAN" FUNCTION
;
; COMPUTE TAN(X) = SIN(X) / COS(X)
; ----------------------------------------------------------------------------
TAN:
        jsr     STORE_FAC_IN_TEMP1_ROUNDED
        lda     #$00
        sta     CPRMASK
        jsr     SIN
        ldx     #TEMP3
        ldy     #$00
        jsr     GOMOVMF
        lda     #TEMP1+(5-BYTES_FP)
        ldy     #$00
        jsr     LOAD_FAC_FROM_YA
        lda     #$00
        sta     FACSIGN
        lda     CPRMASK
        jsr     TAN1
        lda     #TEMP3
        ldy     #$00
        jmp     FDIV
TAN1:
        pha
        jmp     SIN1

; ----------------------------------------------------------------------------
.ifdef CONFIG_SMALL
CON_PI_HALF:
        .byte   $81,$49,$0F,$DB
CON_PI_DOUB:
        .byte   $83,$49,$0F,$DB
QUARTER:
        .byte   $7F,$00,$00,$00
POLY_SIN:
        .byte   $04,$86,$1E,$D7,$FB,$87,$99,$26
        .byte   $65,$87,$23,$34,$58,$86,$A5,$5D
        .byte   $E1,$83,$49,$0F,$DB
.else
CON_PI_HALF:
        .byte   $81,$49,$0F,$DA,$A2
CON_PI_DOUB:
        .byte   $83,$49,$0F,$DA,$A2
QUARTER:
        .byte   $7F,$00,$00,$00,$00
POLY_SIN:
        .byte   $05,$84,$E6,$1A,$2D,$1B,$86,$28
        .byte   $07,$FB,$F8,$87,$99,$68,$89,$01
        .byte   $87,$23,$35,$DF,$E1,$86,$A5,$5D
        .byte   $E7,$28,$83,$49,$0F,$DA,$A2
  .ifndef CONFIG_11
; no easter egg text before BASIC 1.1
  .elseif !.def(CONFIG_2A)
; ASCII encoded easter egg
MICROSOFT:
        .byte   $A6,$D3,$C1,$C8,$D4,$C8,$D5,$C4
        .byte   $CE,$CA
  .else
; PET encoded easter egg text since CBM2
MICROSOFT:
        .byte   $A1,$54,$46,$8F,$13,$8F,$52,$43
        .byte   $89,$CD
  .endif
.endif

.ifndef AIM65
; ----------------------------------------------------------------------------
; "ATN" FUNCTION
; ----------------------------------------------------------------------------
ATN:
        lda     FACSIGN
        pha
        bpl     L3FDB
        jsr     NEGOP
L3FDB:
        lda     FAC
        pha
        cmp     #$81
        bcc     L3FE9
        lda     #<CON_ONE
        ldy     #>CON_ONE
        jsr     FDIV
; ----------------------------------------------------------------------------
; 0 <= X <= 1
; 0 <= ATN(X) <= PI/8
; ----------------------------------------------------------------------------
L3FE9:
        lda     #<POLY_ATN
        ldy     #>POLY_ATN
        jsr     POLYNOMIAL_ODD
        pla
        cmp     #$81
        bcc     L3FFC
        lda     #<CON_PI_HALF
        ldy     #>CON_PI_HALF
        jsr     FSUB
L3FFC:
        pla
        bpl     L4002
        jmp     NEGOP
L4002:
        rts

; ----------------------------------------------------------------------------
POLY_ATN:
.ifdef CONFIG_SMALL
        .byte   $08
		.byte	$78,$3A,$C5,$37
		.byte	$7B,$83,$A2,$5C
		.byte	$7C,$2E,$DD,$4D
		.byte	$7D,$99,$B0,$1E
		.byte	$7D,$59,$ED,$24
		.byte	$7E,$91,$72,$00
		.byte	$7E,$4C,$B9,$73
		.byte	$7F,$AA,$AA,$53
		.byte	$81,$00,$00,$00
.else
        .byte   $0B
		.byte	$76,$B3,$83,$BD,$D3
		.byte	$79,$1E,$F4,$A6,$F5
		.byte	$7B,$83,$FC,$B0,$10
        .byte   $7C,$0C,$1F,$67,$CA
		.byte	$7C,$DE,$53,$CB,$C1
		.byte	$7D,$14,$64,$70,$4C
		.byte	$7D,$B7,$EA,$51,$7A
		.byte	$7D,$63,$30,$88,$7E
		.byte	$7E,$92,$44,$99,$3A
		.byte	$7E,$4C,$CC,$91,$C7
		.byte	$7F,$AA,$AA,$AA,$13
        .byte   $81,$00,$00,$00,$00
.endif

.if .def(CONFIG_11A) && (!.def(CONFIG_2))
		.byte	$00 ; XXX
.endif
.endif
.endif