.segment "CODE"
ISCNTC:
        jsr     LE8F3
        bcc     RET1
LE633:
        jsr     LDE7F
        beq     STOP
        cmp     #$03
        bne     LE633
;!!! runs into "STOP"