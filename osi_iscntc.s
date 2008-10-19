.segment "CODE"
ISCNTC:
        jmp     MONISCNTC
        nop
        nop
        nop
        nop
        lsr     a
        bcc     RET2
        jsr     GETLN
        cmp     #$03
;!!! *used*to* run into "STOP"