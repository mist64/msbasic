.ifdef KBD
RND:
        ldx     #$10
        jsr     SIGN
        beq     LFC26
        bmi     LFC10
        lda     $87
        ldy     $88
LFBFA:
        sta     FAC+2
        sty     FAC+1
LFBFE:
        asl     a
        asl     a
        eor     FAC+2
        asl     a
        eor     FAC+1
        asl     a
        asl     a
        asl     a
        asl     a
        eor     FAC+1
        asl     a
        rol     FAC+2
        rol     FAC+1
LFC10:
        lda     FAC+2
        dex
        bne     LFBFE
        sta     $87
        sta     FAC+3
        lda     FAC+1
        sta     $88
        lda     #$80
        sta     FAC
        stx     FACSIGN
        jmp     NORMALIZE_FAC2
LFC26:
        ldy     $03CA
        lda     $03C7
        ora     #$01
GOMOVMF:
        bne     LFBFA
        .byte   $F0
.else
CONRND1:
        .byte   $98,$35,$44,$7A
CONRND2:
        .byte   $68,$28,$B1,$46
RND:
        jsr     SIGN
.ifdef CONFIG_CBM_ALL
        bmi     L3F01
        bne     LDF63
        lda     ENTROPY
        sta     FAC+1
        lda     ENTROPY+4
        sta     FAC+2
        lda     ENTROPY+1
        sta     FAC+3
        lda     ENTROPY+5
        sta     FAC+4
        jmp     LDF88
LDF63:
.else
        tax
        bmi     L3F01
.endif
        lda     #<RNDSEED
        ldy     #>RNDSEED
        jsr     LOAD_FAC_FROM_YA
.ifndef CONFIG_CBM_ALL
        txa
        beq     L3EDA
.endif
        lda     #<CONRND1
        ldy     #>CONRND1
        jsr     FMULT
        lda     #<CONRND2
        ldy     #>CONRND2
        jsr     FADD
L3F01:
        ldx     FAC_LAST
        lda     FAC+1
        sta     FAC_LAST
        stx     FAC+1
.ifdef CONFIG_CBM_ALL
        ldx     FAC+2
        lda     FAC+3
        sta     FAC+2
        stx     FAC+3
LDF88:
.endif
        lda     #$00
        sta     FACSIGN
        lda     FAC
        sta     FACEXTENSION
        lda     #$80
        sta     FAC
        jsr     NORMALIZE_FAC2
        ldx     #<RNDSEED
        ldy     #>RNDSEED
GOMOVMF:
        jmp     STORE_FAC_AT_YX_ROUNDED
.endif
