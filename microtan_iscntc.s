.segment "CODE"
ISCNTC:
        lda     $01
        cmp     #$03
        beq     LC6EF
        lda     #$01
        rts
LC6EF:
        nop
        nop
        cmp     #$03
;!!! runs into "STOP"