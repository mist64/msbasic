.segment "CODE"
ISCNTC:
        lda     #$01
        bit     $1740
        bmi     RET2
        ldx     #$08
        lda     #$03
        clc
        cmp     #$03
;!!! runs into "STOP"